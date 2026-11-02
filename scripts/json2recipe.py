#!/usr/bin/env python

import json
from pathlib import Path

REPOSITORY_ROOT = Path(__file__).resolve().parent.parent
KEEP_JSON = REPOSITORY_ROOT / "keep.json"
RECIPES_FOLDER = REPOSITORY_ROOT / "_recipes"

with KEEP_JSON.open("r") as f:
    data = json.load(f)

# f string template
recipe_template = """\
---
layout: recipe
title: {title_yaml}
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

# convert unicode title to ascii filename
def title_to_filename(title):
    filename = title.lower().replace(" ", "-")
    filename = "".join(c for c in filename if c.isalnum() or c == "-")
    # remove leading and trailing -
    filename = filename.strip("-")
    # remove multiple -
    while "--" in filename:
        filename = filename.replace("--", "-")
    return filename

# from notes in list to .md files in _recipes
for note in data:
    if 'Recepty' not in note['tags']:
        continue

    filename = title_to_filename(note['title'])

    path_filename = RECIPES_FOLDER / f"{filename}.md"
    content = format_content(note)
    with path_filename.open("w") as f:
        f.write(
            recipe_template.format(
                title_yaml=json.dumps(note['title'], ensure_ascii=False),
                content=content,
            )
        )

print(f"Converted {len(data)} notes to recipes in {RECIPES_FOLDER}.")
print("Done.")