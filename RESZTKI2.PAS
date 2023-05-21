{$N+}
unit resztki2;

interface

{*}PROCEDURE rysuj(sx,sy:longint;kol:byte);
{*}PROCEDURE rysuj_kwad(sx,sy:longint;kol:byte);
{*}PROCEDURE rysujelement(sx,sy:longint;gdzie:byte);
{*}PROCEDURE t_cir(sx,sy:longint);
{*}PROCEDURE wybor_zmenu;
{*}PROCEDURE komentarze;
{*}PROCEDURE tultipsy;
{*}PROCEDURE lupa_zumuj(sx,sy:integer);
{*}PROCEDURE lupa_oblicz;
{*}PROCEDURE woda;
{*}PROCEDURE bombelki;
{*}PROCEDURE lawa;
{*}PROCEDURE kwas;
{*}PROCEDURE paczki;
{*}PROCEDURE sprawdzaj_bonusy;

implementation
uses crt,vars,glowne,dos,xms,maskp,myszunit,cosin,dzwieki2,SMix,nowe,resztki;

{*}PROCEDURE rysuj(sx,sy:longint;kol:byte);
var
x,y,d:integer;
bylo:array[0..maxy-1] of byte;
begin
x:=0;
y:=rysowanie.rozm;
d:=3-2*rysowanie.rozm;
fillchar2(bylo,maxy,0);
if rysowanie.jakrys=0 then {bez textury}
   repeat
     if (sy+y>=0) and (sy+y<maxy) and ((sx+x)-(sx-x)>=1) and (bylo[sy+y]=0) then begin
       if kol=0 then hline_x(sx-x,sx+x,sy+y,0)
                else hline_smiec_x(sx-x,sx+x,sy+y,kolter[rysowanie.kolor]+ord(not rysowanie.gladko),
                      kolter[rysowanie.kolor]+2*ord(rysowanie.gladko)+ord(not rysowanie.gladko));
       bylo[sy+y]:=1;
     end;
     if (sy-y>=0) and (sy-y<maxy) and ((sx+x)-(sx-x)>=1) and (bylo[sy-y]=0) then begin
       if kol=0 then hline_x(sx-x,sx+x,sy-y,0)
                else hline_smiec_x(sx-x,sx+x,sy-y,kolter[rysowanie.kolor]+ord(not rysowanie.gladko),
                      kolter[rysowanie.kolor]+2*ord(rysowanie.gladko)+ord(not rysowanie.gladko));
       bylo[sy-y]:=1;
     end;
     if (sy+x>=0) and (sy+x<maxy) and ((sx+y)-(sx-y)>=1) and (bylo[sy+x]=0) then begin
       if kol=0 then hline_x(sx-y,sx+y,sy+x,0)
                else hline_smiec_x(sx-y,sx+y,sy+x,kolter[rysowanie.kolor]+ord(not rysowanie.gladko),
                      kolter[rysowanie.kolor]+2*ord(rysowanie.gladko)+ord(not rysowanie.gladko));
       bylo[sy+x]:=1;
     end;
     if (sy-x>=0) and (sy-x<maxy) and ((sx+y)-(sx-y)>=1) and (bylo[sy-x]=0) then begin
       if kol=0 then hline_x(sx-y,sx+y,sy-x,0)
                else hline_smiec_x(sx-y,sx+y,sy-x,kolter[rysowanie.kolor]+ord(not rysowanie.gladko),
                      kolter[rysowanie.kolor]+2*ord(rysowanie.gladko)+ord(not rysowanie.gladko));
       bylo[sy-x]:=1;
     end;
     inc(x);
     if d>=0 then begin
        dec(y);
        d:=d+2*(2*x-2*y+1);
     end else d:=d+2*(2*x+1)
   until x>y
  else {z textura}
   repeat
     if (sy+y>=0) and (sy+y<maxy) and ((sx+x)-(sx-x)>=1) and (bylo[sy+y]=0) then begin
       if kol=0 then hline_x(sx-x,sx+x,sy+y,0)
                else hline_textura_x(sx-x,sx+x,sy+y);
       bylo[sy+y]:=1;
     end;
     if (sy-y>=0) and (sy-y<maxy) and ((sx+x)-(sx-x)>=1) and (bylo[sy-y]=0) then begin
       if kol=0 then hline_x(sx-x,sx+x,sy-y,0)
                else hline_textura_x(sx-x,sx+x,sy-y);
       bylo[sy-y]:=1;
     end;
     if (sy+x>=0) and (sy+x<maxy) and ((sx+y)-(sx-y)>=1) and (bylo[sy+x]=0) then begin
       if kol=0 then hline_x(sx-y,sx+y,sy+x,0)
                else hline_textura_x(sx-y,sx+y,sy+x);
       bylo[sy+x]:=1;
     end;
     if (sy-x>=0) and (sy-x<maxy) and ((sx+y)-(sx-y)>=1) and (bylo[sy-x]=0) then begin
       if kol=0 then hline_x(sx-y,sx+y,sy-x,0)
                else hline_textura_x(sx-y,sx+y,sy-x);
       bylo[sy-x]:=1;
     end;
     inc(x);
     if d>=0 then begin
        dec(y);
        d:=d+2*(2*x-2*y+1);
     end else d:=d+2*(2*x+1)
   until x>y;
end;

{*}PROCEDURE rysuj_kwad(sx,sy:longint;kol:byte);
var
x,y,py:integer;
begin
x:=rysowanie.rozm div 2;
py:=rysowanie.rozm div 2;
if rysowanie.jakrys=0 then begin{bez textury}
   for y:=-rysowanie.rozm to rysowanie.rozm-1 do
       if kol=0 then hline_x(sx-rysowanie.rozm,sx+rysowanie.rozm-1,sy+y,0)
                else hline_smiec_x(sx-rysowanie.rozm,sx+rysowanie.rozm-1,sy+y,
                                   kolter[rysowanie.kolor]+ord(not rysowanie.gladko),
                                   kolter[rysowanie.kolor]+2*ord(rysowanie.gladko)+ord(not rysowanie.gladko));
end else {z textura}
   for y:=-rysowanie.rozm to rysowanie.rozm-1 do
       if kol=0 then hline_x(sx-rysowanie.rozm,sx+rysowanie.rozm-1,sy+y,0)
                else hline_textura_x(sx-rysowanie.rozm,sx+rysowanie.rozm-1,sy+y);
end;

