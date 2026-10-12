---
layout: post
title:  "MeshCentral"
author: "Jarda"
description: A description
categories: 
    - category
tags: 
    - MeshCentral
---


Porovnání nástrojů MeshCommander a MeshCentral se točí kolem správy zařízení, zejména s ohledem na technologii Intel AMT (Active Management Technology / vPro). Ačkoliv spolu částečně sdílejí kód a mohou se doplňovat, každý z nich slouží k jinému účelu.

## MeshCommander

• Typ nástroje: Lehká lokální desktopová aplikace nebo webové rozhraní běžící přímo na konkrétním počítači / v prohlížeči (určené pro správu 1 až několika strojů).
• Zaměření: Slouží výhradně pro správu a konfiguraci Intel AMT (vPro)out-of-band (mimo operační systém).
• Klíčové vlastnosti: Zapnutí/vypnutí PC, přístup do BIOSu, připojení přes VNC/KVM, připojení ISO obrazů vzdáleně, nastavení AMT parametrů.
• Rozsah: Funguje lokálně v síti (nebo přes VPN/přímé směrování na IP adresu AMT). Intel sice ukončil oficiální podporu pro MeshCommander, ale projekt žije dál komunitně.

## MeshCentral

• Typ nástroje: Plnohodnotná, open-source, self-hosted webová platforma (Node.js aplikace), která vyžaduje vlastní server (nebo Docker kontejner).
• Zaměření: Kompletní vzdálená správa mnoha zařízení (pomocí vlastního agenta MeshAgent) napříč operačními systémy a navíc integrovaná podpora pro Intel AMT.
• Klíčové vlastnosti:
	• Podpora více administrátorů, vícefaktorové ověřování (MFA), SSO a správa oprávnění.
	• Vzdálená plocha, terminál, přenos souborů přes lehkého agenta nainstalovaného v OS.
	• Schopnost propojit Intel AMT přes internet pomocí CIRA (Client Initiated Remote Access), což znamená, že spravovaný počítač s vPro se dokáže připojit k vašemu serveru MeshCentral i mimo firemní síť bez nutnosti VPN.
• Rozsah: Centrální dashboard pro desítky až tisíce strojů odkudkoliv přes web. Intel ukončil financování/vývoj, ale komunita kolem MeshCentral projekt nadále udržuje a vydává opravy.


To je výborný plán. Lenovo ThinkStation P330 (ať už v provedení Tiny, SFF nebo Tower) je workstation třída postavená na čipsetu C246. Pokud je v něm osazen procesor s podporou vPro (např. i5-8500, i7-8700 a podobné modely bez "F"), máš v rukou ideální železo pro plnohodnotný Intel AMT a vzdálenou hardwarovou správu.

Díky tomu získáš KVM na úrovni hardwaru, takže můžeš P330 na dálku zapnout, vstoupit do BIOSu, přeinstalovat OS z virtuálního ISO obrazu a řešit kernel panics, aniž bys musel připojovat monitor a klávesnici.

Zde je postup, jak to celé elegantně rozběhnout:

## Příprava P330 (Intel MEBx)

Než do hry vstoupí MeshCentral, musíš AMT probudit přímo na základní desce.

* **Vstup do konfigurace:** Při startu počítače (na obrazovce s logem Lenovo) mačkej `Ctrl+P`. Tím se dostaneš do Intel Management Engine BIOS Extension (MEBx).
* **Změna hesla:** Výchozí heslo je téměř vždy `admin`. Hned po prvním přihlášení tě systém vyzve ke změně. Nové heslo má přísná pravidla (musí mít přesně 8 a více znaků, velké písmeno, malé písmeno, číslo a speciální znak). Toto heslo si dobře ulož, MeshCentral ho bude potřebovat.
* **Aktivace sítě:** V menu najdi sekci *Network Setup* a zkontroluj, že je zapnutý *Network Access State*. Konfiguraci IP adresy můžeš nechat na DHCP (a na routeru/Zabbixu si pak MAC adresu zafixovat) nebo nastavit statickou IP.
* **Povolení AMT:** V sekci *Intel AMT Configuration* zkontroluj, že je *Manageability Feature Selection* nastaveno na *Enabled*.

## Nasazení MeshCentralu

Vzhledem k tvé infrastruktuře dává největší smysl nasadit MeshCentral jako Docker kontejner. Je to Node.js aplikace, která je velmi nenáročná na zdroje.

Pro rychlý start stačí jednoduchý `docker-compose.yml`:

```yaml
version: '3'
services:
  meshcentral:
    image: typhonragewind/meshcentral:latest
    container_name: meshcentral
    ports:
      - "8086:443"
    environment:
      - HOSTNAME=tvoje-domena-nebo-ip
      - REVERSE_PROXY=false
      - IFRAME=false
      - ALLOW_NEW_ACCOUNTS=true
    volumes:
      - ./meshcentral/data:/opt/meshcentral/meshcentral-data
      - ./meshcentral/user_files:/opt/meshcentral/meshcentral-files
    restart: always

```

Po prvním spuštění a vytvoření administrátorského účtu nezapomeň nastavit `ALLOW_NEW_ACCOUNTS=false`, aby se ti tam nikdo cizí neregistroval.

## 3. Spárování a správa

Jakmile běží P330 s aktivním AMT na síti a MeshCentral je dostupný z prohlížeče:

1. V MeshCentralu vytvoř novou skupinu zařízení (Device Group) a jako typ správy zvol *Agent-less (Intel AMT)*.
2. Klikni na *Add Device* a zadej IP adresu tvého P330.
3. Systém si vyžádá AMT přihlašovací údaje (uživatel je `admin` a heslo je to, které jsi nastavoval v MEBx pomocí `Ctrl+P`).
4. MeshCentral se s P330 spojí a na dashboardu uvidíš dostupné funkce: Power Control (zapnutí/vypnutí natvrdo) a především záložku *Desktop*, přes kterou získáš hardwarové KVM přes IP.

Dej si jen pozor na to, že pokud má P330 dedikovanou grafickou kartu (např. nějaké NVIDIA Quadro), Intel AMT KVM umí přenášet obraz pouze z integrované grafiky na procesoru (iGPU). Pro plné využití vzdáleného obrazu z BIOSu je často nutné v BIOSu nastavit integrovanou grafiku jako primární zobrazovač.