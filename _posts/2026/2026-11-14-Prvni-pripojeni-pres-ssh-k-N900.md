---
layout: post
title:  "První připojení k N900 přes ssh (a repozitář plan9)"
author: "Jarda"
description: "Jak se na N900 dostat přes ssh z počítače: přidání starého zrcadla plan9, instalace openssh-server, nastavení hesla, klíče a chyby, na které se narazí."
categories:
    - n900
tags:
    - Maemo
    - ssh
    - plan9
    - apt
thumbnail: /assets/n900/n900_openssh.jpeg
---

- [Co budeš potřebovat](#co-budeš-potřebovat)
  - [Krok 1: repozitář plan9](#krok-1-repozitář-plan9)
  - [Krok 2: ssh server na telefonu](#krok-2-ssh-server-na-telefonu)
  - [Krok 3: adresa telefonu](#krok-3-adresa-telefonu)
  - [Krok 4: připojení z počítače](#krok-4-připojení-z-počítače)
- [Klíč místo hesla](#klíč-místo-hesla)
- [Chyby, na které jsem narazil](#chyby-na-které-jsem-narazil)
- [Bezpečnost](#bezpečnost)
- [Co dál](#co-dál)

Na N900 se většina věcí dělá nejpohodlněji z počítače: kopírovat soubory, spouštět příkazy, stavět balíčky. Pro to je potřeba ssh server na telefonu. Nokia ho z výroby nedodává, a protože oficiální repozitáře zmizely, musí se instalovat z jiného místa. Tenhle článek je návod pro čistý telefon (zkoušeno na druhé Nokii s Maemo 5, PR 1.3).

## Co budeš potřebovat

- N900 připojenou k **Wi-Fi** a správné **datum a čas** (jinak nefunguje ověření certifikátů).
- **Terminál na telefonu** (balíček `osso-xterm`, ikona X Terminal) a **root**: příkaz `sudo gainroot` (balíček `rootsh`). Oba jsou v Extras (a na zrcadle plan9 z kroku 1); jestli je na telefonu nemáte, nejdřív je tam nainstalujte Správcem aplikací. Příkazy v kroku 1 a 2 se zadávají jako root.
- Na počítači nástroje `ssh` a `ssh-copy-id` (Linux, macOS, nebo WSL).

### Krok 1: repozitář plan9

Oficiální `repository.maemo.org` je mrtvý. Žije ale zrcadlo **`maemo.plan9.de`**, které je snapshotem celého repozitáře z roku 2017 a obsahuje spoustu balíčků (Extras, Extras-testing, SDK a další). Má jednu výhodu: je přes obyčejné **HTTP**, takže ho zvládne i stará metoda `https` v aptu, která už dnes neumí moderní TLS.

Přidejte zdroje, buď přes Správce aplikací (*Application catalogues*), nebo přímo souborem. V terminálu jako root:

```bash
cat > /etc/apt/sources.list.d/plan9.list <<'EOF'
deb http://maemo.plan9.de/apt-mirror/mirror/repository.maemo.org/extras/ fremantle free non-free
deb http://maemo.plan9.de/apt-mirror/mirror/repository.maemo.org/extras-testing/ fremantle free non-free
deb http://maemo.plan9.de/apt-mirror/mirror/repository.maemo.org/extras-devel/ fremantle free non-free
EOF
apt-get update
```

Při `apt-get update` se objeví varování `GPG error ... NO_PUBKEY ...`. To je očekávané: zrcadlo nemá klíč, který by apt na telefonu znal. Balíčky jsou ale dobře dostupné a přes `apt-get` se instalují normálně.

{: .warning}
> Je to cizí zrcadlo přes HTTP a bez podpisu. Balíčky se na telefonu instalují jako root a nikdo neověří, že jsou věrnou kopií. Stejně to dělám já na vlastním telefonu, ale měl bys to vědět. Do `extras-devel` sahej opatrně, jsou tam rozpracované věci.

### Krok 2: ssh server na telefonu

Server je balíček `openssh-server` (verze 5.1) z Extras. Instalace:

```bash
apt-get install openssh-server
```

Pak nastav **heslo roota** a spusť server:

```bash
passwd
/etc/init.d/ssh start
ps | grep sshd
```

Pozor na poslední příkaz: výstup vždy obsahuje i řádek samotného `grep sshd`. Server běží, jen když je tam **ještě jeden řádek** s `/usr/sbin/sshd -D`. Pokud vidíte jen řádek s `grep`, server neběží.

Po restartu telefonu se server spustí sám (upstart job `sshd`).

### Krok 3: adresa telefonu

Na telefonu:

```bash
ifconfig wlan0 | grep "inet addr"
```

Zapiš si adresu (například `192.168.1.50`). Je dobré nechat si ji v routeru přidělit napevno, ať se nemění.

### Krok 4: připojení z počítače

Naivní pokus `ssh root@192.168.1.50` dnes skončí takhle:

```bash
Unable to negotiate with 192.168.1.50 port 22: no matching host key type found. Their offer: ssh-rsa,ssh-dss
```

Nový OpenSSH na počítači už starý typ klíče `ssh-rsa` standardně nepovoluje, a server na telefonu jiný nenabízí. Řešení je povolit ho **jen pro tohle jedno zařízení**. Do `~/.ssh/config` na počítači:

```conf
Host n900
    HostName 192.168.1.50
    User root
    HostKeyAlgorithms +ssh-rsa
    PubkeyAcceptedAlgorithms +ssh-rsa
    SetEnv TERM=xterm
```

Pak stačí `ssh n900`. První spojení se zeptá, jestli důvěřuješ otisku klíče, odpovíte `yes`, a zadáte heslo roota z kroku 2. (`SetEnv TERM=xterm` opraví zobrazení v terminálu, telefon nezná novější typy terminálů.)

## Klíč místo hesla

Heslo nechcete pořád zadávat, a hlavně nechcete, aby se šlo na telefon přihlásit heslem. Zkopírujte svůj veřejný klíč:

```bash
ssh-copy-id n900
```

Zadáte heslo naposledy. Pak už se `ssh n900` pustí bez hesla. Pokud `ssh-copy-id` nepoužívá alias, přidej ty dvě volby ručně: `ssh-copy-id -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa n900`.

## Chyby, na které jsem narazil

| Chyba | Příčina a oprava |
|---|---|
| `Connection refused` na portu 22 | ssh server neběží, nebo není nainstalovaný. Na telefonu `ps \| grep sshd` (hledej druhý řádek) a `/etc/init.d/ssh start`. |
| `no matching host key type found` | Chybí `HostKeyAlgorithms +ssh-rsa` v `~/.ssh/config`, nebo voláš `ssh` bez přezdívky. |
| `Permission denied (publickey)` po úpravě serveru | Heslo roota nenastaveno (`passwd`), nebo klíč není v `/root/.ssh/authorized_keys`. |
| `Connection timed out` | Špatná adresa, telefon spí (Wi-Fi), nebo je jiná podsíť. Zkus `ping` a `ifconfig` na telefonu. |
| `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED` | Telefon byl přeinstalován a má jiný klíč serveru. `ssh-keygen -R 192.168.1.50` a znovu. |
| Při `apt-get update` `NO_PUBKEY` | Očekávané, zrcadlo nemá klíč. Ignoruj. |

## Bezpečnost

- Server 5.1 je z roku 2009 a povoluje **root s heslem**. V domácí síti za routerem to jde, v cizí Wi-Fi ani na mobilních datech ho nenechte běžet.
- Po zkopírování klíče vypněte hesla: v `/etc/ssh/sshd_config` nastavte `PasswordAuthentication no` a `/etc/init.d/ssh restart`. Nejdřív si ověř, že přihlášení klíčem funguje.
- Moderní ssh server (OpenSSH 10) mám i ve svém repozitáři jako balíček `openssh`. Běží v `/opt/openssh`, na portu 2222, jen s klíči a pro uživatele `user`, a nespouští se sám. Hodí se na doladění; pro první připojení je jednodušší systémový `openssh-server`.

## Co dál

Až se na telefon dostanete přes ssh, můžete si přidat i můj repozitář s dalšími balíčky: viz [apt repozitář pro N900]({{ site.baseurl }}{% post_url 2026/2026-11-05-Apt-repozitar-pro-N900 %}), který vysvětluje, proč je k HTTPS potřeba `apt-transport-curl`.
