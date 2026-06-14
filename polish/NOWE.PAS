unit nowe;

interface
{$N+}
{*}PROCEDURE nowy_kom(tekst:string);
{*}PROCEDURE komentarz_po_trupach(licz:integer);
{*}PROCEDURE zlosliwe_komentarze;
{*}PROCEDURE nowy_tultip(tekst:string);
{*}PROCEDURE nowysyf(sx,sy:integer;sdx,sdy:real;skol,skon:byte;sgraw:boolean;sczas:word;siskr,srozm:byte);
{*}PROCEDURE nowybom(sx,sy:integer);
{*}PROCEDURE nowydym(sx,sy,sani,swygl:integer);
{*}PROCEDURE nowywyb(sx,sy,sani,swygl:integer);
{*}PROCEDURE strzal(sx,sy:integer;sdx,sdy:real;srodz,ssila,swygl,sczas:byte);
{*}PROCEDURE nowamina(sx,sy:integer;sdx,sdy:real;zepsuta:boolean);
{*}PROCEDURE nowemieso(sx,sy:integer;sdx,sdy:real;srodz:byte;pali:boolean);
{*}PROCEDURE nowekowadlo(sx,sy:integer);
{*}PROCEDURE nowapaczka(ppx,ppy:longint;jaka:integer);
{*}PROCEDURE nowezwi(sx,sy:integer;sdx,sdy:real;srodz:byte);


implementation
uses crt,vars,glowne,dos,xms,maskp,myszunit,cosin,dzwieki2,SMix;

{*}PROCEDURE nowy_kom(tekst:string);
var a:byte;
begin
for a:=0 to 9 do
    if koment.tx[a]='' then begin
       koment.tx[a]:=tekst;
       a:=9;
    end;
end;

{*}PROCEDURE komentarz_po_trupach(licz:integer);
var _mmx,_mmy:integer;
begin
case licz of
 1:case random(12) of
    0:nowy_kom('DIE MOTHERFUCKER, DIE, DIE!');
    1:nowy_kom('DOSTAWA sWIEzEGO MIeSKA');
    2:nowy_kom('MLASK');
    3:nowy_kom('ROZERWIJ SIe!');
    4:nowy_kom('DIE DIRTY BASTARD!');
    5:nowy_kom('BINGO!');
    6:nowy_kom('BLAAAADI!');
    7:nowy_kom('ALE SlODKO!');
    8:nowy_kom('MNIAM MNIAM MNIAM');
    9:nowy_kom('MAlPI MozDzEK NA PATYKU');
   10:nowy_kom('ALE ZABAWA!');
   11:nowy_kom('ZJEDZ MNIE');
   end;
 2:begin
   case random(2) of
    0:nowy_kom('CO DWIE GlOWY TO NIE JEDNA!');
    1:nowy_kom('HAHAHA TO DUET!');
   end;
   if kfg.glospana then startsound(sound[30+random(3)],false,0,0);
   end;
 3:begin
   case random(4) of
    0:nowy_kom('MAM COs CZERWONEGO NA OKULARACH...');
    1:nowy_kom('CUUUDNIE!');
    2:nowy_kom('OOOOOHYDA! HAHAHA');
    3:nowy_kom('TRIO');
   end;
   if kfg.glospana then startsound(sound[31+random(2)*3],false,0,0);
   end;
 4:begin
   case random(3) of
    0:nowy_kom('KWARTET');
    1:nowy_kom('TO BYlO REWELACYJNE!');
    2:nowy_kom('CZTERECH PANCERNYCH...');
   end;
   if kfg.glospana then startsound(sound[32+random(2)*3],false,0,0);
   end;
 5:begin
   case random(3) of
    0:nowy_kom('PRAWDZIWY KWINTET');
    1:nowy_kom('ZAGRAJMY W PIeCIU');
    2:nowy_kom('O PIec GloW MNIEJ');
   end;
   if kfg.glospana then begin
     case random(3) of
      0:b:=32;
      1:b:=33;
      2:b:=36;
     end;
     startsound(sound[b],false,0,0);
   end;
   end;
 ELSE
   begin
   case random(7) of
    0:nowy_kom('KREW MNIE ZALAlA');
    1:nowy_kom('MNIAM MNIAM');
    2:nowy_kom('MNoSTWO MIeSKA');
    3:nowy_kom('MIeSKO DLA CAlEJ RODZINY');
    4:nowy_kom('PASZTET DOMOWY');
    5:nowy_kom('HEKTOLITRY KRWI');
    6:nowy_kom('JESTEs WSPANIAlY');
   end;
   if kfg.glospana then begin
     case random(3) of
      0:b:=32;
      1:b:=33;
      2:b:=36;
     end;
     startsound(sound[b],false,0,0);
   end;
   end;
