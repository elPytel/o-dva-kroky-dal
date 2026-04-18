---
layout: post
title: "VS Code na mobilu"
description: Visual Studio Code běžící na mobilním telefonu
categories: 
    - mobily
    - samsung
tags:
    - VSCode
    - termux
thumbnail: /assets/phone/20251130_122435_Opera.jpg
---

# VS Code na mobilu

Jedna z pokročilých funkcí Samsungů řady S je možnost spouštět aplikace v okně podobně jako na desktopu v režimu DeX. 

## 1. instalace Termuxu

Termux jsem nainstaloval z Google Play Store:
[Termux - Google Play Store](https://play.google.com/store/apps/details?id=com.termux)

## 2. instalace code-serveru

Skript: instalace code-serveru v Termuxu
```bash
#!/data/data/com.termux/files/usr/bin/bash

echo "🔧 Aktualizuji Termux balíčky..."
pkg update -y && pkg upgrade -y

echo "📦 Přidávám tur-repo..."
pkg install tur-repo -y

echo "📥 Instaluji code-server..."
pkg install code-server -y

echo "📂 Vytvářím konfigurační adresář..."
mkdir -p ~/.config/code-server

echo "⚙️ Nastavuji config (auth = none, port 8080)..."
cat > ~/.config/code-server/config.yaml <<EOF
bind-addr: 0.0.0.0:8080
auth: none
cert: false
EOF

echo "🚀 Hotovo! Spouštím code-server..."
echo "--------------------------------------------------"
echo "Teď otevři v prohlížeči adresu:"
echo "👉  http://localhost:8080"
echo "--------------------------------------------------"

code-server
```

> [!example] Co skript udělá:
>- aktualizuje Termux,
>- nainstaluje `tur-repo` (repozitář obsahující code-server),
>- nainstaluje `code-server`,
>- nastaví konfiguraci,
>- spustí ho.

Potom stačí jít v telefonu do prohlížeče na:

👉 http://localhost:8080

### Jak skript použít
Otevři Termux

Zkopíruj skript do souboru:
```bash
vim install_code_server.sh
```

vlož obsah → ulož a zavři

Udělej skript spustitelný:
```bash
chmod +x install_code_server.sh
```

Spusť:
```bash
./install_code_server.sh
```

## 3. realizace
![script]({{ site.baseurl }}/assets/phone/20251130_122336_Termux.jpg)
![instalace]({{ site.baseurl }}/assets/phone/20251130_122402_Termux.jpg)
![prohlížeč]({{ site.baseurl }}/assets/phone/20251130_122435_Opera.jpg)

Nyní již jen stačí v režimu DEX otevřít prohlížeč a jít na adresu http://localhost:8080 kde se zobrazí VS Code běžící na mobilu.

## Odkazy

- [gihub: Visual Studio Code](https://github.com/Microsoft/vscode)
- [Install Visual Studio Code (actually code-server) on Android](https://gist.github.com/ppoffice/b9e88c9fd1daf882bc0e7f31221dda01)
- [Coder: termux code-server](https://coder.com/docs/code-server/termux#installation)
- [reddit: SamsungDex - VS Code](https://www.reddit.com/r/SamsungDex/comments/sn1qzl/dex_apps_for_a_developer_vscode/)
- [codewithharry: Install VS Code on Android](https://www.codewithharry.com/blogpost/install-vs-code-in-android)
- [stackoverflow: How to run Visual Studio Code on Samsung DeX](https://stackoverflow.com/questions/52517514/how-to-run-visual-studio-code-on-samsung-dex)