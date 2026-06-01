---
layout: post
title:  "SSL checker"
author: "Jarda"
description: Jednoduchý Makefile pro kontrolu platnosti SSL certifikátu.
categories: 
    - IT
    - Github
tags: 
    - Makefile
thumbnail: /assets/SSL_logo.png
---

# Kontrola SSL certifikátu pomocí Makefile

Už jsem si nechtěl pořád dokola hledat příkazy pro kontrolu platnosti SSL certifikátu, a tak jsem si napsal jednoduchý Makefile, který mi ty příkazy pamatuje za mě.


## Příklad použití

Pro stažení SSL certifikátu pro `seznam.cz` a zobrazení jeho platnosti stačí spustit:

```bash
make WEBSITE=seznam.cz
```

A do terminálu se vypíší všechny informace o certifikátu, včetně data expirace.

## Gist:

<script src="https://gist.github.com/elPytel/ce59630602b039a785702bd30e9e324c.js"></script>

