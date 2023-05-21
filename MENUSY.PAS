unit menusy;

interface
{$N+}
{*}PROCEDURE pierwsze_sprawy;
{*}PROCEDURE ostatnie_sprawy;
{*}PROCEDURE standard_kfg;
{*}PROCEDURE wczytaj_kfg;
{*}PROCEDURE zapisz_kfg;
{*}PROCEDURE wczytaj_rekordy;
{*}PROCEDURE zapisz_rekordy;
{*}PROCEDURE ustaw_rekordy(jak:byte); {0:wg punktow, 1:wg trupow}
{*}PROCEDURE menu;
{*}PROCEDURE podliczenie_po_grze;
{*}PROCEDURE intro;

implementation
uses crt,vars,glowne,dos,xms,maskp,myszunit,cosin,dzwieki2,SMix,
     nowe,resztki,resztki2,loudsejw,timer,robteren,dat_file,gadparam;

type
Tnaglowek=array[0..5] of char;

const
naglowek:Tnaglowek=('S','2','1','0','5','i');

var
wyniki:array[1..11] of record
    imie:string[10];
    dd,mm,rr:word;
    pkt,trupow:longint;
    end;
miejscegracza:byte;

{*}PROCEDURE Sadist_OS;
begin
textbackground(0);textcolor(7);
clrscr;
textbackground(4);textcolor(15);
writeln(' Sadist II: Ostatni krzyk  ver.1.07                        (c)2000/2001 S.K.GAD ');
textbackground(0);textcolor(7);
end;

{*}PROCEDURE rezerwacja_konwencjonalnej;
begin
writeln('pamieci zostalo:',memavail,'b');
WITH pam do begin
spost:=sizeof(post^) div Tmaxpost;
szwi:=sizeof(zwi^) div Tmaxzwi;
smies:=sizeof(mies^) div Tmaxmies;
skow:=sizeof(kow^) div Tmaxkow;
spacz:=sizeof(pacz^) div Tmaxpacz;
ssyf:=sizeof(syf^) div Tmaxsyf;
sopad:=sizeof(opad^) div Tmaxopad;
spoc:=sizeof(poc^) div Tmaxpoc;
smin:=sizeof(min^) div Tmaxmin;
swyb:=sizeof(wyb^) div Tmaxwyb;
sdym:=sizeof(dym^) div Tmaxdym;
sbom:=sizeof(bom^) div Tmaxbom;

maxpost:=100;
maxsyf:=500;
maxpoc:=100;
maxmin:=100;
maxmies:=100;
maxwyb:=30;
maxdym:=50;
maxopad:=1000;
maxkow:=10;
maxbom:=100;
maxzwi:=30;
maxpacz:=10;

wczytaj_detale;

suma:=pamminpotrz+1000+spost*maxpost+
            szwi*maxzwi+
            smies*maxmies+
            skow*maxkow+
            spacz*maxpacz+
            ssyf*maxsyf+
            sopad*maxopad+
            spoc*maxpoc+
            smin*maxmin+
            swyb*maxwyb+
            sdym*maxdym+
            sbom*maxbom;

if maxavail<pamminpotrz+1000+spost*10+
            szwi*10+
            smies*10+
            skow*10+
            spacz*10+
            ssyf*10+
            sopad*10+
            spoc*10+
            smin*10+
            swyb*10+
            sdym*10+
            sbom*10 then begin
  writeln('brak minimum potrzebnej pamieci konwencjonalnej; uruchamianie przerwane!');
  halt(0);
end;

if suma>maxavail then begin
  writeln('brakuje pamieci, potrzeba ',suma,' czyli o ',suma-maxavail,' za malo; zmniejszam detale');
  repeat
   suma:=pamminpotrz+1000+spost*maxpost+
            szwi*maxzwi+
            smies*maxmies+
            skow*maxkow+
            spacz*maxpacz+
            ssyf*maxsyf+
            sopad*maxopad+
            spoc*maxpoc+
            smin*maxmin+
            swyb*maxwyb+
            sdym*maxdym+
            sbom*maxbom;
   if suma>maxavail then begin
      if maxmies>10 then dec(maxmies);
      if maxsyf>10 then dec(maxsyf,2);
      if maxopad>10 then dec(maxopad,10);
      if maxpoc>10 then dec(maxpoc);
      if maxmin>10 then dec(maxmin);
      if maxbom>10 then dec(maxbom);
      if maxpost>10 then dec(maxpost);
      if maxwyb>10 then dec(maxwyb);
      if maxdym>10 then dec(maxdym);
      if maxbom>10 then dec(maxbom);
      if maxpacz>10 then dec(maxpacz);
      if maxzwi>10 then dec(maxzwi);
      if maxkow>10 then dec(maxkow);
   end;
  until suma<=maxavail;
end;
{halt(0);}
writeln('status:'#13#10,
        ' pst:',maxpost,
        ', prt:',maxsyf,
        ', poc:',maxpoc,
        ', min:',maxmin,
        ', mie:',maxmies,
        ', wyb:',maxwyb,','#13#10,
        ' dym:',maxdym,
        ', opd:',maxopad,
        ', kow:',maxkow,
        ', bom:',maxbom,
        ', zwi:',maxzwi,
        ', pac:',maxpacz);

if memavail>pamminpotrz+spost*maxpost then getmem(post,spost*maxpost)
   else halt;
if memavail>pamminpotrz+szwi*maxzwi then getmem(zwi,szwi*maxzwi)
   else halt;
if memavail>pamminpotrz+smies*maxmies then getmem(mies,smies*maxmies)
   else halt;
if memavail>pamminpotrz+skow*maxkow then getmem(kow,skow*maxkow)
   else halt;
if memavail>pamminpotrz+spacz*maxpacz then getmem(pacz,spacz*maxpacz)
   else halt;
if memavail>pamminpotrz+ssyf*maxsyf then getmem(syf,ssyf*maxsyf)
   else halt;
if memavail>pamminpotrz+sopad*maxopad then getmem(opad,sopad*maxopad)
   else halt;
if memavail>pamminpotrz+spoc*maxpoc then getmem(poc,spoc*maxpoc)
   else halt;
if memavail>pamminpotrz+smin*maxmin then getmem(min,smin*maxmin)
   else halt;
if memavail>pamminpotrz+swyb*maxwyb then getmem(wyb,swyb*maxwyb)
   else halt;
if memavail>pamminpotrz+sdym*maxdym then getmem(dym,sdym*maxdym)
   else halt;
if memavail>pamminpotrz+sbom*maxbom then getmem(bom,sbom*maxbom)
   else halt;

END;{with}

end;

{*}PROCEDURE pierwsze_sprawy;
var
 DirInfo:SearchRec;
 juz:boolean;
 a:longint;
 wyr2:string;
 buf1,buf2:array[0..36] of char;
 pl:file;
begin
Sadist_OS;

write('Wykrywanie myszy... ');
if not sprawdzczyjestmysz then begin
   writeln('brak myszy! [chcesz uruchomic Sadista bez myszy ??? ;-)]');
   halt(0);
end
   else writeln('jest mysz');

writeln('Rezerwacja pamieci XMS');
if (paramcount>0) and (parametr(true,false,'BEZDZWIEKU')) then begin
   jestkartamuzyczna:=false;
   writeln('Dzwiek wylaczony z linii polecen!');
   end else
   jestkartamuzyczna:=true;

if jestkartamuzyczna then begin
   Init;
   writeln('Wczytywanie dzwiekow')
end;
LoadSounds;
XMSAllocate(_xms[1].h,5000);

sprawdz_katalogi;
randomize;
writeln('Rezerwacja pamieci konwencjonalnej:');
writeln('wolnej pamieci:',memavail,'b, rezerwacja na najwazniejsze rzeczy');
new(scr);fillchar(scr^,64000,0);
new(scr2);fillchar(scr2^,64000,0);
new(fonty);
new(fontym);
new(chmur);
new(negatyw);
pamiecikonwencjonalnej:=memavail;

rezerwacja_konwencjonalnej;
GetIntVec($9,Save_Int);
SetIntVec(Old_Int,Save_Int);fillchar2(Kl,SizeOf(Kl),0);fillchar2(Klw,SizeOf(Klw),0);
SetIntVec($9,@Get_Keyb_Int);
scr_x1:=0;scr_x2:=319;scr_y1:=0;scr_y2:=199;
writeln('Wczytywanie danych...');
wczytaj_fonty;
wczytaj_pal('paleta.pal');
{$I+} a:=ioresult; {$I-}
obrazki;

datassign(plik,'dane\s2.dat','transtab.dat',0);
blockread(plik, chmur^,sizeof(chmur^));
close(plik);
datassign(plik,'dane\s2.dat','negtab.dat',0);
blockread(plik, negatyw^,sizeof(negatyw^));
close(plik);

move(pal_gl,pal,sizeof(pal));
{zrob palete sciemniania}
for a:=0 to 255 do
    znajdz_kolor(trunc(pal_gl[a,0]/1.3),
                 trunc(pal_gl[a,1]/1.3),
                 trunc(pal_gl[a,2]/1.3),ciempal[a],0);
il_trupow:=0;
_wolno_wrocic_do_gry:=false;
zmiana[0]:=0;

{zrob liste tekstur}
write('Budowanie bazy tekstur: ');
iltextur:=0;
FindFirst('tekstury\*.stx',Anyfile,DirInfo);
while (DosError=0) and (iltextur<3000) do begin
   inc(iltextur);
   wyr:=DirInfo.Name;
   if pos('STX',wyr)>0 then delete(wyr,pos('STX',wyr)-1,4);
   mem2xms(wyr,_xms[1].h,offsety[13]+iltextur*10,10);
   FindNext(DirInfo);
end;

if iltextur>=2 then
 repeat
   juz:=true;
   for a:=1 to iltextur-1 do begin
       xms2mem(_xms[1].h,offsety[13]+a*10,wyr,10);
       xms2mem(_xms[1].h,offsety[13]+(a+1)*10,wyr2,10);
       if wyr2<wyr then begin
          mem2xms(wyr,_xms[1].h,offsety[13]+(a+1)*10,10);
          mem2xms(wyr2,_xms[1].h,offsety[13]+a*10,10);
          juz:=false;
       end;
   end;
 until juz;

write('znaleziono ',iltextur,' tekstur(e/y) ');

{wierzchy:}
ilwierzch:=0;
FindFirst('tekstury\*.stw',Anyfile,DirInfo);
while (DosError=0) and (ilwierzch<3000) do begin
   inc(ilwierzch);
   wyr:=DirInfo.Name;
   if pos('STW',wyr)>0 then delete(wyr,pos('STW',wyr)-1,4);
   mem2xms(wyr,_xms[1].h,offsety[14]+ilwierzch*10,10);
   FindNext(DirInfo);
end;

if ilwierzch>=2 then
 repeat
   juz:=true;
   for a:=1 to ilwierzch-1 do begin
       xms2mem(_xms[1].h,offsety[14]+a*10,wyr,10);
       xms2mem(_xms[1].h,offsety[14]+(a+1)*10,wyr2,10);
       if wyr2<wyr then begin
          mem2xms(wyr,_xms[1].h,offsety[14]+(a+1)*10,10);
          mem2xms(wyr2,_xms[1].h,offsety[14]+a*10,10);
          juz:=false;
       end;
   end;
 until juz;
writeln('i ',ilwierzch,' wierzch(y/ow)');
{E zrob liste tekstur}

