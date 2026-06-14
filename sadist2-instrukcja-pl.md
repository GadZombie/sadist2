# Sadist II: Ostatni krzyk - instrukcja do gry

**Sadist ©1999 & Sadist II ©2000–2026** — [gadz.pl](https://gadz.pl/sadist-2)

## Jak to działa?

## Wstęp

**Sadist II** powstał w 2000 roku jako gra dla **MS-DOS** — brutalna piaskownica, w której tworzysz teren, wypuszczasz grupy postaci i… no, reszta zależy od Twojej wyobraźni (oraz arsenału od bazuki po kowadło).

**Wersja z 2026 roku** to ten sam program, **przekompilowany nadal w Turbo Pascalu 7.0**, z kilkoma poprawkami. Opakowany jest w **DOSBoxa** z gotową konfiguracją — nie musisz nic ustawiać w `CONFIG.SYS`, martwić się o pamięć XMS ani walczyć z kartą Sound Blaster. Problemy opisane w dalszej części dokumentu (brak pamięci, brak dźwięku, konflikty z WinAmpem itd.) dotyczą **oryginalnego uruchamiania pod czystym DOS-em** i w obecnej dystrybucji **nie powinny wystąpić**.

Przy okazji powstała też **wersja angielska** — lepiej późno niż później, skoro minęło już 26 lat.

Poniższy opis został nieco zredagowany, ale utrzymuje dość specyficzny, nieco infantylny styl oryginalnej instrukcji. W większości z powodów historycznych — to dokument z epoki...

---

## TL;DR — najważniejsze w skrócie

**Na czym polega Sadist II?**

- Tworzysz lub wczytujesz **dwuwymiarow teren** (wzgórza, dziury, tło).
- Na ekran wychodzą **postaci** (max 5 grup) — mogą walczyć między sobą, uciekać, panikować albo stać i się nudzić.
- **Ty** wybierasz broń lub „atrakcję" i strzelasz myszką — albo przejmujesz kontrolę nad jedną postacią z klawiatury.
- Możesz zmieniać **pogodę**, włączać **horror**, zalewać wszystko **krwią**, rysować teren, zapisywać poziomy.
- To nie jest gra z fabułą — to **symulator chaosu** w klimacie grozy z przymrużeniem oka.

**Jak szybko zacząć?**

1. Uruchom grę (DOSBox załatwia resztę).
2. W **menu głównym** wybierz **Nowy teren**, ustaw parametry, kliknij **Stwórz**.
3. Na pasku menu na dole (klawisz **6** lub spacja) otwórz **menu główne** i kliknij liczby przy grupach — pojawią się postaci.
4. Przełącz na menu **1** (bronie), wybierz np. strzelbę lub bazukę.
5. **Lewy przycisk myszy** = strzał. **Prawy (trzymany)** = celownik.
6. Eksperymentuj z menu **4** (warunki) — włącz agresję, burzę, deszcz krwi…
7. **ESC** = powrót do menu głównego; stamtąd możesz zapisać teren.

Reszta tego dokumentu to szczegółowy opis każdej opcji — na start wystarczy powyższe.

---

## Pierwsza sprawa

Wiem, że ten dokument nie jest krótki. Musicie mi to wybaczyć — starałem się opisać wszystko jak najbardziej szczegółowo, co dało tę pokaźną długość. Mimo to bardzo proszę o wytrwanie do końca (choćby pobieżnie), bo znajdziecie tu wiele ważnych informacji o Sadist II, odpowiedzi na wiele pytań i nie tylko.


---

## A. Menu główne

Jest to pierwszy ekran po włączeniu Sadist II. Masz w nim wszystkie podstawowe opcje oraz wyjście do systemu. „Guziki" ułożone są w kółku, w którego środku jest powrót do gry — **Kontynuuj masakrę!!!** Na pierwszy rzut oka go nie widać, ale podpisy wszystko wyjaśniają.

Opcje zapisu terenu oraz powrotu do akcji uaktywniają się dopiero po stworzeniu lub wczytaniu terenu.

### A1. Nowy teren

Tutaj tworzy się nowy teren. Jest on tworzony losowo, ale kilka ustawień zależy od Ciebie.

- **Tekstura** — wybór tekstury na utworzonym terenie. Tekstury pobierane są z podkatalogu `TEKSTURY`. Jeśli nie chcesz żadnej tekstury, wybierz **brak**.
- **Kolor** — działa tylko po wyłączeniu tekstury; to kolor terenu.
- **Wierzch** — górna część terenu (trawa itp.), pobierana z podkatalogu `TEKSTURY`. Po wybraniu **brak** nie będzie żadnego wierzchu.
- **Górna i dolna granica wysokości** — pomiędzy tymi granicami zostanie utworzony losowo teren. Dolna granica może zejść poniżej ziemi — będą wtedy dziury.
- **Czyść/zostaw poprzedni teren** — działa tylko wtedy, gdy już jest jakiś stworzony teren (wczytany lub utworzony). Przy tworzeniu nowego terenu poprzedni może zostać niewymazany i nowy nałoży się na niego.
- **Tryb gry** — wybór rodzaju gry; zobacz punkt [C: Tryby gry](#c-tryby-gry).
- **Stwórz** — po wciśnięciu tego guzika zostanie utworzony teren.

### A2. Zapis terenu

Zapis aktualnego terenu do pliku. Opcja uaktywnia się po stworzeniu lub wczytaniu terenu. Tereny zapisywane są w podkatalogu `TERENY`. Ponieważ tereny są kompresowane, zapis zajmuje pewną chwilę. W pliku terenu zostaje zapisany sam teren oraz kilka ustawień: tło (tylko jego nazwa, nie sam obrazek!), ustawienia wylotu postaci, warunki itp.

### A3. Odczyt terenu

Odwrotność zapisu terenu. Po wybraniu pliku terenu zostaje on wczytany wraz ze wszystkimi ustawieniami. Wczytane zostaje także konkretne tło dla tego terenu. Jeśli owego tła nie będzie w podkatalogu z tłami, nie zostanie wczytane żadne tło i będzie ono czarne.

### A4. Odczyt postaci

W programie jest zawsze pięć grup postaci. Możesz je w dowolnym momencie zmieniać na takie, jakie posiadasz w podkatalogu `POSTACI`. Na liście dostępnych zestawów zaznaczone są kolorowymi wskaźnikami obecne zestawy dla poszczególnych grup. Dla każdej grupy przypisany jest jeden zestaw — wybierasz go kliknięciem obok danego zestawu znaczku grupy. Po wciśnięciu guzika **wczytaj** zostaną wczytane tylko te zestawy, które zostały właśnie zmienione.

### A5. Odczyt tła

Wczytanie rysunku tła widocznego „za" terenem. Tła pobierane są z podkatalogu `TLA`. Pamiętaj: jeśli masz wyłączony rysunek tła, nie zauważysz żadnych zmian aż do czasu jego włączenia.

### A6. Opcje

Tutaj masz dostępnych sporo opcji i ustawień programu.

#### Grafika i efekty

- **obrazek tła** [włączone/wyłączone] — włączanie rysunku tła. Po wyłączeniu uaktywnia się guzik „kolor", którym ustawia się jednolity kolor zamiast rysunku. Przyspiesza to nieco działanie programu.
- **dymy/wybuchy** [włączone/wyłączone] — sprajty eksplozji i dymów; tylko efekt dodatkowy, nie są do niczego potrzebne, a zwalniają program.
- **opady** [włączone/wyłączone] — można je wyłączyć z menu w grze, ale wyłączenie tutaj spowoduje całkowite pomijanie ich w programie, co powinno jeszcze nieco przyspieszyć działanie.
- **partikle (kamienie, krew itd.)** [włączone/wyłączone] — bardzo zwalnia program i jest niemal niezbędne; wyłączając tę opcję, stracisz dużo zabawy — nie będzie leciała krew, iskier, kamyków po wybuchach itd. Lepiej tego nie wyłączać.
- **bąbelki pod wodą** [włączone/wyłączone] — wyłączanie bąbelków pod wodą; działa tylko kiedy jest włączona woda.
- **łuski** [włączone/wyłączone] — wylatujące łuski ze strzelby/minigana/karabinu.
- **mięso, cegły itp.** [włączone/wyłączone] — lepiej tego nie wyłączać; nie będzie wtedy lecieć mięso z postaci, nie będzie też obiektów typu piłka, cegła itd.; „bronie" rzucające mięsem w ogóle nie będą działały.
- **wstrząsy ekranu** [włączone/wyłączone] — podczas wybuchów i trzęsienia ziemi; nie ma wpływu na prędkość programu.
- **blyski ekranu od pioruna** [włączone/wyłączone] — rozbłysk całego ekranu przy uderzeniu pioruna.
- **szybkość działania horroru** [01–20] — od tego ustawienia zależy, jak szybko krew będzie zalewać wszystko podczas włączonego trybu horroru; im mniejsza liczba, tym wolniej. Tryb horroru ma duży wpływ na prędkość — na wolniejszych komputerach warto zmniejszyć tę liczbę. Standardowo: 2.
- **fontanny krwi** [włączone/wyłączone] — dodatkowy efekt przy śmierci postaci i zwierzątek; żeby dobrze wyglądały, w detalach ustaw jak najwięcej partiklów.
- **ilość krwi** [10%–500%] — ilość krwi wytwarzanej przy ranach; 100% to standard.

#### Postacie i rozgrywka

- **rany od upadków** [włączone/wyłączone] — jak postać uderzy w ścianę, ziemię lub sufit z większą siłą, może stracić siłę (nawet życie) i poleje się krew.
- **spadek siły po większych ranach** [włączone/wyłączone] — kiedy postać straci kończynę czy głowę, traci siłę i po chwili umiera; wyłączając to, będzie wciąż biegać po ekranie, dopóki nie zabije jej ktoś inny.
- **centrowanie na postać sterowaną** [włączone/wyłączone] — podczas sterowania postacią z klawiatury ekran przesuwa się za nią, żeby utrzymać ją mniej więcej w centrum.
- **zwierzątka** [włączone/wyłączone] — włącza lub wyłącza wszystkie zwierzęta poruszające się po terenie: ptaki i ryby.
- **zwierzątka pojawiają się same** [włączone/wyłączone] — ptaszki i rybki wlatują (wpływają) z brzegów ekranu same (rybki tylko przy włączonej wodzie).
- **wersja dla młodszych** [włączone/wyłączone] — wyłącza krew, mięso i krzyki przy śmierci; postaci znikają. Jeśli Twoje dziecko już koniecznie musi w to grać — włącz to.

#### Paczki

- **paczki** [włączone/wyłączone] — spadające paczki z bonusami.
- **częstotliwość spadania paczek** [01–30] — 01 = najrzadziej, 30 = najczęściej.
- **paczki są też pod ziemią** [włączone/wyłączone] — paczki czasem pojawiają się pod ziemią i trzeba je odkopać.
- **postaci mogą otwierać paczki** [włączone/wyłączone] — postaci mogą otwierać paczki same, jeśli do nich podejdą.

#### Pogoda

- **wieloplanowe opady** [włączone/wyłączone] — opady deszczu i śniegu mogą padać na trzech planach: z tyłu, na teren i z przodu. Tylko plan środkowy ma działanie na otoczenie; pozostałe plany to efekt wizualny.
- **odgłosy deszczu** [włączone/wyłączone] — dźwięk deszczu; szczególnie klimatyczny z burzą.

#### Interfejs

- **pasek menu** [włączony/wyłączony/auto-chowany] — czerwone menu na dole ekranu. Wyłączenie daje większy obszar widoczny, ale utrudnia działanie. Auto-chowany — optymalna opcja: pojawi się, gdy przesuniesz wskaźnik myszy na dół ekranu (zmienia to także TAB w czasie gry).
- **podpisy, komentarze** [włączone/wyłączone] — krótkie teksty przy akcjach lub podpisy do aktualnie wybranego menu.
- **miejsce podpisów** [na górze/na dole]
- **liczniki trupów** [włączone/wyłączone] — małe liczniki trupów w rogu ekranu.
- **miejsce liczników** [na górze/na dole]
- **tultipsy** [włączone/wyłączone] — krótkie podpowiedzi obok kursora myszy; dobre dla początkujących.
- **wskaźniki pocisków za ekranem** [włączone/wyłączone] — wskaźniki przy brzegu ekranu, gdy pocisk wyleci poza widok.
- **wskaźniki postaci za ekranem** [włączone/wyłączone] — analogicznie dla zaznaczonej postaci.
- **kapanie krwi w menu** [włączone/wyłączone] — w głównym menu cały czas kapie krew z góry ekranu.
- **zakładki w menu** [włączone/wyłączone] — zakładki do każdego menu oddzielnie; prawy klawisz myszy (klawisz ` (tylda) w trakcie gry).
- **pamiętanie opcji każdego menu** [włączone/wyłączone] — na każdym menu oddzielnie pamiętane są opcje (dotyczy menu z broniami i innymi atrakcjami).

#### Dźwięk i sterowanie

- **głos złego pana** [włączone/wyłączone] — podczas ciekawszych akcji (zabita większa ilość jednocześnie) słychać w tle śmiech.
- **dźwięki** [włączone/wyłączone] — ogólne wyłączanie wszystkich dźwięków.
- **czułość myszki** [01–50]
- **szybkość przesuwania ekranu myszą** [01–20]
- **szybkość przesuwania ekranu klawiaturą** [01–20]
- **frejmskip** [01–20] — jeśli program działa za wolno, ustaw większą liczbę; pokazywanie co n-tej klatki przyspiesza grę kosztem płynności.

**\* detale \*** — otwiera nowe menu (patrz: [punkt A7](#a7-detale)).

### A7. Detale

> Wersja w DOSBox powinna pozwolić na ustawienia maksymalne w tym menu i raczej nie będzie trzeba ich więcej zmieniać. W przypadku problemów z prędkością, można zwiększyć szybkość emulowanego procesora w DOSBox klawiszami ctrl+F12 (zmniejszenie ctrl+F11)

Specyficzne menu w porównaniu z innymi. Ustawia się w nim dokładnie, po ile maksymalnie na raz może być poszczególnych detali. Na każdy szczegół przeznaczona jest dana ilość pamięci konwencjonalnej. Jeśli masz mało wolnej pamięci, nie ma tu wiele do manewrowania. Ilość detali ma wpływ na prędkość działania programu.

> ⚠️ Staraj się nie używać tego menu zbyt często — za każdym razem ponownie alokowana jest pamięć i może się zdarzyć błąd. Po każdym wejściu do tego menu (nawet jak nic nie zmienisz!) zostaną zresetowane wszystkie obiekty w terenie.

Każda pozycja ma intuicyjną nazwę. Jedyna wymagająca wyjaśnienia: *Max ilość wybuchów* — nie chodzi o same wybuchy (ich ilość jest nieograniczona), a o sprajty wybuchów. Im ich więcej, tym efektowniejsze większe eksplozje. Przy każdym detalu w nawiasie podana jest standardowa wartość, przy której program powinien wyglądać już dobrze.

Na dole ekranu podana jest ilość wolnej pamięci:

| Kolor | Znaczenie |
|-------|-----------|
| Zielony (powyżej 1000 B) | Program na 99% będzie działał poprawnie |
| Pomarańczowy (poniżej 1000 B) | Pewna szansa, że się wysypie |
| Czerwony (poniżej zera) | Może się to stać przy przydzielaniu pamięci podczas uruchamiania — nie zaczynaj zabawy w takiej sytuacji |

Przy każdorazowym uruchomieniu programu sprawdzana jest ilość wolnej pamięci. Jeśli braknie jej na ustawienia detali takie, jakie były poprzednio, detale zostaną zmniejszone. Po wyjściu z programu ustawienia zostają zapisane do pliku.

### A8. Statystyki

Pełna lista statystyk: ilości wypuszczonych pocisków różnego rodzaju, ilość postaci, trupów (jak zginęli) itd. Statystyki zerują się przy każdym uruchomieniu programu.

### A9. Autorzy

Parę informacji co, kto i jak.

### A10. Wyjście do systemu

Szybkie opuszczenie programu — jeśli już widzisz krew, nawet po odwróceniu się od monitora.

---

## B. Pasek menu

Czerwone menu na dole ekranu, widoczne w trakcie gry. Masz na nim wszystkie potrzebne opcje, bronie itd. Ponieważ ikon jest za dużo, menu podzielone jest tematycznie na sześć części. Zmienia się je klawiszem spacji lub cyframi od 1 do 6 lub zakładkami w menu (jeśli są włączone). Klawiszem TAB włączasz i wyłączasz cały pasek menu.

### B1. Bronie

W tym menu wybierasz broń, którą będziesz strzelać myszką lub sterowaną postacią.

| Broń | Opis | Ustawienia |
|------|------|------------|
| **bazuka** | Tradycyjny pocisk, powoli ciąży w dół, podatny na wiatr, wybucha po zetknięciu | siła wybuchu |
| **granat** | Wybucha po ustalonym czasie, podatny na wiatr, może zostać złapany i rzucony | siła, czas do wybuchu |
| **bomba** | Podobnie jak granat, lecz cięższa; po wybuchu rozpada się na odłamki | siła, czas do wybuchu |
| **karabin** | Duża częstotliwość, bez rozrzutu, pociski szybkie i niewidoczne | siła pocisków |
| **lekkie działko** | Duży rozmach, ciężko celować, pociski wybuchają z większą siłą | siła pocisków |
| **strzelba** | Rzadkie strzały (przeładowanie), drobny rozrzut, zabija na miejscu | siła pocisków |
| **snajperka** | Natychmiast trafia postać w celowniku, duża siła | — |
| **miotacz ognia** | Ogień nie rani, ale podpala | ogień/napalm |
| **nalot** | Pociski zrzucone z samolotu; lewy klawisz = z lewej, prawy = z prawej | zwykłe pociski/napalm |
| **pocisk samonaprowadzający** | Leci w wyznaczone miejsce; po pewnym czasie spada, jeśli nie trafi | siła, ustaw cel |
| **laser** | Promień tnie podłoże i ludzi | siła, zwykły/podpalający |
| **prąd** | Poraza, może zapalać | moc (V), zwykły/podpalający |
| **ognista kula** | Ciężka kula, po wybuchu pali wszystko dookoła | siła wybuchu |
| **miny** | Leżą i czekają; max 100 min naraz; prawy klawisz = zabierz minę; guzik „odpal" wysadza wszystkie | działająca/zepsuta/losowo |
| **kowadło** | Spadające kowadło niszczy wszystko | — |
| **piła** | „Broń ręczna" — tnie wszystko, czasem trzeba się namachać | — |
| **rejlgan** | Dla fanów Quake'a — szybki, zabija na trasie, nie wybucha | — |
| **napalm** | Jak bazuka, ale zapala wszystko wokół | siła wybuchu |
| **miotacz odłamków** | Wyrzuca spore ilości odłamków, podobnych jak z bomb | — |

### B2. Inne atrakcje

Dalszy ciąg broni, lecz innego typu:

- **śmieci** — rzucasz jabłkami, piłkami (postaci lubią je kopać), cegłami
- **mięsko** — dla kompletnie niewyżytych — rzucasz mięsem lub całymi zwłokami wybranej lub losowej grupy
- **krew** — podobnie jak powyżej, lecz polewasz krwią
- **piorun** — „strzał" piorunem z kursora
- **śnieg** / **deszcz** — opady z kursora
- **postać** — rzucasz ręcznie postacią z wybranej grupy
- **zwierzątka** — rzucasz ręcznie wybranym zwierzątkiem
- **wentylator** — zdmuchuje wszystko, co nie trzyma się terenu; lewy klawisz = rozkręcanie, prawy = utrzymanie prędkości
- **lupa** — do podglądu z bliska; można włączać non-stop (F2); przydatna np. do snajperki
- **paczki** — rzucanie paczkami; trzy rodzaje: bonusy, pułapki, inne; każdy można włączyć/wyłączyć

### B3. Opcje postaci

Menu ma znaczenie tylko, gdy zaznaczona jest co najmniej jedna postać. Pod ikonami pokazuje się siła, grupa i numer postaci (jedna zaznaczona) lub ilość wybranych postaci (więcej niż jedna).

| Opcja | Działanie |
|-------|-----------|
| **stoi** | Każe wybranym stać; potrafią robić zaskakujące rzeczy... |
| **blokuje** | Rola „blokera" (jak w Lemingach) — zawraca postaci, które podejdą |
| **idzie** / **biegnij** | Każe iść / biec |
| **panika** | Bieganie, wrzeszczenie, zmiana kierunku — trudno zapanować |
| **zawróć** | Zawraca wybrane postaci |
| **dodaj siły [+]** / **odejmij siły [-]** | ±50 jednostek siły; przy 0 postać ginie |
| **wolna wola [?]** | Postać robi rzeczy sama — ucieka przed zagrożeniami itd.; standardowo włączone |
| **śmierć [czaszka]** | Zabija natychmiast |
| **ugaś ogień** | Gasi wszystkie zapalone wybrane postaci |
| **nieśmiertelność** | Niezniszczalne postaci; zabija je tylko przepaść, woda, lawa lub kwas |
| **odznacz** | Odznacza wszystkich zaznaczonych (identycznie: ALT bez ustawiania kursora) |
| **zaznacz wszystkich** | Lewy klawisz = wszystkie; prawy na strzałce koloru = grupa; Ctrl = dodaj grupę |

#### Sterowanie postacią

Działa tylko przy wybranej **jednej** postaci. Sterowanie z klawiatury:

| Klawisz | Akcja |
|---------|-------|
| Strzałki na boki | Chodzenie lub bieganie |
| Strzałki w górę/dół | Zmiana kąta strzelania |
| A / Z | Zmiana siły strzału |
| S | Kopanie |
| D | Bicie |
| X | Strzał wybraną bronią |
| C | Skakanie |
| V + strzałka w bok | Idzie; bez strzałki — biegnie |

Wyjście z trybu sterowania: ponowne wciśnięcie guzika sterowania lub śmierć postaci.

### B4. Warunki

Sterowanie pogodą i nie tylko:

- **deszcz** / **śnieg** / **burza** / **deszcz krwi** — nie zadziała, jeśli w konfiguracji wyłączone opady
- **horror** — wydobywająca się krew ze ścian
- **trzęsienie ziemi** — działa tylko po kliknięciu; teren obsuwa się w dół
- **dziura** / **woda** / **lawa** / **kwas** — pięć możliwości zmiany podłoża; działa tylko jedna na raz
- **szaleńcy** — postaci biją się także wewnątrz grup
- **bicie się** — ogólny włącznik walki

**Paski:**

- **z lewej** — prędkość i kierunek wiatru; AUTO zmienia wiatr między granicami
- **w środku** — siła opadów; zasady AUTO jak przy wietrze
- **z prawej** — stopień agresji; zero = jak wyłączenie bicia się
- **pionowy z prawej** — poziom wody/lawy/kwasu

### B5. Rysowanie

Menu do rysowania terenu. Z lewej „próbka" tekstury lub koloru. Tekstury z podkatalogu `TEKSTURY`. Zamiast tekstury można używać koloru. Niektóre kolory mają specjalne właściwości: **metal** (cięższy do zniszczenia) i **krew** (wysycha i kapie, w 4 odcieniach). Obok wybór rozmiaru „pędzla" — to samo dla obiektów (schody, mostki itp.).

### B6. Menu główne

Wizerunki postaci z każdej z pięciu grup. Statystyki:

- **postaci jest/max** — ile postaci na ekranie / na ile możliwych
- **trupów tutaj** — trupów w aktualnym terenie (zeruje się po nowym terenie)
- **trupów razem** — trupów w całej grze od uruchomienia
- **ostatnie kombo** — ile ostatnio zginęło jednocześnie

Liczby pod postacią pokazują ile postaci z danej grupy jest w terenie (wyższa) na ile ustawionych (niższa). Klikając ustawiasz ilość postaci na ekranie. Mały znaczek obok postaci włącza/wyłącza punkty wyjścia.

Po kliknięciu wizerunku postaci pojawiają się opcje wyjścia:

- **co postać ma robić** — po pojawieniu się
- **kierunek** — początkowy kierunek
- **początkowa siła**
- **wolna wola** — standardowo włączone (patrz [B3](#b3-opcje-postaci))
- **częstotliwość pojawiania się**
- **%** — ile procent musi zostać żywych, aby przyszli następni (0% = po śmierci ostatniego, 100% = natychmiast po każdej śmierci)
- **zrzuć** — natychmiastowe uzupełnienie braków
- **nastawienie do innych grup** — 5 ikon; które grupy ze sobą walczą (chyba że „szaleńcy")

---

## C. Tryby gry

Dostępne są dwa tryby gry.

### 1. Tradycyjny — „mordowanie dla zabawy"

Taki, jaki był w Sadist: możesz robić wszystko, masz wszystkie bronie i opcje.

### 2. Gra na czas

Granie z kilkoma utrudnieniami:

- Określony czas na grę
- Ograniczona amunicja dla poszczególnych broni
- Rozpoczęcie **jedynie** przez tworzenie nowego terenu z tym trybem — nie działa na wczytanych terenach
- Start: 2000 amunicji + po 3 pociski na każdą potrzebną ofiarę (np. 200 postaci = 2600 amunicji, rozdzielone losowo)
- Misja: zabicie 150–400 postaci
- Postaci spadają z góry w grupach po 20; nowi pojawiają się po zabiciu wszystkich obecnych
- Ograniczone opcje — brak sterowania postaciami, punktów wyjścia, wody itd.
- Po czasie: podsumowanie. Premia za przekroczenie progu: `2 × potrzebna_ilość_trupów × trupów_ponad_próg` (średnio kilkadziesiąt–kilkuset tysięcy punktów)
- Po podsumowaniu ESC → menu; możesz wrócić na teren lub stworzyć nowy

---

## D. Klawiszologia i ogólne sterowanie

### Klawisze

| Klawisz | Funkcja |
|---------|---------|
| **F1** | Wybór broni |
| **F2** | Włączanie/wyłączanie lupy |
| **F3** | Włączanie/wyłączanie kursora |
| **F11** | Zapis mega zrzutu ekranu → `S2MS0123.BMP` (cały teren) |
| **F12** | Zapis zrzutu ekranu → `S2SS0123.PCX` (widoczny ekran) |
| **Spacja** | Zmiana menu na dole |
| **1–6** | Wybór konkretnego menu (bronie, atrakcje, postaci, warunki, rysowanie, główne) |
| **Tab** | Włączanie/wyłączanie menu na dole |
| **` (tylda)** | Włączanie/wyłączanie zakładek w menu |
| **Strzałki kursora** | Przesuwanie ekranu (gdy nie sterujesz postacią) |
| **Home/End/Delete/Page Down** | Sterowanie siłą i kierunkiem strzału (jak prawy klawisz myszy) |
| **Shift** | Przenoszenie kursorem postaci |
| **Ctrl** | Rzucenie przenoszonymi postaciami w kierunku celownika |
| **Alt** | Zaznaczanie postaci |
| **Alt+Ctrl** | Dodawanie kolejnych postaci do zaznaczonych |
| **+/-** | Zaznaczanie/odznaczanie postaci pod kursorem |
| **P** | Pauza (wszystko stoi, ale możesz działać) |
| **ESC** | Powrót do menu |

Klawisze sterowania postacią — patrz [B3. Opcje postaci](#b3-opcje-postaci).

### Mysz

- **Lewy klawisz** — strzał
- **Prawy klawisz (trzymany)** — sterowanie celownikiem; boki = obrót, góra/dół = siła strzału

---

## E. Pierwsze uruchomienie

Krótki przewodnik po pierwszym uruchomieniu:

1. **Konfiguracja** — przy pierwszym uruchomieniu może pojawić się napis o braku pliku konfiguracji i ustawieniach domyślnych. Przy kolejnych — wczytane zostaną ostatnie ustawienia.
2. **Intro** — można pominąć parametrem `-bezintro`.
3. **Menu główne** — domyślnie wczytani ludzie dla każdej grupy; możesz wczytać inne zestawy z `POSTACI`.
4. **Teren** — stwórz nowy (`nowy teren`) lub wczytaj istniejący. Ustaw parametry i wciśnij **stwórz**.
5. **Postaci** — ekran będzie pusty. Menu główne na pasku (spacja lub 6), klikaj liczby przy grupach.
6. **Broń** — menu 1, wybierz broń i... powodzenia.
7. **Eksploracja** — sprawdź menu 1–6; w menu 4 (warunki) włącz agresję i pogodę.
8. **Zapis** — ESC, zapisz teren, zmień opcje.

> W przeciwieństwie do Sadist I, Sadist II **nie zapisuje** ostatniego terenu przy wyjściu — przy każdym uruchomieniu trzeba teren wczytać lub stworzyć nowy.

---

## F. Strzelanie do problemów (troubleshooting)

> 📎 Poniższe problemy dotyczą uruchamiania pod natywnym DOS-em. W obecnej wersji opakowanej w DOSBoxa nie powinny mieć zastosowania.

### Problemy przy uruchamianiu

- **Zawieszenie po „rezerwacja pamięci XMS"** — brak wystarczającej pamięci XMS, brak `EMM386.EXE` lub problemy z pamięcią. Przy ~4 MB XMS sprawdź `CONFIG.SYS` i menadżera pamięci rozszerzonej.

- **Zawieszenie po „rezerwacja pamięci konwencjonalnej"** — brak pamięci podstawowej. Usuń programy rezydentne i spróbuj ponownie.

- **Zawieszenie/błąd po „wczytywanie danych"** — brakuje pliku w podkatalogu `DANE` lub jest błąd. Spróbuj rozpakować program ponownie.

- **Zawieszenie po „wczytywanie dźwięków"** — źle zainstalowana karta muzyczna, brak zmiennych `BLASTER` (bez nich nie zadziała autodetekcja!) lub inny program zajmuje kartę (WinAmp, mixer Sound Blaster).

- **Zawieszenie/błąd po „budowanie bazy tekstur"** — problem w katalogu z teksturami. Przeglądnij i usuń złe pliki.

- **Zawieszenie/błąd po „budowanie bazy zestawów postaci"** — problem w katalogu z postaciami. W `POSTACI` **musi** być co najmniej jeden plik z postaciami.

- **Zawieszenie/błąd po „wczytywanie konfiguracji"** — błąd w pliku konfiguracji. Skasuj `SADIST2.CFG` — przywróci to ustawienia standardowe.

- **Runtime Error 203 lub 207** — najpewniej brak pamięci konwencjonalnej. Zmniejsz detale, zostaw wolnej pamięci, wyrzuć programy rezydentne.

- **Zawieszenie/reset komputera** — konflikt z kartą muzyczną. Uruchom z parametrem `-bezdzwieku` (zyskasz też trochę pamięci).

### Inne

- **Brak muzyki w grze** — w Sadist 2 nie ma muzyki i nie będzie. Ale granie bez muzyki to strata. Włącz płytę Six Feet Under — stworzona chyba idealnie dla tego programu.

- **WinAmp + Sadist = zawieszenie** — WinAmp zajmuje kartę muzyczną. Jedyna opcja: `sadist2.exe /bezdzwieku`.

---

## G. FAQ — zbiór głupich pytań

**Dlaczego nie mogę sterować zwierzątkami?**
Zwierzątka są tylko detalem — nie były tworzone z zamiarem oddziaływania na nie jak na postaci. Ciesz się, że możesz je zabijać.

**Czemu nie ma muzyki?**
Bo nie. W Sadist 2 nie ma muzyki — włącz Six Feet Under (może być Cannibal Corpse itp.).

**Dlaczego nie leje się krew?**
Pewnie zapomniałeś, że nad tym trzeba samemu popracować — wybierz broń i do roboty!

**Dlaczego postaci nie strzelają do siebie jak w Sadist I?**
Zrezygnowałem z tej opcji — po włączeniu szybko nie było już terenu. Teraz masz bardziej urozmaicone bicie się. Strzelać można podczas sterowania postacią z klawiatury.

**Gdzie są sople jak w Sadist?**
Zrezygnowałem — mogłyby mocno zwolnić program.

**A drzewka?**
Były ładne, ale nieużyteczne — postaci chodziły po nich, a nie obok. Teren w Sadist II jest o wiele bardziej rozwinięty.

**Dlaczego nie ma tylu rzeczy jak w starym Sadist?**
To inny program. Tęsknisz za starym — zagraj w niego. Tutaj masz innowacje i nowe pomysły. Brakło mi pamięci na dalsze rozwijanie kodu.

**Czemu przy mega-screenshotach nie widać postaci?**
Mega screenshot to wizualny zapis terenu (bitmapa) — używam go do podglądów terenów na stronie.

**Zepsute miny blokują rzucanie działających?**
Limit 100 min. Zbieraj prawym klawiszem myszy lub wrzuć do przepaści/wody.

**Jak skonfigurować pamięć konwencjonalną?**

Przykładowe pliki (Windows 95):

**Autoexec.bat:**

```bat
rem *** ustawienia karty muzycznej, mozesz miec inne: ***
SET SOUND=C:\PROGRA~1\CREATIVE\CTSND
SET MIDI=SYNTH:1 MAP:E MODE:0
SET BLASTER=A220 I5 D1 H5 P330 E620 T6
PATH C:\WINDOWS;C:\WINDOWS\COMMAND
SET TEMP=C:\WINDOWS\TEMP
mode con codepage prepare=((852) C:\WINDOWS\COMMAND\ega.cpi) >nul
mode con codepage select=852 >nul
keyb pl,,C:\WINDOWS\COMMAND\keybrd4.sys
```

**Config.sys:**

```bat
DEVICE=C:\WINDOWS\HIMEM.SYS
DEVICE=C:\WINDOWS\EMM386.EXE RAM D=64
FILES=80
DOS=UMB,HIGH
device=C:\WINDOWS\COMMAND\display.sys con=(ega,,1)
Country=048,852,C:\WINDOWS\COMMAND\country.sys
```

To tylko przykład — u Ciebie mogą być inne katalogi i ustawienia. Windows 98 zachowuje się inaczej. Dla Windows 98 PL ściągnij patch'a z [Oficjalnej Strony Sadist](http://www.sadist.qs.pl/) — ~40 KB więcej wolnej pamięci konwencjonalnej.

---

## H. Parę ostatnich słów

Autor nie ponosi odpowiedzialności za szkody wynikłe z użytkowania tego programu, powstania choroby psychicznej (lub jej nasilenia), śmierci rodziny gracza, wypaczenia umysłowego i innych skrzywień psychicznych itd. Jeśli nie masz 18 lat — graj na własną odpowiedzialność, lecz nie uważam, aby to była gra dla Ciebie. Jeśli masz dziecko — lepiej nie pokazuj mu tego (wiem, jak dzieciom się to podoba!), bo nie odciągniesz go od komputera.

Podziękowania dla mojej siostrzenicy za parę śmiesznych pomysłów i motywację do dalszej pracy — gdybyście widzieli, jak ona lubi Sadista! Podziękowania także osobom, które męczyły mnie o stworzenie Sadist II — bez których pewnie nie chciałoby mi się tego pisać. Zarazem: strasznie mnie wkurzali zasypywaniem pytaniami o kolejną wersję i podrzucaniem pomysłów, których wyraźnie nie prosiłem.

Chcę zdementować pogłoski, jakoby Sadist był kopią jakiegoś programu. Sadist był tworzony bez powielania czyichś pomysłów. Spotkałem się już z wzorowaniem się **na** Sadist innych gier.

---

## I. Dane techniczne

### Rozszerzenia plików

| Rozszerzenie | Zawartość |
|--------------|-----------|
| `*.S2P` | Zestaw postaci |
| `*.S2T` | Zapisany teren |
| `*.S2B` | Rysunek tła |
| `*.STX` | Rysunek tekstury |
| `*.STW` | Rysunek wierzchu terenu |

### Formaty

- **Zestawy postaci** — wszystkie animacje, ustawienia i dźwięki. Dźwięki: format RAW (czyste dane), 8-bit, mono, 22050 Hz.
- **Tereny** — wygląd terenu (kompresja LZSS), nazwa tła (nie sam rysunek!), punkty wyjścia postaci, miny, warunki pogodowe.
- **Tła** — format zbliżony do BMP, 48 kolorów, 640×300, tablica przeźroczystości po bitmapie.
- **Tekstury i wierzchy** — uproszczony format bitmapy. Paleta sprowadzana do standardowej — czasem „pokaleczenie" kolorów. W wierzchu kolor czarny `#000000` = przeźroczysty.

### O programie

Program napisany w **Turbo Pascalu 7.0** pod DOS, z wstawkami assemblerowymi (Xan, dzięki za pomoc!), bez użycia obiektów, w trybie real-mode, z wykorzystaniem unita do obsługi pamięci XMS.

- **Kod:** 16 220 linii, 552 KB, 22 pliki PAS + CRT, DOS i MOUSE
- **Czas pisania:** ~5 miesięcy ciężkiej pracy (lipiec 2000 → wersja 1.0, 12.2000)
- **Cel:** żeby Wam się lepiej grało!

---

## J. To by było na tyle

I to raczej wszystko, co miałem do powiedzenia. Mam nadzieję, że po przeczytaniu tego jakże krótkiego dokumentu będziesz już wiedzieć, jak używać Sadist 2. Obsługa nie należy do najprostszych, ale to kwestia dużej ilości opcji — trzeba je poznać i się przyzwyczaić. Potem już leci z górki.

---

> **NIECH KREW BĘDZIE Z TOBĄ**
> *(a nie poza tobą)*

