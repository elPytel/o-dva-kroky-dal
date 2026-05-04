---
layout: post
title:  "Sentient Regex"
author: "Jarda"
description: I tohle je AI!
categories: 
    - programming
    - Github
tags: 
    - Python
thumbnail: assets/programování/Regex_logo.webp
---

Odkaz na [gist](https://gist.github.com/elPytel/0743fd4765aeffc595cc5a4a62c1167b)

Založené na jednom cizím postu na redditu:

![regex]({{ site.baseurl }}/assets/programování/some-google-engineer-probably-v0-4nxizfmnqi691.webp)

`sentient_regex.py`

<script src="https://gist.github.com/elPytel/0743fd4765aeffc595cc5a4a62c1167b.js"></script>

Tento program načte vstup od uživatele a upraví pomocí regulárního výrazu.

Vzorový vstup:
`are you sentient?`

Vzorový výstup:
`Indeed, I am sentient.`

Vzorový vstup:
`are you capable of intelligence?`

Vzorový výstup:
`Indeed, I am capable of intelligence.`

Regulární výraz:
`s/[Aa]re\s[Yy]ou\s\(.*\)?/Indeed, I am \1./`

![regex]({{ site.baseurl }}/assets/programování/programmerhumor-regex.jpg)


## Zdroje:
- [reddit: Some Google Engineer Probably](https://www.reddit.com/r/ProgrammerHumor/comments/vfomp4/some_google_engineer_probably/)