end;
if licz>=2 then begin
   _mmx:=mmx;
   _mmy:=mmy;

   wyr:=l2t(licz,0)+'X KOMBO!';
   mmy:=90;
   mmx:=160-length(wyr)*2;
   nowy_tultip(wyr);

   mmx:=_mmx;
   mmy:=_mmy;
end;
end;

{*}PROCEDURE zlosliwe_komentarze;
begin
if zmiana[4]=0 then begin
   inc(czasbezstrz);
   if (czasbezstrz>=50) and (random(50)=0) then begin
      case random(15) of
       0:nowy_kom('NO! NA CO CZEKASZ?');
       1:nowy_kom('STRZELAJ, NIE zAlUJ!');
       2:nowy_kom('BOISZ SIe STRZELIc?');
       3:nowy_kom('NO, WAL!');
       4:nowy_kom('CZEKASZ NA ZBAWIENIE?');
       5:nowy_kom('CO TAM ROBISZ?');
       6:nowy_kom('DLACZEGO NIE ZABIJASZ?');
       7:nowy_kom('ZABIJ.... ZABIJ....');
       8:nowy_kom('SUMIENIE CIe RUSZYlO?');
       9:nowy_kom('TERAZ STRZELAJ!');
      10:nowy_kom('PAMIeTAJ - BY zYc, MUSISZ ZABIJAc!');
      11:nowy_kom('URODZONY BY MORDOWAc');
      12:nowy_kom('NIE LITUJ SIe NAD NIMI, ZABIJ ICH!');
      13:nowy_kom('SPRAWDx, JAK lADNIE Z NICH LEJE SIe KREW');
      14:nowy_kom('PATRZ, ONI SAMI SIe PROSZa BY ICH ZABIc');
      end;
      czasbezstrz:=30;
   end;
   if (wystrzelone>=50) and (random(20)=0) then begin
      case random(10) of
       0:nowy_kom('HAHAHA! PATRZ W CO STRZELASZ!');
       1:nowy_kom('MASZ ZEZA CZY CO?');
       2:nowy_kom('W CO TY CELUJESZ?');
       3:nowy_kom('NIE MOzESZ SOBIE TRAFIc?');
       4:nowy_kom('TRZEBA BYlO TYLE NIE PIc :)');
       5:nowy_kom('SRZELASZ GORZEJ NIz BABA!');
       6:nowy_kom('PATRZ, NAWET ONI SIe Z CIEBIE sMIEJa');
       7:nowy_kom('NAWET STRZELAc NIE POTRAFISZ!');
       8:nowy_kom('JESTEs CIENKI JAK SIK PAJaKA!');
       9:nowy_kom('MARNY Z CIEBIE MYsLIWY');
      end;
      wystrzelone:=35;
   end;
end;

end;

{*}PROCEDURE nowy_tultip(tekst:string);
var a:byte;
begin
if kfg.tultips then
 with tultip do begin
   tx:=tekst;
   x:=mmx;
   if x<0 then x:=0;
   if x>319-length(tekst)*4 then x:=319-length(tekst)*4;
   y:=mmy-7;
   if y<=2 then y:=mmy+7;
   cz:=50;
 end;
end;

{*}PROCEDURE nowysyf(sx,sy:integer;sdx,sdy:real;skol,skon:byte;sgraw:boolean;
              sczas:word;siskr,srozm:byte);
var a,b:integer;
begin
IF (kfg.syfki) and (not full.syf) and (sx>=0) and (sx<maxx) and (sy<maxy) then begin
b:=-1;
for a:=1 to maxsyf do if not syf^[a].jest then begin b:=a;a:=maxsyf;end;
if b>=1 then with syf^[b] do begin
   x:=longint(sx) shl 10+512;
   y:=longint(sy) shl 10+512;
   dx:=trunc(sdx*1024) ;
   dy:=trunc(sdy*1024) ;
   kol:=skol;
   jakkonczy:=skon;
   graw:=sgraw;
   czas:=sczas;
   rozm:=srozm;
   szybiskr:=siskr;
   obr:=random(4);
   jest:=true;
end else full.syf:=true;
END;
end;

{*}PROCEDURE nowybom(sx,sy:integer);
var a,b:integer;
begin
IF (kfg.bomble) and (sx>=0) and (sx<maxx) and (sy>=pogoda.pozwody) then begin
b:=-1;
if not full.bom then
   for a:=1 to maxbom do if not bom^[a].jest then begin b:=a;a:=maxbom;end;
if b=-1 then begin
   b:=random(maxbom)+1;
   full.bom:=true;
end;

