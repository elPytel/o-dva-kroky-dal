---
layout: post
title:  "Streamování her"
author: "Jarda"
description: "Jak zprovoznit lokální streamování her z Windows 11 na Ubuntu 26.04"
categories: 
    - games
    - Steam
tags: 
    - streaming
    - Sunshine
    - Moonlight
thumbnail: /assets/steam-logo-steam-icon-transparent.webp
---

# Zprovoznění lokálního streamování her: Windows 11 host a Ubuntu klient

Pokud řešíte streamování z herního desktopu na počítač s linuxem, tak dost možná narazíte s Steam remote play.


![steam]({{ site.baseurl }}/assets/steam-logo-steam-icon-transparent.webp)

## Proč selhalo Steam Remote Play (Black Screen of Death)

Typický scénář: Spojení se naváže, slyšíte zvuk, klávesnice odesílá inputy, ale obrazovka zůstává černá. Kde je problém?

* **Wayland vs. XWayland na klientovi:** Moderní distribuce (např. Ubuntu 26.04) používají jako výchozí zobrazovací server Wayland. Steam klient při Remote Play spoléhá na kompozitor vrstvu XWayland. V této iteraci často dochází ke ztrátě video bufferu, zvlášť když se Steam snaží inicializovat hardwarové dekódování (VA-API), které přes tuto mezivrstvu buď spadne, nebo tiše selže a zahodí obraz.
* **Hostitel a zachytávání obrazu (NVIDIA Pascal a Win 11):** Starší generace hardwarových enkodérů (např. na kartách řady GTX 1070 Ti) v kombinaci s Windows 11 občas kolidují se Steamem při využití proprietárního NVFBC (NVIDIA Frame Buffer Capture). Steam se sice dá v nastavení přepnout na fallback (Windows Desktop Duplication API), ale to znamená vyšší latenci, nebo úplné selhání zachytávání obrazu.

## Řešení: Nasazení Sunshine (Host) a Moonlight (Klient)

![sunshine]({{ site.baseurl }}/assets/sunshine-stream.png){: .small .left}

Moonlight je open-source klient původního protokolu Nvidia GameStream. Jeho serverovou část plně nahrazuje komunitní projekt Sunshine.

**Hlavní výhody:**

* Moonlight má nativní Wayland klient s perfektně vyřešenou hardwarovou akcelerací dekódování.
* Sunshine komunikuje přímo s NVENC na grafické kartě s minimální režií.
* Podpora mDNS pro automatické nalezení v síti a obrovské možnosti konfigurace bitratu.

## Postup nasazení

![moonlight]({{ site.baseurl }}/assets/moonlight-stream.png){: .small .left}

### 1. Konfigurace hostitele (Windows 11)

1. Stáhněte a nainstalujte instalátor [Sunshine](https://app.lizardbyte.dev/Sunshine/?lng=cs) z jejich oficiálního GitHub [repozitáře](https://github.com/lizardbyte/sunshine).
2. Služba poběží automaticky na pozadí. Otevřete prohlížeč a přejděte do webové administrace na adrese `https://localhost:47990`.
3. Ignorujte varování prohlížeče o neplatném certifikátu (Sunshine si generuje vlastní lokální self-signed certifikát).
4. Při prvním přístupu si vytvořte administrátorské přihlašovací údaje.

### 2. Konfigurace klienta (Ubuntu)

Pro zajištění nejnovější verze s odladěnou podporou Waylandu je naprosto ideální využít Flatpak.

1. Nainstalujte Moonlight přes terminál:

```bash
flatpak install flathub com.moonlight_stream.Moonlight
```

2. Spusťte aplikaci Moonlight.

### 3. Spárování a spuštění

1. Moonlight pomocí mDNS automaticky vyhledá běžící Sunshine instanci na lokální síti.
2. Klikněte na nalezený počítač. Moonlight vygeneruje bezpečnostní párovací PIN.
3. Přepněte se do webové administrace Sunshine na hostitelském stroji, v horním menu přejděte do záložky **PIN** a zadejte vygenerovaný kód.
4. V Moonlightu zmizí ikona zámečku. Nyní stačí vybrat aplikaci **Desktop** pro čistý stream plochy, nebo **Steam Big Picture** pro přímý přechod do herního režimu.

**Sysadmin tip pro fajnšmekry:** V administraci Sunshine (záložka Configuration -> Apps) lze velmi snadno naskriptovat spouštění pre a post skriptů (Do a Undo). Můžete tak zavolat například utilitu QRes pro automatickou úpravu rozlišení a obnovovací frekvence hostitele tak, aby přesně odpovídaly parametrům linuxového monitoru, a po ukončení relace z klienta vše vrátit do původního stavu.
