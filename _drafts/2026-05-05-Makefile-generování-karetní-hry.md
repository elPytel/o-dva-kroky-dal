---
layout: post
title:  "Makefile generování karetní hry"
author: "Jarda"
description: A description
categories: 
    - programming
tags: 
    - Makefile
thumbnail: assets/pc/makefile.webp
---

# Vlastní Makefile

```bash
targets: prerequisites
	command
	command
```

## Barevný výstup

```makefile
RED	   := $(shell printf '\033[0;31m')
GREEN  := $(shell printf '\033[0;32m')
YELLOW := $(shell printf '\033[0;33m')
BLUE   := $(shell printf '\033[0;34m')
CYAN   := $(shell printf '\033[0;36m')
MAGENTA:= $(shell printf '\033[0;35m')
BOLD   := $(shell printf '\033[1m')
RESET  := $(shell printf '\033[0m')
```