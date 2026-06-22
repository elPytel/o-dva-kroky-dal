---
layout: post
title:  "Discord server bash accessor"
author: "Jarda"
description: "Discord bot pro vzdálenou správu serveru přes bash příkazy"
categories: 
    - programming
    - Github
tags: 
    - Discord
    - Python
    - Bash
thumbnail: /assets/Discord_logo.jpg
---

Github: [Discord server bash accessor](https://github.com/elPytel/Discord_server_bash_accessor)

Provozoval jsem několik strojů na kterých běžely moje experimenty. Thinkpad x220t dělal domácí server a potřeboval jsem způsob jak bych jej mohl vzdáleně kontrolovat.

Cílem bylo:
1. Možnost vzdáleného přístupu k serveru bez nutnosti SSH připojení.
2. Aplikace, která poběží na mém mobilu.
3. Možnost vzdáleného spouštění příkazů a získávání výstupu.
4. Odesílání souborů ze serveru (logy).

Chtěl jsem nějaké řešení, které by bylo dostatečně bezpěčné. Nechtěl jsem řešit ssh pro přístup z telefonu. 

Všechny tyto cíle splněuje řešení v podobě Discord bota, který komunikuje s mým serverem a umožňuje mi ovládat jej přes Discord zprávy.

Discord nabízí poměrně přívětivé prostředí pro odesílání zpráv a je škálovatelný co do počtu zpravovaných strojů.

Každý stroj si vytvoří po připojení vlastní kanál. Příkazy které do něj zapíšu se vykonají na serveru a výstup se mi vrátí zpět do kanálu.

## Možné příkazy pro bota:

Spusť vzdáleně příkaz a vrať výstup:
```txt
$run "bash command"
```

Pošli mi soubor ze serveru:
```txt
$file "path to file"
```