{*}PROCEDURE rysujelement(sx,sy:longint;gdzie:byte);
{gdzie: 0-w XMS, 1-na ekranie, przezroczyste!}
const
offs:array[0..14] of record x,y:shortint end=(
      (x:  6;y: -3), {schody 1 w /}
      (x: -6;y: -3), {schody 1 w \}
      (x:  6;y: -4), {schody 2 w /}
      (x: -6;y: -4), {schody 2 w \}
      (x:  5;y: -4), {schody metalowe /}
      (x: -5;y: -4), {schody metalowe \}
      (x: 10;y: -5), {deska /}
      (x:-10;y: -5), {deska \}
      (x: 10;y:  0), {deska pozioma}
      (x: 10;y:  0), {kladka z pali pozioma}
      (x: 10;y:  0), {pozioma konstrukcja stalowa}
      (x: 10;y:  0), {most}
      (x:  0;y:-10), {deska pionowa}
      (x:  0;y:-10), {kolumna}
      (x:  0;y:-10)  {pionowa konstrukcja stalowa}
     );
var
rx,ry:longint;
ob,obroz:longint;
buf:array[0..100] of byte;
begin
ob:=rysowanie.obiekt-1;
obroz:=rysowanie.obrozm-1;
if gdzie=2 then obroz:=2;
rx:=trunc(sx-offs[ob].x*(obroz-1)/2)-5-offs[ob].x div 2;
ry:=trunc(sy-offs[ob].y*(obroz-1)/2)-5-offs[ob].y div 2;
for a:=0 to obroz do begin
    case gdzie of
      0:MaskPicxmswxms(rx,ry,10,10,0, offsety[21]+ob*100,1);
      1:begin
        XMS2Mem(_xms[1].h,offsety[21]+ob*100,buf,100);
        MaskPict(rx,ry,10,10,0, chmur^,buf,scr^);
        end;
      2:MaskPicxms(rx,ry,10,10,0, offsety[21]+ob*100,scr^,1,true);
      3:MaskPicxmswxms2(rx,ry,10,10,0, offsety[21]+ob*100,1);
    end;
    rx:=rx+offs[ob].x;
    ry:=ry+offs[ob].y;
end;
end;

{*}PROCEDURE t_cir(sx,sy:longint);
var
x,y,d:integer;
buf,bylo:array[0..maxy-1] of byte;

begin
x:=0;
y:=rysowanie.rozm;
d:=3-2*rysowanie.rozm;
fillchar2(bylo,maxy,0);
repeat
if (sy+y>=0) and (sy+y<maxy) and ((sx+x)-(sx-x)>=1) and (bylo[sy+y]=0) then begin
   hlineT(sx-x,sx+x,sy+y,kolter[rysowanie.kolor]);
   bylo[sy+y]:=1;
end;
if (sy-y>=0) and (sy-y<maxy) and ((sx+x)-(sx-x)>=1) and (bylo[sy-y]=0) then begin
   hlineT(sx-x,sx+x,sy-y,kolter[rysowanie.kolor]);
   bylo[sy-y]:=1;
end;
if (sy+x>=0) and (sy+x<maxy) and ((sx+y)-(sx-y)>=1) and (bylo[sy+x]=0) then begin
   hlineT(sx-y,sx+y,sy+x,kolter[rysowanie.kolor]);
   bylo[sy+x]:=1;
end;
if (sy-x>=0) and (sy-x<maxy) and ((sx+y)-(sx-y)>=1) and (bylo[sy-x]=0) then begin
   hlineT(sx-y,sx+y,sy-x,kolter[rysowanie.kolor]);
   bylo[sy-x]:=1;
end;

inc(x);
if d>=0 then begin
   dec(y);
   d:=d+2*(2*x-2*y+1);
end else d:=d+2*(2*x+1)
until x>y;

end;

{*}PROCEDURE wybor_zmenu;
const
corobiapostacie:array[0..4] of byte=(0,6,1,2,7);
bronie:array[0..19] of string[22]=
       ('BAZUKA','GRANAT','BOMBA','DYNAMIT','KARABIN','MINIGAN','STRZELBA',
        'SNAJPERKA','MIOTACZ OGNIA','NALOT','POC.SAMONAPROWADZAJaCY',
        'LASER','PRaD','KULA OGNISTA','MINY','KOWADlO','PIlA','REJLGAN',
        'NAPALM','MIOTACZ ODlAMKoW');
inneat:array[100..110] of string[10]=
       ('sMIECI','MIeSKO','KREW','PIORUN','sNIEG','DESZCZ','POSTACI',
        'ZWIERZaTKA','WENTYLATOR','LUPA','PACZKI');
nazwcorobi:array[0..4] of string[8]=
       ('STOI','BLOKUJE','IDZIE','BIEGNIE','PANIKUJE');

begin
{pisz(0,0,l2t(mmx,3)+'/'+l2t(mmy-(199-ekr.menuwys),3),0);}

