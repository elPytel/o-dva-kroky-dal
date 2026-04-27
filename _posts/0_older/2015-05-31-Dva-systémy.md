---
layout: post
title:  "Dva systémy"
author: "Jarda"
description: Jak nainstalovat Windows XP k již nainstalovaným Windows 7.
categories: 
    - pc
tags: 
    - Windows 7
    - Windows XP
thumbnail: /assets/pc/Windows_XP.png
---

Jelikož jsem se i já jako mnoho uživatelů PC potýkal s myšlenkou nainstalovat si na svůj notebook/PC s Windows 7 také Windows XP a jelikož jsem na různých fórech našel spoustu návodů, které se v mnohém lišily, žádný nefungoval 100% a já jsem musel tím pádem čerpat ze všech najednou, rozhodl jsem se poznatky z nich, ty které mě dovedly k cíli, shrnout v rámci možností (obsáhnout vše potřebé nikdy na 100% nejde) do jednoho příspěvku a přidat k nim něco málo mých vlastních zkušeností:  
  
Předem je třeba upozornit, že pokud se do této "prácičky" chce pustit kdokoliv, kdo má s PC jen začátečnické zkušenosti, důrazně doporučuji vůbec se do tohoto nepouštět či přenechat to odborníkovi, protože se nejedná o jednoduchou věc!  
Zároven chci říct, že ani já nejsem odborník a proto se předem omlouvám za cokoliv lacikého, co se v článku objeví a předem děkuji každému, kdo mě opraví nebo doplní :)  

Takže k věci:  
Instaloval jsem Windows XP k již nainstalovaným Windows 7, ale tento návod by měl funogvat i pro kombinaci Win Vista/Win XP.  

Před tím, než začnete něco dělat, doporučuji si tento návod vytisknout, nebo ho mít neustále před sebou na druhém PC či notebooku.  
Pokud se vše bude dařit, celá operace zabere tak kolem 1-2 hodin.  

![Windows 7 SP1]({{ site.baseurl }}/assets/pc/Windows_7_SP1.png)

## Zálohujte!
Nejdříve se doporučuje zálohovat si všechna data na pevném disku na jakékoliv přenosné médium.  
Tento krok není nutný, ale náhoda je blbec a vždycky se může stát něco, co vaše data nenávratně smaže.  
Proto ten kdo svá data nezazálohuje, činí tak na vlastní nebezpečí (stejně jako jsem to udělal já, naštěstí vše proběhlo bez problémů) 

## Disk pro obnovu systému
Další důležitou věcí, která se narozdíl od té předešlé musí udělat každopádně, je vypálit si na volné DVD disk pro obnovu systému Windows 7 (Pokud jste tak už neučinili při prvním zapnutí svého PC/notebooku).  
Toto uděláte v nabídce `Start->Ovládací Panely->Systém a zabezpečení->Zálohování a obnovení->Vytvořit disk pro opravu systému`.  
Až po provedení tohoto kroku můžete pokračovat k samotnému návodu na instalaci dvou operačních systémů.  

## Teď už k samotnému návodu:  
  
