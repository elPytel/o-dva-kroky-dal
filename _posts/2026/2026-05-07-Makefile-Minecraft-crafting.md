---
layout: post
title:  "Makefile Minecraft crafting"
author: "Jarda"
description: Cvičení v psaní Makefile pro generování předmětů z Minecraftu.
categories: 
    - programming
    - Github
tags: 
    - Makefile
thumbnail: assets/pc/makefile.webp
---

Odkaz na [github](https://github.com/elPytel/Makefile-Minecraft-crafting)


Předpisy make:
```bash
targets: prerequisites
	recipe
```

Jednoduchá závislost pro ukázku:

```makefile
crafting_table: oak_planks
	@echo "$(YELLOW)Crafting$(RESET) crafting table from oak planks..."
	@touch $@

stick: oak_planks
	@echo "$(YELLOW)Crafting$(RESET) stick from oak planks..."
	@touch $@

oak_planks: oak_log
	@echo "$(YELLOW)Crafting$(RESET) oak planks from oak log..."
	@touch $@

oak_log: visit_forest
	@echo "$(YELLOW)Cutting$(RESET) a oak tree to get an oak log..."
	@touch $@
    
visit_forest:
    @echo "$(YELLOW)Visiting$(RESET) the forest to find an oak tree..."
    @touch $@
```

| Pojem | Minecraft Analogie | Význam v automatizaci |
|---|---:|---|
| Target | crafting_table | Výsledný artefakt (soubor). |
| Prerequisites | oak_planks | Vstupy, bez kterých proces nezačne. |
| Recipe | Make crafting table | Skript/příkaz, který transformuje vstupy na výstup. |

Příkaz `touch $@` představuje vytvoření souboru, který reprezentuje úspěšné dokončení kroku.

Všechny `targety` jsou zde soubory, které se postupně vytvářejí. Pokud spustíme `make crafting_table`, make zkontroluje závislosti a spustí příkazy v pořadí, které zajistí, že všechny potřebné soubory budou vytvořeny.

`crafting_table` > `oak_planks` > `oak_log` > `visit_forest`

## Zobecnění pravidla `_ingot`

```makefile
%_ingot: %_ore furnace coal
	@echo "Smelting $(notdir $<) in the furnace to create $@..."
	@touch $@
```

`%` funguje jako wildcard. Pokud make hledá `iron_ingot`, dosadí za `%` `iron`. Vyžaduje k tomu soubor `%_ore` (např. `iron_ore`) a pec (`furnace`) a uhlí (`coal`).

Automatické proměnné:
- `$@`: Cíl (např. iron_ingot).
- `$<`: První závislost (např. iron_ore). To je užitečné, protože v peci tavíme rudu, ne uhlí nebo pec samotnou.

## Další zobecnění pro nástroje

```makefile
# Definice nastroju
PICKAXES = diamond_pickaxe iron_pickaxe stone_pickaxe wooden_pickaxe

# Vybere prvni existujici nastroj z seznamu
PICKAXE = $(firstword $(wildcard diamond_pickaxe iron_pickaxe stone_pickaxe wooden_pickaxe))

# Nastroje vyzaduji: material + tycky + stul
%_pickaxe: %_material stick crafting_table
	@echo "$(YELLOW)Crafting$(RESET) tool $@ from $<..."
	@touch $@

# Definice, co je materialem pro dany typ (alias pro pattern rule)
iron_material: iron_ingot
	@ln -sf $< $@
stone_material: cobblestone
	@ln -sf $< $@
wooden_material: oak_planks
	@ln -sf $< $@
```