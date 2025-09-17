#!/usr/bin/env python

import json
import os

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

H1_list = [
    "Ingredience:",
    "Postup:",
    "Postup přípravy:",
    "Zdroje:",
    "Zdroj:"
]

# make links working
# https://www.vareni.cz/recepty/kureci-cina-se-zeleninou/
# kureci cina se zeleninou

def make_link(link:str):
    last_part = link.split("/")[-1]
    link_name = last_part.replace("-", " ")
    return f"[{link_name}]({link})"

def format_content(note):
    content = note['content']
    # :\n 
    content = content.replace(":\n", ":\n\n")
    for h1 in H1_list:
        content = content.replace(h1, f"\n# {h1}")
    lines = content.splitlines()
    for i, line in enumerate(lines):
        if line.strip().startswith("https://"):
            lines[i] = make_link(line.strip())
    return "\n".join(lines)

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