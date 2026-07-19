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

# VPC сеть и подсети для группы ВМ
resource "yandex_vpc_network" "network" {
  name = "vm-group-network"
}

resource "yandex_vpc_subnet" "subnet-a" {
  name           = "vm-group-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-b" {
  name           = "vm-group-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

# Файл user-data для установки Nginx
resource "local_file" "metadata" {
  content  = file("${path.module}/metadata.yaml")
  filename = "${path.module}/metadata.yaml"
}

# Группа виртуальных машин
resource "yandex_compute_instance_group" "web-ig" {
  name                = "web-instance-group"
  folder_id           = "b1gngj2vearsiu0su8h9"
  service_account_id  = "ajei7lurfa0kep4cnhbo"
  deletion_protection = false

  instance_template {
    platform_id = "standard-v3"
    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8hrphlcsmi293sjc74"  # Ubuntu 22.04 LTS
        size     = 10
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.network.id
      subnet_ids = [
        yandex_vpc_subnet.subnet-a.id,
        yandex_vpc_subnet.subnet-b.id
      ]
      nat = true
    }

    metadata = {
      user-data = file("${path.module}/metadata.yaml")
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = [
      "ru-central1-a",
      "ru-central1-b"
    ]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name = "web-ig-tg"
  }
}

# Сетевой балансировщик для группы ВМ
resource "yandex_lb_network_load_balancer" "web-ig-nlb" {
  name = "web-ig-network-load-balancer"

  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.web-ig.load_balancer[0].target_group_id
    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

# Вывод IP-адреса балансировщика (создаётся автоматически)
# Вывод IP-адреса балансировщика
output "load_balancer_ip" {
  value = one(yandex_lb_network_load_balancer.web-ig-nlb.listener[*].external_address_spec[*].address)
}
