---
layout: post
title:  "Objevujeme Makefile"
author: "Jarda"
description: Jak na Makefile a proč je užitečný
categories: 
    - programming
tags: 
    - Makefile
thumbnail: assets/programování/makefile.webp
---

S Makefile jsem se mořil již při studiu na ČVUT, ale při té příležitosti jsem ho vlastně pořádně nerozlousknul. Měl jsem nastavenou pipeline pro kompilaci C kódu, ale netušill jsem jak to že to funguje. 

Pak přišel Covid 19 a já se přeunul znovu do prváku na TUL. Teď dokončuji ing studium a dal jsem Makefile druhou šanci.

Musel jsem ho zkrotit, když jsme na pana Jeníčka bojoval s OpenGL v C++, při vývoji našeho vlastního herníního enginu. Roky IT vzdělnání se na mě podepsaly pozitivně a již jsem s ním takový problém neměl.

Nejvíce ladění **make** jsem se ale dočkal, když jsem dával do kupy karetní hru Gnarl. Potřeboval jsem provázat:
- stahování závislostí `apt` + `pip`,
- `python` scripty,
- `bash` příkazy,
- Linux utility,
- `xml` pipelines,
- HTML -> PDF export přes headless prohlížeč...

Na všechno jsem už měl nějaké kusy kódu v Pythonu, Shellové scripty...

Potřeboval jsem to ale nějak spojit dohromady v jeden koherentní celek.

Hodně se toho dá udělat v Pythonu, ale je to takové škrábání se vidličkou na zádech, jde to, ale vy víte že to není ono. Rozhodl jsem se proto vyzkoušet Makefile jako nástroj pro orchestraci všech těchto kroků.

## Deklarativní vs. Imperativní programování
`make` se primárně řadí do deklarativního programování.

Co to znamená? V Makefile neříkáme počítači krok po kroku co má udělat: „Teď se podívej na soubor A, pak na soubor B, a pokud je A novější, spusť kompilátor.“ Místo toho deklarujeme cíle (**targets**), jejich závislosti (**prerequisites**) a pravidla (**recipes**).

Logika systému: make si sám sestaví orientovaný acyklický graf (DAG) závislostí. Když ho pak spustíme, nástroj projde tento graf a sám určí minimální množinu příkazů, které musí vykonat, aby dosáhl požadovaného stavu.

Proč je to občas matoucí? (Hybridní povaha)
Ačkoliv je celková struktura Makefile deklarativní, samotné příkazy (v tabulátory odsazených řádcích) jsou čistě imperativní shell skripty.

```bash
targets: prerequisites
	command
	command
```

- `targets` - co chceme vytvořit (Název souboru, který chceme vygenerovat),
- `prerequisites` - soubory, které jsou potřeba k vytvoření cíle (Závislosti, které musí být aktuální, aby cíl mohl být vytvořen),
- `recipes` - příkazy, které se spustí, pokud jsou závislosti novější než cíl,
  - `command` - jednotlivé příkazy v receptu, které se spouští v shellu.

Make kouká na čas poslední modifikace souborů a rozhoduje, které příkazy spustit. Pokud je cílový soubor starší než některá z jeho závislostí, make spustí příkazy pro aktualizaci cíle.

Pokud se při spuštění pipeliny nevytváří soubor, který by se názvem schodoval s cílem, **make** bude tyto příkazy spouštět při každém zavolání.

Pokud neexistuje soubor stejného názvu jako závislost, make se bude snažit tento soubor vytvořit pomocí pravidel, která jsou definována v Makefile. Pokud žádné pravidlo pro vytvoření tohoto souboru neexistuje, make vypíše chybu a zastaví se.

## Zdroje:
- [wiki: Make (software)](https://en.wikipedia.org/wiki/Make_(software))
- [makefiletutorial.com](https://makefiletutorial.com/)