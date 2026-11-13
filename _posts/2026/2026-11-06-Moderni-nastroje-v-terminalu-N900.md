---
layout: post
title:  "Moderní nástroje v terminálu N900"
author: "Jarda"
description: tmux, rsync, strace, ncdu, ripgrep, fzf, micro, links a další. Co jsem přeložil pro Nokii N900, co na ní běží a na co si dát pozor.
categories:
    - n900
    - Claude
tags:
    - Maemo
    - terminál
    - tmux
thumbnail: /assets/n900/n900_mc.png
---

- [Co telefon má a co mu chybí](#co-telefon-má-a-co-mu-chybí)
- [Malé programy v C](#malé-programy-v-c)
- [Programy v Rustu a Go](#programy-v-rustu-a-go)
- [Barvy v terminálu](#barvy-v-terminálu)
- [Textová menu: dialog, whiptail a apt tui](#textová-menu-dialog-whiptail-a-apt-tui)
- [Co jsem nechal být](#co-jsem-nechal-být)

N900 je malý Linux v kapse a terminál na ní bývá nejužitečnější aplikace. Jenže výbava z roku 2009 je skromná: chybí `tmux`, `screen`, `ncdu`, `strace`, `rsync`, textový prohlížeč s moderním TLS a spousta dalšího. Projekt N900 resurrection má proto sbírku programů, které jsem přeložil a zabalil. Tenhle článek je přehled, co mezi nimi je, a hlavně proč se některé nedaly přeložit tak snadno.

## Co telefon má a co mu chybí

Prostředí značně omezuje co na něm poběží. Telefon má:

- **256 MB RAM** (v běžném provozu je volných asi 100 MB v cache), Linuxové jádro **2.6.28**, jedno jádro procesoru 600 MHz.
- Terminál 800×480, tedy asi 80×24 řádků s vysunutou klávesnicí.
- Knihovny: `glib 2.20` (nové programy jako irssi, WeeChat nebo Midnight Commander ji nepřeloží, chtějí 2.3x až 2.5x), `ncurses 5.7` (bez „w“), `OpenSSL 0.9.8` (jen TLS 1.0, na internetu prakticky k ničemu), `zlib 1.2.3`.
- Chybí i drobnosti: `file`, `rsync`, `tmux`, `lynx`, `strace`, `gdb` a další. Je tam busybox, mplayer, git, Python 3, perl, sqlite3, curl, wget, nmap a lsof.
- Kořenový systém má jen asi 57 MB volného místa, proto programy jdou do `/opt/<aplikace>` a odkazy do `/usr/bin`. Systémové balíčky nikdy nepřepisuju.

## Malé programy v C

Ty jsem překládal podle receptu z článku o sestavování. Pár poznámek k těm, kde to nešlo „samo“:

- **tmux 3.8.** Potřebuje knihovnu libevent, kterou jsem přeložil staticky bez `eventfd`: glibc 2.5 na telefonu nemá pro něj obálku. Tmux se odmítne spustit, když v systému není žádná UTF-8 locale. Telefon je má v archivu locale-archive, ale sysroot na PC jen prázdné soubory, a tak se tmux dřív v emulaci spustit nedal. Teď si archiv z telefonu zkopíruju (`make locale-overlay`) a tmux se testuje i pod qemu.
- **ncdu 1.22** (verze 2.x je v Zigu, tak jsem použil 1.x). Je to nejrychlejší způsob, jak zjistit, co zaplnilo 2 GB `/home` nebo 57 MB kořenový systém.
- **strace 6.19.** Jádro 2.6.28 umí `ptrace`, ale hlavičky z novějších balíčků musí být před těmi starými ze sysrootu. Strace jsem potřeboval při hledání příčiny zasekávání Application Manageru.
- **file 5.48.** Pro databázi `magic.mgc` je při překladu potřeba nativní `file` stejné verze. Doplňuje správce souborů `ranger`, který si dřív vystačil jen s mojí atrapou `file`.
- **rsync 3.5.2.** Zálohy a synchronizace z PC přes SSH. Dosud jsem měl jen `scp` a `tar`.
- **screen 5.0.2** a **tig 2.6.1** (ten potřebuje `ncursesw`, takže se zase linkuje staticky).
- **links 2.30**, textový prohlížeč, který přes statické OpenSSL 3 umí **TLS 1.3**. Stock prohlížeč má TLS 1.0, a tak je to jeho záchranná síť pro moderní weby. Svazek certifikátů je přibalený a obálka `/usr/bin/links` nastavuje `SSL_CERT_FILE`.
- **OpenSSH 10.6** (klient i server do `/opt/openssh`, systémová verze 5.1 se nedotýká). Ověřeno **jen pod qemu** (přihlášení klíčem, odmítnutí špatného klíče, sftp), na telefonu jsem ho zatím nezkoušel. Server nic nespouští a poslouchá na portu 2222 jen s klíči.

## Programy v Rustu a Go

Tady pomáhá, že oba jazyky umí statické binárky, které nepotřebují glibc 2.5. O tom je samostatný článek, tady jen seznam:

| Program | Co dělá |
|---|---|
| ripgrep 15.2, fd 10.5, bat 0.26 | rychlé hledání v souborech, hledání souborů, `cat` se zvýrazněním |
| fzf 0.75 | fuzzy hledání v historii a souborech |
| micro 2.0 | editor s normálními klávesami (Ctrl-S, Ctrl-Q, myš) pro ty, kdo vim nemají rádi |
| age 1.2 | šifrování souborů bez nastavování gpg |
| amfora 1.11 | prohlížeč Gemini |
| wireguard-go + `wg` | VPN v uživatelském prostoru přes `/dev/net/tun` |

U **wireguard-go** je důležité přiznat, co jsem ověřil: klíče, verze a pomocný skript `wg-n900 up|down`. Samotný tunel jsem zatím nezkoušel, protože potřebuje server a mění směrování telefonu. U **bat** se muselo použít cross gcc z projektu musl, protože zvýrazňování syntaxe (oniguruma) je napsané v C. Obálka `/usr/bin/bat` také nastavuje `BAT_PAGER=cat`, protože `less` v busyboxu na telefonu nezná přepínač `-R`.

## Barvy v terminálu

Stálý nešvar: stock terminál nastavuje `TERM=xterm`, tedy 8 barev, a v systému chybí terminfo pro 256 barev. `cbonsai` a `ranger` pak padají s chybou `Color number is greater than COLORS-1 (7)`. Opravil to malý balíček **`terminfo-256color`**, který přidá `xterm-256color`, `screen-256color` a `tmux-256color` do `/usr/share/terminfo` (nic systémového nepřepisuje) a přidá do `.bashrc` blok, který přepne `TERM`. Zrovna u tohohle jsem se přesvědčil, že ncurses 5.7 přečte jen starší formát databáze terminfo, takže jsem musel zmenšit `pairs#65536` na 32767. Při prvním vydání jsem se navíc spletl: záznam `xterm-256color` z moderního ncurses kreslí rámečky sekvencí `ESC ( 0`, které terminál Maemo nezná, a `dialog` (i `apt tui`) pak měl rozbitou grafiku. Stockový záznam `xterm` na telefonu používá `SO`/`SI`, a proto je teď `xterm-256color` postavený na něm a mění jen barvy.

## Textová menu: dialog, whiptail a apt tui

Na menu v terminálu se hodí `dialog` (1.3, přeložený se statickým ncursesw) a `whiptail` (z projektu newt, se statickým slang a popt). Nad dialogem stojí `apt tui`, o kterém píšu v článku o apt repozitáři.

## Co jsem nechal být

- **irssi, WeeChat, mc, profanity**: potřebují novou glib. Šlo by přeložit vlastní kopii glib, ale zatím to nestálo za to.
- **Impala** (Wi-Fi TUI): potřebuje `iwd`, telefon má `icd2`.
- **Těžké nástroje** (lazygit, bottom, helix, taskwarrior) žerou RAM.

Všechno je v apt repozitáři `n900-resurrection.github.io/n900-repository` a zdroje v organizaci [n900-resurrection](https://github.com/n900-resurrection). Většina balíčků je otestovaná na telefonu přes `make test`, ale kde jsem se zastavil u qemu nebo u klíčů, píšu to výslovně.
