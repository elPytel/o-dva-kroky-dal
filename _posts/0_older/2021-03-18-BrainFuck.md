---
layout: post
title:  "BrainF#ck"
author: "Jarda"
description: BrainF#ck kompilátor v C
categories: 
    - programming
    - Github
tags: 
    - C
    - BrainFuck
thumbnail: assets/programování/BrainfuckHelloWorld.png
---

Odkaz na [github](https://github.com/elPytel/BF_interpreter)

Příkazy jazyka BrainF#ck:
- `>` posunout ukazatel doprava
- `<` posunout ukazatel doleva
- `+` inkrementovat hodnotu na aktuální pozici
- `-` dekrementovat hodnotu na aktuální pozici
- `.` vypsat znak odpovídající hodnotě na aktuální pozici
- `,` načíst znak a uložit jeho hodnotu na aktuální pozici
- `[` pokud je hodnota na aktuální pozici nulová, skočit na příkaz za odpovídající `]`
- `]` pokud je hodnota na aktuální pozici nenulová, skočit zpět na příkaz za odpovídající `[`

Celý jazyk je postaven na těchto 8 příkazech, které manipulují s polem bajtů a ukazatelem.

Myšlenka interpretoru je jednoduchá. Tyto příkazy jsou interpertovány stavovým automatem jako příkazy v jazyce C.

| Branfuck | C | Komentář |
| --- | --- | --- |
| `>` | `++ptr;` | Pokud je ukazatel větší než velikost pole, přidá se další buňka |
| `<` | `--ptr;` |
| `+` | `++*ptr;` |
| `-` | `--*ptr;` |
| `.` | `putchar(*ptr);` |
| `,` | `*ptr = getchar();` |

Smyčky pro vyhodnocení potřebují trochu složitější logiku, protože je potřeba správně zpracovat vnořené smyčky. K tomu se používá zásobník pro uložení pozic smyček.

Kód se načítá z textového souboru, který obsahuje BrainF#ck kód. Interpret prochází tento kód znak po znaku a vykonává odpovídající příkazy.

## Relevatní odkazy:
- [roachhd: Basics of BrainFuck](https://gist.github.com/roachhd/dce54bec8ba55fb17d3a)
- [wiki: Brainfuck](https://cs.wikipedia.org/wiki/Brainfuck)