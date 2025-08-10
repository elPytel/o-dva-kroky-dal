#!/usr/bin/env python

import json
import os
import glob
import uuid
from datetime import datetime

KEEP_JSON = "keep.json"
RECIPES_FOLDER = "./_recipes"

with open("./keep.json", "r") as f:
    data = json.load(f)

# f string template
recipe_template = """\
---
layout: recipe
title: {title}
---
{content}
"""

def format_content(note):
    content = note['content']
    # za ":" musí být \n
    content = content.replace(":", ":\n")
    # před ingrediencemi musí být prázdný řádek
    content = content.replace("Ingredience:", "\n# Ingredience:")
    content = content.replace("Postup:", "\n# Postup:")
    return content

# from notes in list to .md files in _recipes
for note in data:
    if 'Recepty' not in note['tags']:
        continue

    filename = os.path.join(RECIPES_FOLDER, f"{note['id']}.md")
    content = format_content(note)
    with open(filename, "w") as f:
        f.write(recipe_template.format(title=note['title'], content=content))

print(f"Converted {len(data)} notes to recipes in {RECIPES_FOLDER}.")
print("Done.")