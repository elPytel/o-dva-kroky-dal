---
layout: post
title:  "Python basic colors"
author: "Jarda"
description: Tvorba vlastního balíčku pro základní barvy v Pythonu
categories: 
    - programming
    - Github
tags: 
    - Python
thumbnail: assets/programování/Python_logo.png
---

Odkaz na [github](https://github.com/elPytel/basic-colors)

- [Vytvoření balíčku](#vytvoření-balíčku)
  - [Publikace na PyPI](#publikace-na-pypi)
  - [Kontrola instalace z PyPI](#kontrola-instalace-z-pypi)
  - [Vynucení aktualizace balíčku:](#vynucení-aktualizace-balíčku)


Balíček `basic-colors` poskytuje jednoduché funkce pro tisk barevného textu do terminálu a také formátování zpráv typu info, warning, success a error.


Vzorový výstup pro stylování textu:

```txt
ℹ️ Info: This is an info message.     
⚠️ Warning: This is a warning message.
✅ Success: This is a success message.  
❌ Error: This is an error message.
```

## Vytvoření balíčku

Klíčové soubory:
- `README.md`: Popis projektu (doporučuje se použít Markdown).
- `LICENSE`: Licence projektu (např. MIT, Apache 2.0).
- `setup.py`: Konfigurace pro balíček.

Pro sestavení balíčku jsem použil `setuptools` a vytvořil `setup.py`:

```python
from setuptools import setup, find_packages

setup(
    version='0.1.2',
    name='basic-colors',
    py_modules=["basic_colors"],
    author='elPytel',
    author_email='xxx',
    description='A module for printing colored text to the terminal',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    url='https://github.com/elPytel/basic-colors',
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.6',
)
```

Testování balíčku:
```bash
pip install .
```

Vytvoření distribučního balíčku:
```bash
pip install build
python -m build
```

Výsledkem budou soubory `.tar.gz` a `.whl` ve složce `dist/`.

### Publikace na PyPI

Zaregistroval jsem se na [PyPI](https://pypi.org/).

Poté jsem nainstaloval twine a nahrál balíček:
```bash
pip install twine
twine upload dist/*
```

### Kontrola instalace z PyPI

Pro ověření, že balíček je dostupný a funguje správně, jsem ho nainstaloval z PyPI:
```bash
pip install basic-colors
```

### Vynucení aktualizace balíčku:
```bash
pip install --upgrade --no-cache-dir basic-colors
```