if guzik[1] then
 case ekr.ktore_menu of
  0:begin {bronie}
   if (mmy>=199-ekr.menuwys+3) and (mmy<=199-ekr.menuwys+17) and
      ((mmx+1) mod 18>=3) and ((mmx+1) mod 18<=17) and (mmx<=196) then begin
      celow.bron:=((mmx+1) div 18);
      nowy_tultip(bronie[celow.bron]);
   end;
   if (mmy>=199-ekr.menuwys+22) and (mmy<=199-ekr.menuwys+36) and
      ((mmx+1) mod 18>=3) and ((mmx+1) mod 18<=17) and (mmx<=160) then begin
      celow.bron:=((mmx+1) div 18)+11;
      nowy_tultip(bronie[celow.bron]);
   end;
   end;
  1:begin {inne atrakcje}
   if (mmy>=199-ekr.menuwys+3) and (mmy<=199-ekr.menuwys+17) and
      ((mmx+1) mod 18>=3) and ((mmx+1) mod 18<=17) and (mmx<=196) then begin
      celow.bron:=((mmx+1) div 18)+100;
      nowy_tultip(inneat[celow.bron]);
   end;
   end;
  2:begin {opcje postaci}
   if (klik[1]) and (mmy>=199-ekr.menuwys+3) and (mmy<=199-ekr.menuwys+17) then begin
      if ((mmx+1) mod 18>=3) and ((mmx+1) mod 18<=17) and (mmx<92) then begin
         for a:=1 to maxpost do
          if post^[a].zazn then post^[a].comarobic:=corobiapostacie[((mmx+1) div 18)];
         nowy_tultip(nazwcorobi[((mmx+1) div 18)]);
      end;
      if (mmx>=92) and (mmx<=106) then begin{zmien kierunek}
         for a:=1 to maxpost do
          if post^[a].zazn then post^[a].kier:=-post^[a].kier;
         nowy_tultip('ZMIEn KIERUNEK');
      end;
      if (mmx>=110) and (mmx<=124) then begin{dodaj sily}
         for a:=1 to maxpost do
          if post^[a].zazn then begin
             inc(post^[a].sila,50);
             if post^[a].sila>999 then post^[a].sila:=999;
             if post^[a].niesmiertelny>=0 then post^[a].niesmiertelny:=post^[a].sila;
          end;
         nowy_tultip('+50 SIlY');
      end;
      if (mmx>=128) and (mmx<=142) then begin{odejmij sily}
         for a:=1 to maxpost do
          if post^[a].zazn then begin
             dec(post^[a].sila,50);
             if post^[a].sila<0 then post^[a].sila:=0;
             if post^[a].niesmiertelny>=0 then begin
                if post^[a].sila<=0 then post^[a].sila:=1;
                post^[a].niesmiertelny:=post^[a].sila;
             end;
          end;
         nowy_tultip('-50 SIlY');
      end;
      if (mmx>=146) and (mmx<=160) then begin{wolna wola}
         b:=0;
         for a:=1 to maxpost do if (post^[a].zazn) and (post^[a].jest) and (post^[a].wolnawola) then inc(b);
         if (b=il_zazn) or (b=0) then begin
            for a:=1 to maxpost do
                if post^[a].zazn then post^[a].wolnawola:=not post^[a].wolnawola
         end else
              for a:=1 to maxpost do
                  if post^[a].zazn then post^[a].wolnawola:=true;
         nowy_tultip('WOLNA WOLA');
      end;
      if (mmx>=164) and (mmx<=178) then begin{usmiercenie postaci}
         for a:=1 to maxpost do
          if post^[a].zazn then post^[a].sila:=0;
         nowy_tultip('sMIERc!');
      end;
      if (mmx>=182) and (mmx<=196) then begin{zgaszenie postaci}
         for a:=1 to maxpost do if post^[a].zazn then post^[a].palisie:=false;
         nowy_tultip('UGAs OGIEn');
      end;
      if (mmx>=200) and (mmx<=214) and (il_zazn=1) then begin {sterowanie postacia}
         if ktora_zazn=celow.sterowanie then celow.sterowanie:=0
                                        else celow.sterowanie:=ktora_zazn;
         nowy_tultip('STEROWANIE POSTACIa');
      end;
      if (mmx>=218) and (mmx<=232) then begin{niesmiertelnosc}
         b:=0;
         for a:=1 to maxpost do if (post^[a].zazn) and (post^[a].jest) and (post^[a].niesmiertelny>=0) then inc(b);
         if (b=il_zazn) then begin
            for a:=1 to maxpost do
                if post^[a].zazn then post^[a].niesmiertelny:=-1;
         end else
             for a:=1 to maxpost do
                 if post^[a].zazn then post^[a].niesmiertelny:=post^[a].sila;
         nowy_tultip('NIEsMIERTELNOsc');
      end;
      if (mmx>=270) and (mmx<=284) then begin{odznaczenie postaci}
         for a:=1 to maxpost do post^[a].zazn:=false;
         nowy_tultip('ODZNACZONE');
      end;
      if (mmx>=288) and (mmx<=316) then begin{zaznaczenie wszystkich postaci}
         for a:=1 to maxpost do post^[a].zazn:=true;
         nowy_tultip('ZAZNACZONE WSZYSTKIE');
      end;
   end;
   end;
  3:begin {pogoda}
   if mysz_w(3,199-ekr.menuwys+22,124,199-ekr.menuwys+27) then begin
      pogoda.wiatr:=(mmx-63) div 2;
      nowy_tultip('SIlA WIATRU');
   end;
   if mysz_w(129,199-ekr.menuwys+22,228,199-ekr.menuwys+27) then begin
      pogoda.wielkopadow:=(mmx-128) div 2;
      nowy_tultip('SIlA OPADoW');
   end;
   if mysz_w(234,199-ekr.menuwys+22,283,199-ekr.menuwys+27) then begin
      pogoda.agresja:=(mmx-233) div 2;
      nowy_tultip('STOPIEn AGRESJI');
   end;
   if (mysz_w(310,199-ekr.menuwys+ 3,315,199-ekr.menuwys+38)) then begin
      pogoda.pozwody:=(mmy-78-ekr.menuwys)*5;
      nowy_tultip('POZIOM WODY/LAWY/KWASU');
   end;
   if klik[1] then begin
      if mysz_w(2,199-ekr.menuwys+3,16,199-ekr.menuwys+17) then begin
         if (not pogoda.deszcz) and (pogoda.il_sniegu=0) then pogoda.il_sniegu:=1;
         pogoda.deszcz:=not pogoda.deszcz;
         nowy_tultip('DESZCZ');
      end;
      if mysz_w(20,199-ekr.menuwys+3,34,199-ekr.menuwys+17) then begin
         if (not pogoda.snieg) and (pogoda.il_sniegu=0) then pogoda.il_sniegu:=1;
         pogoda.snieg:=not pogoda.snieg;
         nowy_tultip('sNIEG');
      end;
      if mysz_w(38,199-ekr.menuwys+3,52,199-ekr.menuwys+17) then begin
         pogoda.burza:=not pogoda.burza;
         nowy_tultip('BURZA');
      end;
      if mysz_w(56,199-ekr.menuwys+3,70,199-ekr.menuwys+17) then begin
         if (not pogoda.deszczkrwi) and (pogoda.il_sniegu=0) then pogoda.il_sniegu:=1;
         pogoda.deszczkrwi:=not pogoda.deszczkrwi;
         nowy_tultip('DESZCZ KRWI');
      end;
      if mysz_w(74,199-ekr.menuwys+3,88,199-ekr.menuwys+17) then begin
         pogoda.horror:=not pogoda.horror;
         nowy_tultip('HORROR');
      end;
      if mysz_w(92,199-ekr.menuwys+3,106,199-ekr.menuwys+17) then begin
         if pogoda.trzesienieziemi<100 then inc(pogoda.trzesienieziemi,10);
         nowy_tultip('TRZeSIENIE ZIEMII');
      end;
     IF NOT TRYBGRY THEN BEGIN
      if mysz_w(110,199-ekr.menuwys+3,124,199-ekr.menuwys+17) then begin
         if pogoda.dziura=1 then begin
            pogoda.dziura:=0;
            fillchar(scr2^,maxx*20,7);
            mem2xms(scr2^,_xms[1].h,offsety[2]+512000,maxx*20);
         end else begin
            pogoda.dziura:=1;
            fillchar(scr2^,maxx*20,0);
            mem2xms(scr2^,_xms[1].h,offsety[2]+512000,maxx*20);
         end;
         nowy_tultip('DZIURA');
      end;
      if mysz_w(128,199-ekr.menuwys+3,142,199-ekr.menuwys+17) then begin
         if pogoda.dziura=2 then begin
            pogoda.dziura:=0;
            fillchar(scr2^,maxx*20,7);
            mem2xms(scr2^,_xms[1].h,offsety[2]+512000,maxx*20);
         end else begin
            pogoda.dziura:=2;
            fillchar(scr2^,maxx*20,0);
            mem2xms(scr2^,_xms[1].h,offsety[2]+512000,maxx*20);
            for a:=1 to maxbom do bom^[a].jest:=false;
         end;
         nowy_tultip('WODA');
      end;
      if mysz_w(146,199-ekr.menuwys+3,160,199-ekr.menuwys+17) then begin
         if pogoda.dziura=3 then begin
            pogoda.dziura:=0;
            fillchar(scr2^,maxx*20,7);
            mem2xms(scr2^,_xms[1].h,offsety[2]+512000,maxx*20);
         end else begin
            pogoda.dziura:=3;
            fillchar(scr2^,maxx*20,0);
            mem2xms(scr2^,_xms[1].h,offsety[2]+512000,maxx*20);
         end;
         nowy_tultip('LAWA');
      end;
      if mysz_w(164,199-ekr.menuwys+3,178,199-ekr.menuwys+17) then begin
         if pogoda.dziura=4 then begin
            pogoda.dziura:=0;
            fillchar(scr2^,maxx*20,7);
            mem2xms(scr2^,_xms[1].h,offsety[2]+512000,maxx*20);
         end else begin
            pogoda.dziura:=4;
            fillchar(scr2^,maxx*20,0);
            mem2xms(scr2^,_xms[1].h,offsety[2]+512000,maxx*20);
            for a:=1 to maxbom do bom^[a].jest:=false;
         end;
         nowy_tultip('KWAS');
      end;
     END;
      if mysz_w(182,199-ekr.menuwys+3,196,199-ekr.menuwys+17) then begin
         pogoda.szalency:=not pogoda.szalency;
         nowy_tultip('SZALEnCY');
      end;
      if mysz_w(200,199-ekr.menuwys+3,214,199-ekr.menuwys+17) then begin
         kfg.bijasie:=not kfg.bijasie;
         nowy_tultip('BICIE SIe');
      end;
      if mysz_w(3,199-ekr.menuwys+31,19,199-ekr.menuwys+39) then begin
         pogoda.autowiatr:=not pogoda.autowiatr;
         nowy_tultip('AUTOMATYCZNE USTAWIANIE WIATRU');
      end;
      if mysz_w(129,199-ekr.menuwys+31,145,199-ekr.menuwys+39) then begin
         pogoda.autoopady:=not pogoda.autoopady;
         nowy_tultip('AUTOMATYCZNE USTAWIANIE OPADoW');
      end;
   end;
   end;
  5:begin {glowne menu}
   if klik[1] then begin
      for a:=0 to 4 do {zmienianie max post w kazdej z grup}
         if mysz_w(3+a*26,199-ekr.menuwys+22,24+a*26,199-ekr.menuwys+35) and
            (grupy[0].maxpost+grupy[1].maxpost+grupy[2].maxpost+
             grupy[3].maxpost+grupy[4].maxpost<maxpost) then inc(grupy[a].maxpost);
      for a:=0 to 4 do {ustawienia wylotu}
         if mysz_w(3+a*26,199-ekr.menuwys+5,24+a*26,199-ekr.menuwys+20) then begin
            ekr.opcja_menu:=a+1;
            nowy_tultip('GRUPA '+l2t(a+1,1));
         end;
      for a:=0 to 4 do {zmiana pozycji wylotu}
         if mysz_w(20+a*26,199-ekr.menuwys+8,24+a*26,199-ekr.menuwys+15) then begin
            grupy[a].wylot:=not grupy[a].wylot;
            if grupy[a].wylot then celow.opcja:=a+1
                              else celow.opcja:=0;
            nowy_tultip('WYLOT GRUPY '+l2t(a+1,1));
         end;

      {zmiana ustawien grupy}
      if (mysz_w(129,199-ekr.menuwys,319,199)) and (ekr.opcja_menu>=1) and (ekr.opcja_menu<=5) then begin
         b:=1;
         if mysz_w(135,199-ekr.menuwys+3,149,199-ekr.menuwys+17) then begin
            inc(grupy[ekr.opcja_menu-1].corobi);
            if grupy[ekr.opcja_menu-1].corobi>5 then grupy[ekr.opcja_menu-1].corobi:=0;
            b:=0;
            nowy_tultip('CO BeDZIE ROBIc');
         end else
         if mysz_w(153,199-ekr.menuwys+3,167,199-ekr.menuwys+17) then begin
            inc(grupy[ekr.opcja_menu-1].kierunek);
            if grupy[ekr.opcja_menu-1].kierunek>1 then grupy[ekr.opcja_menu-1].kierunek:=-1;
            b:=0;
            nowy_tultip('KIERUNEK');
         end else
         if mysz_w(171,199-ekr.menuwys+3,207,199-ekr.menuwys+17) then begin
            if grupy[ekr.opcja_menu-1].sila=990 then grupy[ekr.opcja_menu-1].sila:=999 else
               inc(grupy[ekr.opcja_menu-1].sila,10);
            if grupy[ekr.opcja_menu-1].sila>999 then grupy[ekr.opcja_menu-1].sila:=20;
            b:=0;
            nowy_tultip('SIlA');
         end else
         if mysz_w(209,199-ekr.menuwys+3,223,199-ekr.menuwys+17) then begin
            grupy[ekr.opcja_menu-1].wolnawol:=not grupy[ekr.opcja_menu-1].wolnawol;
            b:=0;
            nowy_tultip('WOLNA WOLA');
         end else
         if mysz_w(227,199-ekr.menuwys+3,256,199-ekr.menuwys+17) then begin
            inc(grupy[ekr.opcja_menu-1].czestot);
            if grupy[ekr.opcja_menu-1].czestot>50 then grupy[ekr.opcja_menu-1].czestot:=0;
            b:=0;
            nowy_tultip('CZeSTOTLIWOsc');
         end else
         if mysz_w(258,199-ekr.menuwys+3,294,199-ekr.menuwys+17) then begin
            inc(grupy[ekr.opcja_menu-1].procent);
            if grupy[ekr.opcja_menu-1].procent>100 then grupy[ekr.opcja_menu-1].procent:=0;
            b:=0;
            nowy_tultip('MUSI ZOSTAc PROCENT ABY WYSZLI NASTePNI');
         end else
         if mysz_w(296,199-ekr.menuwys+3,310,199-ekr.menuwys+17) then begin
            grupy[ekr.opcja_menu-1].wyrzuca:=true;
            b:=0;
            nowy_tultip('POBUDZENIE WYCHODZENIA');
         end else
         for a:=0 to 4 do
             if (mysz_w(137+a*36,199-ekr.menuwys+22,166+a*36,199-ekr.menuwys+38)) then begin
                grupy[ekr.opcja_menu-1].bracia[a]:=not grupy[ekr.opcja_menu-1].bracia[a];
                b:=0;
                nowy_tultip('NASTAWIENIE DO GRUPY '+l2t(a+1,1));
             end;
         if b=1 then ekr.opcja_menu:=0;{klik poza kratkami - pokazuj liczniki}
      end;
   end;
   end;
 end;
