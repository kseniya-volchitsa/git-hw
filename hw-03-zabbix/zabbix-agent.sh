#!/bin/bash

# Установка Zabbix Agent
wget https://repo.zabbix.com/zabbix/7.2/debian/pool/main/z/zabbix-release/zabbix-release_7.2-1+debian12_all.deb
dpkg -i zabbix-release_7.2-1+debian12_all.deb
apt update
apt install zabbix-agent -y

# Настройка агента
sed -i "s/Server=127.0.0.1/Server=10.180.28.40/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=10.180.28.40/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=$(hostname)/" /etc/zabbix/zabbix_agentd.conf

# Создание Bash скрипта
cat > /usr/local/bin/my_info.sh <<'EOF'
#!/bin/bash
case $1 in
  1) echo "Волчица Ксения" ;;
  2) date "+%Y-%m-%d %H:%M:%S" ;;
  *) echo "Usage: $0 {1|2}" ;;
esac
EOF
chmod +x /usr/local/bin/my_info.sh

# Создание Python скрипта
cat > /usr/local/bin/my_info.py <<'EOF'
#!/usr/bin/env python3
import sys
import datetime

def main():
    if len(sys.argv) < 2:
        print("Usage: my_info.py <argument>")
        return
    arg = sys.argv[1]
    if arg == "1":
        print("Волчица Ксения")
    elif arg == "2":
        print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
    elif arg == "-ping":
        print("pong")
    elif arg == "-simple_print":
        print("Hello from Zabbix Python script!")
    else:
        print("Unknown argument")
if __name__ == "__main__":
    main()
EOF
chmod +x /usr/local/bin/my_info.py

# Настройка UserParameter
echo "UserParameter=custom.info[*],/usr/local/bin/my_info.sh \$1" > /etc/zabbix/zabbix_agentd.conf.d/userparams.conf
echo "UserParameter=custom.python[*],/usr/local/bin/my_info.py \$1" >> /etc/zabbix/zabbix_agentd.conf.d/userparams.conf

systemctl restart zabbix-agent
systemctl enable zabbix-agent
