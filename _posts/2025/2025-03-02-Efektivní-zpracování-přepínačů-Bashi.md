---
layout: post
title:  "Efektivní zpracování přepínačů Bashi"
author: "Jarda"
description: Scriptujeme v Bashi o 106
categories: 
    - programming
    - Github
tags: 
    - Bash
---

Odkaz na [gist](https://gist.github.com/elPytel/b006352dae16e8f1f577e19f75bd05d3)

Pro dobře čitelné scripty v bashi doporučuji stavový automat pro zpracování přepínačů. Tento přístup umožňuje snadno rozšířit skript o další přepínače a zároveň udržet kód přehledný a snadno udržovatelný. 

Alternativně lze použít i `getopts` pro zpracování přepínačů, ale ten nepodporuje dlouhé přepínače (např. `--help`), což může být nevýhodou pro uživatele, kteří jsou zvyklí na tento styl.

<script src="https://gist.github.com/elPytel/b006352dae16e8f1f577e19f75bd05d3.js"></script>

Na začátku kódu jsou definovány konstatny a řídící proměnné.

```bash
#!/bin/bash
# By Pytel

#DEBUG=true
DEBUG=false

VERBOSE=false
```

Dále script obsahuje funkci `printHelp`, která vypíše nápovědu pro uživatele.

Jednoduchá detekce vyhodnotí zda je script spuštěný s přepínači nebo bez. Pokud není zadán žádný přepínač, script vypíše nápovědu a ukončí se s kódem.

While smyčka s `case` zpracovává jednotlivé přepínače. Každý přepínač je zpracován v samostatném bloku, což umožňuje snadno přidat další přepínače v budoucnu.

Příkaz `shift` posune všechny argumenty o jeden doleva, což umožňuje zpracovat další přepínač nebo argument v další iteraci smyčky. Tímto způsobem se stavový automat postupně přechroustá přes všechny zadané přepínače a provede konfiguraci skriptu podle zadaných parametrů.

Složitější příkazy lze zpracovat pomocí funkcí, kterým se předávají parametry. To umožňuje modularizovat kód a zlepšit jeho čitelnost.

```bash
# Konstanta, kterou chceme konfigurovat pomocí prepinace
TIME=5

# Funkce pro nastaveni casu a osetreni vstupu
function setTime() { # ( time)
    TIME="$1"
}

# hlavni cast progamu
sleep $TIME
```

Potom v kódu:
```bash
        -t | --time)	shift; setTime "$1" || exit 4;;
```
Pokud příjde přepínač `-t` nebo `--time`, v bloku `case` zavoláme funci `setTime`, přesuneme se o jeden argument do prava a předáme ho do funkce. 

Dvě `||` spojují dvě operace: první je volání funkce `setTime` s argumentem, a druhá je kontrola, zda tato operace byla úspěšná. Pokud `setTime` vrátí chybu (například pokud není zadán žádný argument), skript se ukončí s kódem 4.

Po zkončení zpracování přepínačů se script může věnovat své hlavní funkci, přičemž všechny potřebné proměnné a nastavení jsou již nakonfigurovány podle zadaných přepínačů.