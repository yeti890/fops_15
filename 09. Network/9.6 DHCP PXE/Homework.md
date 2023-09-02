# Домашнее задание к занятию "DHCP, PXE"

Эти задания обязательные к выполнению. Пожалуйста, присылайте на проверку все задачи сразу. Любые вопросы по решению задач задавайте в чате учебной группы.

### Цели задания

1. Научиться создавать и настраивать DHCP-сервер
2. Настроить автоматическую выдачу ip-адресов для конечных устройств.

Данная практика закрепляет знания о работе протокола DHCP и настройку параметров сетевых устройств. Эти навыки пригодятся для понимания принципов построения сети и взаимодействия сетевых устройств между собой.

### Инструкция к заданию

1. Сделайте копию [Шаблона для домашнего задания](https://docs.google.com/document/d/1youKpKm_JrC0UzDyUslIZW2E2bIv5OVlm_TQDvH5Pvs/edit) себе на Google Диск.
2. В названии файла введите корректное название лекции и вашу фамилию и имя.
3. Зайдите в “Настройки доступа” и выберите доступ “Просматривать могут все в Интернете, у кого есть ссылка”. Ссылка на инструкцию [Как предоставить доступ к файлам и папкам на Google Диске](https://support.google.com/docs/answer/2494822?hl=ru&co=GENIE.Platform%3DDesktop)
4. Скопируйте текст задания в свой  Google Документ.
5. Выполните домашнее задание, запишите ответы и приложите необходимые скриншоты и код в свой Google Документ.
6. Для проверки домашнего задания преподавателем отправьте ссылку на ваш Google документ в личном кабинете.
7. Все вопросы задавайте в разделе «Вопросы по заданию» у вас в личном кабинете или в комментариях к вашему решению при сдаче домашнего задания.

### Дополнительные материалы, которые могут пригодится для выполнения задания

[Статья о настройке DHCP-cервера в ОС Debian](https://aeb-blog.ru/debian/ustanovka-dhcp-servera-v-debian-10/)

### Задание 1

#### Описание задания
Перед вами стоит задача настроить DHCP-сервер в Linux.

#### Требование к результату
- Вы должны отправить файл с выполненным заданием.
- К выполненной задаче добавьте скриншоты настройки и работающего DHCP-сервера.
- Для выполнения заданий вы можете использовать дистрибутив на ваш выбор (Deb-дистрибутив или CentOs).

#### Процесс выполнения
1. Запустите программу VirtualBox
2. В программе VirtualBox загрузите операционную систему Ubuntu, если она у вас не установлена в качестве основной системы.
3. Установите DHCP-сервер:
    *sudo apt-get install isc-dhcp-server -y*
4. Настройте DHCP-сервер так, чтобы клиенту выдавался ip-адрес, ip-адрес dns-сервера и максимальное время аренды адреса было 8 часов.
5. Запустите службу DHCP:
    *sudo systemctl start isc-dhcp-server.service*

#### Решение:
Произведем настройку DHCP сервера на AlmaLinux 9.2

- Устанавливаем DHCP сервер и редактор:
```
sudo dnf -y install dhcp-server nano
```

- Создаем конфиг файл с необходимыми параметрами:
```
sudo nano /etc/dhcp/dhcpd.conf
```
~~~
option domain-name "srv.dhcp.pxe";
option domain-name-servers 8.8.8.8, 8.8.4.4;
default-lease-time 600;
max-lease-time 28800;
authoritative;

subnet 192.168.254.0 netmask 255.255.255.0 {
    range dynamic-bootp 192.168.254.100 192.168.254.200;
    option broadcast-address 192.168.254.255;
    option routers 192.168.254.1;
    interface eth1;
}
~~~

- Добавим разрешающее правило в firewall и сохраним его:
```
sudo firewall-cmd --add-service=dhcp
```
```
sudo firewall-cmd --runtime-to-permanent
```

- Настроим внутренний сетевой интерфейс для работы с DHCP сервером:
```
sudo nano /etc/sysconfig/network-scripts/ifcfg-eth1
```
- Запишем конфигурацию:
~~~
TYPE=Ethernet
BOOTPROTO=none
NAME=eth1
DEVICE=eth1
ONBOOT=yes
IPADDR=192.168.254.1
NETMASK=255.255.255.0
DNS1=8.8.8.8
~~~

- Перезапустим службу:
```
sudo systemctl restart NetworkManager
```

- Теперь включим пересылку трафика:
```
sudo su
```
```
echo "net.ipv4.ip_forward = 1" >>/etc/sysctl.conf
```
```
sysctl -p
```

- И включим "маскарадинг":
```
sudo firewall-cmd --permanent --add-masquerade
```

```
sudo reboot
```

- Проверяем работу DHCP сервера, подключаем к нему DHCP клиента:

![screenshot](/09.%20Network/9.6%20DHCP%20PXE/screenshots/dhcp-status.png)

![screenshot](/09.%20Network/9.6%20DHCP%20PXE/screenshots/ping-client.png)

---

### Задание 2.

#### Описание задания
Перед вами стоит задача создать и настроить PXE-сервер.

#### Требование к результату
- Вы должны отправить файлы с выполненным заданием
- К выполненной задаче добавьте скриншоты с конфигурацией PXE-сервера и его работоспособность.
- Для выполнения заданий вы можете использовать дистрибутив на ваш выбор (Deb-дистрибутив или CentOS).

#### Процесс выполнения
1. Запустите программу VirtualBox
2. В программе VirtualBox загрузите операционную систему Ubuntu, если она у вас не установлена в качестве основной системы.
3. Установите TFTP-сервер:
   *sudo apt-get install tftpd-hpa*
4. Создайте директорию для TFTP-сервера.
5. В файле “tftp-hpa” TFTP-сервера укажите выделенный ip-адрес или адрес loopback-интерфейса. 
6. Также в дополнительных опциях TFTP-сервера разрешите создавать новые файлы.
7. Перезагрузите TFTP-сервер: 
   *service tftp-hpa restart*
8. Создайте в директории TFTP-сервера какой-нибудь файл
9. Проверьте работоспособность PXE-сервера, либо загрузив с него файл по сети, либо подключившись TFTP-клиентом.
10. Выполните скриншоты и ответ внесите в комментарии к решению задания. 

#### Решение:

- Установим TFTP сервер:

```
sudo dnf makecache --refresh
```
```
sudo dnf install -y tftp-server tftp
```

- Создадим для него директорию и назначим права:

```
sudo mkdir -p /tftp
```
```
sudo chmod -R 777 /tftp/
```
```
sudo chown -R nobody:nogroup /tftp/
```

- Скопируем файлы конфигураций TFTP для systemd:

```
sudo cp /usr/lib/systemd/system/tftp.service /etc/systemd/system/tftp-server.service
```
```
sudo cp /usr/lib/systemd/system/tftp.socket /etc/systemd/system/tftp-server.socket
```

- Отредактируем файл сервиса TFTP:
```
sudo tee /etc/systemd/system/tftp-server.service<<EOF
[Unit]
Description=Tftp Server
Requires=tftp-server.socket
Documentation=man:in.tftpd

[Service]
ExecStart=/usr/sbin/in.tftpd -c -p -s /tftpboot
StandardInput=socket

[Install]
WantedBy=multi-user.target
Also=tftp-server.socket
EOF
```

- Запускаем сервис:
```
sudo systemctl daemon-reload
```
```
sudo systemctl enable --now tftp-server
```
```
sudo systemctl status tftp-server
```

- Добавляем правило в брандмауер:
```
sudo firewall-cmd --add-service=tftp --permanent
```
```
sudo firewall-cmd --reload
```

 - Поместим тестовые файлы в директорию TFTP:
```
sudo touch /tftpboot/file{1..3}.txt
```
```
echo "Hello File 1" | sudo tee /tftpboot/file1.txt
```
```
echo "Hello File 2" | sudo tee /tftpboot/file2.txt
```
```
echo "Hello File 3" | sudo tee /tftpboot/file3.txt
```


- Теперь настроим клиента:
```
sudo yum install tftp -y
```
```
tftp 192.168.254.1
```

- Прочитаем файлы на сервере:
```
cat file1.txt file2.txt file3.txt 
```

- Скачаем один из них:
```
get file1.txt ~/test
```
- Загрузим файл на сервер:
```
put ~/test/upload.txt
```

### Правила приема работы
- В личном кабинете отправлена ссылка на ваш Google документ, в котором прописан код каждого скрипта и скриншоты, демонстрирующие корректную работу скрипта
- В документе настроены права доступа “Просматривать могут все в Интернете, у кого есть ссылка”
- Название документа содержит название лекции и ваши фамилию и имя

### Общие критерии оценки
Задание считается выполненным при соблюдении следующих условий:
1. Выполнено оба задания
2. К заданию прикреплено 2 файла конфигураций и скриншоты работающих серверов: по итогам выполнения каждого задания

