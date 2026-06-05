unit vars;

interface
uses crt,myszunit;

const
pamminpotrz=3300; {32000[trawabuf] +8000[?] +14000[wczytywanie]}
{pamminpotrzmen=22000; {to co powyzej, tylko w procce menusy}

maxx=1280;        {wymiary ekranu gry}
maxy=400;
maxx1=1309696;    {wymiary ekranu gry shl 10 (lub *1024)}
maxy1=408576;
maxx1a=1310720;   {wymiary ekranu gry +1 shl 10 (lub *1024)}
maxy1a=409600;

Old_Int=$66;
Tmaxpost=300;  {100}
Tmaxsyf=1100;  {500}
Tmaxpoc=200;   {100}
Tmaxmin=200;   {100}
Tmaxmies=300;  { 50}
Tmaxwyb=100;   { 30}
Tmaxdym=100;   {100}
Tmaxopad=2000;{1000}
Tmaxkow=30;    { 10}
Tmaxbom=200;   {100}
Tmaxzwi=100;   { 30}
Tmaxpacz=100;  { 10}

maxpost:word=Tmaxpost;
maxsyf:word=Tmaxsyf;
maxpoc:word=Tmaxpoc;
maxmin:word=Tmaxmin;
maxmies:word=Tmaxmies;
maxwyb:word=Tmaxwyb;
maxdym:word=Tmaxdym;
maxopad:word=Tmaxopad;
maxkow:word=Tmaxkow;
maxbom:word=Tmaxbom;
maxzwi:word=Tmaxzwi;
maxpacz:word=Tmaxpacz;

corobitab:array[0..4] of byte=(0,6,1,2,7); {tablica poczatkowych ruchow postaci}
kgrup:array[0..4] of byte=(32,64,48,24,16); {kolory kolejnych grup}
czesci:array[0..5] of byte=(0,0,1,1,2,3);     {na jakie czesci sie rozlatuje?}

kolter:array[1..72] of byte=
   (2,122,3,123,
    124,4,125,5,
    10,11,12,13,
    18,19,20,21,
    26,27,28,29,
    34,35,36,37,
    42,43,44,45,
    50,51,52,53,
    58,59,60,61,
    66,67,68,69,
    74,75,76,77,
    82,83,84,85,
    90,91,92,93,
    98,99,100,101,
    106,107,108,109,
    114,115,116,117,
    162,163,164,165,
    178,179,180,181);
czescipoz:array[0..5] of record x,y:shortint end= {pozycje, z ktorych wylatuje mieso}
       ((x:-3;y:-1),
        (x: 3;y:-1),
        (x:-3;y: 4),
        (x: 3;y: 4),
        (x: 0;y:-4),
        (x: 0;y:-1));

typybroni1:array[0..19] of record {jakie bronie uzywaja jakich pociskow?}
   rodz, {rodzaj pocisku}
   il,   {ilosc uzywanej amunicji do jednego strzalu}
   odrz  {sila odrzutu postaci przy strzale; dziala odwrotnie: 1-mocno, wiecej-slabo}
   :byte;
   uzal  {czy odrzut jest uzalezniony od ustawionej sily strzalu?}
   :boolean
   end=
   ((rodz: 0; il: 1 ;odrz: 6; uzal: true),   {bazuka}
    (rodz: 1; il: 1 ;odrz:30; uzal:false),   {granat}
    (rodz: 2; il: 1 ;odrz:30; uzal:false),   {bomba}
    (rodz: 3; il: 1 ;odrz:30; uzal:false),   {dynamit}
    (rodz: 4; il: 1 ;odrz: 8; uzal:false),   {karabin}
    (rodz: 4; il: 1 ;odrz: 6; uzal:false),   {minigan}
    (rodz: 4; il: 2 ;odrz: 1; uzal:false),   {strzelba}
    (rodz: 4; il: 1 ;odrz: 0; uzal:false),   {snajper}
    (rodz: 5; il: 1 ;odrz:30; uzal: true),   {miotacz}
    (rodz: 0; il: 8 ;odrz: 0; uzal:false),   {nalot}
    (rodz: 0; il: 1 ;odrz: 6; uzal: true),   {poc.samo}
    (rodz: 6; il: 1 ;odrz: 0; uzal:false),   {laser}
    (rodz: 6; il: 1 ;odrz:40; uzal:false),   {prad}
    (rodz: 7; il: 1 ;odrz: 3; uzal: true),   {kula og.}
    (rodz: 8; il: 1 ;odrz:30; uzal:false),   {mina}
    (rodz: 9; il: 1 ;odrz:30; uzal:false),   {kowadlo}
    (rodz: 5; il: 1 ;odrz: 0; uzal:false),   {pila}
    (rodz:10; il: 1 ;odrz: 1; uzal:false),   {rejlgan}
    (rodz: 5; il:13 ;odrz: 6; uzal: true),   {napalm}
    (rodz: 4; il: 1 ;odrz:15; uzal: true));  {miot. odl}
typybroni2:array[100..109] of record {jakie inne atr. uzywaja jakich pociskow?}
   rodz, {rodzaj pocisku}
   il    {ilosc uzywanej amunicji do jednego strzalu}
   :byte;
   end=
   ((rodz:11; il: 1 ),   {smieci}
    (rodz:99; il: 0 ),   {miesko}
    (rodz:99; il: 0 ),   {krew}
    (rodz: 6; il: 5 ),   {piorun}
    (rodz:99; il: 0 ),   {snieg}
    (rodz:99; il: 0 ),   {deszcz}
    (rodz:255;il: 1 ),   {postaci}
    (rodz:255;il: 1 ),   {zwierz}
    (rodz:99; il: 0 ),   {wenty}
    (rodz:99; il: 0 ));  {lupa}

type
Ekran=array [0..199, 0..319] of byte;
fonty_tabl=array[0..60,0..6,0..6] of byte;
fonty2_tabl=array[0..59,0..5,0..3] of byte;
paleta_typ=array[0..255,0..2] of byte;
GDRHeader=record
  naglowek:array[0..3] of char;
  RX,RY:word;
  pal:paleta_typ;
end;
Tkfg=record
    dym_wyb,
    tlo,
    syfki,
    opady,
    miecho,
    komentarze,
    tultips,
    wskazniki_poc,
    wskazniki_post,
    wstrzasy_ekranu,
    fejdyekranu,
    odglosy_deszczu,
    bomble,
    zwierz,
    zwierzsamewychodza,
    glospana,
    luski,
    dzieci,
    smierczglutami,
    aureolki,

    paczki,postotwierajapaczki,paczkiwziemi,
    pokazuj_sterowanego,
    ranyodupadkow,
    traceniesily,
    bijasie,liczniki,
    wieloplanowyopady,
    kursorwidac,
    zakladki,zapamietujmenu:boolean;
    co_klatke,_co_klatke,tlokolor,
    gdziepodpisy,gdzielicznik,szybhorror,
    kolejnoscrekordow,czestotpacz,czuloscmysz,
    szybprzesekrmysz,szybprzesekrklaw:byte;
    krew_w_menu,dzwiek:boolean;
    imie:string[10];
    bronmenu:array[0..1] of byte;
    il_krwi:single;
    end;

Ttrawabuf=array[0..319] of byte;
Tlupapod=array[-30..30,-30..30] of byte;

{typy tablic obiektow}
Tpost=array[1..Tmaxpost] of record
     jest:boolean;
     x,y,dx,dy:single;
     ani,doani,sila,niesmiertelny:integer;
     corobi,comarobic:byte;
                  {0-stoi            dx:=0   dy:=0}
                  {1-idzie           dx:=0.5 dy:=0}
                  {2-biega           dx:=1   dy:=0}
                  {3-spada pionowo   dx:=0   dy:=0.5 [macha rekami]}
                  {4-leci krecac sie dx:=?   dy:=?}
                  {5-trzyma cos      dx:=0   dy:=0}
                  {6-blokuje         dx:=0   dy:=0}
                  {7-panikuje        dx:=1   dy:=0}
     cotrzyma,grupa,ogienani,
     rany:byte;
        {0- bez ran}
        {1- urwane rece}
     ktorego_walnie,  {podczas animacji uderzenia, juz zapamietane, ktory oberwie}
     ktore_mieso_walnie:word; {podczas animacji uderzenia, juz zapamietane, ktore mieso poleci}
     kier:shortint;
     zazn,trzymany,wolnawola,palisie:boolean;
     dusisie,blyska:byte;
     end;
Tzwi=array[1..Tmaxzwi] of record
     jest:boolean;
     x,y:longint;
     dx,dy:integer;
     ani,doani,sila:integer;
     rodz,corobi:byte;
     end;
Tmies=array[1..Tmaxmies] of record
    jest:boolean;
    x,y:longint;
    dx,dy:integer;
    rodz,
    stal:byte;    {czy w poprzedniej klatce byl na ziemi?}
    obr:shortint;
    trzyma_go,krew:word;
    palisie:boolean;
    end;
Tkow=array[1..Tmaxkow] of record
    jest:boolean;
    x,y:longint;
    dy:integer;
    stal,   {czy w poprzedniej klatce byl na ziemi? - do dzwieku}
    stoi:byte; {ile klatek juz stoi - do wylaczania po chwili}
    end;
Tpacz=array[1..Tmaxpacz] of record {spadajace paczki z bonusami}
   jest,rozwalasie,trzymany:boolean;
   x,y:longint;
   dy:integer;
   rodz,wygl,
   stal:byte;    {czy w poprzedniej klatce byl na ziemi? - do dzwieku}
   end;
Tsyf=array[1..Tmaxsyf] of record
    jest:boolean;
    x,y:longint;
    dx,dy:integer;
    kol,
    jakkonczy, {0-znika, 1-zostaje w scianie, 2-zostaje na ziemi}
    rozm,
    szybiskr:byte; {szybkosc zciemniania iskier, podaje sie zmiana[X]}
    graw:boolean;
    czas:word;
    obr:shortint;
    end;
Topad=array[1..Tmaxopad] of record
    jest:boolean;
    x:longint;
    y:integer;
    kol,plan,rodz:byte; {rodz:0-snieg,1-deszcz}
    end;
Tpoc=array[1..Tmaxpoc] of record
    jest:boolean;
    x,y:longint;
    dx,dy:integer;
    rodz,sila,wygl,
    stal:byte;    {czy w poprzedniej klatce byl na ziemi?}
    ostkier:single;
    czas:integer;
    trzyma_go:word;
   end;
Tmin=array[1..Tmaxmin] of record
    jest:boolean;
    x,y:longint;
    dx,dy:integer;
    stal:byte;    {czy w poprzedniej klatce byla na ziemi?}
    ostkier:single;
    czas:integer;
    end;
Twyb=array[1..Tmaxwyb] of record
    jest:boolean;
    x,y:integer;
    ani,wygl:shortint;
    end;
Tdym=array[1..Tmaxdym] of record
    jest:boolean;
    x:longint;
    y:integer;
    doani,ani,wygl:shortint;
    end;
Tbom=array[1..Tmaxbom] of record
    jest:boolean;
    x,y:longint;
    dy:integer;
    end;



var
pamiecikonwencjonalnej:longint;
_xms:array[0..4] of record
                 h:word;
                 os:longint;
                 end;
GDRHead:GDRHeader;
Scr,scr2:^Ekran;
scr_x1,scr_x2,scr_y1,scr_y2:word;
fonty:^fonty_tabl;
fontym:^fonty2_tabl;
trawabuf:^Ttrawabuf;

ciagle_dzwieki:array[0..10] of byte;
{0- syk bomby           7 }
{1- ogien na ekranie    6 }
{2- miotacz ognia       5 }
{3- deszcz              4 }
{4- laser               5 }
{5- prad                5 }
Save_Int : pointer;
Kl,klw:array[0..127] of boolean;
pal,pal_gl,palczekaj:array[0..255,0..2] of byte;
offsety:array[1..32] of longint;
offsetyp,offsetym:array[0..4] of longint;

a:integer;
plik:file;
wyr:string;
b:byte;

ekr:record
    wy,x,y,
    menuwys:longint;
    skok,fejd:integer;
    ktore_menu,opcja_menu:byte;
    jak_menu:shortint; {0-brak, 1-autowysuw, 2-stale}
    end;
zmiana:array[0..10] of integer;
ciempal:array[0..255] of byte;

post:^Tpost;
zwi:^Tzwi;
mies:^Tmies;
kow:^Tkow;
pacz:^Tpacz;
syf:^Tsyf;
opad:^Topad;
poc:^Tpoc;
min:^Tmin;
wyb:^Twyb;
dym:^Tdym;
bom:^Tbom;

{rozne liczniki}
il_post,   {ilosc postaci na ekranie}
il_min,    {ilosc min na ekranie}
il_zazn,   {ilosc zaznaczonych postaci}
ktora_zazn,{ktora post. zaznaczona? [dziala tylko przy jednej]}
il_trupow, {licznik trupow}
il_trup_et,{ile bylo trupow przy wejsciu do tego etapu}
punkty,    {punkty}
ost_combo, {ostatnie kombo}

wystrzelone,{do zlosliwych uwag: ilosc wystrzelonych pociskow}
czasbezstrz {do zlosliwych uwag: czas bez strzelania}
          :longint;

grupy:array[0..4] of record
    maxpost,jestpost,corobi,czestot,procent:integer;
    wylot,wyrzuca,
    wolnawol:boolean;
    kiedynast:byte;
    kierunek:shortint;
    wylx,wyly,sila:integer; {pozycja wylotu}
    {dotad jest zapisywane w terenach}

    bracia:array[0..4] of boolean;
    ranykrew:array[0..3,0..7] of record
                                 x,y:shortint;
                                 dx,dy:single;
                                 end;
    bicie:array[0..1] of record {0-kopanie, 1-bicie}
                         x,y:shortint;
                         dx,dy:single;
                         klatka:byte;
                         end;
    szybkosc,waga:real;
    sila_bicia,sila_kop:integer;
    ani_corobi:array[0..13] of byte;{szybkosci animacji}
    kolorkrwi:record
         od,ile:integer;
         end;
    end;
celow:record
    temp,kat,sila,
    st_kat,st_sila:integer; {kat i sila dla sterowania postaciami}
    bron,
    nie_lap_ludzi, {zeby nie lapac ludzi shiftem przez chwile po rzucie}
    jest_pochodnia,{odstepy miedzy kolejnymi dzwiekami pochodni}
    opcja:byte;   {opcja celownika:
                   0-zwyczajnie, bez kombinacji - strzelanie itd:)
                   1..5-ustawianie pozycji wylotu kazdej z grup
                   6-rysowanie
                   7-ustawianie pozycji celownika pocisku samonaprowadz.
                   }
    zaznacza, {altem}
    lapie, {shiftem}
    strzela,lupa:boolean; {jak sprawdzanie guzik[1], ale podczas strzelania postacia}
    x1,x2,y1,y2,
    celx,cely:longint; {pozycja celu samonaprowadzajacego pocisku}
    ktorycel:integer; {0-zwykly cel, >0-celem postac nr}
    sterowanie:byte; {ktora postacia sie steruje; 0-zadna}
    end;
