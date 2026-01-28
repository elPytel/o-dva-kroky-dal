---
layout: post
title: "Konec světa!"
description: Konec světa podle Édouarda Lucase
categories: ["kreativní psaní", "fikce", "matematika"]
thumbnail: https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Tower_of_Hanoi.jpeg/600px-Tower_of_Hanoi.jpeg
---

# Konec světa!

Jak všichni víme, tak svět v roce 2012 nezkončil. Kdy však ale zkončí?

![Hanoiské věže](https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Tower_of_Hanoi.jpeg/600px-Tower_of_Hanoi.jpeg)

Otto plánoval, kam by se toto léto vydal za dobrodružstvím. Křištálovou lebku používal jako těžítko. Kopí osodu měl zaparkované na chalupě. 

![Let do Vietnamu]({{ site.baseurl }}/assets/plane_to_Vietnam.jpg)
> Vygeneroval ChatGPT.

Francouzský pohled.

Ve Větnamu sedí ve stánku francouz a prodává suvenýry.

Why is this game called Tower of Hanoi?
Marketing.

The puzzle is not ancient. We know who invented it: the mathematician Édouard Lucas.[1] In fact, the original game can be found in a museum in Paris, with an inscription identifying him as the inventor.

The puzzle was introduced in 1883 with this description:

D’après une vieille légend indienne, les brahmes se succèdent depuis bien longtemps, sur les marches de l’autel, dans le Temple de Bénarès, pour exécuter le déplacement de la Tour Sacrée de BRAHMA, aux soixante-quatre étages en or fin, garnis de diaments de Golconde. Quant tout sera fina, la Tour et les brahmes tomberont, et ce sera la fin du monde!

written by one “Professor N. Claus (de Siam) of the College Li-Sou-Stian”, who named the game LA TOUR D’HANOÏ.[2] Permuting the letters of this psuedonym gives “Lucas d’Amiens”, teacher at the lyceé “Saint-Louis”.

But the legend is not about Hanoi at all; it is located in Benares (Varanasi) in India! Lucas’ choice of name was purely based on what he thought would help it sell.

However, when Lucas started to market the puzzle in its modest version with only eight wooden discs, French newspapers were full of reports from Tonkin. In fact, Hanoi had been seized by the French in 1881, but during the summer of 1883 was under constant siege by troops from the Chinese province of Yunnan… So Lucas selected the name of Hanoi because it was in the headlines at the time.

The fact that he could create an anagram using “de Siam” probably helped.

The legend is entirely due to Lucas, with later refinements by Henri de Parville; there is no actual Indian or Vietnamese myth corresponding to this mathematical puzzle. It was merely fashionable Orientalism.


"Mnozí zde již před tebou hledali, ale chrám nenašli."

In the great temple at Benares, beneath the dome which marks the centre of the world, rests a brass-plate in which are fixed three diamond needles, each a cubit high and as thick as the body of a bee. On one of these needles, at the creation, God placed sixty-four discs of pure gold, the largest disc resting on the brass plate, and the others getting smaller and smaller up to the top one. This is the Tower of Bramah. Day and night unceasingly the priests transfer the discs from one diamond needle to another according to the fixed and immutable laws of Bramah, which require that the priest must not move more than one disc at a time and that he must place this disc on a needle so that there is no smaller disc below it. When the sixty-four discs shall have been thus transferred from the needle on which at the creation God placed them to one of the other needles, tower, temple, and Brahmins alike will crumble into dust, and With a thunderclap the world will vanish.
- The Tower of Hanoi — Myths and Maths

# Větnam
Hledání chrámu ve Větnamu nedaleko města Hanoi. 

Kdesi v horách nedaleko města Hanoj stojí chrám, ve kterém je velká místnost a v ní se nachází 64 zlatých disků v různých velikostech. Mniši přesouvají tyto disky mezi třemi kolíky. Při přesunech dodržují posvátná pravidla. Legenda říká, že až se mnichům podaří přesunout všechny disky z prvního kolíku na třetí, nastane konec světa. 