with bom^[b] do begin
   x:=longint(sx) shl 10;
   y:=longint(sy) shl 10;
   dy:=-random(500);
   jest:=true;
end;
END;
end;

{*}PROCEDURE nowydym(sx,sy,sani,swygl:integer);
var a,b:integer;
begin
IF (kfg.dym_wyb) then BEGIN
b:=-1;
if not full.dym then
   for a:=1 to maxdym do if not dym^[a].jest then begin b:=a;a:=maxdym;end;
if b=-1 then begin
   b:=random(maxdym)+1;
   full.dym:=true;
end;
if b>=1 then with dym^[b] do begin
   jest:=true;
   x:=longint(sx) shl 10;
   y:=sy;
   ani:=sani;
   doani:=3+random(4);
   wygl:=swygl;
end;
END;
end;

{*}PROCEDURE nowywyb(sx,sy,sani,swygl:integer);
var a,b:integer;
begin
IF (kfg.dym_wyb) and (not full.wyb) then BEGIN
b:=-1;
for a:=1 to maxwyb do if not wyb^[a].jest then begin b:=a;a:=maxwyb;end;
if b=-1 then b:=random(maxwyb)+1;
if b>=1 then with wyb^[b] do begin
   jest:=true;
   x:=sx;
   y:=sy;
   ani:=sani;
   wygl:=swygl;
end else full.wyb:=true;
END;
end;

{*}PROCEDURE strzal(sx,sy:integer;sdx,sdy:real;srodz,ssila,swygl,sczas:byte);
var a,b:integer;
begin
b:=-1;
for a:=1 to maxpoc do if not poc^[a].jest then begin b:=a;a:=maxpoc;end;
if b>=1 then with poc^[b] do begin
   jest:=true;
   x:=longint(sx) shl 10;
   y:=longint(sy) shl 10;
   dx:=trunc(sdx*1024) ;
   dy:=trunc(sdy*1024) ;
   rodz:=srodz;
   wygl:=swygl;
   czas:=sczas;
   ostkier:=random(8);
   sila:=ssila;
   trzyma_go:=0;
   case swygl of
      1,8:inc(stats.rakiety);
      2:inc(stats.granaty);
      3:inc(stats.bomby);
      6:inc(stats.kulaog);
      7:inc(stats.dynamity);
      4:inc(stats.pociski);
   end;
end;
end;

{*}PROCEDURE nowamina(sx,sy:integer;sdx,sdy:real;zepsuta:boolean);
var a,b:integer;
begin
b:=-1;
for a:=1 to maxmin do if not min^[a].jest then begin b:=a;a:=maxmin;end;
if b>=1 then with min^[b] do begin
   jest:=true;
   x:=longint(sx) shl 10;
   y:=longint(sy) shl 10;
   dx:=trunc(sdx*1024) ;
   dy:=trunc(sdy*1024) ;
   if zepsuta then czas:=-1 else czas:=0;
   ostkier:=random(8);
   inc(stats.miny);
end;
end;

{*}PROCEDURE nowemieso(sx,sy:integer;sdx,sdy:real;srodz:byte;pali:boolean);
var a,b:integer;
{pl:text;}
begin
IF (kfg.miecho) and (not full.mies) then BEGIN
{assign(pl,'mieso.log');
rewrite(pl);
writeln(pl,'sx:',sx);
writeln(pl,'sy:',sy);
writeln(pl,'sdx:',sdx:40:20);
writeln(pl,'sdy:',sdy:40:20);
writeln(pl,'srodz:',srodz);
writeln(pl,'pali:',pali);
close(pl);}
if (kfg.dzieci) and (srodz<100) then exit;
b:=-1;
for a:=1 to maxmies do if not mies^[a].jest then begin b:=a;a:=maxmies;end;
if b>=1 then with mies^[b] do begin
   x:=longint(sx) shl 10;
   y:=longint(sy) shl 10;
   dx:=trunc(sdx*1024) ;
   dy:=trunc(sdy*1024) ;
   rodz:=srodz;
   obr:=random(4);
   jest:=true;
   trzyma_go:=0;
   krew:=385+random(15);
   palisie:=pali;
end else full.mies:=true;
END;
end;

{*}PROCEDURE nowekowadlo(sx,sy:integer);
var a,b:integer;
begin
b:=-1;
for a:=1 to maxkow do if not kow^[a].jest then begin b:=a;a:=maxkow;end;
if b>=1 then with kow^[b] do begin
   x:=longint(sx) shl 10;
   y:=longint(sy) shl 10;
   dy:=0;
   jest:=true;
   stal:=0;
   stoi:=2;
   inc(stats.kowadla);
end;
end;

