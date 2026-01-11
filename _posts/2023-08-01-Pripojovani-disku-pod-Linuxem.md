---
layout: post
title: "Připojování disků pod Linuxem"
description: "Jak připojit disky pod Linuxem"
categories: ["linux", "Disk"]
thumbnail: https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Tux.svg/506px-Tux.svg.png
---

# Připojování disků pod Linuxem
- [Připojování disků pod Linuxem](#připojování-disků-pod-linuxem)
  - [Linuxové formáty](#linuxové-formáty)
    - [Mountování manuálně](#mountování-manuálně)
    - [Mountování automaticky](#mountování-automaticky)
  - [Win - NTFS](#win---ntfs)


## Linuxové formáty
### Mountování manuálně

Když chcete připojit disk ručně, například abyste se ujistili, že umístění připojení je vždy stejné, nebo když nemáte přístup k rozhraní Desktop, připojte disk k Raspberry Pi a vytvořte cílovou složku, která bude bodem připojení úložného zařízení, např. `exdisk`:

```bash
sudo mkdir /mnt/exdisk
```

Nyní najděte název externího disku:

```bash
fdisk -l
```

A najděte oddíl začínající na `/dev/` s očekávanou velikostí souboru, např. `/dev/sdb2/`. Použijte to k připojení úložného zařízení v bodě připojení, který jste právě vytvořili:

```bash
sudo mount /dev/sdb2 /mnt/exdisk
```

Můžete ověřit, že je úspěšně připojen pomocí výpisu obsahu (`ls /mnt/exdisk`). Pro odpojení úložného zařízení:

```bash
sudo umount /mnt/mydisk
```

### Mountování automaticky

Můžete upravit soubor `fstab` pro definování, kde budou úložná zařízení automaticky připojena při spuštění Raspberry Pi. K tomu budeme potřebovat UUID diskového oddílu:

```bash
sudo blkid
```

Nyní otevřete soubor fstab:

```bash
sudo nano /etc/fstab
```

Pak přidejte následující řádky, nahraďte UUID a umístění připojení:

```bash
UUID=D632-BE5F /mnt/exdisk fstype defaults,auto,users,rw,nofail 0 0
```

Síťový disk lze připojit stejným způsobem:
```Bash
//NASdrive.local/data /home/pi/NAS cifs -o username=pi,password=naspassword 0 0
```

Toto vystavuje vaše uživatelské jméno a heslo, což není ideální a mnohem lepší je vytvořit soubor s přihlašovacími údaji. Postupujte podle bezpečnostního průvodce [zde](https://raspberrypi-guide.github.io/networking/raspberry-pi-security.html).

Upravte soubor `/etc/fstab` jako uživatel root a znovu přidejte svůj samba share:

``` Bash
//NASdrive.local/data /home/pi/NAS cifs -o credentials=mycredentials.env 0 0
```

Otestujte nyní s:

``` Bash
sudo mount -a
```

Pokud se disk nějakým způsobem nepřipojí, zkuste přidat `uid=1000,gid=1000,iocharset=utf8` k příkazu fstab. Případně můžete použít `mount` a `umount` pro připojení a odpojení disků. 

[raspberrypi-guide](https://raspberrypi-guide.github.io/filesharing/filesharing-raspberry-pi.html)

## Win - NTFS
Windowsové diskové oddíly mají řešená oprávnění jinak než Linux. Pro jejich Připojení je vhodné používat `ntfs-3g` oproti samotnému `ntfs`.

``` Bash
sudo apt install fuse
sudo apt install ntfs-3g
```

```bash
permissions,users,auto,exec
```

- [askubuntu: mount ntfs](https://askubuntu.com/questions/92863/mount-ntfs-partition-at-startup-with-non-root-user-as-owner)
- [askubuntu: mount a drive without changing the directory owner to root](https://askubuntu.com/questions/1374799/is-it-possible-to-mount-a-drive-without-changing-the-directory-owner-to-root)