if guzik[2] then
 case ekr.ktore_menu of
  2:begin {opcje postaci}
    if klik[2] then begin
      for b:=0 to 2 do
       if mysz_w(290+b*10,199-ekr.menuwys+6,294+b*10,199-ekr.menuwys+10) then begin{zaznaczenie grupy 0,2,4}
         for a:=1 to maxpost do
             if post^[a].grupa=b*2 then post^[a].zazn:=true
                else if not kl[29] then post^[a].zazn:=false;
         nowy_tultip('ZAZNACZONA GRUPA '+l2t(b*2+1,1));
       end;
      for b:=0 to 1 do
       if mysz_w(295+b*10,199-ekr.menuwys+11,299+b*10,199-ekr.menuwys+15) then begin{zaznaczenie grupy 1,3}
         for a:=1 to maxpost do
             if post^[a].grupa=1+b*2 then post^[a].zazn:=true
                else if not kl[29] then post^[a].zazn:=false;
         nowy_tultip('ZAZNACZONA GRUPA '+l2t(b*2+2,1));
       end;
    end;
    end;
  3:begin
    {ustawianie granic}
    if mysz_w(3,199-ekr.menuwys+20,124,199-ekr.menuwys+24) then begin
       pogoda.wtrgrp:=(mmx-63) div 2;
       if pogoda.wtrgrl>pogoda.wtrgrp then pogoda.wtrgrp:=pogoda.wtrgrl;
    end;
    if mysz_w(3,199-ekr.menuwys+25,124,199-ekr.menuwys+29) then begin
       pogoda.wtrgrl:=(mmx-63) div 2;
       if pogoda.wtrgrp<pogoda.wtrgrl then pogoda.wtrgrl:=pogoda.wtrgrp;
    end;

    if mysz_w(129,199-ekr.menuwys+20,228,199-ekr.menuwys+24) then begin
       pogoda.wlkopgrp:=(mmx-128) div 2;
       if pogoda.wlkopgrl>pogoda.wlkopgrp then pogoda.wlkopgrp:=pogoda.wlkopgrl;
    end;
    if mysz_w(129,199-ekr.menuwys+25,228,199-ekr.menuwys+29) then begin
       pogoda.wlkopgrl:=(mmx-128) div 2;
       if pogoda.wlkopgrp<pogoda.wlkopgrl then pogoda.wlkopgrl:=pogoda.wlkopgrp;
    end;
    end;
  5:begin {glowne menu}
   if klik[2] then begin
      for a:=0 to 4 do
         if mysz_w(3+a*26,199-ekr.menuwys+22,24+a*26,199-ekr.menuwys+35) and
            (grupy[a].maxpost>0) then dec(grupy[a].maxpost);
      if (mysz_w(129,199-ekr.menuwys,319,199)) and (ekr.opcja_menu>=1) and (ekr.opcja_menu<=5) then begin
         if mysz_w(135,199-ekr.menuwys+3,149,199-ekr.menuwys+17) then begin
            dec(grupy[ekr.opcja_menu-1].corobi);
            if grupy[ekr.opcja_menu-1].corobi<0 then grupy[ekr.opcja_menu-1].corobi:=5;
            nowy_tultip('CO BeDZIE ROBIc');
         end else
         if mysz_w(153,199-ekr.menuwys+3,167,199-ekr.menuwys+17) then begin
            dec(grupy[ekr.opcja_menu-1].kierunek);
            if grupy[ekr.opcja_menu-1].kierunek<-1 then grupy[ekr.opcja_menu-1].kierunek:=1;
            nowy_tultip('KIERUNEK');
         end else
         if mysz_w(171,199-ekr.menuwys+3,207,199-ekr.menuwys+17) then begin
            dec(grupy[ekr.opcja_menu-1].sila,10);
            if grupy[ekr.opcja_menu-1].sila<20 then grupy[ekr.opcja_menu-1].sila:=999;
            nowy_tultip('SIlA');
         end else
         if mysz_w(227,199-ekr.menuwys+3,256,199-ekr.menuwys+17) then begin
            dec(grupy[ekr.opcja_menu-1].czestot);
            if grupy[ekr.opcja_menu-1].czestot<0 then grupy[ekr.opcja_menu-1].czestot:=50;
            nowy_tultip('CZeSTOTLIWOsc');
         end else
         if mysz_w(258,199-ekr.menuwys+3,294,199-ekr.menuwys+17) then begin
            dec(grupy[ekr.opcja_menu-1].procent);
            if grupy[ekr.opcja_menu-1].procent<0 then grupy[ekr.opcja_menu-1].procent:=100;
            nowy_tultip('MUSI ZOSTAc PROCENT ABY WYSZLI NASTePNI');
         end else {klik poza kratkami - pokazuj liczniki}
            ekr.opcja_menu:=0;
      end;
   end;
   end;
 end;