rejlgan:record
    x,y,dx,dy:real;
    dl:longint;
    czas:byte;
    end;
ust_broni:record
    bazuka:record
       sila:byte;
       end;
    granat,bomba,dynamit:record
       sila,czas:byte;
       end;
    ludzie:record
       grupa:shortint;
       end;
    pocsam:record
       sila:byte;
       end;
    laser:record
       sila:byte;
       podpala:boolean;
       end;
    prad:record
       sila:byte;
       podpala:boolean;
       dlug:longint;
       end;
    kulaog:record
       sila:byte;
       end;
    nalot,miotacz:record
       rodz:byte;
       end;
    napalm:record
       sila:byte;
       end;
    smieci:record
       co:shortint;
       end;
    miesko:record
       co,grupa:shortint;
       end;
    zwierz:record
       rodzaj:byte;
       end;
    wentyl:record
       sila,ani:single;
       end;
    lupa:record
       powiekszenie, znieksztalcenie:integer;
       odwracax,odwracay:shortint;
       end;
    paczki:record
       rzut:byte;
       rodzaje:array[0..2] of boolean
       end;
    strzelba,minigan,karabin:record
       sila:byte;
       end;
    miny:record
       zepsute:byte;
       end;
    end;
stats:record
    rakiety,
    granaty,
    bomby,
    dynamity,
    kulaog,
    miny,
    kowadla,
    pociski,
    postaci,
    utopionych,
    zabitych,
    spalonych,
    zwierzatek,
    najlkombo,
    paczbylo,
    paczzebr,
    rejlpoc
              :longint;
    end;