# Indie
Přesun do Indie a pátrání po chrámu Kashi Vishwanath.

Na freskách původního chrámu byl vyobrazen příběh o vzniku Brahmovy věže. Dnes je tento příběh možné dohledat jako součást Indických Véd:

{: .note }
>Když se Dévové a Asurové střetli v Rgvédě, Dévové se obrátili na boha Šivu kvůli potížím, které jim Asurové působili. Šiva na situaci zeptal Brahma a ten přišel s řešením. Měly být vytvořeny tři světy (Lóky):
>
>- Swarga Lóka, která je domovem Dévů,
>- Martya Lóka, která je lidské sídlo,
>- Paathala Lóka, která je místo, kde mohou žít Asurové.
>
>Do každé Lóky Brahma umístil diamantovou věž a v Aakash Lóce položil 64 zlatých disků. Dévové dostali za úkol přenášet disky do Paathala Lóky podle stejných pravidel. Až tak učiní nadejde konec Brahmova cyklu, a tedy i konec lidského světa.

# Pravidla přesunu disků

![Přesun disků](https://upload.wikimedia.org/wikipedia/commons/6/60/Tower_of_Hanoi_4.gif)

# Kdy nastane konec světa?

Pan prof. Picek spočítá jak dlouho by jim to trvalo.

Počet disků:
$$n = 64$$

Počáteční podmínky:
$$a_0 = 0$$,
$$a_1 = 1$$

Rekurentní vztah:

$$a_n = 2a_{n-1} + 1$$

Posun indexu:

$$a_{n+1} = 2a_n + 1$$

Přerovnání:

$$a_{n+1} - 2a_n = 1$$

Charakteristický polynom:

$$x - 2 = 0$$

Kořen:

$$x = 2$$

Obecné řešení:

$$a_n^{(h)} = \alpha 2^n$$

Hledáme partikulární řešení:

$$a_n^{(p)} = k * 1$$

Dosazení do rekurentního vztahu:

$$k * 1 - 2k * 1 = 1$$

$$-k = 1$$

$$k = -1$$

Celkové řešení:

$$a_n = \alpha 2^n - 1$$

Dosazení počátečních podmínek:

$$a_0 = 0 = \alpha 2^0 - 1$$

$$\alpha = 1$$

Výsledný vzorec pro výpočet n-tého členu je:

$$a_n = 2^n - 1$$

Dosazení n:

$$a_{64} = 2^{64} - 1$$

Přepočet na roky:

$$
\frac
{2^{64} - 1}
{60 * 60 * 24 * 365.25} 
\approx 5845545316
$$

Stáří našeho vesmíru je přibližně 13.8 miliard let.

$$\frac{5845545316}{13.8e9} \approx 42$$

Odpovědí je **42**, tedy že vesmír zkončí za 42 násobek stáří současného vesmíru.

## Zdroje:
- [wiki: Tower of Hanoi](https://en.wikipedia.org/wiki/Tower_of_Hanoi)
- [quora: Does the Tower of Hanoi have any relation to Hindu mythology?](https://www.quora.com/Does-the-Tower-of-Hanoi-have-any-relation-to-Hindu-mythology)
- [google books: The Tower of Hanoi: Myths and Maths](https://www.google.com/books/edition/The_Tower_of_Hanoi_Myths_and_Maths/FbJDAAAAQBAJ?hl=en&gbpv=1&dq=tower%20of%20hanoi%20myths%20and%20maths&printsec=frontcover)
- [Ian Parberry: Towers Of Hanoi](https://ianparberry.com/TowersOfHanoi/index64.html)
- [The Tower of Hanoi — Brahma’s Discs](https://alieninwonderland.medium.com/the-tower-of-hanoi-brahmas-discs-4d098d51b02c)
- [ijrpr: Demystified Secret of Brahma Prastara, Sri Chakra and the Universe](https://ijrpr.com/uploads/V3ISSUE5/IJRPR4240.pdf)