end;

{*}PROCEDURE komentarze;
begin
with koment do begin
  if tx[0]<>'' then begin
    if kfg._co_klatke>=kfg.co_klatke then begin
       if kfg.gdziepodpisy=0 then pisz(m,1+ord(trybgry)*10,tx[0],0)
                             else pisz(m,192-ekr.menuwys,tx[0],0);
    end;
    if (m>160-trunc(length(tx[0])*3.5)) or ((m>-200) and (cz<=1)) then begin
       if (tx[1]<>'') then dec(m,30)
                      else dec(m,15);
    end;
    if (m<=160-trunc(length(tx[0])*3.5)) and (cz>1) then begin
       dec(cz);
       m:=160-trunc(length(tx[0])*3.5);
    end;
    if (tx[1]<>'') and (koment.cz>5) then koment.cz:=5;

    if m<=-200 then begin
       for a:=0 to 8 do tx[a]:=tx[a+1];
       tx[9]:='';
       cz:=100;
       m:=300;
    end;

  end;
end;
end;

{*}PROCEDURE tultipsy;
var k:byte;
begin
with tultip do begin
    if (cz>=1) and (kfg._co_klatke>=kfg.co_klatke) then begin
       piszm(x+1,y,tx,1);
       if cz>=8 then k:=23
                else k:=16+cz;

       piszm(x,y,tx,k);
    end;
    if cz>0 then dec(cz);