lupapod:^Tlupapod;
koment:record
    tx:array[0..9] of string;
    cz:byte;
    m:integer;
    end;
tultip:record
    tx:string;
    cz:byte;
    x,y:integer;
    end;
pogoda:record
    wiatr,wtrgrl,wtrgrp,
    wielkopadow,wlkopgrl,wlkopgrp,
    trzesienieziemi,agresja,pozwody:integer;    { 9*2}
    autowiatr,autoopady,
    snieg,deszcz,burza,sople,sopleuryw,
    horror,deszczkrwi,szalency:boolean; {10*1}
    il_sniegu,bylo_sniegu:word;         { 2*2}
    rodztla:string[10];                 {11*1}
    dziura:byte;                        { 1*1} {0-ziemia,1-dziura,2-woda,3-lawa,4-kwas}
    jest_piorun:byte;
    droga_p:record
        x,y:array[0..499] of integer;
        roz:array[0..2] of integer;
        ilekrok:integer;
        end;
    end;
piorun_w_wode:byte;
nowy_param:record
    rodzteren:byte;
    textura,wierzch:longint; {0-bez textury, >0-z textura nr...}
    grgora,grdol:integer; {granice: gorna i dolna}
    czyscstare:boolean;
    end;
kfg:Tkfg;
ostpliki:record
   teren,tlo:string[8];
   postaci:array[0..4] of string[8];
   end;
mysz:record
    wygl:byte;
    end;
rysowanie:record
    rozm,kolor,textura,ksztalt,
    jakrys:byte; {0-rysowanie kolorem, 1-rysowanie textura}
    obiekt,obrozm:integer;
    gladko:boolean;
    end;

full:record {czy w danej turze juz jest max obiektow; zeby nie sprawdzac kilka razy}
    syf,
    bom,
    dym,
    wyb, {ani wybuchu, nie dziury}
    mies:boolean;
    end;

bonusy:record
    lekkiepost,
    ciezkopost,
    przyklejpost,
    panika,
    pinball,
    spokojni:word;
    end;

pilatnie:byte;

iltextur,ilwierzch,ilpostaci:longint;
texturar,wierzchr:record
    rx,ry:integer;
    nazwa:string[10];
    end;

pam:record
   suma,
   spost,szwi,smies,skow,spacz,ssyf,sopad,spoc,smin,swyb,sdym,sbom:longint;
   end;

pauza, trybgry,
_nowy,_wyjscie,
_wolno_wrocic_do_gry,
jestkartamuzyczna:boolean;

tr_gry:record
   amun:array[0..11] of integer;
   czas,
   jeszcze,
   bylopkt:longint;
   grupa:byte;
   end;

implementation


end.