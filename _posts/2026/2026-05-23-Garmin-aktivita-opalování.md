---
layout: post
title:  "Garmin aktivita: opalování"
author: "Jarda"
description: Tvorba vlastní aktivity pro zaznamenávání času stráveného na slunci.
categories: 
    - Garmin
tags: 
    - aktivita
thumbnail: https://cdn.iconscout.com/icon/free/png-256/free-garmin-3628786-3030148.png
---

Rozhodl jsem se vytvořit si vlastní sportovní aktivitu na hodinkách "opalování". Můj model Instinct 2X solar má funkci "solární dobíjení", takže cílem je vytvořit aktivitu, která zaznamenává množství slunečního záření, které hodinky zaznamenají.

Garmin sice nativní sportovní profil pro opalování nemá, ale systém hodinek je dostatečně flexibilní na to, aby šlo novou aktivitu vytvořit. 

Mím cílem je mít aktivitu, která bude měřit:
- čas, 
- tep (úroveň relaxace),
- solárního nabíjení,
- nebude používat GPS

# Obsah:
- [Obsah:](#obsah)
  - [Jak si tento "sport" do Instinctů 2X přidat:](#jak-si-tento-sport-do-instinctů-2x-přidat)
    - [Vytvoření vlastní aktivity](#vytvoření-vlastní-aktivity)
    - [Vyladění datových polí (Dashboard pro slunění)](#vyladění-datových-polí-dashboard-pro-slunění)
  - [Nastavení periodického upozornění "Otočit"](#nastavení-periodického-upozornění-otočit)
  - [Konfigurace aktivity přes mobilní aplikaci](#konfigurace-aktivity-přes-mobilní-aplikaci)
  - [Export profilu z hodinek](#export-profilu-z-hodinek)
    - [Import do kamarádových hodinek](#import-do-kamarádových-hodinek)

## Jak si tento "sport" do Instinctů 2X přidat:

V aplikaci Garmin IQ si nainstalujte aplikaci (Datové pole) Solar Intesity Logger.

### Vytvoření vlastní aktivity

1. Stiskněte pravé horní tlačítko (**GPS**) pro otevření seznamu aktivit.
2. Sjeď úplně dolů a vyber **Přidat** (Add).
3. Zvol **Jiné** (Other), hodinky vás provedou tvorbou aktivity.
4. Jako název vyťukejte `Opalování`.
5. V nastavení se ujistěte že je GPS opravdu vypnutá.
6. Upravte obrazovky.

### Vyladění datových polí (Dashboard pro slunění)

Hned po vytvoření vám hodinky nabídnou úpravu nastavení. Přejděte do **Datových obrazovek** a nastavte pole tak, aby dávala pro opalování smysl:

* **Časovač:** Abyste věděli, kdy se máte otočit a abyste neskončili s popáleninami.
* **Tepová frekvence:** Můžete sledovat, jak vám při odpočinku na sluníčku klesá tep a roste hodnota "Body Battery".
* **Solární intenzita:** abyste v reálném čase viděli, na kolik procent to slunce zrovna "pálí" do panelu.

Obecná konfigurace:
- Zaznamenávat teplotu,
- nepoužívat GPS,

Obrazovka 1:
- teplota,
- hodiny,
- stopky,
- západ slunce
  
Obrazovka 2:
- srdeční tep,
- frekvence dýchání

Obrazovka 3:
- nabití baterie,
- solární intenzita

Obrazovka 4:
- Olvádání hudby

Když pak tuto aktivitu uložíte, normálně se vám propíše do Garmin Connectu. Navíc si pak ve widgetu pro solární nabíjení můžete zkontrolovat nasbírané lux-hodiny a zjistit, jestli mělo vaše ležení na slunci z hlediska energetického zisku pro hodinky vůbec smysl.

## Nastavení periodického upozornění "Otočit"
Garmin umožňuje v rámci každé aktivity nastavit periodická upozornění, takže vám hodinky samy zavibrují a pípnutím vás upozorní, že je čas změnit stranu.

1. Stiskněte tlačítko **GPS** (vpravo nahoře) a najděte v seznamu svou aktivitu **OPALOVANI**.
2. Aktivitu zatím nespouštějte. Místo toho dlouze podržte tlačítko **MENU** (vlevo uprostřed).
3. Vyberte **Nastavení aktivity** (bude se jmenovat *Nastavení: OPALOVANI*).
4. Sjeďte na položku **Upozornění** (Alerts) a potvrďte.
5. Zvolte **Přidat nové** (Add New).
6. Z nabídky vyberte **Čas** (Time).
7. Zadejte interval – například **15 minut** nebo **20 minut**.

Tohle upozornění je ve výchozím stavu cyklické. Jakmile aktivitu spustíte, hodinky vám každých 15 minut zavibrují na zápěstí. Vibrační motorek u Instinctů 2X je dostatečně silný, aby vás probral i z lehkého spánku na sluníčku.

Pokud chcete mít na displeji přímo textovou výzvu, můžete v kroku 6 místo "Čas" zvolit **Vlastní** (Custom).
Tam najdete přednastavené zprávy jako "Pít" nebo "Jíst", ale můžete si tam vyklikat i vlastní text (například `OTOCIT`). Následně mu opět přiřadíte časový interval. Na displeji pak vyskočí přímo tento nápis.

## Konfigurace aktivity přes mobilní aplikaci
Mobilní aplikace Garmin Connect sice nenabízí možnost vytvořit nový sportovní profil, ale jakmile ho vytvoříte na hodinkách, okamžitě se vám propíše do aplikace. Odtud můžete pohodlně nastavit všechna datová pole, upozornění a další parametry bez nutnosti klikat přes tlačítka na hodinkách.

1. Na hodinkách vytvořte aktivitu podle předchozího návodu (Přidat, Kopírovat aktivitu, Přejmenovat).
2. Otevřete v telefonu aplikaci **Garmin Connect**.
3. Klepněte na ikonu svého zařízení (nahoře na domovské obrazovce) nebo běž přes menu do **Zařízení Garmin** a vyber své Instinct 2X.
4. Zvol **Aktivity a aplikace** (Activities & Apps) a rozklikni své nově vytvořené **OPALOVANI**.
5. Nyní můžeš velmi pohodlně přes dotykový displej telefonu nastavit vše potřebné:
* V sekci **Datové obrazovky** si naklikáte layout a konkrétní metriky (čas, tepovka, solární intenzita).
* V sekci **Upozornění** si nastavíte onen časový trigger pro otáčení.

Jakákoliv změna, kterou v tomto menu aplikace uděláte, se bleskově a bez nutnosti ruční synchronizace propíše do hodinek.

## Export profilu z hodinek

Oficiální cestou přes mobilní aplikaci Garmin Connect to nasdílet nelze. Ekosystém nenabízí žádné tlačítko pro export vlastního profilu aktivity. Z pohledu souborového systému hodinek to ale proveditelné je. Garmin ukládá profily sportů jako binární `.fit` soubory, se kterými se dá na úrovni úložiště ručně manipulovat.

Tady je postup, jak tenhle konfigurační soubor vytáhnout a předat dál:

* Připojte své Instincty k počítači přes USB kabel.
* Hodinky se přihlásí jako externí úložiště (většinou přes protokol MTP).
* Otevřete interní paměť a projděte do adresáře `Garmin/Sports`.
* Zde najdete soubory s koncovkou `.fit`. Protože názvy mohou být generické (např. `8F4A1234.FIT` nebo název původní zkopírované šablony s číslem), seřaď si soubory podle data úpravy. Ten nejnovější je **OPALOVANI**.
* Tento `.fit` soubor zkopírujte do počítače a pošlete kamarádovi.

### Import do kamarádových hodinek

* Kamarád připojí své Garminy k počítači.
* Otevře interní paměť a najde adresář `Garmin/NewFiles`. Tohle je dropzóna, kterou operační systém hodinek po odpojení od USB automaticky čte a zpracovává.
* Vloží `.fit` soubor přímo do této složky.
* Bezpečně odpojí hodinky od počítače.

Při následném náběhu systému si hodinky všimnou nového souboru ve složce `NewFiles`, zprocesují ho (přesunou si ho interně k ostatním sportům) a aktivita OPALOVANI se kamarádovi objeví v nabídce.

Na jiném modelu je však možné že `.fit` soubor nebude kompatibilní, protože každý model může mít mírně odlišnou strukturu dat pro sportovní profily.