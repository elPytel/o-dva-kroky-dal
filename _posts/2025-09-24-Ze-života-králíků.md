---
layout: post
title: "Ze života králíků"
description: Kombinatorické metody v praxi
categories: ["kreativní psaní", "fikce", "matematika"]
thumbnail: https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/FibonacciRabbit.svg/250px-FibonacciRabbit.svg.png
---

# Vánoce v Austrálii

Vzhledem k tomu, že Austrálie leží na jižní polokouli, tak jim na Vánoce nikdy, tedy kromě doby ledové, nepadá sníh, protože tam mají zrovna léto. A tak australskému farmáři Thomasu Austinovi přišlo zcela přirozené, že nejlepším způsobem jak s přáteli strávit svátky, bude uspořádání honu na zajíce. Proto si pořídil 24 králíků, 5 zajíců a 72 koroptví, které nechal vypustit na svůj pozemek ve Viktorii.

Hon sklidil mezi jeho přáteli velký úspěch, ale lovcům se na jeho rozsáhlém panství nepodařilo odlovit všechny jedince. 

Thomas si z toho nic nadělal, jelikož to znamenalo, že na přes rok ušetří za nákup králíků. Co však nevěděl, tak bylo jaké nedozírné důsledky budou mít jeho činy z oslav Vánoc roku 1859.

# Králíci

Již kolem roku 1900, tedy za zhruba 40 let, se populace králíků rozrostla z Viktorie přes Nový Jižní Wales, Queensland, Severní teritorium až do západní Austrálie. Prakticky z jedné strany kontinentu na tu druhou. V té době již nikdo neměl pochyb do jaké šlamastiky se Australané, klokani, krávy, krokodýli, pavouci a vše ostatní co tam tak žije dostali. 

Australská vláda začala tento problém brát seriózně. 

Lidé si začali pokládat otázky typu: "Kolik bude žít v Austrálii králíků za sto let?" 

Nikdo však na takovou otázku nedovedl odpovědět přesně. 

Stejně tak jako si později USA stanoví za cíl dopravit člověk na měsíc do konce dekády, tak Australská vláda si rozhodla stanovit za otázku cti určit počet králíků do výročí sta let od jejich vypuštění do volné přírody.

Politici se však ještě úplně nevzpamatovali po fiasku z prohrané války s Emu a tak se tento problém rozhodli přenechat kompetentnějším. Zadali to za úkol statistickému úřadu. Ten si pozval odborníka z akademické půdy, který by dovedl tuto složitou otázku zodpovědět. 

# Matematika přichází na pomoc

Pan prof. RNDr. CSc. Picek, odborník na matematiku, hovoří:

"Víte s králíkama se to má tak, oni se pořád množí. Ale tady není potřeba vymýšlet nic nového, on to přede mnou již popsal ve 13. století jistý Leonardo Pisánský zvaný Fibonacci ve své posloupnosti popisující právě růst populace králíků."

{: .note }
> Fibonacciho posloupnost je v matematice označována nekonečná posloupnost přirozených čísel, začínající 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, …, kde každé číslo je součtem dvou předchozích. 

Rekurentní definice Fibonacciho posloupnosti tedy je:

![Fibonacciho posloupnost](https://wikimedia.org/api/rest_v1/media/math/render/svg/53794b63f960a8d45bb08375d775fdc4e678375a)

Názorná ilustrace množství králíků dle Fibonaccioho posloupnosti:

![wiki: fibo králíci](https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/FibonacciRabbit.svg/250px-FibonacciRabbit.svg.png)

Pan Picek vypracoval pro Australskou vládu počítačový program pro výpočet množství králíků:

```python

def fibonacci(n):
    # počáteční podmínky
    if n == 0:
        return 0
    if n == 1:
        return 1
    # rekurze
    return fibonacci(n-1) + fibonacci(n-2)
```

Pro spuštění programu potřebujete počítač a tak Australský statistický úřad po mnoho úvahách nechal v šedesátých letech minulého století po vzoru USA vybudovat sálový počítač, který by odpověděl na základní otázku Života *králíků* a vůbec. 

Bohužel, jak s určitostí věděli, bylo jich více než 42.

Programátoři převedli tento pseudokód do jazyka symbolických adres a nahráli jej do elektronkového počítače.

Již je dělilo od odpovědi na otázku: "Kolik bude žít v Austrálii králíků za sto let?", kdyby si jí lidí položili právě před sto lety, pouhých pár minut počítačových výpočtů.

```python
print(fibonacci(100))
```

Program běžel, běžel minuty, běžel hodiny, běžel den a noc, než se konečně na dobro zasekl.

Na výstupu počítače pro chybová hlášení se rozsvítili číslice **1202**.

"Co je to za chybu?" Zvolal v brzkých ranních hodinách junior assembly programátor. 
"Došla pomět!" Odpověděl mu jeho služebně starší kolega.

Počítač se zasekl na rekurentní smyčce. Funkce `fibonacci()` se volala pořád dokola a dokola až počítači přetekl stack, tedy došla paměť pro výpočty. Žádný počítač té doby nebyl dostatečně výkonný aby dovedl tento problém vypočíst, ale to nikdo z programátorů tenkrát ještě nevěděl. Museli se vrátit zpět k rýsovacímu prknu, nebo přesněji k matematikům. 

# Řešení rekurentních rovnic

Vláda se opět obrátila pro radu k panu prof. RNDr. CSc. Pickovi. Ten jim pomoc neodmítl ani tentokrát:

"Můžeme se vydat cestou řešení rekurentních rovnic!"

Fibonacciho posloupnost vyjádřená jako rekurentní vztah:
$$a_{n+2} = a_{n+1} + a_n$$

Počáteční podmínky:
$$a_0 = 0$$,
$$a_1 = 1$$

Charakteristický polynom:
$$ x^2 -x -1= 0 $$

Kořeny kvadratické rovnice:

$$x_{1,2} = \frac{1 \pm \sqrt{1+4}}{2}$$

$$x_{1,2} = \frac{1 \pm \sqrt{5}}{2}$$

Povšimněte si že jeden z kořenů vychází jako hodnota zlatého středu:
φ = (1+√5) / 2 ≈ 1,618

Obecné řešení:
$$a_n = \alpha \varphi ^n + \beta \psi ^n$$

Dosazení počátečních podmínek:

$$a_0 = 0 = \alpha \varphi ^0 + \beta \psi ^0$$

$$\alpha = - \beta$$

$$a_1 = 1 = \alpha \varphi ^1 + \beta \psi ^1$$

Dosadíme alfu za betu:

$$a_1 = 1 = \alpha \varphi ^1 - \alpha \psi ^1$$

$$\alpha = \frac{1}{\varphi - \psi}$$

$$\varphi - \psi = \sqrt5$$

Výsledný vzorec pro výpočet n-tého členu je:

$$
a_n = \frac{\varphi^n-\psi^n}{\sqrt5}
$$

Programátoři vytvořili nový upravený program, který již jen dosazoval do vzorečku:
```python
import math

def fibonacci(n):
    x1 = (1+math.sqrt(5))/2
    x2 = (1-math.sqrt(5))/2
    ans = 1/math.sqrt(5) * (math.pow(x1, n) - math.pow(x2, n))
    return ans
```

Tento program již neměl zabudovanou rekurzi a tak doběhl in počítači té doby.

Výsledkem bylo: **354 224 848 179 263 100 000**
# Video

<iframe width="560" height="315" src="https://www.youtube.com/embed/WEwTHys9Nuo" title="How 13 Rabbits Became 600 Million" frameborder="0" allowfullscreen></iframe>

## Zdroje:
- [wiki: králíci v Austrálii](https://cs.wikipedia.org/wiki/Invaze_králíka_divokého_v_Austrálii)
- [wiki: fibonacci](https://cs.wikipedia.org/wiki/Fibonacciho_posloupnost)
- [wiki: Válka s emuy](https://cs.wikipedia.org/wiki/Válka_s_emuy)
- [wiki: Stopařův průvodce po Galaxii](https://cs.wikipedia.org/wiki/Stopařův_průvodce_po_Galaxii)
- [wiki: eniac](https://cs.wikipedia.org/wiki/ENIAC)
- [nasa: 1202](https://www.nasa.gov/history/alsj/a11/a11.1201-pa.html)