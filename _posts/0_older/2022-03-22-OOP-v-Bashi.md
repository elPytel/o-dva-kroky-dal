---
layout: post
title:  "OOP a TDD v Bashi"
author: "Jarda"
description: "Objektově orientované programování v Bashi"
categories: 
    - programming
    - Github
tags: 
    - Bash
thumbnail: assets/pc/Bash-logo.png
---

Ukázka jak by mohlo vypadat objektově orientované programování v Bashi. Vyscházím z předchozího článku o objektovém Bashi.

## Přetížení operátorů

I když je tohle skvělá ukázka flexibility Bashe, v ostré produkci na serverech doporučuji zůstat u standardních postupů. Tento framework je určen především pro edukační účely a demonstraci toho, že hranice mezi skriptováním a programováním jsou tenké.

```bash
#!/bin/bash
# By Pytel

source ./class.sh

#DEBUG=true
DEBUG=false

declare -A number

# Definice objektu number
number=(
    ["value"]=0
    ["display"]='
        echo "Value: $(get $this.value)"
        '
    ["+"]='
        local n1=$(get $this.value);
        local n2=$(get $1.value);
        echo "$(( n1 + n2 ))";
        '
    ["-"]='
        local n1=$(get $this.value);
        local n2=$(get $1.value);
        echo "$(( n1 - n2 ))";
        '
)

declare -A n1
declare -A n2

new n1 = number
new n2 = number

array_n1=( 4 5 1 )
array_n2=( 2 1 1 )
sum=( 6 6 2 )
dif=( 2 4 0 )

function test_display () {
    out=$(rof number.display)
    echo -e "$out"
    if [ "$out" != "Value: 0" ]; then
        return 1
    fi
    return 0
}

function test_operator+ () {
    local len=$(( ${#sum[@]} -1 ))
    local out=""
        
    for i in $(seq 0 $len); do
        echo "index: $i"
        echo "${array_n1[$i]}"
            
        sat n1.value = ${array_n1[$i]}
        sat n2.value = ${array_n2[$i]}
        
        out="$(rfn n1 + n2)"
        
        if [ "$out" != "${sum[$i]}" ]; then
            
            echo "$(get n1.value) + $(get n2.value) = $out"
            echo "sum: ${sum[$i]}"
            return 1
        fi
    done
    return 0
}

function test_operator- () {
    local len=$(( ${#sum[@]} -1 ))
    local out=""

    for i in $(seq 0 $len); do
        echo "index: $i"
        echo "${array_n1[$i]}"

        sat n1.value = ${array_n1[$i]}
        sat n2.value = ${array_n2[$i]}

        out="$(rfn n1 - n2)"

        if [ "$out" != "${dif[$i]}" ]; then

            echo "$(get n1.value) - $(get n2.value) = $out"
            echo "sum: ${dif[$i]}"
            return 1
        fi
    done
    return 0
}

# END
```

A kouzla se dějou: `out="$(rfn n1 + n2)"` vypočítá součet hodnot `n1` a `n2` pomocí přetíženého operátoru `+` definovaného v objektu `number`.