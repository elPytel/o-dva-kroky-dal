#!/usr/bin/env python3
"""
Generate simple category pages under `kategorie/` for each tag found in `_posts/`.

Requires: PyYAML
Usage:
  pip install pyyaml
  python3 scripts/generate_category_pages.py

This writes files like `kategorie/mobily.md` with front matter:
---
layout: category
title: Mobily
category: mobily
permalink: /kategorie/mobily/
---
"""
import os
import re
import sys
import unicodedata

try:
    import yaml
except Exception:
    print("PyYAML required. Install with: pip install pyyaml", file=sys.stderr)
    sys.exit(1)

ROOT = os.path.dirname(os.path.dirname(__file__))
POSTS_DIR = os.path.join(ROOT, '_posts')
OUT_DIR = os.path.join(ROOT, 'kategorie')

def slugify(s: str) -> str:
    s = s.lower()
    s = unicodedata.normalize('NFKD', s)
    s = ''.join(c for c in s if not unicodedata.combining(c))
    s = re.sub(r'[^a-z0-9\s-]', '', s)
    s = re.sub(r'\s+', '-', s.strip())
    s = re.sub(r'-+', '-', s)
    return s

def read_front_matter(path):
    with open(path, 'r', encoding='utf-8') as f:
        text = f.read()
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        return {}
    try:
        return yaml.safe_load(m.group(1)) or {}
    except Exception:
        return {}

def collect_tags():
    tags = {}
    for root, dirs, files in os.walk(POSTS_DIR):
        for fn in files:
            path = os.path.join(root, fn)
            if not os.path.isfile(path):
                continue
            fm = read_front_matter(path)
            for key in ('tags', 'categories'):
                if key in fm and fm[key]:
                    if isinstance(fm[key], str):
                        raw = fm[key]
                        # Support both comma-separated and space-separated category strings
                        if ',' in raw:
                            vals = [v.strip() for v in raw.split(',') if v.strip()]
                        else:
                            vals = [v.strip() for v in re.split(r'\s+', raw) if v.strip()]
                    else:
                        vals = fm[key]
                    for t in vals:
                        tags[t] = tags.get(t, 0) + 1
    return tags

def ensure_out():
    os.makedirs(OUT_DIR, exist_ok=True)

def write_page(tag, count):
    slug = slugify(tag)
    title = tag
    filename = os.path.join(OUT_DIR, f"{slug}.md")
    permalink = f"/kategorie/{slug}/"
    content = f"---\nlayout: category\ntitle: {title}\ncategory: {tag}\npermalink: {permalink}\n---\n\n"
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)
    print('Wrote', filename)

def main():
    tags = collect_tags()
    if not tags:
        print('No tags found in _posts/')
        exit(1)
    ensure_out()
    for tag, count in sorted(tags.items(), key=lambda x: (-x[1], x[0])):
        write_page(tag, count)

if __name__ == '__main__':
    main()
