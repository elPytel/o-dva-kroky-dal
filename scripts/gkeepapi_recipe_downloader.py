#! /usr/bin/env python3
# by elPytel
import os
import gkeepapi
import configparser

FOLDER_NAME = '../_recipes'
CONFIG_FILE = 'keep.config'

VERBOSE = True
DEBUG = True

# Načti konfiguraci
config = configparser.ConfigParser()
config.read(CONFIG_FILE)


if DEBUG:
    print(f"Přihlašovací údaje: {config['google']['email']}, \"{config['google']['password']}\"")

# Přihlaš se ke svému Google účtu
keep = gkeepapi.Keep()
success = keep.authenticate(config['google']['email'], config['google']['password'])

if not success:
    raise Exception("Přihlášení selhalo. Zkontroluj své přihlašovací údaje.")
elif VERBOSE:
    print("Přihlášení bylo úspěšné.")

exit()

# Synchronizace poznámek
keep.sync()

# Filtruj podle štítku "recepty"
notes = keep.find(labels=[keep.findLabel('recepty')])

# f string template
recipe_template = """\
---
layout: recipe
title: {title}
---
{content}
"""

for note in notes:
    # Vytvoř Markdown soubor pro každý recept
    filename = f"{note.title.replace(' ', '_')}.md"
    with open(os.path.join(FOLDER_NAME, filename), 'w', encoding='utf-8') as file:
        file.write(recipe_template.format(title=note.title, content=note.text))