{zrob liste postaci}
write('Budowanie bazy zestawow postaci: ');
ilpostaci:=0;
FindFirst('postaci\*.s2p',Anyfile,DirInfo);
while (DosError=0) and (iltextur<3000) do begin
   inc(ilpostaci);
   wyr:=DirInfo.Name;
   if pos('S2P',wyr)>0 then delete(wyr,pos('S2P',wyr)-1,4);
   mem2xms(wyr,_xms[1].h,offsety[17]+ilpostaci*10,10);

   assign(pl,'postaci\'+DirInfo.Name);
   reset(pl,1);
   wyr:='';
   seek(pl,25);
   blockread(pl,wyr,25);
   mem2xms(wyr,_xms[1].h,offsety[18]+ilpostaci*30,25);
   close(pl);

   FindNext(DirInfo);
end;

if ilpostaci>=2 then
 repeat
   juz:=true;
   for a:=1 to ilpostaci-1 do begin
       xms2mem(_xms[1].h,offsety[17]+a*10,wyr[0],10);
       xms2mem(_xms[1].h,offsety[17]+(a+1)*10,wyr2[0],10);
       if wyr2<wyr then begin
          mem2xms(wyr,_xms[1].h,offsety[17]+(a+1)*10,10);
          mem2xms(wyr2,_xms[1].h,offsety[17]+a*10,10);

          xms2mem(_xms[1].h,offsety[18]+a*30,buf1,26);
          xms2mem(_xms[1].h,offsety[18]+(a+1)*30,buf2,26);
          mem2xms(buf1,_xms[1].h,offsety[18]+(a+1)*30,26);
          mem2xms(buf2,_xms[1].h,offsety[18]+a*30,26);
          juz:=false;
       end;
   end;
 until juz
       else if ilpostaci=0 then begin
          writeln('BRAK PLIKOW Z POSTACIAMI! Uruchamianie przerwane...');
          halt(0);
       end;

writeln('znaleziono ',ilpostaci,' zestaw(y/ow) postaci');

wczytaj_kfg;
{readkey;}
{-----------}
trybgraf;
ustawoknomyszy(0,0,319*2,199);
ustawczuloscmyszy(51-kfg.czuloscmysz,51-kfg.czuloscmysz);
ustawpozycjemyszy(319,100);
end;

{*}PROCEDURE ostatnie_sprawy;
begin
trybtext;
Sadist_OS;
writeln('Studio Komputerowe GAD: http://gad.art.pl/ email:gad@gad.art.pl'#13#10,
        'Oficjalna Strona Sadist: http://sadist.art.pl/ znajduje sie na serwerze'#13#10,
        'QuadroSoft: http://komputron.pl/ .'#13#10);

wczytaj_rekordy;
ustaw_rekordy(0);
zapisz_rekordy;

XMSFree(_xms[1].h);
if jestkartamuzyczna then begin
   Shutdown;
   FreeSounds;
end;

SetIntVec($9,Save_Int);
dispose(scr);
dispose(scr2);
dispose(fonty);
dispose(fontym);
dispose(chmur);
dispose(negatyw);
{$I+}
a:=ioresult;
writeln('Pamietaj, ze ten program to freeware i jesli ktos Ci go sprzedal, to masz prawo wyrwac mu za to watrobe :>.'#13#10#10,
        'Zanim wyslesz do mnie emaila z pytaniami - koniecznie przeczytaj plik'#13#10,
        '"S2-JTD.htm" !!! Znajdziesz w nim wiele odpowiedzi na swoje pytania.');
end;

{*}PROCEDURE standard_kfg;
begin
with kfg do begin
   dym_wyb:=true;
   tlo:=true;
   opady:=true;
   syfki:=true;
   miecho:=true;
   komentarze:=true;
   tultips:=true;
   wskazniki_poc:=true;
   wskazniki_post:=true;
   wstrzasy_ekranu:=true;
   co_klatke:=1;
   tlokolor:=1;
   fejdyekranu:=true;
   odglosy_deszczu:=true;
   pokazuj_sterowanego:=true;
   ranyodupadkow:=true;
   traceniesily:=true;
   bijasie:=true;
   liczniki:=true;
   dzwiek:=true;
   bomble:=true;
   zwierz:=true;
   zwierzsamewychodza:=true;
   gdziepodpisy:=0;
   gdzielicznik:=0;
   wieloplanowyopady:=true;
   krew_w_menu:=true;
   glospana:=true;
   szybhorror:=2;
   paczki:=true;
   postotwierajapaczki:=true;
   paczkiwziemi:=true;
   imie:='SADYSTA';
   kolejnoscrekordow:=0;
   czestotpacz:=4;
   luski:=true;
   czuloscmysz:=45;
   kursorwidac:=true;
   zakladki:=true;
   zapamietujmenu:=false;
   bronmenu[0]:=0;
   bronmenu[1]:=100;
   szybprzesekrmysz:=8;
   szybprzesekrklaw:=12;
   il_krwi:=1;
   smierczglutami:=true;
   aureolki:=true;
end;
with ostpliki do begin
   teren:='TEREN';
   tlo:='TLO';
   for a:=0 to 4 do postaci[a]:='LUDZIE';
end;
with nowy_param do begin
   rodzteren:=13;
   textura:=0;
   wierzch:=1;
   grgora:=30;
   grdol:=395;
   czyscstare:=true;
end;
with ekr do begin
   x:=maxx div 2 -160;
   y:=maxy div 2 -100;
   skok:=0;
   ktore_menu:=5;
   opcja_menu:=0;
   menuwys:=0;
   jak_menu:=2;
end;
with mysz do begin
   wygl:=0;
end;
with celow do begin
   sila:=10;
   kat:=0;
   temp:=0;
   zaznacza:=false;
   celx:=640;
   cely:=200;
   ktorycel:=0;
   lupa:=false;
end;
with rysowanie do begin
   rozm:=20;
   kolor:=13;
   textura:=1;
   jakrys:=0;
   obiekt:=1;
   obrozm:=5;
   gladko:=true;
end;
with ust_broni do begin
   bazuka.sila:=8;
   granat.sila:=7;
   granat.czas:=40;
   bomba.sila:=9;
   bomba.czas:=40;
   dynamit.sila:=9;
   dynamit.czas:=40;
   pocsam.sila:=8;
   strzelba.sila:=5;
   minigan.sila:=6;
   karabin.sila:=3;
   laser.sila:=5;
   laser.podpala:=false;
   prad.sila:=5;
   prad.podpala:=false;
   prad.dlug:=0;
   kulaog.sila:=8;
   napalm.sila:=3;
   miotacz.rodz:=0;
   nalot.rodz:=0;
   smieci.co:=0;
   miesko.co:=0;
   miesko.grupa:=0;
   wentyl.ani:=0;
   lupa.powiekszenie:=14;
   lupa.znieksztalcenie:=50;
   lupa.odwracax:=1;
   lupa.odwracay:=1;
   paczki.rzut:=3;
   paczki.rodzaje[0]:=true;
   paczki.rodzaje[1]:=true;
   paczki.rodzaje[2]:=true;
   miny.zepsute:=0;
end;
for a:=0 to 4 do
  with grupy[a] do begin
    wylot:=false;
    corobi:=2;
    czestot:=5;
    sila:=50;
    kierunek:=0;
    kiedynast:=0;
    procent:=50;
    wylx:=213+a*213;
    wyly:=5;
    wolnawol:=true;
    for b:=0 to 4 do bracia[b]:=false;
    bracia[a]:=true;
  end;
with pogoda do begin
   wiatr:=0;
   wtrgrl:=-10;
   wtrgrp:=10;
   wielkopadow:=30;
   wlkopgrl:=20;
   wlkopgrp:=40;
   autowiatr:=true;
   autoopady:=true;
   snieg:=false;
   deszcz:=false;
   burza:=false;
   sople:=false;
   sopleuryw:=false;
   deszczkrwi:=false;
   horror:=false;
   jest_piorun:=0;
   pozwody:=370;
   dziura:=0;
   agresja:=10;
end;
with tultip do begin
   x:=0;
   y:=0;
   cz:=0;
   tx:='';
end;
trybgry:=false;
fillchar(stats,sizeof(stats),0);
sprawdz_czy_jest_plik_tla(ostpliki.tlo);
end;

{*}PROCEDURE wczytaj_kfg;
var
naglwczyt:Tnaglowek;

begin
standard_kfg;
{$I+} a:=ioresult; {$I-}

assign(plik,'dane\sadist2.cfg');
{$I-}
reset(plik,1);
{$I+}
if ioresult=0 then begin
   {$I-}
   writeln('Plik z konfiguracja znaleziony, wczytywanie...');
   blockread(plik,naglwczyt,sizeof(naglwczyt));
   if naglwczyt<>naglowek then begin
      writeln('Plik z konfiguracja w starej wersji; uzyte beda ustawienia standardowe');
      exit
   end;

   blockread(plik,kfg,sizeof(kfg));
   blockread(plik,ostpliki,sizeof(ostpliki));
   blockread(plik,nowy_param,sizeof(nowy_param));
   blockread(plik,ekr.jak_menu,sizeof(ekr.jak_menu));
   blockread(plik,celow,sizeof(celow));
   blockread(plik,rysowanie,sizeof(rysowanie));
   blockread(plik,ust_broni,sizeof(ust_broni));
   blockread(plik,grupy,sizeof(grupy));
   blockread(plik,pogoda,sizeof(pogoda));
end
   else
   writeln('Plik z konfiguracja nie znaleziony lub uszkodzony; uzyte beda ustawienia'+#13+#10+'standardowe');
close(plik);
{----}
if iltextur=0 then begin
   nowy_param.textura:=0;
   rysowanie.textura:=0;
   rysowanie.jakrys:=0;
end;
if ilwierzch=0 then nowy_param.wierzch:=0;

lupa_oblicz;
if nowy_param.textura>iltextur then nowy_param.textura:=iltextur;
if nowy_param.wierzch>ilwierzch then nowy_param.wierzch:=ilwierzch;
if rysowanie.textura>iltextur then rysowanie.textura:=iltextur;
sprawdz_czy_jest_plik_tla(ostpliki.tlo);
{$I+} a:=ioresult; {$I-}
end;

{*}PROCEDURE zapisz_kfg;
begin
{$I+} a:=ioresult; {$I-}

assign(plik,'dane\sadist2.cfg');
{$I-}
rewrite(plik,1);
{$I+}
if ioresult=0 then begin
   {$I-}
   blockwrite(plik,naglowek,sizeof(naglowek));
   blockwrite(plik,kfg,sizeof(kfg));
   blockwrite(plik,ostpliki,sizeof(ostpliki));
   blockwrite(plik,nowy_param,sizeof(nowy_param));
   blockwrite(plik,ekr.jak_menu,sizeof(ekr.jak_menu));
   blockwrite(plik,celow,sizeof(celow));
   blockwrite(plik,rysowanie,sizeof(rysowanie));
   blockwrite(plik,ust_broni,sizeof(ust_broni));
   blockwrite(plik,grupy,sizeof(grupy));
   blockwrite(plik,pogoda,sizeof(pogoda));
end;
close(plik);

{$I+} a:=ioresult; {$I-}
end;

{*}PROCEDURE wczytaj_rekordy;
var a:integer;
begin
for a:=1 to 11 do
    with wyniki[a] do begin
       imie:='BRAK';
       pkt:=0;
       trupow:=0;
       dd:=0;
       mm:=0;
       rr:=0;
    end;
{$I-}
assign(plik,'dane\S2REK.CFG');
reset(plik,1);
{$I+}
if ioresult=0 then begin
   {$I-}
   blockread(plik,wyniki,sizeof(wyniki));
   close(plik);
end;
{$I+}
a:=ioresult;
end;

{*}PROCEDURE zapisz_rekordy;
var a:integer;
begin
{$I-}
assign(plik,'dane\S2REK.CFG');
rewrite(plik,1);
{$I+}
if ioresult=0 then begin
   {$I-}
   blockwrite(plik,wyniki,sizeof(wyniki));
   close(plik);
end;
{$I+}
a:=ioresult;
end;

{*}PROCEDURE ustaw_rekordy(jak:byte); {0:wg punktow, 1:wg trupow}
var
a:integer;
d,m,r,dt:word;
juz:boolean;
l:longint;
im:string[10];
buf:array [0..99] of byte;
begin
getdate(r,m,d,dt);
with wyniki[11] do begin
   imie:=kfg.imie;
   pkt:=punkty;
   trupow:=il_trupow;
   dd:=d;
   mm:=m;
   rr:=r;
end;
miejscegracza:=11;
repeat
   juz:=true;
   for a:=1 to 10 do
       if ((jak=0) and (wyniki[a].pkt<wyniki[a+1].pkt)) or
          ((jak=1) and (wyniki[a].trupow<wyniki[a+1].trupow)) then begin
          if a+1=miejscegracza then miejscegracza:=a;
          move(wyniki[a],buf,sizeof(wyniki) div 11);
          move(wyniki[a+1],wyniki[a],sizeof(wyniki) div 11);
          move(buf,wyniki[a+1],sizeof(wyniki) div 11);
          juz:=false;
          a:=10;
       end else
       if ((jak=0) and (wyniki[a].pkt=wyniki[a+1].pkt) and (wyniki[a].trupow<wyniki[a+1].trupow)) or
          ((jak=1) and (wyniki[a].trupow=wyniki[a+1].trupow) and (wyniki[a].pkt<wyniki[a+1].pkt)) then begin
          if a+1=miejscegracza then miejscegracza:=a;
          move(wyniki[a],buf,sizeof(wyniki) div 11);
          move(wyniki[a+1],wyniki[a],sizeof(wyniki) div 11);
          move(buf,wyniki[a+1],sizeof(wyniki) div 11);
          juz:=false;
          a:=10;
       end;
until juz;
end;

{menu}
{*}PROCEDURE wczytaj_mini_tlo(nazwa:string);
var
buf:array[0..63] of byte;
a,b:longint;
begin
mem2xms(scr^,_xms[1].h,offsety[11],64000);
{$I-}
fillchar2(scr^,64000,1);
mem2xms(scr^,_xms[1].h,offsety[16],5000);

Assign (plik,'tla\'+nazwa);
filemode:=0;
Reset (plik, 1);
for a:=0 to 29 do begin
    BlockRead (plik,scr^,6400);
    for b:=0 to 63 do buf[b]:=scr^[(b*10) div 320,(b*10) mod 320];
    mem2xms(buf,_xms[1].h,offsety[16]+a*64,64)
end;
seek(plik,64000*3+12288);
blockread(plik,pal[208],144);
close(plik);
{$I+}
xms2mem(_xms[1].h,offsety[11],scr^,64000);
cala_paleta(false);
end;

{*}PROCEDURE pokaz_mini_tlo;
var
a:longint;
begin
for a:=0 to 29 do
    xms2mem(_xms[1].h,offsety[16]+a*64,scr^[160+a,250],64);
end;

{*}PROCEDURE suwak(x,y,szer,wys,min,max,kolmin,kolmax:integer;var wartosc:word);
var
 a,b:longint;
 dl_paska1,dl_paska2:real;
begin
  ebar(x-1,y-1, x+szer+1,y+wys+1, 5);
  dl_paska1:=(longint(wartosc)*100)/max;
  dl_paska2:=(dl_paska1*longint(szer))/100;
  for a:=0 to trunc(dl_paska2) do
      for b:=0 to wys do
          putpix(x+a,y+b,kolmin+trunc(((a*(kolmax-kolmin+1))/(dl_paska2+1))));
  if (guzik[1]) and (mysz_w(x,y,x+szer,y+wys)) then begin
     wartosc:=trunc((mmx-x+1)/(szer/max));
     if wartosc<min then wartosc:=min;
     if wartosc>max then wartosc:=max;
  end;
end;

{*}PROCEDURE menu_start;
var
py,pdy:integer;
juz:boolean;
begin
mem2xms(scr^,_xms[1].h,offsety[11]+64000,64000);

xms2mem(_xms[1].h,offsety[31]+64000,scr2^,64000);

{spadanie menu z gory}
py:=0;
pdy:=0;
repeat
  juz:=false;

  if pdy<10 then inc(pdy);
  py:=py+pdy;
  if py>=199 then begin
     if abs(pdy)>=4 then StartSound(Sound[20],false,1,1);
     pdy:=-trunc(pdy/1.1);
     py:=199;
  end;
  if (py=199) and (pdy=0) then juz:=true;
  move3(scr2^[199-py],mem[$A000:0],py*320);
  move3(scr^[py],mem[$A000:py*320],64000-(py*320));

  sprawdz_mysz;
  if (keypressed) or (klik[1]) or (klik[2]) then juz:=true;
  synchro;
until juz;
{E spadanie menu z gory}


move2(scr2^,scr^);
move2(scr^,mem[$A000:0]);
while keypressed do readkey;

end;

{*}PROCEDURE menu_koniec(_wroc:boolean);
var
py,pdy:integer;
juz:boolean;
begin
move2(scr^,scr2^);
if not _wroc then begin
   fillchar2(scr^,64000,0);
   if _wyjscie then begin
      piszc(160,100,'NIECH KREW BeDZIE Z TOBa',7);
      StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*random(5)+12],false,15,15);
      end;
   end
             else xms2mem(_xms[1].h,offsety[11]+64000,scr^,64000);
py:=199;
pdy:=0;
repeat
  juz:=false;

  if pdy>-10 then dec(pdy);
  py:=py+pdy;
  if (py<=0) then begin juz:=true;py:=0;end;
  move3(scr2^[199-py],mem[$A000:0],py*320);
  move3(scr^[py],mem[$A000:py*320],64000-(py*320));

  sprawdz_mysz;
  if (keypressed) or (klik[1]) or (klik[2]) then juz:=true;
  synchro;
until juz;
if _wyjscie then fadeout(1,0,255);
end;

{*}PROCEDURE menu_pokaz_liste_autorow;
begin
     pisz(5,5,'SADIST II: OSTATNI KRZYK - AUTORZY (1/2)',96);

     pisz(7, 20,'POMYSl                  GRZEGORZ "GAD" DROZD',0);
     pisz(7, 30,'PROGRAM                 GRZEGORZ "GAD" DROZD',0);
     pisz(7, 40,'ASMOWE PROCKI           TOMASZ "XAN" SANECKI',0);
     pisz(7, 50,'GRAFIKA:',0);
     pisz(14, 60,'CZCIONKI, SPRAJTY, LOGO S2 ITD.         GAD',0);
     pisz(14, 70,'RYS.TYTUlOWY                 JAKUB MACIEJEK',0);
     pisz(14, 80,'ANIMACJA JASZCZURKI                     NEO',0);
     pisz(7, 90,'DxWIeKI          KRADZIONE Z RozNYCH GIER :)',0);
     pisz(7,100,'GlOS ZlEGO PANA         GRZEGORZ "GAD" DROZD',0);
     pisz(7,110,'GlOSY POSTACI - LUDZI   TOMASZ "XAN" SANECKI',0);
     pisz(7,120,'EDYTOR POSTACI          TOMASZ "XAN" SANECKI',0);

     pisz(83 ,140,'STUDIO KOMPUTEROWE GAD',0);
     pisz(97 ,150,'HTTP://GAD.ART.PL/',0);
     pisz(87 ,160,'HTTP://SADIST.ART.PL/',0);
     pisz(111,170,'GAD@GAD.ART.PL',0);
end;

{*}PROCEDURE menu;
const
goradol:array[0..1] of string[8]=('NA GoRZE','NA DOLE');
tmenu:array[0..2] of string[12]=('WYlaCZONY','AUTO-CHOWANY','WlaCZONY');
ilkrwi=30;
var
juz,swpis,
byltrybgry:boolean;
a1,a2,a,b:integer;
_wroc:boolean;
ktore,k,k1,wybr:byte;
skfg:Tkfg;
wr:word;
smaxpost,smaxsyf,smaxpoc,smaxmin,smaxmies,smaxwyb,smaxdym,smaxopad,smaxkow,smaxbom,smaxzwi,smaxpacz:word;

kll:char;
komunikat:array[0..1] of string[50];
buf2:array[0..640] of byte;

krop:array[1..ilkrwi] of record
     jest:boolean;
     x:integer;
     y,dy:single;
     ani,kani:byte;
     end;
kropobr:array[0..6,0..69] of byte;

lista:array[1..400] of string[8];
ilplik,pozxlisty:word;
wpisnazw:record
   wpisuje:boolean;
   kur:integer;
   nazwa:string[10];
   end;
kopiapostaci:array[0..4] of string[8];
wolnejpamieci:longint;
tip:string[70];

 {+}PROCEDURE guztext(x,y:integer;txt:string;kon,koff:byte;wyb:byte;wlacz:boolean);
 var k:byte;
 begin
 if (mysz_w(x,y,x+length(txt)*7-1,y+6)) and (wlacz) then begin
    k:=kon;
    wybr:=wyb;
    end else if wlacz then k:=koff else k:=120;
 pisz(x,y,txt,k);
 if not wlacz then fillchar(scr^[y+3,x],length(txt)*7,15);
 end;

 {+}PROCEDURE guzobr(x,y,sz:integer;nr:longint;wyb:byte;wlacz:boolean);
 var k:word;
 begin
 if (mysz_w(x,y,x+sz-1,y+7)) and (wlacz) then begin k:=480;wybr:=wyb end
                         else k:=0;
 maskpicxms(x,y,60,8,0, offsety[32]+nr*960+k, scr^,1,false)
 end;

 {+}PROCEDURE guztextw(x,y:integer;txt:string;var wl:boolean;
                       koffwyl,konwyl,kon,koff:byte;wyb:byte;wlacz:boolean);
 var k:byte;
 begin
 if (mysz_w(x,y,x+length(txt)*7+19,y+6)) and (wlacz) then begin
    if wl then k:=kon else k:=konwyl;
    wybr:=wyb;
    if klik[1] then wl:=not wl;
 end else
     if (wl) and (wlacz) then k:=koff else k:=koffwyl;
 pisz(x,y,txt,k);
 maskpicxms(x+length(txt)*7+5,
            y,15,7,0,offsety[19]+25*225+ord(wl)*120,scr^,1,true);
 if not wlacz then fillchar(scr^[y+3,x],length(txt)*7+19,15);
 end;

 {+}PROCEDURE zroblisteplikow(katalog,roz:string);
 var
 DirInfo:SearchRec;
 a:integer;
 wyr:string;
 juz:boolean;
 begin
 ilplik:=0;
 for a:=1 to 300 do lista[a]:='';
 FindFirst(katalog+'\*.'+roz,Anyfile,DirInfo);
 while (DosError=0) and (ilplik<300) do begin
    inc(ilplik);
    wyr:=DirInfo.Name;
    if pos(roz,wyr)>0 then delete(wyr,pos(roz,wyr)-1,1+length(roz));
    lista[ilplik]:=wyr;
    FindNext(DirInfo);
 end;

 if ilplik>=2 then
  repeat
    juz:=true;
    for a:=1 to ilplik-1 do begin
        if lista[a]>lista[a+1] then begin
           wyr:=lista[a];
           lista[a]:=lista[a+1];
           lista[a+1]:=wyr;
           juz:=false;
        end;
    end;
  until juz;

 end;

 {+}PROCEDURE wpisywanie_nazwy_pliku(illit,xx,yy:byte;imie:boolean);
 var a,b:byte;
 begin
 for a:=0 to 6 do
     for b:=0 to 6 do
         putpixn(xx+wpisnazw.kur*7+b,yy+a);
 if keypressed then begin
    kll:=readkey;
    {wpisywanie znaku}
    if ((kll in [#65..#90,#48..#57,#95,#33]) or ((kll=#32) and (imie))) and ((not kl[54]) and (not kl[42]))
       and (length(wpisnazw.nazwa)<illit) then begin
       insert(kll,wpisnazw.nazwa,wpisnazw.kur);
       inc(wpisnazw.kur);
    end else
    {wpisywanie znaku - maue litery na dooshe}
    if ((not imie) or ((not kl[54]) and (not kl[42]))) and (kll in [#97..#122]) and (length(wpisnazw.nazwa)<illit) then begin
       insert(upcase(kll),wpisnazw.nazwa,wpisnazw.kur);
       inc(wpisnazw.kur);
    end else
    if (imie) and ((kl[54]) or (kl[42])) and
       (kll in [#65,#67, #69, #76, #78, #79, #83, #88, #90,
                #97,#99,#101,#108,#110,#111,#115,#120,#122]) and
       (length(wpisnazw.nazwa)<illit) then begin
       insert(chr(ord(upcase(kll))+32),wpisnazw.nazwa,wpisnazw.kur);
       inc(wpisnazw.kur);
    end else
    {bekspejs}
    if (kll=#8) and (wpisnazw.kur>1) then begin dec(wpisnazw.kur);delete(wpisnazw.nazwa,wpisnazw.kur,1);end
    else {enter}
    if (kll=#13) then wpisnazw.wpisuje:=false
    else
    if kll=#0 then begin
       kll:=readkey;
       {dilejt}
       if (kll=#83) and (length(wpisnazw.nazwa)>=wpisnazw.kur) then begin delete(wpisnazw.nazwa,wpisnazw.kur,1);end
       else
       {szczauka f lefo}
       if (kll=#75) and (wpisnazw.kur>1) then dec(wpisnazw.kur)
       else
       {szczauka f prafo}
       if (kll=#77) and (wpisnazw.kur<length(wpisnazw.nazwa)+1) then inc(wpisnazw.kur);
    end;
 end;
 end;

 {+}FUNCTION jest_plik(nazwa:string):boolean;
 var plik:file;a:word;
 begin
 jest_plik:=false;
 {$I+}
 a:=ioresult;
 {$I-}
 assign(plik,nazwa);
 reset(plik,1);
 if ioresult=0 then jest_plik:=true;
 close(plik);
 end;

 {+}PROCEDURE komunikat_bledu(blad:byte; k1,k2:string);
 begin
 case blad of
  0:komunikat[0]:=k1;
  2:komunikat[0]:='BRAK PLIKU';
  3:komunikat[0]:='BRAK PODKATALOGU';
  5:komunikat[0]:='PLIK ZABEZPIECZONY PRZED ZAPISEM';
  100:komunikat[0]:='BlaD PODCZAS ODCZYTU PLIKU';
  101:komunikat[0]:='BlaD PODCZAS ZAPISU PLIKU';
  150:komunikat[0]:='DYSK ZABEZPIECZONY PRZED ZAPISEM';
  152:komunikat[0]:='NAPeD NIE JEST GOTOWY';
  245:komunikat[0]:='STARA WERSJA PLIKU, WYMAGA KONWERSJI NA NOWa!'; {to nie RE tylko moj wlasny numerek :)}
  else komunikat[0]:='BlaD NR '+l2t(blad,3);
 end;
 komunikat[1]:=k2;
 end;

 {+}PROCEDURE pokaz_ekran(k1,k2:string);
 begin
 xms2mem(_xms[1].h,offsety[31],scr^,64000);
 pisz(160-trunc(length(k1)*3.5),90,k1,0);
 pisz(160-trunc(length(k2)*3.5),100,k2,0);
 move2(scr^,mem[$A000:0]);
 end;

 {+}FUNCTION ilesuma:longint;
 begin
  with pam do begin
   ilesuma:=spost*maxpost+
            szwi*maxzwi+
            smies*maxmies+
            skow*maxkow+
            spacz*maxpacz+
            ssyf*maxsyf+
            sopad*maxopad+
            spoc*maxpoc+
            smin*maxmin+
            swyb*maxwyb+
            sdym*maxdym+
            sbom*maxbom;
  end;
 end;

 {+}PROCEDURE pokaz_ustawienia1;
 var
 wr:word;
 begin
     guztextw(15,20,'OBRAZEK TlA',kfg.tlo,120,184,7,0,1,true);

     if (mysz_w(140,20,274,26)) and (not kfg.tlo) then begin k:=7;wybr:=12;end else
        if kfg.tlo then k:=120 else k:=0;
     pisz(140,20,'KOLOR TlA: '+l2t(kfg.tlokolor,3),k);
     if kfg.tlo then bar(245,20,273,25,127)
                else bar(245,20,273,25,kfg.tlokolor);
     drawline(246,26,274,26,1,false); drawline(274,21,274,26,1,false);

     guztextw(15,30,'RANY OD UPADKoW',kfg.ranyodupadkow,120,184,7,0,15,true);
     guztextw(15,40,'SPADEK SIlY PO WIeKSZYCH RANACH',kfg.traceniesily,120,184,7,0,16,true);
     guztextw(15,50,'CENTROWANIE NA POSTAc STEROWANa',kfg.pokazuj_sterowanego,120,184,7,0,17,true);
     guztextw(15,60,'ZWIERZaTKA',kfg.zwierz,120,184,7,0,18,true);
     guztextw(15,70,'ZWIERZaTKA POJAWIAJa SIe SAME',kfg.zwierzsamewychodza,120,184,7,0,14,kfg.zwierz);
     guztextw(15,80,'WIELOPLANOWE OPADY',kfg.wieloplanowyopady,120,184,7,0,19,kfg.opady);
     guztextw(15,90,'PACZKI',kfg.paczki,120,184,7,0,20,true);
     guztext(15,100,'CZeSTOTLIWOsc SPADANIA PACZEK: '+l2t(kfg.czestotpacz,2),7,0,22,kfg.paczki);
     wr:=kfg.czestotpacz; suwak(255,100,59,5,1,30,186,199,wr);
     if kfg.paczki then kfg.czestotpacz:=wr;
     guztextw(15,110,'PACZKI Sa TEz POD ZIEMIa',kfg.paczkiwziemi,120,184,7,0,23,kfg.paczki);
     guztextw(15,120,'POSTACI MOGa OTWIERAc PACZKI',kfg.postotwierajapaczki,120,184,7,0,21,kfg.paczki);
     guztextw(15,130,'AUREOLKI NIEsMIERTELNYCH',kfg.aureolki,120,184,7,0,24,true);
     guztextw(15,140,'WERSJA DLA MlODSZYCH',kfg.dzieci,120,184,7,0,10,true);

     guzobr(100,180,60,6,90,true);
     guzobr(195,180,50,2,98,true);
     guzobr(255,180,50,1,97,true);
     guzobr(15,180,50,0,99,true);
 end;

 {+}PROCEDURE pokaz_ustawienia;
 var
 ww,wr:word;
 begin
     pisz(5,5,'USTAWIENIA PROGRAMU (2/3)',96);
     guztextw(15,20,'DYMY/WYBUCHY',kfg.dym_wyb,120,184,7,0,2,true);
     guztextw(15,30,'OPADY',kfg.opady,120,184,7,0,3,true);
     guztextw(15,40,'PARTIKLE (KAMIENIE, KREW ITD)',kfg.syfki,120,184,7,0,4,true);
     guztextw(15,50,'BaBELKI POD WODa',kfg.bomble,120,184,7,0,18,true);
     guztextw(15,60,'lUSKI',kfg.luski,120,184,7,0,8,kfg.syfki);
     guztextw(15,70,'MIeSO, CEGlY ITP',kfg.miecho,120,184,7,0,5,true);
     guztext(15,80,'PASEK MENU: '+tmenu[ekr.jak_menu],7,0,9,true);
     guztextw(15,90,'WSTRZaSY EKRANU',kfg.wstrzasy_ekranu,120,184,7,0,10,true);
     guztextw(15,100,'ODGlOSY DESZCZU',kfg.odglosy_deszczu,120,184,7,0,13,true);
     guztextw(15,110,'BlYSKI EKRANU OD PIORUNA',kfg.fejdyekranu,120,184,7,0,14,true);
     guztext(15,120,'SZYBKOsc DZIAlANIA HORRORU: '+l2t(kfg.szybhorror,2),7,0,12,true);
     wr:=kfg.szybhorror; suwak(235,120,79,5,1,20,186,199,wr);
     kfg.szybhorror:=wr;
     guztextw(15,130,'GlOS ZlEGO PANA',kfg.glospana,120,184,7,0,19,true);
     guztextw(15,140,'FONTANNY KRWI',kfg.smierczglutami,120,184,7,0,21,kfg.syfki);
     guztext(15,150,'ILOsc KRWI: '+l2t(trunc(kfg.il_krwi*100),3)+'%',7,0,20,kfg.syfki);
     wr:=trunc(kfg.il_krwi*100); ww:=wr;
     suwak(137,150,177,5,10,500,186,199,wr);
     if (ww<>wr) and (kfg.syfki) then kfg.il_krwi:=wr/100;

     guzobr(100,180,60,6,90,true);
     guzobr(195,180,50,2,98,true);
     guzobr(255,180,50,1,97,true);
     guzobr(15,180,50,0,99,true);
 end;

 {+}PROCEDURE pokaz_detale;
 const
 palpas:array[0..17] of byte=
    (15,97,98,47,100,101,195,102,39,38,37,36,153,130,206,22,78,79);
 var
 wr:word;
 pamk:longint;
 dl_paska1,dl_paska2:real;
 a,b:longint;
 begin
     guztext(10, 20,'   POSTACI: '+l2t(maxpost,4){+' (100)'},7,0,1,true);
     guztext(10, 30,' PARTIKLoW: '+l2t(maxsyf,4) {+' (500)'},7,0,2,true);
     guztext(10, 40,'  POCISKoW: '+l2t(maxpoc,4) {+' (100)'},7,0,3,true);
     guztext(10, 50,'       MIN: '+l2t(maxmin,4) {+' (100)'},7,0,4,true);
     guztext(10, 60,'    MIeSKA: '+l2t(maxmies,4){+' (50)'},7,0,5,true);
     guztext(10, 70,'  WYBUCHoW: '+l2t(maxwyb,4) {+' (10)'},7,0,6,true);
     guztext(10, 80,'     DYMoW: '+l2t(maxdym,4) {+' (100)'},7,0,7,true);
     guztext(10, 90,'    OPADoW: '+l2t(maxopad,4){+' (1000)'},7,0,8,true);
     guztext(10,100,'   KOWADEl: '+l2t(maxkow,4) {+' (10)'},7,0,9,true);
     guztext(10,110,'  BaBELKoW: '+l2t(maxbom,4) {+' (100)'},7,0,10,true);
     guztext(10,120,'ZWIERZaTEK: '+l2t(maxzwi,4) {+' (30)'},7,0,11,true);
     guztext(10,130,'    PACZEK: '+l2t(maxpacz,4){+' (10)'},7,0,12,true);

     wr:=maxpost;
     suwak(128, 20,185,5,10,Tmaxpost,186,199,maxpost);
     if wolnejpamieci-ilesuma<=0 then maxpost:=wr;

     wr:=maxsyf;
     suwak(128, 30,185,5,10,Tmaxsyf,186,199,maxsyf);
     if wolnejpamieci-ilesuma<=0 then maxsyf:=wr;

     wr:=maxpoc;
     suwak(128, 40,185,5,10,Tmaxpoc,186,199,maxpoc);
     if wolnejpamieci-ilesuma<=0 then maxpoc:=wr;

     wr:=maxmin;
     suwak(128, 50,185,5,10,Tmaxmin,186,199,maxmin);
     if wolnejpamieci-ilesuma<=0 then maxmin:=wr;

     wr:=maxmies;
     suwak(128, 60,185,5,10,Tmaxmies,186,199,maxmies);
     if wolnejpamieci-ilesuma<=0 then maxmies:=wr;

     wr:=maxwyb;
     suwak(128, 70,185,5, 4,Tmaxwyb,186,199,maxwyb);
     if wolnejpamieci-ilesuma<=0 then maxwyb:=wr;

     wr:=maxdym;
     suwak(128, 80,185,5, 4,Tmaxdym,186,199,maxdym);
     if wolnejpamieci-ilesuma<=0 then maxdym:=wr;

     wr:=maxopad;
     suwak(128, 90,185,5,10,Tmaxopad,186,199,maxopad);
     if wolnejpamieci-ilesuma<=0 then maxopad:=wr;

     wr:=maxkow;
     suwak(128,100,185,5, 4,Tmaxkow,186,199,maxkow);
     if wolnejpamieci-ilesuma<=0 then maxkow:=wr;

     wr:=maxbom;
     suwak(128,110,185,5,10,Tmaxbom,186,199,maxbom);
     if wolnejpamieci-ilesuma<=0 then maxbom:=wr;

     wr:=maxzwi;
     suwak(128,120,185,5,10,Tmaxzwi,186,199,maxzwi);
     if wolnejpamieci-ilesuma<=0 then maxzwi:=wr;

     wr:=maxpacz;
     suwak(128,130,185,5, 4,Tmaxpacz,186,199,maxpacz);
     if wolnejpamieci-ilesuma<=0 then maxpacz:=wr;

     if wolnejpamieci-ilesuma>1000 then b:=16
        else
        if (wolnejpamieci-ilesuma<1000) and (wolnejpamieci-ilesuma>0) then b:=40
           else b:=8;
     piszc(160,149,'DOSTePNEJ WOLNEJ PAMIeCI: '+l2t(wolnejpamieci-ilesuma,6),b);
     pamk:=wolnejpamieci-ilesuma;

     if pamk<0 then ebar(9,157, 311,164, 15)
               else ebar(9,157, 311,164, 5);
     dl_paska1:=(pamk*100)/pamiecikonwencjonalnej;
     dl_paska2:=(dl_paska1*300)/100;
     a:=0;
     while a<trunc(dl_paska2) do begin
       for b:=0 to 5 do
         putpix(10+a,158+b,palpas[trunc((a*18)/300)]);
       inc(a);
       if a<trunc(dl_paska2) then begin
          for b:=0 to 5 do
              putpix(10+a,158+b,palpas[trunc(((a+8)*18)/300)]);
          inc(a);
       end;
     end;
 end;

 {+}PROCEDURE ruch_myszy_po_plikach;
 var _mx,_my,_kurs:longint;
 begin
  if (not wpisnazw.wpisuje) and (ilplik>=1) then begin
     if keypressed then begin
        kll:=readkey;
        if kll=#13 then begin
           ustawpozycjemyszy(320,173);
           sprawdz_mysz;
           klik[1]:=true
        end;
        if kll=#0 then begin
           kll:=readkey;
           _mx:=(mmx-15) div 110;
           _my:=(mmy-20) div 9;
           _kurs:=_my+(pozxlisty+_mx)*14;
           if (kll=#80) then inc(_kurs);
           if (kll=#72) then dec(_kurs);
           if (kll=#77) then inc(_kurs,14);
           if (kll=#75) then dec(_kurs,14);
           if kll in [#80,#72,#77,#75] then begin
              if _kurs<0 then _kurs:=ilplik-1;
              if _kurs>=ilplik then _kurs:=0;
              _mx:=_kurs div 14-pozxlisty;
              _my:=_kurs mod 14;
              while _mx>2 do begin inc(pozxlisty);dec(_mx) end;
              while _mx<0 do begin dec(pozxlisty);inc(_mx) end;
              ustawpozycjemyszy((18+_mx*110)*2,23+_my*9);
              sprawdz_mysz;
              klik[1]:=true;
           end;
        end;
     end;
  end;
 end;

 {+}PROCEDURE wlacz_ustaw_detali;
 begin
    ktore:=10;juz:=false;
    smaxpost:=maxpost;
    smaxsyf:=maxsyf;
    smaxpoc:=maxpoc;
    smaxmin:=maxmin;
    smaxmies:=maxmies;
    smaxwyb:=maxwyb;
    smaxdym:=maxdym;
    smaxopad:=maxopad;
    smaxkow:=maxkow;
    smaxbom:=maxbom;
    smaxzwi:=maxzwi;
    smaxpacz:=maxpacz;
 end;

begin
skfg:=kfg;
_wroc:=false;
ktore:=0;
datassign(plik,'dane\s2.dat','krople.obr',2);
blockread(plik,kropobr,490);
close(plik);

for a:=1 to ilkrwi do krop[a].jest:=false;

menu_start;

new(trawabuf);
wolnejpamieci:=memavail+ilesuma-3000;
byltrybgry:=trybgry;
repeat
  kfg._co_klatke:=kfg.co_klatke;
  sprawdz_mysz;
  if ktore=0 then xms2mem(_xms[1].h,offsety[31]+64000,scr^,64000)
             else xms2mem(_xms[1].h,offsety[31],scr^,64000);

  wybr:=0;
{  pisz(0,0,l2t(mmx,3)+'X'+l2t(mmy,3),0);}
  case ktore of {ktore jest menu?}
   0:begin {glowne}
     wpisnazw.wpisuje:=false;

     a2:=0;
     if mysz_w(125,7,186,31) then begin
        wybr:=1;
        tip:='STWoRZ NOWY TEREN ROZGRYWKI'
     end else
     if mysz_w(50,36,111,53) then begin
        wybr:=3;
        tip:='WCZYTAJ TEREN Z PLIKU'
     end else
     if mysz_w(210,35,272,52) then begin
        if _wolno_wrocic_do_gry then wybr:=2 else a2:=120;
        tip:='ZAPISZ TEREN DO PLIKU'
     end else
     if mysz_w(22,73,82,92) then begin
        wybr:=4;
        tip:='USTAW DOWOLNE ZESTAWY POSTACI DLA GRUP'
     end else
     if mysz_w(239,72,300,89) then begin
        wybr:=5;
        tip:='WCZYTAJ RYSUNEK TlA'
     end else
     if mysz_w(235,106,289,136) then begin
        wybr:=6;
        tip:='OPCJE I KONFIGURACJA PROGRAMU'
     end else
     if mysz_w(17,107,81,132) then begin
        wybr:=9;
        tip:='DZISIEJSZE STATYSTYKI'
     end else
     if mysz_w(51,145,112,165) then begin
        wybr:=10;
        tip:='LISTA 10 NAJWIeKSZYCH SADYSToW'
     end else
     if mysz_w(114,65,200,133) then begin
        if _wolno_wrocic_do_gry then begin wybr:=99;a2:=7 end else a2:=120;
        tip:='KONTYNUUJ MASAKRe!!!'
     end else
     if mysz_w(207,142,249,172) then begin
        wybr:=8;
        tip:='AUTORZY PROGRAMU'
     end else
     if mysz_w(136,162,180,194) then begin
        wybr:=90;
        tip:='DOsc KRWI NA DZISIAJ...'
     end else begin
        wybr:=0;
        tip:='';
     end;

     b:=96;
     a1:=1;
     for a:=1 to length(tip) do
        if (tip[a]=' ') and (a-a1>=10) then begin
           dec(b,4);
           a1:=a;
        end;

     a:=0;
     a1:=1;
     wyr:='';
     while a<length(tip) do begin
        inc(a);
        if ((tip[a]<>' ') or (a-a1<10)) and (a<length(tip)) then wyr:=wyr+tip[a]
           else begin
              if a>=length(tip) then inc(a);
              piszc(160,b,copy(tip,a1,a-a1),a2);
              inc(b,8);
              inc(a);
              a1:=a;
           end;

     end;


     if (klik[1]) and (wybr>0) then begin
        case wybr of
          1:begin
            ktore:=4; {nowy}
            mem2xms(scr2^,_xms[1].h,offsety[11],64000);
            xms2mem(_xms[1].h,offsety[13]+nowy_param.textura*10,wyr[0],10);
            wczytaj_texture_do_rysowania(wyr+'.STX');
            xms2mem(_xms[1].h,offsety[11],scr2^,64000);

            for a:=0 to 39 do begin
                for b:=0 to 279 do buf2[b]:=random(3);
                mem2xms(buf2,_xms[1].h,offsety[16]+5000+longint(a)*280,280);
            end;
            fillchar2(trawabuf^,sizeof(trawabuf^),0);
            xms2mem(_xms[1].h,offsety[14]+nowy_param.wierzch*10,wyr,10);
            wczytaj_wierzch(wyr+'.STW');
            end;
          2:begin {zapis terenu}
            ktore:=6;
            zroblisteplikow('TERENY','S2T');
            pozxlisty:=0;
            if jest_plik('TERENY\'+ostpliki.teren+'.S2T') then wpisnazw.nazwa:=ostpliki.teren
                                                          else wpisnazw.nazwa:=lista[1];
            wpisnazw.wpisuje:=false;
            end;
          3:begin {odczyt terenu}
            ktore:=5;
            zroblisteplikow('TERENY','S2T');
            pozxlisty:=0;
            if jest_plik('TERENY\'+ostpliki.teren+'.S2T') then wpisnazw.nazwa:=ostpliki.teren
                                                          else wpisnazw.nazwa:=lista[1];
            wpisnazw.wpisuje:=false;
            end;
          4:begin {odczyt postaci}
            ktore:=8;
            for a:=0 to 4 do kopiapostaci[a]:=ostpliki.postaci[a];
            pozxlisty:=0;
            for a:=1 to 300 do xms2mem(_xms[1].h,offsety[17]+a*10,lista[a],9);
            for a:=0 to 4 do
                if jest_plik('POSTACI\'+ostpliki.postaci[a]+'.S2P') then wpisnazw.nazwa:=ostpliki.postaci[a]
                                                                    else wpisnazw.nazwa:=lista[1];
            wpisnazw.wpisuje:=false;
            end;
          5:begin {odczyt tla}
            ktore:=7;
            zroblisteplikow('TLA','S2B');
            pozxlisty:=0;
            if jest_plik('TLA\'+ostpliki.tlo+'.S2B') then wpisnazw.nazwa:=ostpliki.tlo
                                                     else wpisnazw.nazwa:=lista[1];
            wpisnazw.wpisuje:=false;
            wczytaj_mini_tlo(wpisnazw.nazwa+'.S2B');
            end;
          6:begin {opcje}
            ktore:=1;
            end;
          7:begin {ustawienia}
            ktore:=2;
            end;
          8:begin {autorzy}
            ktore:=3;
            end;
          9:begin {statystyki}
            ktore:=9;
            end;
          10:begin {rekordy}
             wczytaj_rekordy;
             ustaw_rekordy(kfg.kolejnoscrekordow);
             ktore:=11;
             wpisnazw.nazwa:=kfg.imie;
             wpisnazw.wpisuje:=false;
             swpis:=false;
             end;
          90:_wyjscie:=true;
          99:_wroc:=true;
        end;
        klik[1]:=false;wybr:=0;
     end;
     if (kl[1]) and (not klw[1]) then begin _wroc:=true;klw[1]:=true;end;
     end;
   1:begin {ustawienia programu 1/3}
     pisz(5,5,'USTAWIENIA PROGRAMU (1/3)',96);

     pokaz_ustawienia1;

          if (klik[1]) and (wybr>0) then begin
        case wybr of
{          1:kfg.tlo:=not kfg.tlo;
          10:kfg.dzieci:=not kfg.dzieci;}
          12:begin inc(kfg.tlokolor);if kfg.tlokolor>207 then kfg.tlokolor:=1;end;
{          14:kfg.zwierzsamewychodza:=not kfg.zwierzsamewychodza;
          15:kfg.ranyodupadkow:=not kfg.ranyodupadkow;
          16:kfg.traceniesily:=not kfg.traceniesily;
          17:kfg.pokazuj_sterowanego:=not kfg.pokazuj_sterowanego;}
          18:begin {kfg.zwierz:=not kfg.zwierz;}if kfg.zwierz then for a:=1 to maxzwi do zwi^[a].jest:=false;end;
{          19:kfg.wieloplanowyopady:=not kfg.wieloplanowyopady;
          20:kfg.paczki:=not kfg.paczki;
          21:kfg.postotwierajapaczki:=not kfg.postotwierajapaczki;}
          22:begin inc(kfg.czestotpacz);if kfg.czestotpacz>30 then kfg.czestotpacz:=1;end;
{          23:kfg.paczkiwziemi:=not kfg.paczkiwziemi;
          24:kfg.aureolki:=not kfg.aureolki;}
          90:wlacz_ustaw_detali;
          98:ktore:=102;
          97:ktore:=2;
          99:ktore:=0;
        end;
        klik[1]:=false;wybr:=0;
     end;
     if (klik[2]) and (wybr>0) then
        case wybr of
          12:begin dec(kfg.tlokolor);if kfg.tlokolor<1 then kfg.tlokolor:=207;end;
          22:begin dec(kfg.czestotpacz);if kfg.czestotpacz<1 then kfg.czestotpacz:=30;end;
        end;
     if (kl[1]) and (not klw[1]) then begin ktore:=0;klw[1]:=true;end;
     end;
   2:begin {ustawienia programu 2/3}
     pokaz_ustawienia;

     if (klik[1]) and (wybr>0) then begin
        case wybr of
{          2:kfg.dym_wyb:=not kfg.dym_wyb;
          3:kfg.opady:=not kfg.opady;
          4:kfg.syfki:=not kfg.syfki;
          5:kfg.miecho:=not kfg.miecho;
          8:kfg.luski:=not kfg.luski;}
          9:begin inc(ekr.jak_menu);if ekr.jak_menu>2 then ekr.jak_menu:=0 end;
{          10:kfg.wstrzasy_ekranu:=not kfg.wstrzasy_ekranu;}
          12:begin inc(kfg.szybhorror);if kfg.szybhorror>20 then kfg.szybhorror:=1 end;
{          13:kfg.odglosy_deszczu:=not kfg.odglosy_deszczu;
          14:kfg.fejdyekranu:=not kfg.fejdyekranu;
          18:kfg.bomble:=not kfg.bomble;
          19:kfg.glospana:=not kfg.glospana;}
          20:begin kfg.il_krwi:=kfg.il_krwi+0.1;if kfg.il_krwi>5 then kfg.il_krwi:=0.1 end;
{          21:kfg.smierczglutami:=not kfg.smierczglutami;}
          90:wlacz_ustaw_detali;
          98:ktore:=1;
          97:ktore:=102;
          99:ktore:=0;
        end;
        klik[1]:=false;wybr:=0;
     end;
     if (klik[2]) and (wybr>0) then
        case wybr of
          9:begin dec(ekr.jak_menu);if ekr.jak_menu<0 then ekr.jak_menu:=2;end;
          12:begin dec(kfg.szybhorror);if kfg.szybhorror<1 then kfg.szybhorror:=20 end;
          20:begin kfg.il_krwi:=kfg.il_krwi-0.1;if kfg.il_krwi<0.1 then kfg.il_krwi:=5 end;
        end;
     if (kl[1]) and (not klw[1]) then begin ktore:=0;klw[1]:=true;end;
     end;
 102:begin {ustawienia programu 3/3}
     pisz(5,5,'USTAWIENIA PROGRAMU (3/3)',96);
     guztextw(15,20,'PODPISY, KOMENTARZE',kfg.komentarze,120,184,7,0,6,true);
     guztext(15,30,'MIEJSCE PODPISoW: '+goradol[kfg.gdziepodpisy],7,0,1,kfg.komentarze);
     guztextw(15,40,'LICZNIKI TRUPoW',kfg.liczniki,120,184,7,0,17,true);
     guztext(15,50,'MIEJSCE LICZNIKoW: '+goradol[kfg.gdzielicznik],7,0,2,kfg.liczniki);
     guztextw(15,60,'TULTIPSY',kfg.tultips,120,184,7,0,3,true);
     guztextw(15,70,'WSKAxNIKI POCISKoW ZA EKRANEM',kfg.wskazniki_poc,120,184,7,0,7,true);
     guztextw(15,80,'WSKAxNIKI POSTACI ZA EKRANEM',kfg.wskazniki_post,120,184,7,0,7,true);
     guztext(15,90,'FREJMSKIP: '+l2t(kfg.co_klatke,2),7,0,8,true);
     wr:=kfg.co_klatke; suwak(116,90,198,5,1,20,186,199,wr); kfg.co_klatke:=wr;
     guztextw(15,100,'KAPANIE KRWI W MENU',kfg.krew_w_menu,120,184,7,0,15,true);
     guztextw(15,110,'DxWIeKI',kfg.dzwiek,120,184,7,0,16,true);
     guztext(15,120,'CZUlOsc MYSZKI: '+l2t(kfg.czuloscmysz,2),7,0,18,true);
     wr:=kfg.czuloscmysz; suwak(151,120,163,5,1,50,186,199,wr);
     kfg.czuloscmysz:=wr;
     if (guzik[1]) and (mysz_w(151,120,314,125)) then ustawczuloscmyszy(51-kfg.czuloscmysz,51-kfg.czuloscmysz);
     guztextw(15,130,'ZAKlADKI W MENU',kfg.zakladki,120,184,7,0,19,true);
     guztextw(15,140,'PAMIeTANIE OPCJI KAzDEGO MENU',kfg.zapamietujmenu,120,184,7,0,20,true);
     guztext(15,150,'SZYBKOsc PRZES. EKRANU MYSZa: '+l2t(kfg.szybprzesekrmysz,2),7,0,21,true);
     wr:=kfg.szybprzesekrmysz; suwak(249,150,65,5,0,20,186,199,wr);
     kfg.szybprzesekrmysz:=wr;
     guztext(15,160,'SZYBKOsc PRZES. EKRANU KLAW.: '+l2t(kfg.szybprzesekrklaw,2),7,0,22,true);
     wr:=kfg.szybprzesekrklaw; suwak(249,160,65,5,0,20,186,199,wr);
     kfg.szybprzesekrklaw:=wr;
     guzobr(100,180,60,6,90,true);
     guzobr(195,180,50,2,98,true);
     guzobr(255,180,50,1,97,true);
     guzobr(15,180,50,0,99,true);

     if (klik[1]) and (wybr>0) then begin
        case wybr of
          1:begin inc(kfg.gdziepodpisy);if kfg.gdziepodpisy>=2 then kfg.gdziepodpisy:=0;end;
          2:begin inc(kfg.gdzielicznik);if kfg.gdzielicznik>=2 then kfg.gdzielicznik:=0;end;
{          3:kfg.tultips:=not kfg.tultips;
          6:kfg.komentarze:=not kfg.komentarze;
          7:kfg.wskazniki_poc:=not kfg.wskazniki_poc;}
          8:begin inc(kfg.co_klatke);if kfg.co_klatke>20 then kfg.co_klatke:=1;end;
{          15:kfg.krew_w_menu:=not kfg.krew_w_menu;
          16:kfg.dzwiek:=not kfg.dzwiek;
          17:kfg.liczniki:=not kfg.liczniki;}
          18:begin
            inc(kfg.czuloscmysz);
            if kfg.czuloscmysz>50 then kfg.czuloscmysz:=1;
            ustawczuloscmyszy(51-kfg.czuloscmysz,51-kfg.czuloscmysz);
            end;
{          19:kfg.zakladki:=not kfg.zakladki;
          20:kfg.zapamietujmenu:=not kfg.zapamietujmenu;}
          21:begin inc(kfg.szybprzesekrmysz);if kfg.szybprzesekrmysz>=21 then kfg.szybprzesekrmysz:=0;end;
          22:begin inc(kfg.szybprzesekrklaw);if kfg.szybprzesekrklaw>=21 then kfg.szybprzesekrklaw:=0;end;
          90:wlacz_ustaw_detali;
          98:ktore:=2;
          97:ktore:=1;
          99:ktore:=0;
        end;
        klik[1]:=false;wybr:=0;
     end;
     if (klik[2]) and (wybr>0) then
        case wybr of
          8:begin dec(kfg.co_klatke);if kfg.co_klatke<1 then kfg.co_klatke:=20;end;
         18:begin
             dec(kfg.czuloscmysz);
             if kfg.czuloscmysz<=0 then kfg.czuloscmysz:=50;
             ustawczuloscmyszy(51-kfg.czuloscmysz,51-kfg.czuloscmysz);
             end;
         21:if kfg.szybprzesekrmysz>0 then dec(kfg.szybprzesekrmysz) else kfg.szybprzesekrmysz:=20;
         22:if kfg.szybprzesekrklaw>0 then dec(kfg.szybprzesekrklaw) else kfg.szybprzesekrklaw:=20;
        end;
     if (kl[1]) and (not klw[1]) then begin ktore:=0;klw[1]:=true;end;
     end;
   3:begin {autorzy}
     if random(50)=0 then b:=random(16);
     menu_pokaz_liste_autorow;
     pisz(66,130,'! TEN PROGRAM TO FREEWARE !',b*8);

     guzobr(195,180,50,2,98,true);
     guzobr(255,180,50,1,97,true);
     guzobr(15,180,50,0,99,true);
     if (klik[1]) and (wybr=99) then ktore:=0;
     if (klik[1]) and (wybr in [97,98]) then ktore:=103;
     if (kl[1]) and (not klw[1]) then begin ktore:=0;klw[1]:=true;end;
     end;
   103:begin {autorzy c.d.}
     if random(50)=0 then b:=random(16);
     pisz(5,5,'SADIST II: OSTATNI KRZYK - AUTORZY (2/2)',96);

     pisz(7,20,'W PROGRAMIE WYKORZYSTANO:',0);
     pisz(7,30,'COSIN                                 BINBOY',0);
     pisz(189,38,'BINBOY@FREE.COM.PL',0);
     pisz(7,48,'SMIX                           ETHAN BRODSKY',0);
     pisz(189,56,'EBRODSKY@POBOX.COM',0);
     pisz(7,66,'LZSS                            ANDREW EIGUS',0);
     pisz(126,74,'AEIGUS@FGATE.CASTLE.RIGA.LV',0);

     pisz(34,160,'WOLNEJ PAMIeCI:'+l2t(memavail,6)+'B, XMS:'+l2t(XMSGetFreeMem,6)+'KB',0);

     guzobr(195,180,50,2,98,true);
     guzobr(255,180,50,1,97,true);
     guzobr(15,180,50,0,99,true);
     if (klik[1]) and (wybr=99) then ktore:=0;
     if (klik[1]) and (wybr in [97,98]) then ktore:=3;
     if (kl[1]) and (not klw[1]) then begin ktore:=0;klw[1]:=true;end;
     end;
   4:begin {nowy teren}
     pisz(5,5,'NOWY TEREN',96);
     xms2mem(_xms[1].h,offsety[13]+nowy_param.textura*10,wyr,10);
     if nowy_param.textura>0 then guztext(15,20,'TEKSTURA: '+l2t(nowy_param.textura,3)+' '+wyr,7,0,2,true)
                             else guztext(15,20,'TEKSTURA: BRAK',7,0,2,true);
     if nowy_param.textura=0 then guztext(180,20,'KOLOR: '+l2t(nowy_param.rodzteren,3),7,0,1,true)
                             else pisz(180,20,'KOLOR: '+l2t(nowy_param.rodzteren,3),120);
     if nowy_param.textura=0 then bar(257,20,285,25,kolter[nowy_param.rodzteren])
                             else bar(257,20,285,25,127);
     drawline(258,26,286,26,1,false); drawline(286,21,286,26,1,false);
     xms2mem(_xms[1].h,offsety[14]+nowy_param.wierzch*10,wyr,10);
     if nowy_param.wierzch>0 then guztext(15,30,'WIERZCH: '+l2t(nowy_param.wierzch,3)+' '+wyr,7,0,3,true)
                             else guztext(15,30,'WIERZCH: BRAK',7,0,3,true);

     guztext(15,40,'GoRNA GRANICA WYSOKOsCI: '+l2t(100-nowy_param.grgora div 4,4)+'%',7,0,4,true);
     guztext(15,50,'DOLNA GRANICA WYSOKOsCI: '+l2t(100-nowy_param.grdol div 4,4)+'%',7,0,5,true);

     if _wolno_wrocic_do_gry then begin
        if nowy_param.czyscstare then guztext(15,60,'CZYsc POPRZEDNI TEREN',7,0,6,true)
                                 else guztext(15,60,'ZOSTAW POPRZEDNI TEREN',7,0,6,true);
        end
           else nowy_param.czyscstare:=true;

     if trybgry then guztext(15,75,'TRYB: GRA NA CZAS',7,0,7,true)
                else guztext(15,75,'TRYB: MORDOWANIE DLA ZABAWY',7,0,7,true);

     for a:=0 to 39 do begin {pokazywanie przykladu terenu}
         b:=0;
         xms2mem(_xms[1].h,offsety[16]+5000+longint(a)*280,buf2,280);
         while b<280 do begin
            if nowy_param.textura>0 then begin
               xms2mem(_xms[1].h,offsety[12]+(a mod texturar.ry)*320,buf2[b],texturar.rx);
               inc(b,texturar.rx);
            end else begin
               inc(buf2[b],kolter[nowy_param.rodzteren]);
               inc(b);
            end;
         end;
         move3(buf2,scr^[140+a,20],280);
     end;

     if nowy_param.wierzch>0 then begin {...i wierzchu}
        for a:=0 to 39 do begin
            b:=0;
            xms2mem(_xms[1].h,offsety[28]+a*320,trawabuf^,320);
            while b<280 do begin
               if trawabuf^[b mod wierzchr.rx]>0 then
                  scr^[140+a,20+b]:=trawabuf^[b mod wierzchr.rx];
               inc(b)
            end;
            if a=wierzchr.ry-1 then a:=39;
        end;
     end;

     guzobr(15,90,60,4,98,true);
     guzobr(15,100,50,0,99,true);
     if (klik[1]) and (wybr>0) then begin
        case wybr of
          1:begin inc(nowy_param.rodzteren);if nowy_param.rodzteren>72 then nowy_param.rodzteren:=1;end;
          2:begin
            inc(nowy_param.textura);if nowy_param.textura>iltextur then nowy_param.textura:=0;
            mem2xms(scr2^,_xms[1].h,offsety[11],64000);
            xms2mem(_xms[1].h,offsety[13]+nowy_param.textura*10,wyr[0],10);
            wczytaj_texture_do_rysowania(wyr+'.STX');
            xms2mem(_xms[1].h,offsety[11],scr2^,64000);
            end;
          3:begin
            inc(nowy_param.wierzch);if nowy_param.wierzch>ilwierzch then nowy_param.wierzch:=0;
            fillchar2(trawabuf^,sizeof(trawabuf^),0);
            xms2mem(_xms[1].h,offsety[14]+nowy_param.wierzch*10,wyr,10);
            wczytaj_wierzch(wyr+'.STW');
            end;
          4:begin
            dec(nowy_param.grgora,4);
            if nowy_param.grgora<30 then begin
               nowy_param.grgora:=395;
               if nowy_param.grgora>nowy_param.grdol then nowy_param.grgora:=nowy_param.grdol;
            end;
            end;
          5:begin
            dec(nowy_param.grdol,4);
            if (nowy_param.grdol<30) or (nowy_param.grdol<nowy_param.grgora) then nowy_param.grdol:=500;
            end;
          6:nowy_param.czyscstare:=not nowy_param.czyscstare;
          7:trybgry:=not trybgry;
          98:begin _nowy:=true;_wolno_wrocic_do_gry:=true;byltrybgry:=trybgry;end;
          99:ktore:=0;
        end;
        klik[1]:=false;wybr:=0;
     end;
     if (klik[2]) and (wybr>0) then
        case wybr of
          1:begin dec(nowy_param.rodzteren);if nowy_param.rodzteren<1 then nowy_param.rodzteren:=72;end;
          2:begin
            dec(nowy_param.textura);if nowy_param.textura<0 then nowy_param.textura:=iltextur;
            mem2xms(scr2^,_xms[1].h,offsety[11],64000);
            xms2mem(_xms[1].h,offsety[13]+nowy_param.textura*10,wyr[0],10);
            wczytaj_texture_do_rysowania(wyr+'.STX');
            xms2mem(_xms[1].h,offsety[11],scr2^,64000);
            end;
          3:begin
            dec(nowy_param.wierzch);if nowy_param.wierzch<0 then nowy_param.wierzch:=ilwierzch;
            fillchar2(trawabuf^,sizeof(trawabuf^),0);
            xms2mem(_xms[1].h,offsety[14]+nowy_param.wierzch*10,wyr,10);
            wczytaj_wierzch(wyr+'.STW');
            end;
          4:begin
            inc(nowy_param.grgora,4);
            if (nowy_param.grgora>395) or (nowy_param.grgora>nowy_param.grdol) then nowy_param.grgora:=30;
            end;
          5:begin
            inc(nowy_param.grdol,4);
            if nowy_param.grdol>500 then begin
               nowy_param.grdol:=30;
               if nowy_param.grdol<nowy_param.grgora then nowy_param.grdol:=nowy_param.grgora;
            end;
            end;
        end;
     if (kl[1]) and (not klw[1]) then begin
        ktore:=0;klw[1]:=true;
        {dispose(trawabuf);}
        end;
     end;
   5:begin {odczyt terenu}
     pisz(5,5,'ODCZYT TERENU',96);

     ruch_myszy_po_plikach;

     if ilplik>=1 then begin
       b:=0;{x}  a2:=0;{y}
       for a:=1 to ilplik do begin
         guztext(15+b*110,20+a2*9,lista[a+pozxlisty*14],7,0,10+a,true);
         inc(a2);
         if a2>=14 then begin
            inc(b);
            a2:=0;
            if b>=3 then a:=ilplik;
         end;
       end;
     end else
         pisz(15,20,'BRAK TERENoW DO ODCZYTU',8);

     guzobr(15,150,42,7,2,pozxlisty>0);
     guzobr(265,150,42,8,3,pozxlisty<longint(ilplik div 14)-2);

     guztext(139,150,'NAZWA:',7,32,4,true);
     pisz(132,159,wpisnazw.nazwa,7);

     guzobr(130,170,60,3,5,true);

     if (dwuklik[1]) and (wybr in [11..99]) then wybr:=5;

     guzobr(15,180,50,0,1,true);
     if (klik[1]) and (wybr>0) then begin
        case wybr of
          1:ktore:=0;
          2:if pozxlisty>0 then dec(pozxlisty);
          3:if pozxlisty<longint(ilplik div 14)-2 then inc(pozxlisty);
          4:begin wpisnazw.wpisuje:=true;wpisnazw.kur:=1;end;
          5:begin
            dispose(trawabuf);
            dispose(scr2);
            pokaz_ekran('WCZYTYWANIE PLIKU',wpisnazw.nazwa+'.S2T');
            wczytaj_teren(wpisnazw.nazwa+'.S2T',k);
            new(scr2);
            new(trawabuf);
            if k=0 then begin
               sprawdz_czy_jest_plik_tla(pogoda.rodztla);
               wczytaj_tlo(pogoda.rodztla+'.S2B',k1);
               if k1=0 then ostpliki.tlo:=pogoda.rodztla;
               resetuj_teren;
               xms2mem(_xms[1].h,offsety[11],scr^,64000);
               _wolno_wrocic_do_gry:=true;
            end;
            komunikat_bledu(k,'TEREN WCZYTANY POPRAWNIE',wpisnazw.nazwa+'.S2T');
            ktore:=99;
            trybgry:=false;
            byltrybgry:=false;
            end;
          11..99:begin
              wpisnazw.nazwa:=lista[wybr-10+pozxlisty*14];
              if wpisnazw.kur>length(wpisnazw.nazwa)+1 then
                 wpisnazw.kur:=length(wpisnazw.nazwa)+1;
           end;
        end;
        klik[1]:=false;wybr:=0;
     end;

     if wpisnazw.wpisuje then wpisywanie_nazwy_pliku(8,125,159,false);
     ostpliki.teren:=wpisnazw.nazwa;

     if (kl[1]) and (not klw[1]) then begin ktore:=0;klw[1]:=true;end;
     end;
   6:begin {zapis terenu}
     pisz(5,5,'ZAPIS TERENU',96);

     ruch_myszy_po_plikach;

     if ilplik>=1 then begin
       b:=0;{x}  a2:=0;{y}
       for a:=1 to ilplik do begin
         guztext(15+b*110,20+a2*9,lista[a+pozxlisty*14],7,0,10+a,true);
         inc(a2);
         if a2>=14 then begin
            inc(b);
            a2:=0;
            if b>=3 then a:=ilplik;
         end;
       end;
     end;

     guzobr(15,150,42,7,2,pozxlisty>0);
     guzobr(265,150,42,8,3,pozxlisty<longint(ilplik div 14)-2);

     guztext(139,150,'NAZWA:',7,32,4,true);
     pisz(132,159,wpisnazw.nazwa,7);

     guzobr(130,170,60,5,5,true);

     if (dwuklik[1]) and (wybr in [11..99]) then wybr:=5;

     guzobr(15,180,50,0,1,true);
     if (klik[1]) and (wybr>0) then begin
        case wybr of
          1:ktore:=0;
          2:if pozxlisty>0 then dec(pozxlisty);
          3:if pozxlisty<longint(ilplik div 14)-2 then inc(pozxlisty);
          4:begin wpisnazw.wpisuje:=true;wpisnazw.kur:=1;end;
          5:begin
            dispose(trawabuf);
            dispose(scr2);
            pokaz_ekran('ZAPISYWANIE PLIKU',wpisnazw.nazwa+'.S2T');
            zapisz_teren(wpisnazw.nazwa+'.S2T',k);
            new(scr2);
            if k=0 then _wolno_wrocic_do_gry:=true;
            komunikat_bledu(k,'TEREN ZAPISANY POPRAWNIE',wpisnazw.nazwa+'.S2T');
            new(trawabuf);
            ktore:=99;
            end;
          11..99:begin
              wpisnazw.nazwa:=lista[wybr-10+pozxlisty*14];
              if wpisnazw.kur>length(wpisnazw.nazwa)+1 then
                 wpisnazw.kur:=length(wpisnazw.nazwa)+1;
           end;
        end;
        klik[1]:=false;wybr:=0;
     end;

     if wpisnazw.wpisuje then wpisywanie_nazwy_pliku(8,125,159,false);
     ostpliki.teren:=wpisnazw.nazwa;

     if (kl[1]) and (not klw[1]) then begin ktore:=0;klw[1]:=true;end;
     end;
   7:begin {odczyt tla}
     pisz(5,5,'ODCZYT TlA',96);

     ruch_myszy_po_plikach;

     if ilplik>=1 then begin
       b:=0;{x}  a2:=0;{y}
       for a:=1 to ilplik do begin
         guztext(15+b*110,20+a2*9,lista[a+pozxlisty*14],7,0,10+a,true);
         inc(a2);
         if a2>=14 then begin
            inc(b);
            a2:=0;
            if b>=3 then a:=ilplik;
         end;
       end;
     end else
         pisz(15,20,'BRAK TEl DO ODCZYTU',8);

     guzobr(15,150,42,7,2,pozxlisty>0);
     guzobr(265,150,42,8,3,pozxlisty<longint(ilplik div 14)-2);

     guztext(139,150,'NAZWA:',7,32,4,true);
     pisz(132,159,wpisnazw.nazwa,7);

     guzobr(130,170,60,3,5,true);

     if (dwuklik[1]) and (wybr in [11..99]) then wybr:=5;

     guzobr(15,180,50,0,1,true);
     if (klik[1]) and (wybr>0) then begin
        case wybr of
          1:begin
            ktore:=0;
            move(pal_gl,pal,sizeof(pal));
            cala_paleta(false);
            end;
          2:if pozxlisty>0 then dec(pozxlisty);
          3:if pozxlisty<longint(ilplik div 14)-2 then inc(pozxlisty);
          4:begin wpisnazw.wpisuje:=true;wpisnazw.kur:=1;end;
          5:begin
            pokaz_ekran('WCZYTYWANIE PLIKU',wpisnazw.nazwa+'.S2B');
            wczytaj_tlo(wpisnazw.nazwa+'.S2B',K);
            komunikat_bledu(k,'TlO WCZYTANE POPRAWNIE',wpisnazw.nazwa+'.S2B');
            if k=0 then pogoda.rodztla:=wpisnazw.nazwa;
            ktore:=99;
            end;
          11..99:begin
              wpisnazw.nazwa:=lista[wybr-10+pozxlisty*14];
              if wpisnazw.kur>length(wpisnazw.nazwa)+1 then
                 wpisnazw.kur:=length(wpisnazw.nazwa)+1;
              wczytaj_mini_tlo(wpisnazw.nazwa+'.S2B');
           end;
        end;
        klik[1]:=false;wybr:=0;
     end;

     if wpisnazw.wpisuje then wpisywanie_nazwy_pliku(8,125,159,false);
     ostpliki.tlo:=wpisnazw.nazwa;

     pokaz_mini_tlo;

     if (kl[1]) and (not klw[1]) then begin
        ktore:=0;klw[1]:=true;
        move(pal_gl,pal,sizeof(pal));
        cala_paleta(false);
     end;
     end;
   8:begin {odczyt postaci}
     pisz(5,5,'ODCZYT POSTACI',96);

     if ilpostaci>=1 then begin
       a2:=0;{y}
       for a:=1 to ilpostaci do begin
        if (a+pozxlisty*14)<=ilpostaci then begin
         xms2mem(_xms[1].h,offsety[17]+(a+pozxlisty*14)*10,wyr,10);
         pisz(15,20+a2*9,wyr,0);
         xms2mem(_xms[1].h,offsety[18]+(a+pozxlisty*14)*30,wyr,26);
         pisz(80,20+a2*9,wyr,56);
         for a1:=0 to 4 do begin
             if ostpliki.postaci[a1]=lista[a+pozxlisty*14] then
                maskpicxms(280+a1*6,21+a2*9,5,5,0,offsety[27]+25*a1,scr^,1,true)
                else
                maskpic2xms(280+a1*6,21+a2*9,5,5,0,kgrup[a1]+2,offsety[27]+25*a1,scr^,1,true);
             if (klik[1]) and (mysz_w(280+a1*6,21+a2*9,284+a1*6,25+a2*9)) then begin
                wpisnazw.nazwa:=lista[a+pozxlisty*14];
                if wpisnazw.kur>length(wpisnazw.nazwa)+1 then
                   wpisnazw.kur:=length(wpisnazw.nazwa)+1;
                ostpliki.postaci[a1]:=wpisnazw.nazwa;
             end;

         end;
        end;
         inc(a2);
         if a2>=14 then begin
            inc(b);
            a2:=0;
            a:=ilpostaci;
         end;
       end;
     end else
         pisz(15,20,'BRAK POSTACI DO ODCZYTU !? TO NIE POWINNO SIe POKAZAc!',8);

     guzobr(15,150,42,7,2,pozxlisty>0);
     guzobr(265,150,42,8,3,pozxlisty<longint(ilpostaci div 14));

     guzobr(130,170,60,3,5,true);

     guzobr(15,180,50,0,1,true);
     if (klik[1]) and (wybr>0) then begin
        case wybr of
          1:begin
            ktore:=0;
            for a:=0 to 4 do ostpliki.postaci[a]:=kopiapostaci[a];
            end;
          2:if pozxlisty>0 then dec(pozxlisty);
          3:if pozxlisty<longint(ilpostaci div 14) then inc(pozxlisty);
          5:begin
            ktore:=0;
            for a1:=0 to 4 do
              if ostpliki.postaci[a1]<>kopiapostaci[a1] then begin
                pokaz_ekran('WCZYTYWANIE PLIKU',ostpliki.postaci[a1]+'.S2P');
                wczytaj_zestaw_postaci(ostpliki.postaci[a1]+'.S2P',a1,k);
                komunikat_bledu(k,'ZESTAW POSTACI WCZYTANY POPRAWNIE',ostpliki.postaci[a1]+'.S2P');
                if k=0 then przerob_zestaw_postaci(a1);
                ktore:=99;
              end;
            end;
        end;
        klik[1]:=false;wybr:=0;
     end;

     if (kl[1]) and (not klw[1]) then begin
        ktore:=0;klw[1]:=true;
        for a:=0 to 4 do ostpliki.postaci[a]:=kopiapostaci[a];
     end;

     end;
   9:begin {statystyki}
     pisz(5,5,'STATYSTYKI',96);

     pisz(15,20,'RAKIET: ',0);
     pisz(235,20,l2t(stats.rakiety,10),32);
     pisz(15,30,'GRANAToW: ',0);
     pisz(235,30,l2t(stats.granaty,10),32);
     pisz(15,40,'BOMB: ',0);
     pisz(235,40,l2t(stats.bomby,10),32);
     pisz(15,50,'DYNAMIToW: ',0);
     pisz(235,50,l2t(stats.dynamity,10),32);
     pisz(15,60,'KUL OGNISTYCH: ',0);
     pisz(235,60,l2t(stats.kulaog,10),32);
     pisz(15,70,'MIN: ',0);
     pisz(235,70,l2t(stats.miny,10),32);
     pisz(15,80,'KOWADEl: ',0);
     pisz(235,80,l2t(stats.kowadla,10),32);
     pisz(15,90,'POCISKoW: ',0);
     pisz(235,90,l2t(stats.pociski,10),32);
     pisz(15,100,'POCISKoW Z REJLGANA: ',0);
     pisz(235,100,l2t(stats.rejlpoc,10),32);
     pisz(15,110,'POSTACI: ',0);
     pisz(235,110,l2t(stats.postaci,10),32);
     pisz(15,120,'TRUPoW: ',0);
     pisz(235,120,l2t(il_trupow,10),32);
     if il_trupow>0 then a:=trunc((stats.zabitych*100)/il_trupow) else a:=0;
     pisz(25,130,'ZABITYCH: ',0);
     pisz(186,130,l2t(stats.zabitych,10)+' ('+l2t(a,3)+'%)',32);
     if il_trupow>0 then a:=trunc((stats.utopionych*100)/il_trupow) else a:=0;
     pisz(25,140,'UTOPIONYCH: ',0);
     pisz(186,140,l2t(stats.utopionych,10)+' ('+l2t(a,3)+'%)',32);
     if il_trupow>0 then a:=trunc((stats.spalonych*100)/il_trupow) else a:=0;
     pisz(25,150,'SPALONYCH: ',0);
     pisz(186,150,l2t(stats.spalonych,10)+' ('+l2t(a,3)+'%)',32);
     pisz(15,160,'ZABITYCH ZWIERZaTEK: ',0);
     pisz(235,160,l2t(stats.zwierzatek,10),32);
     pisz(15,170,'NAJLEPSZE KOMBO: ',0);
     pisz(284,170,l2t(stats.najlkombo,3),32);
     pisz(15,180,'PACZEK BYlO/ZEBRANYCH: ',0);
     pisz(200,180,l2t(stats.paczbylo,7)+'/'+l2t(stats.paczzebr,7),32);

     guzobr(15,190,50,0,99,true);
     if (klik[1]) and (wybr=99) then ktore:=0;
     if (kl[1]) and (not klw[1]) then begin ktore:=0;klw[1]:=true;end;
     end;
   10:begin {detale}
     pisz(5,5,'MAXYMALNE ILOsCI DANYCH DETALI',96);
     pokaz_detale;

     guzobr(15,180,50,0,99,true);

     if (klik[1]) and (wybr>0) then begin
        case wybr of
          1:if (wolnejpamieci-ilesuma)-pam.spost>0 then begin
               inc(maxpost);
               if maxpost>Tmaxpost then maxpost:=Tmaxpost;
            end;
          2:if (wolnejpamieci-ilesuma)-pam.ssyf*10>0 then begin
               inc(maxsyf,10);
               if maxsyf>Tmaxsyf then maxsyf:=Tmaxsyf;
            end;
          3:if (wolnejpamieci-ilesuma)-pam.spoc>0 then begin
               inc(maxpoc);
               if maxpoc>Tmaxpoc then maxpoc:=Tmaxpoc;
            end;
          4:if (wolnejpamieci-ilesuma)-pam.smin>0 then begin
               inc(maxmin);
               if maxmin>Tmaxmin then maxmin:=Tmaxmin;
            end;
          5:if (wolnejpamieci-ilesuma)-pam.smies>0 then begin
               inc(maxmies);
               if maxmies>Tmaxmies then maxmies:=Tmaxmies;
            end;
          6:if (wolnejpamieci-ilesuma)-pam.swyb>0 then begin
               inc(maxwyb);
               if maxwyb>Tmaxwyb then maxwyb:=Tmaxwyb;
            end;
          7:if (wolnejpamieci-ilesuma)-pam.sdym>0 then begin
               inc(maxdym);
               if maxdym>Tmaxdym then maxdym:=Tmaxdym;
            end;
          8:if (wolnejpamieci-ilesuma)-pam.sopad*10>0 then begin
               inc(maxopad,10);
               if maxopad>Tmaxopad then maxopad:=Tmaxopad;
            end;
          9:if (wolnejpamieci-ilesuma)-pam.skow>0 then begin
               inc(maxkow);
               if maxkow>Tmaxkow then maxkow:=Tmaxkow;
            end;
         10:if (wolnejpamieci-ilesuma)-pam.sbom*5>0 then begin
               inc(maxbom,5);
               if maxbom>Tmaxbom then maxbom:=Tmaxbom;
            end;
         11:if (wolnejpamieci-ilesuma)-pam.szwi>0 then begin
               inc(maxzwi);
               if maxzwi>Tmaxzwi then maxzwi:=Tmaxzwi;
            end;
         12:if (wolnejpamieci-ilesuma)-pam.spacz>0 then begin
               inc(maxpacz);
               if maxpacz>Tmaxpacz then maxpacz:=Tmaxpacz;
            end;

          99:juz:=true;
        end;
        klik[1]:=false;wybr:=0;
     end;
     if (klik[2]) and (wybr>0) then
        case wybr of
          1:begin dec(maxpost);   if maxpost<10 then maxpost:=10 end;
          2:begin dec(maxsyf,10); if maxsyf<10 then maxsyf:=10 end;
          3:begin dec(maxpoc);    if maxpoc<10 then maxpoc:=10 end;
          4:begin dec(maxmin);    if maxmin<10 then maxmin:=10 end;
          5:begin dec(maxmies);   if maxmies<10 then maxmies:=10 end;
          6:begin dec(maxwyb);    if maxwyb<4 then maxwyb:=4 end;
          7:begin dec(maxdym);    if maxdym<4 then maxdym:=4 end;
          8:begin dec(maxopad,10);if maxopad<10 then maxopad:=10 end;
          9:begin dec(maxkow);    if maxkow<4 then maxkow:=4 end;
         10:begin dec(maxbom,5);  if maxbom<10 then maxbom:=10 end;
         11:begin dec(maxzwi);    if maxzwi<10 then maxzwi:=10 end;
         12:begin dec(maxpacz);   if maxpacz<4 then maxpacz:=4 end;
        end;

     if (kl[1]) and (not klw[1]) then begin
        klw[1]:=true;
        juz:=true;
     end;
     if juz then begin
        ktore:=99;
        komunikat[0]:='WSZYSTKIE OBIEKTY ZOSTAlY ZRESETOWANE';
        komunikat[1]:='I W ICH MIEJSCE POJAWIa SIe NOWE!';
        with pam do begin
          freemem(post,spost*smaxpost);
          freemem(zwi,szwi*smaxzwi)   ;
          freemem(mies,smies*smaxmies);
          freemem(kow,skow*smaxkow)   ;
          freemem(pacz,spacz*smaxpacz);
          freemem(syf,ssyf*smaxsyf)   ;
          freemem(opad,sopad*smaxopad);
          freemem(poc,spoc*smaxpoc)   ;
          freemem(min,smin*smaxmin)   ;
          freemem(wyb,swyb*smaxwyb)   ;
          freemem(dym,sdym*smaxdym)   ;
          freemem(bom,sbom*smaxbom)   ;

          getmem(post,spost*maxpost) ;
          getmem(zwi,szwi*maxzwi)    ;
          getmem(mies,smies*maxmies) ;
          getmem(kow,skow*maxkow)    ;
          getmem(pacz,spacz*maxpacz) ;
          getmem(syf,ssyf*maxsyf)    ;
          getmem(opad,sopad*maxopad) ;
          getmem(poc,spoc*maxpoc)    ;
          getmem(min,smin*maxmin)    ;
          getmem(wyb,swyb*maxwyb)    ;
          getmem(dym,sdym*maxdym)    ;
          getmem(bom,sbom*maxbom)    ;
          fillchar(post^,spost*maxpost,0);
          fillchar(syf^,ssyf*maxsyf,0);
          fillchar(poc^,spoc*maxpoc,0);
          fillchar(min^,smin*maxmin,0);
          fillchar(mies^,smies*maxmies,0);
          fillchar(wyb^,swyb*maxwyb,0);
          fillchar(dym^,sdym*maxdym,0);
          fillchar(opad^,sopad*maxopad,0);
          fillchar(kow^,skow*maxkow,0);
          fillchar(bom^,sbom*maxbom,0);
          fillchar(zwi^,szwi*maxzwi,0);
          fillchar(pacz^,spacz*maxpacz,0);
        end;
     end;
     end;
   11:begin {rekordy}
     pisz(5,5,'NAJWIeKSI SADYsCI',96);

     pisz(22,20,'IMIe',0);
     if kfg.kolejnoscrekordow=0 then b:=32 else b:=0;
     guztext(97,20,'PUNKTY',7,b,1,true);
     if kfg.kolejnoscrekordow=1 then b:=32 else b:=0;
     guztext(172,20,'TRUPY',7,b,2,true);
     pisz(247,20,'DATA',0);

     if miejscegracza=11 then a2:=11 else a2:=10;
     for a:=1 to a2 do begin
         if a=1 then begin a1:=0;b:=8 end
            else if (a>=2) and (a<=10) then begin a1:=5;b:=0 end
                 else begin a1:=10;b:=16 end;
         if a=miejscegracza then b:=16;
         with wyniki[a] do begin
            if (imie='BRAK') and
               (pkt=0) and (trupow=0) and
               (dd=0) and (mm=0) and (rr=0) then b:=120;
            pisz(2,25+a*10+a1,l2t(a,2),b);
            pisz(22,25+a*10+a1,imie,b);
            pisz(97,25+a*10+a1,l2t(pkt,10),b);
            pisz(172,25+a*10+a1,l2t(trupow,10),b);
            pisz(247,25+a*10+a1,l2t(dd,2)+'.'+l2t(mm,2)+'.'+l2t(rr,4),b);
         end;
     end;

     guztext(115,163,'IMIe SADYSTY:',7,32,4,true);
     pisz(125,172,wpisnazw.nazwa,7);

     guzobr(15,185,50,0,99,true);

     if (klik[1]) and (wybr>0) then begin
        case wybr of
           1,2:begin
             kfg.kolejnoscrekordow:=wybr-1;
             wczytaj_rekordy;
             ustaw_rekordy(kfg.kolejnoscrekordow);
             end;
           4:begin
             wpisnazw.wpisuje:=true;
             wpisnazw.kur:=1;
             end;
          99:ktore:=0;
        end;
        klik[1]:=false;wybr:=0;
     end;

     swpis:=wpisnazw.wpisuje;
     if wpisnazw.wpisuje then wpisywanie_nazwy_pliku(10,118,172,true);
     kfg.imie:=wpisnazw.nazwa;

     if swpis<>wpisnazw.wpisuje then begin
        wczytaj_rekordy;
        ustaw_rekordy(kfg.kolejnoscrekordow);
     end;

     if (kl[1]) and (not klw[1]) then begin ktore:=0;klw[1]:=true;end;
     end;
   99:begin {komunikat}
     pisz(160-trunc(length(komunikat[0])*3.5),90,komunikat[0],0);
     pisz(160-trunc(length(komunikat[1])*3.5),100,komunikat[1],0);

     guzobr(15,130,50,0,99,true);
     if (klik[1]) and (wybr=99) then ktore:=0;
     if (kl[1]) and (not klw[1]) then begin ktore:=0;klw[1]:=true;end;
     end;
  end;

  if kfg.krew_w_menu then {krople krwi}
    for a:=1 to ilkrwi do begin
      if krop[a].jest then
         with krop[a] do begin
            if ani>=5 then begin
               y:=y+dy;
               if dy<7 then dy:=dy+0.003;
            end;
            dec(kani);
            if kani<=0 then begin inc(ani);kani:=3+random(3);end;
            if ani>=5 then ani:=5+random(2);
            maskpicT(x,trunc(y),7,10,0,chmur^,kropobr[ani],scr^);
            if y>=200 then jest:=false;
         end
      else
      if random(40)=0 then begin
         krop[a].x:=random(323)-4;
         krop[a].y:=0;
         krop[a].dy:=2+random/2;
         krop[a].jest:=true;
         krop[a].ani:=0;
         krop[a].kani:=5;
      end else
      if random(150)=0 then begin
         krop[a].x:=mmx+8;
         krop[a].y:=mmy+10;
         krop[a].dy:=2+random/2;
         krop[a].jest:=true;
         krop[a].ani:=2;
         krop[a].kani:=3;
      end;
    end; {E krople krwi}

  maskpicxms(mmx,mmy,21,21,0,offsety[4]+441,scr^,1,false);
  move2(scr^,mem[$A000:0]);
  czekaj(1); {wyrownaj predkosc}
  if (not wpisnazw.wpisuje) and (not (ktore in [5..7])) then while keypressed do readkey;
  if not kl[1] then klw[1]:=false;
until (_wyjscie) or ((_wroc) and (_wolno_wrocic_do_gry)) or (_nowy);
klw[1]:=true;
dispose(trawabuf);
{drobne poprawki po wyjsciu z konfiguracji (usuwanie zbednych dymow itd..)}
if kfg.dym_wyb<>skfg.dym_wyb then for a:=1 to maxwyb do wyb^[a].jest:=false;
if kfg.syfki<>skfg.syfki     then for a:=1 to maxsyf do syf^[a].jest:=false;
if kfg.opady<>skfg.opady     then for a:=1 to maxopad do opad^[a].jest:=false;
if kfg.miecho<>skfg.miecho   then for a:=1 to maxmies do mies^[a].jest:=false;
if kfg.komentarze<>skfg.komentarze then for a:=0 to 4 do koment.tx[a]:='';
if kfg.fejdyekranu<skfg.fejdyekranu then ekr.fejd:=0;
if kfg.paczki<>skfg.paczki   then for a:=1 to maxpacz do pacz^[a].jest:=false;

czekaj_az_pusci_guziki;
{odjazd menu w gore}
menu_koniec(_wroc);
trybgry:=byltrybgry;
end;

{*}PROCEDURE podliczenie_po_grze;
var
xx,yy:integer;
_juz:boolean;
begin
_juz:=false;
czekaj_az_pusci_guziki;
for yy:=0 to 199 do
    for xx:=0 to 319 do if scr^[yy,xx]=0 then scr^[yy,xx]:=1;
bart(0,0,319,199,15,scr^,chmur^);
move2(scr^,scr2^);
trybgry:=false;
repeat
until not kl[1];
repeat
   move2(scr2^,scr^);
   fillchar(full,sizeof(full),0);
   sprawdz_mysz;

   piszc(160, 20,'KONIEC CZASU',0);
   piszc(160, 40,'PODSUMOWANIE:',0);

   piszc(160, 60,'TRUPoW:            '+l2t(il_trupow-il_trup_et,10),0);
   piszc(160, 70,'POTRZEBNE:         '+l2t(tr_gry.jeszcze,10),0);
   piszc(160, 90,'ZDOBYTYCH PUNKToW: '+l2t(punkty-tr_gry.bylopkt,10),0);

   if (il_trupow-il_trup_et)>=tr_gry.jeszcze then begin
      piszc(160,110,'CEL ZDOBYTY',0);
      piszc(160,130,'PREMIA: '+l2t((il_trupow-il_trup_et)-tr_gry.jeszcze,0)+
                    ' X '+l2t(2*tr_gry.jeszcze,0)+' : '+
                    l2t(((il_trupow-il_trup_et)-tr_gry.jeszcze)*2*tr_gry.jeszcze,0),0);
   end else begin
      piszc(160,110,'NIE UDAlO CI SIe - ZA MAlO TRUPoW!',0);
      piszc(160,130,'NIE DOSTAJESZ PREMII',0);
   end;

   maskpicxms(mmx,mmy,21,21,0,offsety[4]+441,scr^,1,false);

   if (klik[1]) or (klik[2]) then _juz:=true;

   move2(Scr^,mem[$A000:0000]); {rysuj na mem[$A000:0] :)}
   czekaj(1); {wyrownaj predkosc}
until (kl[1]);
if (il_trupow-il_trup_et)>=tr_gry.jeszcze then inc(punkty,((il_trupow-il_trup_et)-tr_gry.jeszcze)*2*tr_gry.jeszcze);
end;

{*}PROCEDURE intro;
var
kap:array[0..319] of byte;
juz:boolean;
a,b,dl,
x,y,
zmi:integer;
begin
wczytaj_pal('paleta.pal');
fillchar2(scr^,64000,0);
fadeout(64,0,255);
case random(7) of
 0:wyr:='WIeCEJ KRWI NIE ZOBACZYSZ NIGDZIE...';
 1:wyr:='DAJ SIe SKUSIc...';
 2:wyr:='NAJBARDZIEJ KRWISTY OBRAZ NA sWIECIE...';
 3:wyr:='TEGO NIE PRZEWIDZIELI NASI PRZODKOWIE...';
 4:wyr:='MARZENIA CZASEM SIe SPElNIAJa...';
 5:wyr:='BRUTAL DEATH METAL';
 6:wyr:='NAPALM DEATH';
end;
piszc(160,190,wyr,0);
move2(scr^,mem[$A000:0]);
fadein(1,0,255);

fillchar2(scr2^,64000,0);
fillchar2(scr^,64000,0);
for a:=0 to 199 do
    for b:=0 to 319 do begin
        if a=0 then scr^[a,b]:=13+random(3)
               else scr^[a,b]:=scr^[a-1,b]+random(3)-1;
        if scr^[a,b]< 12-(a div trunc(50+_sin(b*2)*9)) then
           scr^[a,b]:=12-(a div trunc(50+_sin(b*2)*9));
        if scr^[a,b]> 14-(a div trunc(48+_sin(b)*5)) then
           scr^[a,b]:=14-(a div trunc(48+_sin(b)*5));
    end;

cala_paleta(false);
fillchar2(kap,320,0);

kap[random(320)]:=1;
delay(500);
zmi:=0;
repeat
  sprawdz_mysz;
  juz:=true;
{  synchro;}
  inc(zmi); if zmi>=4 then begin zmi:=0;czekaj(1) end;

  b:=random(320);
  if (random(100)=0) and (kap[b]=0) then kap[b]:=1;
  for a:=0 to 319 do begin
      b:=0;
      if (kap[a]<199) then juz:=false;
      if ((kap[a]=0) and (((a>0) and (kap[a-1]>0)) or
         ((a<319) and (kap[a+1]>0))) and (random(30)=0)) then b:=1;
      if ((b=1) or (kap[a]>0)) and (kap[a]<199) then begin
         mem[$A000:a+kap[a]*320]:=scr^[kap[a],a];
         if kap[a]=1 then mem[$A000:a]:=scr^[0,a];
         inc(kap[a]);
      end;

      b:=random(199)+1;
      if (kap[a]>=b) and (scr^[b,a]>9) then begin
            dl:=random(3)+1;
            while (dl>0) and (b<kap[a]) do begin
               scr^[b,a]:=scr^[b-1,a];
               if random(30)=0 then begin
                  dec(scr^[b,a]);
                  if scr^[b,a]<9 then scr^[b,a]:=9
               end;
               mem[$A000:a+b*320]:=scr^[b,a];
               inc(b);
               dec(dl);
            end;
      end;
  end;

  for a:=0 to 4 do begin
  x:=random(320);
  y:=random(9)+190;
  b:=mem[$A000:y*320+x];
  if (b in [1..7,176..183]) then begin
     mem[$a000:y*320+x]:=181;
     if (y<198) then begin
        if random(2)=0 then dec(b);
        if b<177 then b:=177;
        mem[$a000:(y+1)*320+x]:=b;
     end;
  end;
  end;

  if (keypressed) or (klik[1]) or (klik[2]) then juz:=true;
until juz;
move2(scr^,mem[$A000:0]);

fadeout2(63,0,0,0,1);

{winieta po czerwonym}
datassign (plik,'dane\s2.dat','winieta.gdr',0);
blockread(plik,GDRHead,sizeof(GDRHead));
blockread(plik,scr^,64000);
close(plik);
move2(scr^,mem[$A000:0]);
move(gdrhead.pal,pal_gl,768);

StartSound(Sound[25], false,1,1);
Fadein2(0,255,1,0,false);

repeat
  sprawdz_mysz;
until (keypressed) or (klik[1]) or (klik[2]);
fillchar2(scr^,64000,0);
fillchar2(mem[$A000:0],64000,0);
wczytaj_pal('paleta.pal');
while keypressed do readkey;
end;
end.