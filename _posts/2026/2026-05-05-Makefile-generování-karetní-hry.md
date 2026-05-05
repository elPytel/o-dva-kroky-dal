---
layout: post
title:  "Makefile generování karetní hry"
author: "Jarda"
description: Jak jsem využil Makefile pro orchestraci generování karetní hry Gnarl
categories: 
    - programming
tags: 
    - Makefile
thumbnail: assets/programování/makefile.webp
---

# Vlastní Makefile

- [Vlastní Makefile](#vlastní-makefile)
  - [Struktura Makefile](#struktura-makefile)
  - [Definice konstant](#definice-konstant)
    - [Barevný výstup](#barevný-výstup)
    - [.PHONY](#phony)
  - [Makefile targets](#makefile-targets)
    - [Složky](#složky)
    - [Složizé příkazy](#složizé-příkazy)
    - [Aliasy](#aliasy)
  - [pipelines](#pipelines)


Při generování karetní hry Gnarl využívám vlastnosti Makefile, pro hledání závislostí. Nevytvářím však soubory schodující se s cíli a tak se pipe line spouští při každém zavolání celá od začátku až do konce příkazu který jsme zadali při spuštění make.

Není to sice tak efektivní a nevyužívá to všech dovedností make, ale je to mnohem jednodužší na pohochopení a psaní. 

Make v tomto projektu tak neslouží jako nástroj pro optimalizaci, ale jako jedno místo, kde jsou uložené všechny příkazy pro generování karet a manipulaci s nimi, které by se jinak váleli v README.

Místo příkazů:
```bash
pandoc $(OUT_DIR)/rules_pandoc.md --standalone --metadata title="$(TITTLE)" --css style.css -o $(HTML_DIR)/index.html
pandoc $(OUT_DIR)/rules_pandoc.md --standalone --metadata title="$(TITTLE)" --css print.css -o $(HTML_DIR)/rules_print.html
```

Stačí spustit:
```bash
make html-rules
```

Což je příkaz, který se uživatelsky výrazně snadněji zadává do terminálu, když chcete vygenerovat HTML verzi pravidel.

## Struktura Makefile

```bash
targets: prerequisites
	command
	command
```

## Definice konstant

Konstatny pro cesty k adresářům, které se používají v různých částech Makefile, aby se předešlo opakování a usnadnila údržba.

```makefile
OUT_DIR   := out
TOOLS_DIR := tools
HTML_DIR  := pages
DOCS_DIR  := DOC
```

### Barevný výstup

Všem scriptům přidávám pro přehlednost barevný výstup:

```makefile
RED    := $(shell printf '\033[0;31m')
GREEN  := $(shell printf '\033[0;32m')
YELLOW := $(shell printf '\033[0;33m')
BLUE   := $(shell printf '\033[0;34m')
CYAN   := $(shell printf '\033[0;36m')
MAGENTA:= $(shell printf '\033[0;35m')
BOLD   := $(shell printf '\033[1m')
RESET  := $(shell printf '\033[0m')
```

### .PHONY
`.PHONY` slouží k deklaraci cílů, které nejsou soubory. To znamená, že když spustíme `make clean`, make nebude hledat soubor s názvem `clean`, ale místo toho vždy spustí příkazy definované pod tímto cílem.

```makefile
.PHONY: all clean help
```

## Makefile targets

Doporučené targety:
- `all` - výchozí target, který spouští všechny potřebné kroky,
- `help` - zobrazí nápovědu s popisem všech targetů,
- `clean` - odstraní všechny vygenerované soubory.

```makefile
all: pdf

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  help	- show this help"
	@echo "  html	- generate front/back/both HTML using current XSL (uses python merger when cards/ is present)"
	@echo "  clean	- remove generated PDFs and HTML in $(OUT_DIR) and $(HTML_DIR)"

# Remove generated PDFs and HTML files
clean:
	rm -f "$(OUT_DIR)"/*.pdf
	rm -f "$(HTML_DIR)"/*.html
	rm -f "$(HTML_DIR)"/*.xml
```

### Složky
Pokud potřebuje vytvořit nějaké adresáře, které ještě neexistují, můžeme přidat targety pro jejich vytvoření:

```makefile
$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(HTML_DIR):
	mkdir -p $(HTML_DIR)
```

Target stejného jména jako adresář zajistí, že se adresář vytvoří, pokud ještě neexistuje, a zároveň může být použit jako závislost pro jiné targety, které potřebují tento adresář k uložení svých výstupů.

### Složizé příkazy

Pro složitější příkazy, které jsou na několik řádků a obsahují vnořenou logiku je lepší vytvořit Bash/Python skript, který tyto příkazy zabalí a pak ho zavolat z Makefile.

```makefile
deps:
	@./install.sh

python-merge:
	$(PY) $(TOOLS_DIR)/merge_cards.py $(MERGE_SRCS) $(MERGED)
```

### Aliasy

Pro zpříjemnění práce můžeme vytvořit aliasy, které budou spouštět více targetů najednou. Například:

```makefile
all: pdf html validate
```

Tímto způsobem, když spustíme `make all`, spustí se všechny tři targety `pdf`, `html` a `validate` v jednom příkazu, což zjednodušuje proces pro uživatele, který chce vygenerovat všechny výstupy najednou.

Další možností je vytvořit specifické aliasy pro různé fáze generování, například příkaz:
```makefile
make validate
```
Je mnohem čitelněšjí a snadněji zapamatovatelný než:
```bash
make out/.validated
```

Výhoda takových aliasů je v tom že kombinují srozumitelné názvy s testem a existenci a aktuálnost souborů.

```makefile
validate: $(OUT_DIR)/.validated
$(OUT_DIR)/.validated: $(shell find $(CARDS_DIR) -type f -name '*.xml') $(XSD) | $(OUT_DIR)
	@printf "$(YELLOW)Validating from $(BLUE)%s$(RESET) against $(BLUE)%s$(RESET)\n" "$(CARDS_DIR)" "$(XSD)"
	@./$(TOOLS_DIR)/validate_cards.sh "$(CARDS_DIR)" "$(XSD)"
	@touch $@
```

- `@touch $@` vytvoří soubor `.validated`

Závislosti:
- XML soubore v `$(CARDS_DIR)`
- XSD schéma `$(XSD)`
- výstupní adresář `$(OUT_DIR)`, který musí existovat pro uložení `.validated` souboru.

Příkaz `make validate` zkontroluje všechny XML soubory v `$(CARDS_DIR)` proti XSD schématu a pokud jsou všechny validní, vytvoří soubor `.validated`, který slouží jako důkaz, že validace proběhla úspěšně. Pokud se nějaký soubor změní nebo přidá nový, `.validated` se stane neaktuálním a příště při spuštění `make validate` se znovu spustí validace.

## pipelines

Když tak uživatel zavolá příkaz:
```bash
make pdf
```

Make automaticky spustí pipeline, která mě dvě větve:

pdf -> pdf-rules -> html-rules -> rules-pandoc -> rules.md

pdf -> pdf-both -> html -> html-both -> merge -> validate -> cards/*xml

A nakonec mi vypadnou PDF a HTML verze pravidel a karet, které jsou připravené pro tisk i pro online prohlížení.