end;
end;

{*}PROCEDURE lupa_zumuj(sx,sy:integer);
var
x,y:longint;
lupa:array[-30..30] of record dx,dy:longint end;
begin
dispose(scr2);
new(lupapod);
for y:=-30 to 30 do
    move(scr^[sy+y,sx-30],lupapod^[y],61);
for y:=-30 to 30 do begin
    xms2mem(_xms[1].h,offsety[25]+(y+30)*500,lupa[-30],488);
    for x:=-30 to 30 do
        if (sy+y>=0) and (sy+y<=199-ekr.menuwys) and (sx+x>=0) and (sx+x<=319) then
           scr^[sy+y,sx+x]:=lupapod^[lupa[x].dx shr 10,lupa[x].dy shr 10];
end;
dispose(lupapod);
new(scr2)
end;

{*}PROCEDURE lupa_oblicz;
var
x,y:longint;
znieksz,pow:integer;
lupa:array[-30..30] of record dx,dy:longint end;
begin
znieksz:=125-ust_broni.lupa.znieksztalcenie;
pow:=27-ust_broni.lupa.powiekszenie;

for y:=-30 to 30 do begin
    for x:=-30 to 30 do begin
        if sqrt(sqr(x)+sqr(y))<=31 then begin
           lupa[x].dy:=trunc((sin(x/30)/cos(y/znieksz)*
                          pow*ust_broni.lupa.odwracax)*1024);
           lupa[x].dx:=trunc((sin(y/30)/cos(x/znieksz)*
                          pow*ust_broni.lupa.odwracay)*1024);
        end else begin
           lupa[x].dy:=x*1024;
           lupa[x].dx:=y*1024;
        end;
    end;
    mem2xms(lupa[-30],_xms[1].h,offsety[25]+(y+30)*500,488);
end;
end;

{*}PROCEDURE woda;
var
buf:array[0..maxx-1] of byte;
y,p1,px:integer;
begin
for y:=pogoda.pozwody-ekr.wy+1 to 399-ekr.wy do
    if (y>=0) and (y<200-ekr.menuwys) then begin
       px:=(zmiana[5] div 10+(y+zmiana[5]) div 5) mod 2;
       bartp(0,y,318,y,px,168,scr^,chmur^);
       scr^[y,319]:=chmur^[scr^[y,319],168];
    end;

if pogoda.pozwody-ekr.wy<=199-ekr.menuwys then begin
   if piorun_w_wode=0 then
      for y:=0 to 319 do
          scr^[pogoda.pozwody-ekr.wy,y]:=chmur^[scr^[pogoda.pozwody-ekr.wy,y],168+random(8)]
      else
      for y:=0 to 319 do
          scr^[pogoda.pozwody-ekr.wy,y]:=chmur^[scr^[pogoda.pozwody-ekr.wy,y],58+piorun_w_wode+random(2)]
end;
end;

{*}PROCEDURE bombelki;
const
ob:array[0..3,1..2,0..1] of shortint=
   ((( 1, 0),( 0,-1)),
    (( 0, 1),( 1, 0)),
    ((-1, 0),( 0, 1)),
    (( 0,-1),(-1, 0)));
var
_x,_y:longint;
buf:array[-1..1] of byte;
begin
for a:=1 to maxbom do begin
    if bom^[a].jest then begin
       with bom^[a] do begin
         IF NOT PAUZA THEN BEGIN
          x:=x+random(1024)-512;
          y:=y+longint(dy);
          if dy>-1024 then dy:=dy-50;
          if (x<0) or (x>maxx1) or (y shr 10<pogoda.pozwody+1) then jest:=false;
         END;
          _x:=longint(x) shr 10-ekr.x;
          _y:=longint(y) shr 10-ekr.wy;
          putpixT(_x,_y,62);
       end;
    end;
end;
end;

{*}PROCEDURE lawa;
var
buf:array[0..maxx-1] of byte;
y1,y,p1:integer;
bo:boolean;
b:byte;
begin
bart(0,pogoda.pozwody-ekr.wy+4, 319,399-ekr.wy,15,scr^,chmur^);

for y1:=pogoda.pozwody-ekr.wy to pogoda.pozwody-ekr.wy+3 do
    if pogoda.pozwody-ekr.wy<=199-ekr.menuwys then
       for y:=0 to 319 do
           scr^[y1,y]:=chmur^[scr^[y1,y],96+random(7-(y1-(pogoda.pozwody-ekr.wy)))];

IF NOT PAUZA THEN BEGIN
if random(2)=0 then begin
   bo:=true;
   b:=random(2)*3;
end else begin
   bo:=false;
   b:=0;
end;
nowysyf(random(maxx),pogoda.pozwody,random/2-0.25,-random,
        199,0,bo,20-random(10),random(3),b);
END;
end;

{*}PROCEDURE kwas;
var
buf:array[0..maxx-1] of byte;
y,p1,px:integer;
begin
for y:=pogoda.pozwody-ekr.wy+1 to 399-ekr.wy do
    if (y>=0) and (y<200-ekr.menuwys) then begin
       px:=(zmiana[5] div 10+(y+zmiana[5]) div 5) mod 2;
       bartp(0,y,318,y,px,20,scr^,chmur^);
       scr^[y,319]:=chmur^[scr^[y,319],20];
    end;