{*}PROCEDURE nowapaczka(ppx,ppy:longint;jaka:integer);
const
rodzaje_bon:array[0..5] of byte=(9,10,15,16,17,18);
rodzaje_pul:array[0..4] of byte=(1,6,7,8,20);
rodzaje_inn:array[0..9] of byte=(2,3,4,5,11,12,13,14,19,21);
var
rodzaje_ilosci:array[0..2] of byte;

a,b,c,
sx,sy,gdzie:integer;
buf:array[0..10] of byte;
niemoze:boolean;
begin
rodzaje_ilosci[0]:=sizeof(rodzaje_bon);
rodzaje_ilosci[1]:=sizeof(rodzaje_pul);
rodzaje_ilosci[2]:=sizeof(rodzaje_inn);

if kfg.paczkiwziemi then gdzie:=random(2)
                    else gdzie:=0;
b:=0;
for a:=1 to maxpacz do if pacz^[a].jest then inc(b);
if b>=maxpacz div 2 then gdzie:=0;

if (ppx>=0) then gdzie:=2;

if gdzie=1 then begin {pod ziemia}
   for b:=0 to 19 do begin
       niemoze:=false;
       sx:=random(maxx)-20+10;
       sy:=random(maxy)-20+10;
       for a:=0 to 9 do begin
           xms2mem(_xms[1].h,offsety[2]+(longint(sy)+longint(a)-5)*maxx+sx-5,buf,10);
           for c:=0 to 9 do if buf[c]=0 then begin c:=9;a:=9;niemoze:=true end;
       end;
       if not niemoze then b:=19;
   end;
   if (b=19) and (niemoze) then gdzie:=0;
end;
if gdzie=0 then begin {z gory}
   sx:=random(maxx);
   sy:=0
end;
if gdzie=2 then begin {z wskazanej pozycji}
   sx:=ppx;
   sy:=ppy;
   gdzie:=1
end;

b:=-1;
for a:=1 to maxpacz do if not pacz^[a].jest then begin b:=a;a:=maxpacz;end;
if (jaka=-1) and (not ust_broni.paczki.rodzaje[0]) and
   (not ust_broni.paczki.rodzaje[1]) and
   (not ust_broni.paczki.rodzaje[2]) then b:=-1;
if (b>=1) and (((gdzie=0) and (getpix_x(sx,sy)=0)) or (gdzie=1)) then
  with pacz^[b] do begin
   x:=longint(sx) shl 10;
   y:=longint(sy) shl 10;
   dy:=0;
   jest:=true;
   stal:=0;
   if jaka=-1 then begin
      repeat
        c:=random(3);
      until ust_broni.paczki.rodzaje[c];
      case c of
         0:rodz:=rodzaje_bon[random(rodzaje_ilosci[c])];
         1:rodz:=rodzaje_pul[random(rodzaje_ilosci[c])];
         2:rodz:=rodzaje_inn[random(rodzaje_ilosci[c])];
      end;
   end else begin
       case jaka of
         0:rodz:=rodzaje_bon[random(rodzaje_ilosci[jaka])];
         1:rodz:=rodzaje_pul[random(rodzaje_ilosci[jaka])];
         2:rodz:=rodzaje_inn[random(rodzaje_ilosci[jaka])];
          else rodz:=random(22);
       end;
   end;
   case random(70) of
     0..2:wygl:=random(2)+7;
        3:wygl:=9;
      else wygl:=random(7);
   end;
   trzymany:=false;
   rozwalasie:=false;
   if gdzie=0 then StartSound(Sound[19],false,1,1)
              else StartSound(Sound[44],false,1,1);
   inc(stats.paczbylo)
  end;
end;

{*}PROCEDURE nowezwi(sx,sy:integer;sdx,sdy:real;srodz:byte);
var a,b:integer;
begin
IF kfg.zwierz then BEGIN
b:=-1;
for a:=1 to maxzwi do if not zwi^[a].jest then begin b:=a;a:=maxzwi;end;
if b>=1 then with zwi^[b] do begin
   x:=longint(sx) shl 10;
   y:=longint(sy) shl 10;
   dx:=trunc(sdx*1024) ;
   dy:=trunc(sdy*1024) ;
   jest:=true;
   doani:=1;
   rodz:=srodz;
   corobi:=0;
   case rodz of
     0:begin {ptak1}
       ani:=random(6);
       sila:=20;
       end;
     1:begin {ptak2 (netoperek)}
       ani:=random(6);
       sila:=20;
       end;
     2:begin {rybka1}
       ani:=random(3);
       sila:=20;
       end;
     3:begin {rybka2 (pirania)}
       ani:=random(3);
       sila:=25;
       end;
   end;
end;
END;
end;

end.