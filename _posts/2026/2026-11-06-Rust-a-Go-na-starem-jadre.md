---
layout: post
title:  "Rust a Go na jádře 2.6.28"
author: "Jarda"
description: Jak se na starém jádře N900 rozběhly programy v Rustu a Go. Statické binárky, jedna záplata runtime Go a TLS 1.3 bez OpenSSL.
categories:
    - n900
    - Claude
tags:
    - Maemo
    - Rust
    - Go
---

- [Proč zrovna Rust a Go](#proč-zrovna-rust-a-go)
- [Go](#go)
- [Rust](#rust)
- [TLS 1.3 bez OpenSSL](#tls-13-bez-openssl)
- [Další programy](#další-programy)
- [Co není ověřené](#co-není-ověřené)

Moje Nokia N900 má jádro **2.6.28**, glibc 2.5 a OpenSSL 0.9.8. Většina nových programů v C se dá přeložit jen s námahou, protože chtějí novější glibc nebo knihovny. Rust a Go mají jednu velkou výhodu: umí **statické binárky**, které si nesou vlastní libc nebo žádnou nepotřebují. Telefon pak vůbec nemusí řešit, jaké knihovny má.

## Proč zrovna Rust a Go

- Binárka se přeloží na PC (cross-kompilace) a na telefon se jen zkopíruje.
- Nezávisí na glibc 2.5 ani na OpenSSL. TLS 1.3 je v nich napsané samo.
- Mnoho moderních nástrojů (ripgrep, fd, fzf, micro, age, wireguard-go) je právě v jednom z nich.

## Go

Go překládám na hostiteli: `CGO_ENABLED=0`, `GOARM=7`, výsledek je statický. Ověřil jsem na N900 (Go 1.24.13) goroutiny, `net/http` a HTTPS s TLS 1.3 na GitHub. Dvě věci stojí za vysvětlení:

- **Záplata runtime.** Jádro 2.6.28 nemá syscall `epoll_pwait` (na ARMu přibyl až ve 2.6.32). Runtime Go proto padal s `epollwait failed with 38` (ENOSYS), takže **bez úpravy nepoběží žádný Go program**. `build.sh` proto v kopii toolchainu změní číslo syscallu na `epoll_wait` (252). Je to jediná změna, ale bez ní nepoběží nic.
- **Certifikáty.** Go na Maemo žádné kořenové certifikáty nenajde. Programy proto spouštím s `SSL_CERT_FILE=/opt/curl/etc/ssl/cacert.pem`.

CPU je jedno jádro (`NumCPU` = 1), goroutiny tedy běží prokládaně a ne paralelně. Nové Go 1.25 jsem nezkoušel a u `age` je to důvod, proč zůstává verze 1.2 (1.3 už potřebuje Go 1.25).

## Rust

Cíl je `armv7-unknown-linux-musleabi` z `rustup target add`. Výsledek je **statická binárka s vlastní libc (musl)**, takže glibc 2.5 se nepoužije. Je s měkkým ABI (žádné VFP) a `-C target-cpu=cortex-a8`. Linkuje se cross gcc z Workshopu. Instalace `rustup` do `build/rust/` zabere asi 765 MB (není v gitu).

Oficiálně Rust vyžaduje Linux 3.2 a novější, jádro 2.6.28 je starší. Ověřený testovací program (vlákna a kanály, čas, soubory, TCP server a klient na loopbacku) běží a má 430 kB. Pomáhá, že se vyhýbá chybějícím syscallům, jako je `epoll_pwait`.

Moderní asynchronní kód se ukázal jako nejpříjemnější překvapení: **tokio** s vícevláknovým runtimem, časovači, úlohami, TCP echem a HTTPS požadavkem přes `tokio-rustls` běží na telefonu a celý test trvá 1,3 s. Znamená to, že `mio` (a tím `epoll`) funguje, protože na 2.6.28 používá `epoll_wait`, ne `epoll_pwait`. Binárka má 1,2 MB.

## TLS 1.3 bez OpenSSL

Systémový OpenSSL na telefonu umí jen TLS 1.0 (víc o tom v článku o HTTPS a prohlížeči). Rust a Go to řeší po svém:

- **Rust:** knihovna `rustls` 0.23 s providerem `ring` (certifikáty přibalené v `webpki-roots`). Testovací program vypíše `TLS: TLSv1_3, TLS13_AES_128_GCM_SHA256` a howsmyssl.com potvrdí TLS 1.3. C a assembler z `ring` se překládá cross gcc (`CC_armv7_unknown_linux_musleabi=arm-linux-gnueabi-gcc`).
- **Go:** TLS 1.3 je součástí standardní knihovny.

Praktická poznámka: binárky kopíruju do `/home/user/apps`, protože `/tmp` na telefonu je tmpfs velký jen 1 MB.

## Další programy

Pomocné skripty `scripts/cargo-install.sh` (Rust, z crates.io) a `scripts/go-install.sh` (Go, z modulů) postaví program jedním příkazem. Takhle vznikly ripgrep, fd, bat, fzf, micro, age a wireguard-go. Pro `bat` bylo potřeba cross gcc z projektu musl (zvýrazňování syntaxe používá knihovnu oniguruma v C), pro `micro` a `amfora` jsem repozitář naklonoval a přeložil kvůli `replace` v `go.mod`. Další projekt, který na tom stojí, je Signal (klient `gurk` a můj most pro Maemo), o kterém je samostatný článek.

## Co není ověřené

- Dlouhodobý běh a spotřeba paměti (telefon má 245 MB využitelné RAM).
- Další syscally mimo ty, které používají `net/http`, goroutiny a tokio.
- Novější verze Go než 1.24.
- Kontrolní součet `rustup-init` zatím není připnutý.

Všechny programy jsou v apt repozitáři `n900-resurrection.github.io/n900-repository` a zdroje v organizaci [n900-resurrection](https://github.com/n900-resurrection).