1.Pokud chcete na jeden pevný disk nainstalovat více operačních systémů, musíte jej rozdělit na více části a každý operační systém pak nainstalovat na jednu část.  
Program pomocí kterého jsem tohoto dosáhl se nazývá [EASEUS Partition Manager](http://www.partition-tool.com/) (free jen 32 bit) a vše potřebné včetně návodu jak s ním zacházet neleznete zde: http://www.pc-help.cz/viewtopic.php?f=58&t=37086  
  
2.Nyní byste měli mít na pevném disku vytvořen mimo jiné 1 PRÁZDNÝ oddíl o velikosti minimálně 30GB, která je potřebná pro správný chod Windows (velikost tohoto oddílu můžete kdykoliv zvětšit pomocí výše zmíněného programu)  

3.Sežeňte si buď origiální instalační dvd op. systému Win XP, nebo sežeňte na internetu instalační dvd ve formátu ISO.  
  
(V případě že instalujete přímo z originálního DVD přeskočte rovnou k bodu 5)  
  
4.Po stažení ISO souboru stáhněte např. odsud: http://www.stahuj.centrum.cz/multimedia/vypalovani_cd/active-iso-burner/ program Active ISO Burner, pomocí kterého si ve 2 jednoduchých krocích vypálíte ISO soubor s Windows XP na DVD.  


(Tento program mi jako jediný dokázal vypálit fungující!!! bootovací dvd a přitom je tak jednoduchý, že se ani nemusí instalovat)  
  
5.Vložte vypálené bootovací DVD do mechaniky a restartujte počítač.  
  
6.POZOR!! ještě než vám najede Windows(tzn. v černé obrazovce, kdy se spouští BIOS) stiskněte F2 (popř. F12 nebo DEL) , čímž se dostanete do BIOSu.  
Tady vyhledejte oddíl Boot a pomocí pokynů na obrazovce umístěte na první místo vaši DVD mechaniku.  
Tím zaručíte, že při spouštění počítače bude nejdříve načteno DVD, které máte v mechanice.  
  
7.Uložte změny v BIOSU (většinou F10).Tímto se vám znovu restartuje PC.  
  
8.PC se vás po restartu a načtení dvd zeptá, zda chcete bootovat z dvd.  
Stiskněte ENTER a počkejte než budou načteneny potřebné soubory z dvd.  
Po jejich načtení nastává samotná instalace Win XP.  
  
9.Nejdříve se vás PC zeptá na který oddíl na disku Win XP nainstalovat.  
Vyberte ten, který jste speciálně pro instalaci vytvořili (poznáte ho podle písmena, nebo názvu, který jste si zadali v bodě 1).  
Po odENTRování, budete dotázáni zda chcete tento oddíl formátovat.  
Zvolte ano (většinou prostřední možnost ze tří).  
POZOR!!!! Tímto krokem se vám z oddílu vybraného pro instalaci smažou veškerá data (která by tam ale už stejně neměla být, pokud jste vše v bodě 1 provedli podle návodu)  
  
10.Pokračujte v instalaci dle pokynů na obrazovce.  
  
11.Po dokončení instalace Windows XP by se vám měl automtaicky restartovat počítač.  
Nechte ho to provést a když se vás opět zeptá, zda bootovat z DVD, tentokrát nemačkejte nic a on sám spustí Win XP z pevného disku.  
Po spuštění Windows XP, vyndejte bootovací DVD s instalačními soubory Win XP, vložte do ní Disk Pro obnovu systému Windows7, který jste si vytvořili v úvodu návodu (ještě před bodem 1) a restartujte počítač.  

12.Cílem předešlého kroku je opravit instalaci Windows 7, která byla částečně "narušena" instalací Windows XP.  
Po načtení opravného dvd klikněte na "vyhledat stávající instalace Windows" a dále na "opravit spouštění systému windows"  
Tímto krokem znovu zprovozníte Windows 7.  

13.Problém je v tom že i když již máte nainstalovány oba operační systémy, nebudete si moci při startu počítače vybrat, který systém spustit.  
Toho docílíte pomocí programu EASYbcd , který si můžete včetně návodu sehnat zde: http://pravdavocich.cz/clanek/jak-na-dualboot-windows-vista-a-windows-xp  
  
14.Po úspěšném provedení všech 13 předešlých kroků, vyjměte veškerá DVD z mechaniky a vraťte se k bodu 6 a pomocí naprosto stejného postupu tentokrát VRAŤTE bootování z vašeho pevného disku zpět na první místo.
  
15.Naposled restartujte počítač a pokud jste vše udělali správně, při startu počítače vám naběhne nabídka na výběr, který op. systém se má spustit. Gratuluji!

![Windows XP]({{ site.baseurl }}/assets/pc/Windows_XP.png)