if pogoda.pozwody-ekr.wy<=199-ekr.menuwys then begin
   if piorun_w_wode=0 then
      for y:=0 to 319 do
          scr^[pogoda.pozwody-ekr.wy,y]:=chmur^[scr^[pogoda.pozwody-ekr.wy,y],200+random(7)]
   else
      for y:=0 to 319 do
          scr^[pogoda.pozwody-ekr.wy,y]:=chmur^[scr^[pogoda.pozwody-ekr.wy,y],74+piorun_w_wode+random(2)]
end;

end;

{*}PROCEDURE paczki;
const bool:array[0..1] of boolean=(false,true);
var
_x,_y:longint;
a2,b,c,ko,d:integer;
buf:array[-5..10] of byte;
dzwk:boolean;
s1,s2:single;
begin
for a:=1 to maxpacz do begin
 if pacz^[a].jest then begin
   if (pacz^[a].dy<3000) then pacz^[a].dy:=pacz^[a].dy+60;
   for ko:=pacz^[a].dy div 1024 downto 0 do
    if pacz^[a].jest then begin
       with pacz^[a] do begin
         IF NOT PAUZA THEN BEGIN
          if ko=0 then y:=y+longint(dy) mod 1024
                  else y:=y+1024;

          if dy>=300 then begin {sprawdz kolizje z postaciami}
             for b:=maxpost downto 1 do
                if (post^[b].jest) and
                   (post^[b].x>=x shr 10-9) and
                   (post^[b].x<=x shr 10+10) and
                   (post^[b].y>=y shr 10-5) and
                   (post^[b].y<=y shr 10+13) and
                   (post^[b].sila>0) then begin
                      post^[b].sila:=-3;
                      inc(punkty,40);
                   end;
             for b:=maxmin downto 1 do {...i minami}
                if (min^[b].jest) and
                   (min^[b].x shr 10>=x shr 10-7) and
                   (min^[b].x shr 10<=x shr 10+7) and
                   (min^[b].y shr 10>=y shr 10-5) and
                   (min^[b].y shr 10<=y shr 10+10) and
                   (min^[b].czas>=0) then
                     min^[b].czas:=1+random(6);
          end;

          {sprawdz co jest pod nim}
          if (y+4096<=maxy1a) and (y+4096>=0) then begin
             xms2mem(_xms[1].h,offsety[2]+(y shr 10+4)*maxx+x shr 10-5,buf,12);
             if x-5120<0 then fillchar(buf,abs((x-5120) div 1024),0);
             if x+5120>maxx1 then fillchar(buf[maxx-1-x shr 10],5-(maxx-1-x shr 10),0);
          end
             else begin
                if pogoda.dziura=0 then fillchar2(buf,10,1)
                                   else fillchar2(buf,10,0);
             end;
          c:=0;
          for b:=-5 to 4 do if buf[b]>0 then inc(c);

          if pogoda.dziura>=2 then begin
             if (dy>=400) and
                (y shr 10>pogoda.pozwody-5) and (y shr 10<pogoda.pozwody+5) then begin
                plum(x shr 10,10,6,0,1.2);
                if (pogoda.dziura in [3,4]) and (zmiana[2]=0) then
                   nowydym(x shr 10-5+random(10),pogoda.pozwody-1,4+random(4),random(3));
             end;
             if (dy>=400) and (y shr 10>=pogoda.pozwody+5) and (y shr 10<=pogoda.pozwody+7) then
                plum(x shr 10,10,20,0,1.4);
             if (y shr 10>pogoda.pozwody-5) then begin
                if (y shr 10>395) then c:=0;
                if (zmiana[1]=0) and (abs(dy)>1024) then dy:=dy div 2;
                if (dy>=512) and (zmiana[2]=0) then nowybom(x shr 10-5+random(10),y shr 10+5);
             end;
          end;

          if (y>maxy1+10000) and (not trzymany) then jest:=false;

          dzwk:=false;
          if c>=5 then begin
             if ko=0 then y:=y-longint(dy) mod 1024
                     else y:=y-1024;
             dy:=dy div 2;
             dzwk:=true;
          end else if abs(dy)>400 then begin
              for b:=-5 to 4 do
                 if buf[b]>0 then begin
                    putpix_x(x shr 10+b,y shr 10+4,0);
                    nowysyf(x shr 10+b,y shr 10+4,random*2-1,random*2-1,buf[b],2,true,0,0,0);
                 end;
              end;

          for a2:=1 to maxpacz do
              if (a<>a2) and (pacz^[a2].jest) and
                 (x>=pacz^[a2].x-9 shl 10) and
                 (x<=pacz^[a2].x+9 shl 10) and
                 (y>=pacz^[a2].y-10 shl 10) and
                 (y<=pacz^[a2].y) then begin
                 if (stal=0) and (abs(dy)>212) and
                    ((pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y<longint(pogoda.pozwody) shl 10))) then begin
                    StartSound(Sound[44], false,6,8);
                    stal:=20;
                 end;
                 if ko=0 then y:=y-longint(dy) mod 1024
                         else y:=y-1024;
                 dy:=dy div 2;
                 dzwk:=true;
                 a2:=maxpacz;
              end;

          if (not dzwk) and (stal>0) then dec(stal);
          if (dzwk) and (stal=0) and (abs(dy)>212) and
             ((pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y<longint(pogoda.pozwody) shl 10))) then begin
             StartSound(Sound[44], false,6,8);
             stal:=20;
          end;

          if rozwalasie then begin
             StartSound(Sound[43], false,6,8);
             for b:=0 to 29 do
             nowysyf(x shr 10-5+random(10),y shr 10-5+random(10),
                     _sin(trunc(b*12))*(1+random/2),
                     _cos(trunc(b*12))*(1+random/2),
                     random(3)+41,2,true,0,0,random(3));
             case rodz of
               {0 - nic, pusta}
               1: {pulapka-rozwala sie na kawalki i wybucha}
                for b:=0 to 5 do
                strzal(x shr 10,y shr 10,
                       random*2-1,
                       random*2-1,
                       0,7,0,0);
               2..5:{rybki itp}
                for b:=0 to 4+random(15) do
                    nowezwi(x shr 10,y shr 10,
                            random-0.5,random-0.5,
                            rodz-2);
               6: {pulapka-mina}
                 nowamina(x shr 10,y shr 10,0,0,bool[random(2)]);
               7: {pulapka-wielkie bum}
                 wybuch(x shr 10,y shr 10,random(20)+5,true,true,false,bool[random(2)],true);
               8: {pulapka-petardy}
                for b:=0 to 5 do
                strzal(x shr 10,y shr 10,
                       random*2-1,
                       random*2-1,
                       2,4+random(10),7,5+random(15));
               9:begin {bonus-lekkie postaci}
                 inc(bonusy.lekkiepost,40);
                 nowy_kom('*BONUS* LEKKIE POSTACI');
                 end;
               10:begin {bonus-postaci przyklejone do ziemi}
                 inc(bonusy.przyklejpost,40);
                 nowy_kom('*BONUS* POSTACI PRZYKLEJONE DO ZIEMI');
                 end;
               11..14: {pilki,cegly lub jablka}
                for b:=0 to 4+random(15) do
                    nowemieso(x shr 10,y shr 10,
                              random-0.5,random-0.5,
                              89+rodz,false);
               15:begin {bonus-panika}
                 inc(bonusy.panika,40);
                 nowy_kom('*BONUS* PANIKA');
                 end;
               16:begin {bonus-pinball}
                 inc(bonusy.pinball,40);
                 nowy_kom('*BONUS* ODBIJANKA');
                 end;
               17:begin {bonus-ciezcy}
                 inc(bonusy.ciezkopost,40);
                 nowy_kom('*BONUS* CIezKIE POSTACI');
                 end;
               18:begin {bonus-spokojni}
                 inc(bonusy.spokojni,40);
                 nowy_kom('*BONUS* SPOKoJ');
                 end;
               19:begin {zwloki}
                  b:=random(5);
                  for a:=0 to 5 do
                      nowemieso(x shr 10+czescipoz[a].x,y shr 10+czescipoz[a].y,
                                random/2-0.25,random/2-0.25,
                                czesci[a]+b*4,false);
                  end;
               20:begin {pulapka-mega bum z odlamkami}
                  for b:=0 to 9 do
                      wybuch(x shr 10-10+random(20),y shr 10-10+random(20),random(17)+7,true,true,false,false,true);
                  for b:=0 to 9 do strzal(x shr 10,y shr 10,
                                          random*3-1.5,
                                          random*3-1.5,
                                          0,7,0,0);
                  for b:=0 to 19 do nowywyb(x shr 10-25+random(50),y shr 10-25+random(50),
                                           5,random(2));
                  for b:=0 to 19 do nowydym(x shr 10-10+random(20),y shr 10-10+random(20),
                                           5,random(3));
                  end;
               21:begin {kolorowe syfki}
                  s1:=random*2+0.5;
                  s2:=random*3+1.5;
                  c:=100+random(150);
                  d:=random(64);
                  for b:=0 to c do
                      nowysyf(x shr 10,y shr 10,
                              _sin(trunc(b*(360/c)))*(random*s1),
                              _cos(trunc(b*(360/c)))*(random*s2),
                              kolter[d+random(3)],
                              2,
                              true,
                              0,
                              0,
                              0+random(2));
                  end;
             end;
             jest:=false;
             inc(stats.paczzebr);
          end;
         END;
          _x:=longint(x) shr 10-ekr.x;
          _y:=longint(y) shr 10-ekr.y;
          if (ko=0) or (not jest) then
             MaskPicXMS(_x-5,_y-5,10,10,0,offsety[22]+longint(wygl)*100,scr^,1,false);
       end;
    end;
 end;
