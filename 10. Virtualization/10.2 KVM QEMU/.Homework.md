# Домашнее задание к занятию «Типы виртуализации: KVM, QEMU»


### Оформление домашнего задания

1. Домашнее задание выполните в [Google Docs](https://docs.google.com/) и отправьте на проверку ссылку на ваш документ в личном кабинете.  
1. В названии файла укажите номер лекции и фамилию студента. Пример названия: 6.2. Типы виртуализаций: KVM, QEMU — Александр Александров.
1. Перед отправкой проверьте, что доступ для просмотра открыт всем, у кого есть ссылка. Если нужно прикрепить дополнительные ссылки, добавьте их в свой Google Docs.

Любые вопросы по решению задач задавайте в чате учебной группы.

 ---

## Важно

Перед отправкой работы на проверку удаляйте неиспользуемые ресурсы.
Это нужно, чтобы предупредить неконтролируемый расход средств, полученных после использования промокода.

Рекомендации [по ссылке](https://github.com/netology-code/sdvps-homeworks/tree/main/recommend).

---

### Задание 1

**Ответьте на вопрос в свободной форме.**

Какие виртуализации существуют? Приведите примеры продуктов разных типов виртуализации.

**Ответ:**

Виртуализация бывает:
1. Аппаратная - работает благодаря технологиям поддержки со стороны процессора.
* Intel - VT-x, VT-d
* AMD - AMD-V
* ARM - EL2

    Эту технологию используют гипервизоры 1-го и 2-го типа, такие как WMware, HyperV, KVM

2. Программная - эмулирует все железо от процессора до сетевого адаптера. Примеры: 
* QEMU
* VirtualBox 
* XEN

3. Контейнерная - эмулирует несколько изолированных пространств пользователя вместо одного. Виртуальная среда запускается прямо из ядра хостовой операционной системы. Например: 
* Docker
* Kubernetes

4. Хостинговая - провайдер предоставляет виртуальные ресурсы в облаке. Например:
* AWS
* Azure
* GCP
* Яндекс Облако

---

### Задание 2 

Выполните действия и приложите скриншоты по каждому этапу:

1. Установите QEMU в зависимости от системы (в лекции рассматривались примеры).
2. Создайте виртуальную машину.
3. Установите виртуальную машину.
Можете использовать пример [по ссылке](https://dl-cdn.alpinelinux.org/alpine/v3.13/releases/x86/alpine-standard-3.13.5-x86.iso).

Пример взят [с сайта](https://alpinelinux.org). 
 
 **Решение:**

 Задание выполнял на ВМ Ubuntu Server 22.04 в HyperV

* Устанавливаем QEMU в Ubuntu 22.04
```
sudo apt install qemu
```
* Далее скачиваем дистрибутив будущей ВМ:
```
wget https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86/alpine-standard-3.18.3-x86.iso
```
* Создаем диск для нашей ВМ:
```
qemu-img create -f qcow2 alpine.qcow 5G
```
* Создаем нашу ВМ со следующими параметрами:
```
qemu-system-i386 -hda alpine.qcow -boot d -cdrom ~/alpine-standard-3.18.3-x86.iso -m 1024 -nographic
```

* Попадаем в консоль ВМ с началом установки ОС (root без пароля):
![screenshot](/10.%20Virtualization/screenshots/alpine-start.png)

* Выбираем быструю установку ОС 
```
setup-alpine -q
```

* По окончании выключаем ВМ
```
poweroff
```
* Запускаем нашу ВМ, но без установочного дистрибутива:
```
qemu-system-i386 -hda alpine.qcow -m 1024 -nographic
```
Установка закончена:

![screenshot](/10.%20Virtualization/screenshots/ps-qemu.png)

![screenshot](/10.%20Virtualization/screenshots/qemu-running.png)


---

### Задание 3 

Выполните действия и приложите скриншоты по каждому этапу:

1. Установите KVM и библиотеку libvirt. Можете использовать GUI-версию из лекции. 
2. Создайте виртуальную машину. 
3. Установите виртуальную машину. 
Можете использовать пример [по ссылке](https://dl-cdn.alpinelinux.org/alpine/v3.13/releases/x86/alpine-standard-3.13.5-x86.iso). 

Пример взят [с сайта](https://alpinelinux.org). 
 
 **Решение:**

* Проверяем поддержку аппаратной виртуализации:
```
grep -E -c "vmx|svm" /proc/cpuinfo
```
```
sudo apt install -y cpu-checker
```
```
kvm-ok
```

* Проверяем модуль KVM в ядре:
```
lsmod | grep -i kvm
```

* Если выключен - подключаем:
```
sudo modprobe kvm
```
```
sudo modprobe kvm_intel (kvm_amd)
```

* Устанавливаем libvirt и другие зависимости
```
sudo apt install -y libvirt0 libvirt-daemon-system bridge-utils virtinst
```

* Проверяем службу libvirtd:

```
sudo systemctl status libvirtd.service
```

* Права - добавляем своего пользователя в группы libvirt и kvm:
```
sudo usermod -aG libvirt $USER
```

```
sudo usermod -aG kvm $USER
```

* Перезагружаемся
```
sudo reboot
```

* Скачиваем дистрибутив будущей ВМ:
```
wget https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86/alpine-standard-3.18.3-x86.iso -P /tmp
```

* Создаем ВМ:
```
virt-install \
  --name alp \
  --ram 512 \
  --vcpus 1 \
  --disk size=2 \
  --cdrom /tmp/alpine-standard-3.18.3-x86.iso \
  --noautoconsole
```

* Подключаемся к нашей ВМ - логин - root (без пароля)
```
virsh console alp
```

* Выбираем быструю установку ОС 
```
setup-alpine -q
```

* Создаем загрузочный диск 
```
setup-disk
```

* Если требуется добавляем ВМ в автозагрузку
```
virsh autostart alp
```

* Запускаем ВМ
```
virsh start alp
```

* В результате получаем:

![screenshot](/10.%20Virtualization/screenshots/alpine-running.png)

 ---

### Задание 4

Выполните действия и приложите скриншоты по каждому этапу:

1. Создайте проект в GNS3, предварительно установив [GNS3](https://github.com/GNS3/gns3-gui/releases).
2. Создайте топологию, как на скрине ниже.
3. Для реализации используйте машину на базе QEMU. Можно дублировать, сделанную ранее. 

![image](https://user-images.githubusercontent.com/73060384/118615008-f95e9680-b7c8-11eb-9610-fc1e73d8bd70.png)

**Решение:**

* Подготовка ВМ:
```
sudo mkdir -p /kvm/{hdd,iso}
```

* Устанавливаем необходимые компоненты:
```
sudo apt install qemu libvirt0 libvirt-daemon-system libvirt-clients bridge-utils virtinst
```

* Проверяем службу libvirtd:
```
sudo systemctl status libvirtd.service
```

* Теперь разберемся с правами:
```
sudo usermod -aG libvirt-qemu $USER
sudo chgrp libvirt-qemu /kvm/{hdd,iso}
sudo chmod g+w /kvm/hdd
```

* Скачиваем образы будущих ВМ:
```
sudo wget https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86/alpine-standard-3.18.3-x86.iso -P /kvm/iso
```

* Создаем диски для ВМ:
```
sudo qemu-img create -f qcow2 ~/GNS3/images/alp1.qcow 2G
```
```
sudo qemu-img create -f qcow2 ~/GNS3/images/alp2.qcow 2G
```

* Запускаем установку ВМ ARM:
```
sudo qemu-system-i386 -hda ~/GNS3/images/alp1.qcow -boot d -cdrom /kvm/iso/alpine-standard-3.18.3-x86.iso -m 1024 -nographic
```
```
sudo qemu-system-i386 -hda ~/GNS3/images/alp2.qcow -boot d -cdrom /kvm/iso/alpine-standard-3.18.3-x86.iso -m 1024 -nographic
```

* Устанавливаем ОС на ВМ аналогично заданиям выше
* Устанавливаем GNS3 и запускаем его:
```
sudo add-apt-repository ppa:gns3/ppa
sudo apt update                                
sudo apt install gns3-server
gns3server
```

* Так как поддержки KVM у меня нет, будем ее отключать:
```
nano ~/.config/GNS3/2.2/gns3_server.conf 
```

* Добавляем запись:
```
[Qemu]
enable_hardware_acceleration = False
require_hardware_acceleration = False
```

* Идем в веб-интерфейс GNS3:
```
http://192.168.10.150:3080/
```
* Создаем проект, добавляем ВМ Qemu, создаем конфиг сети, стартуем, готово:

![screenshot](/10.%20Virtualization/screenshots/gns3-qemu.png)

---

## Дополнительные задания* (со звёздочкой)

Их выполнение необязательное и не влияет на получение зачёта по домашнему заданию. Можете их решить, если хотите лучше разобраться в материале.

 ---

### Задание 5*

1. Установите виртуальные (alpine) машины двух различных архитектур, отличных от X86 в QEMU.
1. Приложите скриншоты действий.

---

### Задание 6*

1. Установите виртуальные (alpine) машины двух различных архитектур, отличных от X86 в KVM.
1. Приложите скриншоты действий.