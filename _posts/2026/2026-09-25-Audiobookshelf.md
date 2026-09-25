---
layout: post
title:  "Audiobookshelf"
author: "Jarda"
description: Nasazení Audiobookshelf v Proxmox homelabu přes Ansible.
categories: 
    - Homelab
    - Proxmox
tags: 
    - Audiobookshelf
    - IaC
thumbnail: /assets/Audiobookshelf_logo.png
---

- [Nasazení Audiobookshelf v Proxmox homelabu přes Ansible](#nasazení-audiobookshelf-v-proxmox-homelabu-přes-ansible)
  - [Architektura: Čistý hypervizor a dedikovaný Docker-runner](#architektura-čistý-hypervizor-a-dedikovaný-docker-runner)
  - [Bezpečnost na prvním místě: SMB, Least Privilege a UID/GID](#bezpečnost-na-prvním-místě-smb-least-privilege-a-uidgid)
    - [Jak jsem to vyřešil:](#jak-jsem-to-vyřešil)
  - [Peklo s balíčky v čistém Debianu (`docker.io` vs. `docker-ce`)\*\*](#peklo-s-balíčky-v-čistém-debianu-dockerio-vs-docker-ce)
  - [Výsledný stav a struktura v Gitu](#výsledný-stav-a-struktura-v-gitu)
  - [Reference](#reference)


# Nasazení Audiobookshelf v Proxmox homelabu přes Ansible

Když člověk staví homelab, dříve nebo později narazí na zásadní křižovatku: buď bude služby na serveru klikat a lepit ručně v terminálu, nebo k tomu přistoupí jako k produkční infrastruktuře. Rozhodl jsem se proto jít cestou *Infrastructure as Code* (IaC) a celý stack Audiobookshelf nasadit přes Ansible.

Zde je architektonický výcuc toho, co a proč jsme poskládali, včetně všech slepých uliček, kterým se můžete vyhnout.


## Architektura: Čistý hypervizor a dedikovaný Docker-runner

Základní sysadmin pravidlo pro Proxmox zní: *udržuj samotný hypervizor co nejčistší*. Místo abychom instalovali Docker přímo do železa, postavili jsme pro aplikační kontejnery dedikovaný virtuální stroj (`Docker-runner`):

* **Základ:** Bezobslužná instalace čistého Debianu bez GUI pomocí vlastního upraveného *preseed* ISO obrazu.
* **Přístup:** Preseed rovnou vytvoří servisního uživatele `ansible` se zablokovaným heslem, vloží mu SSH klíč a nastaví bezheslové `sudo`.
* **Výsledek:** Po nabootování VM máme během pár minut čisté plátno připravené na to, aby ho plně převzal Ansible z lokálního počítače.

## Bezpečnost na prvním místě: SMB, Least Privilege a UID/GID

Moje sbírka audioknih leží na síťovém SMB disku přímo na Zalmanovi (`//192.168.1.100/data`). Cílem bylo:

1. Zachovat přímý přístup k souborům přes běžnou síťovou složku z Windows/Linuxu.
2. Nedovolit kontejneru s Audiobookshelfem, aby viděl zbytek disku (fotky, zálohy, instalačky).
3. Dodržet princip nejnižších privilegií (*Principle of Least Privilege*) – tedy žádný kontejner běžící pod `rootem` nebo jedním globálním uživatelem.

> [!note]
> Do budoucna plánují samostatnou virtuálku na které poběží jen SMB server, aby byla oddělena od Proxmox hypervizoru a dalších služeb.

### Jak jsem to vyřešil:

* **Unikátní UID + Společné GID:** Vytvořil jsem na hostiteli sdílenou skupinu `media_shared` s pevně daným GID `2000`. Samotný kontejner Audiobookshelf dostal své vlastní unikátní UID `1106` a běží pod skupinou `2000`. Pokud by někdo kontejner kompromitoval, nedostane se ke konfiguracím ostatních služeb.

* **Selektivní Bind Mounts:** Celý SMB share se přes Ansible roli a *Ansible Vault* (pro šifrování hesel v Gitu) připojí na `Docker-runner` do `/mnt/data` s právy nastavenými pro skupinu `media_shared`. Do samotného Docker kontejneru ale nepropisujeme celý disk – namapujeme mu přes *volumes* exkluzivně jen podsložky `/mnt/data/Audio knihy` a `/mnt/data/Podcasts`. O existenci okolních složek nemá kontejner ani tušení.
* **SGID bit:** Složkám jsem v Ansible nastavil práva `2775` (SGID), což zaručuje, že jakýkoliv nově vytvořený soubor automaticky zdědí skupinu `2000` a ostatní služby s ním nebudou mít problém pracovat.

## Peklo s balíčky v čistém Debianu (`docker.io` vs. `docker-ce`)**
Výchozí repozitáře Debianu obsahují starší balíčky `docker.io` a `docker-compose`, které vůbec neobsahují moderní plugin `docker-compose-plugin` (Compose V2). Když jsme následně přes vlastní Ansible roli přidali oficiální repozitář Dockeru (ve formátu `deb822`), instalace havarovala na konfliktu v `dpkg`, protože nový `docker-compose-plugin` se snažil přepsat binárku ze starého balíčku `docker-compose`. 

**Řešení:** Na čistý Debian nikdy neinstalujte Docker z výchozích distribučních repozitářů. Rovnou přidejte oficiální Docker repozitář a instalujte sadu `docker-ce`, `docker-ce-cli`, `containerd.io` a `docker-compose-plugin`.


## Výsledný stav a struktura v Gitu

Nyní celý stack nahodíme (nebo po případné katastrofě kompletně obnovíme na novém stroji) jediným příkazem `ansible-playbook`.

Finální výsek z `docker-compose.yml`, který Ansible na server doručí a spustí, vypadá takto:

```yaml
services:
  audiobookshelf:
    image: ghcr.io/advplyr/audiobookshelf:latest
    container_name: audiobookshelf
    environment:
      - PUID=1106  # Unikátní UID vyhrazené pro Audiobookshelf
      - PGID=2000  # Společná skupina media_shared pro přístup na SMB disk
      - TZ=Europe/Prague
    ports:
      - 13378:80
    volumes:
      - /opt/docker-stacks/audiobookshelf/config:/config
      - /opt/docker-stacks/audiobookshelf/metadata:/metadata
      - "/mnt/data/Audio knihy:/audiobooks"
      - "/mnt/data/Podcasts:/podcasts"
    restart: unless-stopped

```

*(Poznámka: Konfiguraci a metadata držíme přímo na rychlém lokálním NVMe disku virtuálky v `/opt`, zatímco těžká média si kontejner tahá přes síť ze Samby).*

Teď už Audiobookshelf spokojeně běží na portu `13378`, indexuje stávající knihovnu a já mám v Gitu připravenou šablonu, podle které v dalších krocích úplně stejně nasdím zbytek mediálního stacku.

## Reference

Použil jsem:
- [Ansible suite](https://github.com/ansible-suite) - Hynkovu organizaci pro Ansible role a playbooky
  - [Ansible site](https://github.com/ansible-suite/ansible-site) - repo s konfigurací pro Ansible
  - [Ansible Role: smb_mounts](https://github.com/ansible-suite/ansible-role-smb-mounts) - role pro připojení SMB disků
  - [Ansible Role: apt_thirdparty](https://github.com/ansible-suite/ansible-role-apt_thirdparty) - role pro přidání třetích stran repozitářů (např. Docker)
- [Moje homelab repo](https://github.com/elPytel/homelab-ansible-site) - Můj vlastní repozitář s Ansible playbooky pro homelab
- [Audiobookshelf](https://audiobookshelf.org/)