end;

end;

{*}PROCEDURE sprawdzaj_bonusy;
var yy:integer;
begin
yy:=20;
with bonusy do begin
   if lekkiepost>0 then begin
      if lekkiepost>999 then lekkiepost:=999;
      MaskPicXMS(1,yy,25,13,0,offsety[23],scr^,1,false);
      piszm(13,yy+2,l2t(lekkiepost,3),23);
      if (klik[2]) and (mysz_w(15,yy+7,21,yy+11)) then begin lekkiepost:=0;klik[2]:=false end;
      inc(yy,15);
   end;
   if ciezkopost>0 then begin
      if ciezkopost>999 then ciezkopost:=999;
      MaskPicXMS(1,yy,25,13,0,offsety[23]+1300,scr^,1,false);
      piszm(13,yy+2,l2t(ciezkopost,3),23);
      if (klik[2]) and (mysz_w(15,yy+7,21,yy+11)) then begin ciezkopost:=0;klik[2]:=false end;
      inc(yy,15);
   end;
   if przyklejpost>0 then begin
      if przyklejpost>999 then przyklejpost:=999;
      MaskPicXMS(1,yy,25,13,0,offsety[23]+325,scr^,1,false);
      piszm(13,yy+2,l2t(przyklejpost,3),23);
      if (klik[2]) and (mysz_w(15,yy+7,21,yy+11)) then begin przyklejpost:=0;klik[2]:=false end;
      inc(yy,15);
   end;
   if panika>0 then begin
      if panika>999 then panika:=999;
      MaskPicXMS(1,yy,25,13,0,offsety[23]+650,scr^,1,false);
      piszm(13,yy+2,l2t(panika,3),23);
      if (klik[2]) and (mysz_w(15,yy+7,21,yy+11)) then begin panika:=0;klik[2]:=false end;
      inc(yy,15);
   end;
   if spokojni>0 then begin
      if spokojni>999 then spokojni:=999;
      MaskPicXMS(1,yy,25,13,0,offsety[23]+1625,scr^,1,false);
      piszm(13,yy+2,l2t(spokojni,3),23);
      if (klik[2]) and (mysz_w(15,yy+7,21,yy+11)) then begin spokojni:=0;klik[2]:=false end;
      inc(yy,15);
   end;
   if pinball>0 then begin
      if pinball>999 then pinball:=999;
      MaskPicXMS(1,yy,25,13,0,offsety[23]+975,scr^,1,false);
      piszm(13,yy+2,l2t(pinball,3),23);
      if (klik[2]) and (mysz_w(15,yy+7,21,yy+11)) then begin pinball:=0;klik[2]:=false end;
      inc(yy,15);
   end;

   if (NOT PAUZA) AND (zmiana[5]=0) and (zmiana[1]=0) then begin
      if lekkiepost>0 then dec(lekkiepost);
      if ciezkopost>0 then dec(ciezkopost);
      if przyklejpost>0 then dec(przyklejpost);
      if panika>0 then dec(panika);
      if spokojni>0 then dec(spokojni);
      if pinball>0 then dec(pinball);
   end;
end;
end;

end.