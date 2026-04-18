---
layout: post
title:  "Bash v Jupyteru"
author: "Jarda"
description: "Jak používat Bash jako kernel v Jupyteru pro výuku a skriptování."
categories: 
    - programming
tags: 
    - Bash
    - Jupyter
    - VSCode
thumbnail: "/assets/Jupyter.png"
---

Zaobýral jsem se myšlenkou, jak vytvořit výukové materiály pro Bash. Když studenti vypracovávají úkoly, tak musí vykopírovávat výstup z programů, aby mohli vytvořit referát o tom co dělaji. To je zbytečná práce navíc. Napadlo mě, že by bylo skvělé, kdyby mohli psát příkazy přímo v Jupyteru a používat Bash jako kernel, obdobně jako tomu je pro Python. To by jim umožnilo snadno spouštět příkazy a získávat výstupy přímo v notebooku. Jupyter si vždy ukládá výstupy z jednotlivých buněk, stačí pak soubor jenom uložit. 

V python-jupyteru je možné použít příkazy začínající vykřičníkem `!` pro spouštění příkazů v shellu.

```jupyter
!pip install numpy
```

Je to šikovné, když potřebujete doinstalovat pár balíčků na začátku porgramu, ale pro scriptování v Bashi to není ideální. 

Naštěstí existuje projekt `bash_kernel`, který umožňuje používat Bash jako kernel v Jupyteru. To znamená, že můžete psát příkazy přímo v buňkách a spouštět je, aniž byste museli používat `!`.

## Konfigurace prostředí

Pro vývoj používám VSCode s adekvátními rozšířeními pro Jupyter a Python. 

- [Python Extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
- [Jupyter Extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter)

Pro nastavení prostředí jsem vytvořil `Makefile`, který automatizuje instalaci potřebných balíčků a registraci Bash kernelu do Jupyteru.

`apt-dependencies.txt`:

```txt
python3-venv
python3-pip
```

`pip-dependencies.txt`:

```txt
jupyter
bash_kernel
```

`Makefile`:

```make
# Makefile to set up a virtual environment for Jupyter with bash_kernel

.PHONY: help venv install register list init clean

VENV_DIR := jupyter-bash-env
PY := $(VENV_DIR)/bin/python
PIP := $(VENV_DIR)/bin/pip
APT_DEPS := apt-dependencies.txt
PIP_DEPS := pip-dependencies.txt

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  venv         Create virtual environment ($(VENV_DIR))"
	@echo "  install-debs Install system packages from $(APT_DEPS)"
	@echo "  install-pip  Install pip and Python packages from $(PIP_DEPS)"
	@echo "  install      venv + install-debs + install-pip"
	@echo "  register     Register bash kernel into Jupyter (sys-prefix)"
	@echo "  list         List available Jupyter kernels"
	@echo "  init         install + register + list"
	@echo "  clean        Remove virtual environment"

venv:
	@test -d $(VENV_DIR) || python3 -m venv $(VENV_DIR)
	@echo "Virtualenv at $(VENV_DIR)"

install-pip:
	$(PY) -m ensurepip --upgrade
	$(PIP) install --upgrade pip
	$(PIP) install -r $(PIP_DEPS)

install-debs:
	sudo apt-get update
	# Install dependencies ignoring comments and empty lines
	grep -vE '^\s*#|^\s*$$' $(APT_DEPS) | xargs -r sudo apt-get install -y

install: venv install-debs install-pip

register: install
	$(PY) -m bash_kernel.install --sys-prefix

list:
	$(VENV_DIR)/bin/jupyter kernelspec list

init: register list

clean:
	rm -rf $(VENV_DIR)
```

Po vytvoření souborů ve stejné složce a otevření pomocí VSCode, můžete spustit `make init` pro nastavení prostředí. Tento příkaz vytvoří virtuální prostředí, nainstaluje potřebné balíčky a zaregistruje Bash kernel do Jupyteru.

Pak restartujte VSCode, aby se načetly nové Jupyter kernely. Po restartu byste měli vidět možnost vybrat Bash kernel při vytváření nového Jupyter notebooku.

Vytvořte nový soubor `bash-notebook.ipynb`. Otevřete jej a v pravém horním rohu editačního okna v IDE zvolte kernel `Bash`. Nyní můžete psát příkazy přímo do buňky a spouštět je.

```jupyter
echo "Hello, Bash in Jupyter!"
```