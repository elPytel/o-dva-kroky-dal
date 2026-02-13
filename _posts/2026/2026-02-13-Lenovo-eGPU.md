---
layout: post
title: "Lenovo eGPU"
description: Lenovo Thunderbolt 3 Graphics Dock
categories: 
    - linux
    - egpu
tags: 
    - ubuntu
    - lenovo
    - dock
    - 1050
thumbnail: https://download.lenovo.com/km/media/images/ACC500012/thunderbolt%20dock%201_20180216151226.JPG
---

[Lenovo](https://support.lenovo.com/na/cs/solutions/acc500012)

![přehled](https://download.lenovo.com/km/media/images/ACC500012/thunderbolt%20dock%201_20180216151226.JPG)

![porty](https://download.lenovo.com/km/media/images/ACC500012/thunderbolt%20dock%202_20180216150401.JPG)

## Parametry

- Integrovaná grafická karta NVIDIA (R) GTX 1050 (4 GB GDDR5).
- Plně funkční port Thunderbolt 3.0: data, video a napájení
- Podporuje až tři 4K displeje: 1 * HDMI 2.0, 2 * DisplayPort 2.0
- Nabíjí mobilní zařízení pomocí vždy připojeného USB 3.0
- 3,5mm audio port
- Gigabitový ethernetový port

Díky eGPU má dock dostatečný výkon pro připojení až tří 4K monitorů, což u konkurenčních USB-C docků není vůbec běžné.

# NVidia GeForce GTX 1050 Mobile

Nový notebook s výchozími ovladačemi sice s grafikou fungoval, ale ta se přehřívala na 83C, což není ideální. Proto bylo potřeba nainstalovat ovladače přímo od NVidie.

## Ovladače

`ubuntu-drivers devices`

```bash
== /sys/devices/pci0000:00/0000:00:07.0/0000:02:00.0/0000:03:01.0/0000:04:00.0 ==
modalias : pci:v000010DEd00001C8Dsv000017AAsd00005067bc03sc00i00
vendor   : NVIDIA Corporation
model    : GP107M [GeForce GTX 1050 Mobile]
driver   : nvidia-driver-580 - distro non-free recommended
driver   : nvidia-driver-580-server - distro non-free
driver   : xserver-xorg-video-nouveau - distro free builtin
```

Instalace ovladačů:
```bash
sudo apt install -y nvidia-driver-580
sudo reboot
```

Počítač bylo potřeba několikrát restartovat. 

Nakonec pomohlo:
1. Vše vypnout a odpojit eGPU,
2. připojit monitor k eGPU,
3. připojit eGPU k notebooku,
4. zapnout notebook.

`nvidia-smi -l 2`

```bash
Fri Feb 13 22:18:35 2026       
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 580.126.09             Driver Version: 580.126.09     CUDA Version: 13.0     |
+-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce GTX 1050        Off |   00000000:04:00.0  On |                  N/A |
| 31%   56C    P0            N/A  / 5001W |      35MiB /   4096MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
```

Nyní funguje jak monitor připojený k eGPU, tak i větrák eGPU. Už se grafika nepřehřívá na 83C.

# Zdroje:

## Instalace
- [Instalace ovladače](https://www.linuxcapable.com/install-nvidia-drivers-on-ubuntu-linux/#google_vignette)
- [ubuntu.com:nvidia-drivers-installation](https://ubuntu.com/server/docs/nvidia-drivers-installation)

## eGPU
- [Setting Up and Switching Between an NVIDIA eGPU](https://linhbmq.medium.com/setting-up-and-switching-between-an-nvidia-egpu-on-ubuntu-22-04-a-step-by-step-guide-199739f4129f)
- [eGPUScripts](https://github.com/julianpoy/eGPUScripts)

## Pohled dovnitř
- [egpu.io](https://egpu.io/lenovo-thunderbolt-3-graphics-dock-review-doa/)