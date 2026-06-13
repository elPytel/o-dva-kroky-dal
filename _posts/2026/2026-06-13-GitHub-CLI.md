---
layout: post
title:  "GitHub CLI"
author: "Jarda"
description: Jak zprovoznit propojení Gitu s Githubem a jak se přihlásit přes SSH klíč
categories: 
    - Git
    - Github
tags: 
    - Linux
thumbnail: /assets/GitHub_logo.png
---

Github umožnuje clonovat repozitář pomocí několika nástrojů:
- HTTPS
- SSH
- GitHub CLI

Pro to, aby jste rozchodili SSH klíč je potřeba si ho vygenerovat a přidat do Githubu.

HTTPS je jednodušší, ale vyžaduje zadávání přihlašovacích údajů při každém pushi, nebo si musíte uložit přihlašovací údaje do Git Credential Manageru.

## GitHub CLI

GitHub CLI byla pro mě úplně nová volba a tak jsem se rozhodl jí vyzkoušet.

```bash
gh repo clone <github-user>/<repo-name>
```

Aha! ještě je potřeba nainstalovat GitHub CLI. Na Linuxu je to jednoduché:

```bash
sudo apt install gh
```

```bash
gh repo clone <github-user>/<repo-name>
To get started with GitHub CLI, please run:  gh auth login
Alternatively, populate the GH_TOKEN environment variable with a GitHub API authentication token.
```

Při pokusu o clonování repozitáře se vám zobrazí hláška, že je nějdříve potřeba se přihlásit. A našeptá vám příkaz:

```bash
gh auth login
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations on this host? SSH
? Generate a new SSH key to add to your GitHub account? Yes
? Enter a passphrase for your new SSH key (Optional) 
? Title for your SSH key: GitHub CLI
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: XXXX-XXXX
Press Enter to open github.com in your browser... 
Otevírání v existující relaci prohlížeče.
✓ Authentication complete.
- gh config set -h github.com git_protocol ssh
✓ Configured git protocol
✓ Uploaded the SSH key to your GitHub account: /home/pytel/.ssh/id_edxxxxx.pub
✓ Logged in as elPytel
```

CLI vás intearkivně provede celám postupem přihlášení a dá vám několik možností konfigurace. Já jsem zvolil přihlášení pomocí SSH klíče, který CLI samo vygeneruje a pak nahraje do vašeho účtu na Githubu. Stačí jen skopírovat kód, který vám CLI vytvoří a vložit ho do prohlížeče. 

Jednodužší by to snad ani nemohlo být. 

Klonujeme repozitář pomocí příkazu:
```bash
gh repo clone <github-user>/<repo-name>
```