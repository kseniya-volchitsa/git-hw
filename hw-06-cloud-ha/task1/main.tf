terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = "b1g8acaomqmbc0lhlqn0"
  folder_id                = "b1gngj2vearsiu0su8h9"
  zone                     = "ru-central1-a"
}

data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}

resource "yandex_vpc_network" "network" {
  name = "web-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "web-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "web-${count.index + 1}"
  hostname    = "web-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data = "#cloud-config\nruncmd:\n  - apt update\n  - apt install -y nginx\n  - systemctl enable nginx\n  - systemctl start nginx"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_lb_target_group" "web-tg" {
  name = "web-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.web
    content {
      subnet_id = yandex_vpc_subnet.subnet.id
      address   = target.value.network_interface[0].ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "web-nlb" {
  name = "web-network-load-balancer"

  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.web-tg.id

    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

output "load_balancer_ip" {
  value = one(yandex_lb_network_load_balancer.web-nlb.listener[*].external_address_spec[*].address)
}
