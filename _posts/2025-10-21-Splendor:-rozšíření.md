---
layout: post
title: "Splendor: rozšíření"
description: Rozšíření deskové hry Splendor o sezónní slevy a zdražení
categories: ["TTG", "Splendor"]
---

# Rozšíření hry Splendor

Aneb jak jí přezdíváme mi "diamanty". Je to velmi pěkná desková hra. S poměrně jednoduchými pravidly. 

Základní postup ve hře:
- Sbíráte diamanty, 
- kupujete doly, 
- máte levnější nákupy -> kupujete více dolů, 
- kupujete bodové karty (stále s bonusem)

Tři balíčky karet, lišící se cenou a množstvím výherních bodů, které za ně dostanete.

Pokud je více hráčů, tak se základní balíček vykoupí a musíte kupovat dražší karty, ale za ně je více bodů a blížíte se k vítěství. 

Bonusy se ve hře postupně nabalují a hra začíná odsípat rychleji. Problém je ve hře dvou hráčů, kdy je hra po odhalení principu příliš monotoni. 

Rozhodli jsme se udělat naše vlastní rozšíření, které by mělo zvést do hryvětší prvek náhody. 

## Rošíření: Sezóny

Přicházejí sezónní slevy (zdražení) na nákup karet. 
Vybrané kameny jsou na kartách levnější, nebo dražší podle údálostí ve hře.

Dva balíčky karet:
- Sezóny - určují barvu. 
- Ceny - ty mohou klesat nebo růst.

Hráč může a nebo nemusí hodit kostkou na začátku svého tahu. Pokud padne 6, mění se sezóna. Hráč otočí vrchní kartu z obou balíčků.

Barvy kamenů:
- 💎 Bílý diamant
- ⚫ Černý onyx
- 🔴 Červený rubín
- 🟢 Zelený smaragd
- 🔵 Modrý safír
- 🟡 Žluté zlato

Barvy žetonů pro které mohou být slevy jsou rovnoměrně zastoupené herní žetony kromě zlata.

### Změna ceny
Ceny se mohou měnit: -2, -1, +1, +2

Počet událostí: 5, 10, 15

Typy událostí:
- **+2** - Zavalený důl, Parné léto 
- **+1** - Změna vkusu, královksá daň, potopená loď, ledový průsmyk, rozbouřené moře, piráti
- **-1** - Obchodní smlouva, cechovní podpora, krátká zima, vydatná žíla, příznivý vítr
- **-2** - Nová naleziště, Snížené clo

### Herní příklad
Na kartách je kombinace:
*-2 "zelené"*

Znamená to slovu na nákup karty. Všechny karty které mají v ceně zelené žetony jsou tedy levnější (až od dva zelené žetony) (cena nemůže být záporná).

| Půvpdní cena | Nová cena |
|--------------|-----------|
| 2 bílé       | 2 bílé    |
| 1 černý      | 2 černé   |
| 3 zelené     | 1 zelené  |

Na kartách je kombinace:
*+1 "bílé"*

Při nákupu karet s cenou v bílých žetonech musíte k ceně (bílým) přičíst +1.

| Půvpdní cena | Nová cena |
|--------------|-----------|
| 2 bílé       | 3 bílé    |
| 1 černý      | 2 černé   |
| 3 zelené     | 3 zelené  |

## Repozitář s rozšířením

Repozitář s rozšířením je dostupný na GitHubu: [Splendor - Seasons extension](https://github.com/elPytel/Splendor-rozsireni_Sezony)

## Nástroje na tvorbu karet

- [ttga: seznam](https://www.ttgda.org/software-tools)
- [cardmaker](https://github.com/nhmkdev/cardmaker)
- [nandeck](https://nandeck.com/)
- [dextrous](https://www.dextrous.com.au/)

Nakonec jsem si nechal všechny kartičky vygenerovat pomocí Chat GPT.