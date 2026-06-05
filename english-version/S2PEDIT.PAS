uses crt,dos,vars;

const
naglowek:array[1..25] of char='Sadist II Zestaw postaci1';

paleta:array[0..255,0..2] of byte=(
( 0, 0, 0),( 9, 9, 9),(18,18,18),(27,27,27),(36,36,36),(45,45,45),(54,54,54),(63,63,63),
(12, 0, 0),(19, 0, 0),(26, 0, 0),(33, 0, 0),(41, 0, 0),(48, 0, 0),(55, 0, 0),(63, 0, 0),
( 0, 7, 0),( 0,15, 0),( 0,23, 0),( 0,31, 0),( 0,39, 0),( 0,47, 0),( 0,55, 0),( 0,63, 0),
( 0, 0,11),( 0, 0,18),( 0, 0,25),( 0, 0,33),( 0, 0,40),( 0, 0,48),( 0, 0,55),( 0, 0,63),
( 7, 7, 0),(15,15, 0),(23,23, 0),(31,31, 0),(39,39, 0),(47,47, 0),(55,55, 0),(63,63, 0),
(19, 4, 0),(25, 7, 1),(31,11, 2),(37,15, 3),(44,18, 5),(50,22, 6),(56,26, 7),(63,30, 8),
( 9, 0, 9),(15, 0,16),(21, 0,24),(27, 0,32),(33, 0,39),(39, 0,47),(45, 0,55),(51, 0,62),
( 6, 6,28),(13,13,33),(20,20,38),(27,27,43),(35,35,48),(42,42,53),(49,49,58),(57,57,63),
(20, 1, 1),(26, 4, 4),(32, 8, 8),(38,11,11),(44,15,15),(50,18,18),(56,22,22),(62,25,25),
( 1,14, 1),( 6,21, 6),(11,28,11),(16,35,16),(21,42,21),(26,49,26),(31,56,31),(36,63,36),
( 9, 9, 0),(16,16, 7),(24,24,14),(32,32,21),(39,39,28),(47,47,35),(55,55,42),(62,62,49),
(11, 3,11),(18,10,18),(25,18,25),(33,26,33),(40,33,40),(48,41,48),(55,49,55),(63,56,63),
(63, 0, 0),(63, 9, 0),(63,18, 0),(63,27, 0),(63,36, 0),(63,45, 0),(63,54, 0),(63,63, 0),
(63,14,14),(63,21,18),(63,28,23),(63,35,27),(63,42,32),(63,49,36),(63,56,41),(63,63,45),
( 4, 0,19),( 8, 0,25),(13, 0,31),(18, 0,37),(23, 0,43),(28, 0,49),(33, 0,55),(38, 0,61),
(17,17,17),(22,22,22),(27,27,27),(32,32,32),(37,37,37),(42,42,42),(47,47,47),(52,52,52),
(30, 0, 0),(20,21, 0),(10,42, 0),( 0,63, 0),( 0,47,15),( 0,31,31),( 0,15,47),( 0, 0,63),
(15, 2,49),(31, 4,36),(47, 6,22),(63, 9, 9),(47,12, 6),(31,15, 4),(15,18, 2),( 0,22, 0),
( 0,18,15),( 0,14,31),( 0,10,47),( 0, 6,63),( 0,27,63),( 0,49,63),(31,56,63),(63,63,63),
( 0,35, 0),(21,44, 7),(42,53,14),(63,62,22),(63,46,32),(63,31,42),(63,15,52),(63, 0,63),
( 0,13, 6),( 0,16, 9),( 0,19,12),( 0,23,16),( 0,26,19),( 0,30,23),( 0,33,26),( 0,37,30),
( 6,23,42),( 7,24,43),( 8,25,45),( 9,26,47),(10,28,49),(11,29,51),(12,30,53),(13,31,55),
(23, 0, 0),(28, 0, 0),(34, 0, 0),(40, 0, 0),(45, 0, 0),(51, 0, 0),(57, 0, 0),(63, 0, 0),
(16, 0, 0),(19, 2, 0),(23, 4, 0),(27, 6, 0),(31, 9, 0),(36,15, 0),(40,21, 0),(45,27, 0),
(49,33, 0),(54,39, 0),(58,45, 0),(63,51, 0),(63,54,13),(63,57,26),(63,60,39),(63,63,52),
( 0,31, 0),( 0,34, 0),( 0,37, 0),( 0,40, 0),( 0,43, 0),( 0,46, 0),( 0,50, 0),( 0, 0, 0),
( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),
( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),
( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),
( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),
( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),
(15, 0, 0),(21, 0, 0),(28, 0, 0),(35, 0, 0),(42, 0, 0),(49, 0, 0),(56, 0, 0),(63, 0, 0));

paletatxt:array[0..15,0..2] of byte=(
( 0, 0, 0),( 0, 0,42),( 0,42, 0),( 0,42,42),(42, 0, 0),(42, 0,42),(42,21, 0),(42,42,42),
(21,21,21),(21,21,63),(21,63,21),(21,63,63),(63,21,21),(63,21,63),(63,63,21),(63,63,63));

type
Tpobr=array[0..103,0..14,0..14] of byte;
Tmobr=array[0..15,0..6,0..6] of byte;

var
pobr:^Tpobr;
mobr:^Tmobr;
kll:char;
wyjscie:boolean;
imie:string[25];
autor:string[24];
zabezpieczenie:boolean;
dzww:array[0..12] of record
                     n:string[8];
                     os,r:longint;
                     end;

ps2p,
ppobr,
pmobr:string[15];

kolory:array[0..255] of byte;

{*}FUNCTION l2t(liczba:longint;ilosc_lit:byte):string;
var ww:string;minus:boolean;
begin
str(liczba,ww);
if ilosc_lit>0 then begin
   if pos('-',ww)>0 then begin
      delete(ww,pos('-',ww),1);
      minus:=true
   end else minus:=false;
   while length(ww)<ilosc_lit-ord(minus) do insert('0',ww,1);
   if minus then insert('-',ww,1);
   while length(ww)>ilosc_lit do delete(ww,1,1);
end;
l2t:=ww;
end;

{*}FUNCTION fnear(r,g,b:byte):byte;
var
 i,found:byte;
 dist1,dist2 :word;

begin
 dist1:=65535;
 for i:=0 to 15 do
 begin
  dist2:=(abs(paletatxt[i,0]-r)+abs(paletatxt[i,1]-g)+abs(paletatxt[i,2]-b));
  if dist2<=3 then
  begin
    fnear:=i;
    exit
  end;
  if dist2<dist1 then
  begin
    found:=i;
    dist1:=dist2
  end;
 end;
 fnear:=found;
end;

{*}PROCEDURE ustalpalete;
begin

for a:=0 to 255 do
    kolory[a]:=fnear(paleta[a,0],paleta[a,1],paleta[a,2]);

end;

{*}PROCEDURE pokaz_klatke(nr:byte);
var x,y:byte;
begin
textbackground(0);
for y:=0 to 14 do
    for x:=0 to 14 do begin
        gotoxy(4+x*2,7+y);
        textcolor(kolory[pobr^[nr,y,x]]);
        write('ÛÛ');
    end;
textcolor(7);
for y:=1 to 14 do begin
    gotoxy(3+y*2,6); write('ÄÄ');
    gotoxy(3+y*2,22); write('ÄÄ');
end;
for y:=1 to 15 do begin
    gotoxy(3,6+y); write('³');
    gotoxy(34,6+y); write('³');
end;
gotoxy(3,6); write('Ú');
gotoxy(3,22); write('ÀÄ');
gotoxy(33,6); write('Ä¿');
gotoxy(33,22); write('ÄÙ');

gotoxy(4,6);write('[',nr,']Äanimacja:',nr div 8,'Äklatka:',nr mod 8);
end;

{*}PROCEDURE wczytaj_pobr(nazwa:string);
var
io:integer;
wymiary:record x,y:byte end;
begin
{$I+} io:=ioresult; {$I-}
assign(plik,nazwa);
reset(plik,1);
{$I+} io:=ioresult; {$I-}
if io=0 then begin
   {$I-}
   blockread(plik,wymiary,2);
   if (wymiary.x=15) and (wymiary.y=15) then
      blockread(plik,pobr^,sizeof(pobr^))
      else begin
        writeln('Zle wymiary obrazkow! Musza byc 15x15');
        close(plik);
        exit;
        end;
   close(plik);
   {$I+}
   io:=ioresult;
end;
if io=0 then begin
             writeln('Obrazki wczytane poprawnie');
             ppobr:=nazwa;
             end
        else writeln('Blad numer ',io);
{$I+}
end;

{*}PROCEDURE wczytaj_mobr(nazwa:string);
var
io:integer;
wymiary:record x,y:byte end;
begin
{$I+} io:=ioresult; {$I-}
assign(plik,nazwa);
reset(plik,1);
{$I+} io:=ioresult; {$I-}
if io=0 then begin
   {$I-}
   blockread(plik,wymiary,2);
   if (wymiary.x=7) and (wymiary.y=7) then
      blockread(plik,mobr^,sizeof(mobr^))
      else begin
        writeln('Zle wymiary obrazkow! Musza byc 7x7');
        close(plik);
        exit;
        end;
   close(plik);
   {$I+}
   io:=ioresult;
end;
if io=0 then begin
             writeln('Obrazki wczytane poprawnie');
             pmobr:=nazwa;
             end
        else writeln('Blad numer ',io);
{$I+}
end;

{*}PROCEDURE zapisz(nazwa:string);
var
io:integer;
dzwplik:file;
NumRead, NumWritten: Word;
Buf: array[1..2048] of Char;
begin
{$I+} io:=ioresult; {$I-}
assign(plik,nazwa);
rewrite(plik,1);
{$I+} io:=ioresult; {$I-}
IF io=0 then BEGIN
{$I-}

blockwrite(plik,naglowek,sizeof(naglowek));
blockwrite(plik,imie,sizeof(imie));
blockwrite(plik,autor,sizeof(autor));
blockwrite(plik,zabezpieczenie,sizeof(zabezpieczenie));
blockwrite(plik,pobr^,sizeof(pobr^));
blockwrite(plik,mobr^,sizeof(mobr^));

blockwrite(plik,grupy[0].kolorkrwi,sizeof(grupy[0].kolorkrwi));
blockwrite(plik,grupy[0].ranykrew,sizeof(grupy[0].ranykrew));
blockwrite(plik,grupy[0].szybkosc,sizeof(grupy[0].szybkosc));
blockwrite(plik,grupy[0].waga,sizeof(grupy[0].waga));
blockwrite(plik,grupy[0].sila_bicia,sizeof(grupy[0].sila_bicia));
blockwrite(plik,grupy[0].sila_kop,sizeof(grupy[0].sila_kop));
blockwrite(plik,grupy[0].bicie,sizeof(grupy[0].bicie));
blockwrite(plik,grupy[0].ani_corobi,sizeof(grupy[0].ani_corobi));

for a:=0 to 12 do begin
  Assign(dzwplik, dzww[a].n+'.raw');
  reset(dzwplik,1);
  dzww[a].r:=filesize(dzwplik);
  if a=0 then dzww[a].os:=filepos(plik)+sizeof(dzww)
         else dzww[a].os:=dzww[a-1].os+dzww[a-1].r;
  Close(dzwplik);
end;
blockwrite(plik,dzww,sizeof(dzww));

for a:=0 to 12 do begin
  Assign(dzwplik, dzww[a].n+'.raw');
  Reset(dzwplik, 1);
  Writeln('zapisuje plik ', dzww[a].n,'.raw');
  repeat
    BlockRead(dzwplik, Buf, SizeOf(Buf), NumRead);
    BlockWrite(plik, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  Close(dzwplik);
end;

close(plik);
{$I+}
io:=ioresult;
END;

if io=0 then begin
             writeln('S2P zapisany poprawnie');
             ps2p:=nazwa;
             end
        else writeln('Blad numer ',io);
{$I+}
end;

{*}PROCEDURE wczytaj(nazwa:string);
var io:integer;
begin
{$I+} io:=ioresult; {$I-}
assign(plik,nazwa);
reset(plik,1);
{$I+} io:=ioresult;
if io=0 then begin
   {$I-}
   blockread(plik,naglowek,sizeof(naglowek));
   blockread(plik,imie,sizeof(imie));
   blockread(plik,autor,sizeof(autor));
   blockread(plik,zabezpieczenie,sizeof(zabezpieczenie));
   blockread(plik,pobr^,sizeof(pobr^));
   blockread(plik,mobr^,sizeof(mobr^));

   blockread(plik,grupy[0].kolorkrwi,sizeof(grupy[0].kolorkrwi));
   blockread(plik,grupy[0].ranykrew,sizeof(grupy[0].ranykrew));
   blockread(plik,grupy[0].szybkosc,sizeof(grupy[0].szybkosc));
   blockread(plik,grupy[0].waga,sizeof(grupy[0].waga));
   blockread(plik,grupy[0].sila_bicia,sizeof(grupy[0].sila_bicia));
   blockread(plik,grupy[0].sila_kop,sizeof(grupy[0].sila_kop));
   blockread(plik,grupy[0].bicie,sizeof(grupy[0].bicie));
   blockread(plik,grupy[0].ani_corobi,sizeof(grupy[0].ani_corobi));

   blockread(plik,dzww,sizeof(dzww));

   close(plik);
   {$I+}
   io:=ioresult;
end;
if io=0 then begin
             writeln('S2P wczytany poprawnie');
             ps2p:=nazwa;
             end
        else writeln('Blad numer ',io);
{$I+}
end;

{*}PROCEDURE wybormenu(lit,tekst:string);
begin
textbackground(0);
write('   ');
textcolor(14);textbackground(6);
write(' '+lit+' ');
textcolor(7);textbackground(0);
writeln(' '+tekst);
end;

{*}PROCEDURE naglowekmenu(tekst:string);
begin
textcolor(15);textbackground(4);
writeln('S2P Edit (c)GAD 2001  http://gad.art.pl/ http://www.sadist.qs.pl/ gad@gad.art.pl');

textbackground(0);
write(' ');
textcolor(12);textbackground(1);
writeln('  '+tekst+'  ');
textcolor(7);textbackground(0);
writeln;
end;

{*}PROCEDURE menju;
begin
clrscr;
naglowekmenu('Menu glowne');

wybormenu('A','wczytaj zestaw postaci  ['+ps2p+']');
wybormenu('B','zapisz zestaw postaci  ['+ps2p+']');
wybormenu('C','wczytaj rysunki postaci  ['+ppobr+']');
wybormenu('D','wczytaj rysunki miesa  ['+pmobr+']');
wybormenu('E','zmiana koloru krwi');
wybormenu('F','zmiana miejsca ran, z ktorych leje sie krew');
wybormenu('G','zmiana szybkosci i wagi');
wybormenu('H','sila bicia i kopania');
wybormenu('I','miejsce i kierunek uderzenia');
wybormenu('J','szybkosci animacji');
wybormenu('K','nazwa postaci  ['+imie+']');
wybormenu('L','dzwieki');
if zabezpieczenie then wyr:=' *zabezpieczone przed zmiana*' else wyr:='';
wybormenu('M','autor postaci  ['+autor+']'+wyr);
writeln;
wybormenu('S','przywroc ustawienia domyslne');
writeln;
wybormenu('Q','wyjscie');
writeln;
write('Wybieraj: ');
kll:=readkey;
writeln;
end;

{*}PROCEDURE z_kolorkrwi;
begin
clrscr;
kll:=#255;
naglowekmenu('Zmiana koloru krwi');
writeln('numer koloru: ',grupy[0].kolorkrwi.od);
writeln('dodatkowa losowa zmiana [+ ile]: ',grupy[0].kolorkrwi.ile);

writeln;
write('Zmieniasz? ');
kll:=readkey;
writeln;
if upcase(kll)='T' then begin
   write('numer koloru: ');
   readln(grupy[0].kolorkrwi.od);
   write('dodatkowa losowa zmiana [+ ile]: ');
   readln(grupy[0].kolorkrwi.ile);
end;

kll:=#255;
end;

{*}PROCEDURE z_szybwag;
begin
clrscr;
kll:=#255;
naglowekmenu('Zmiana szybkosci i wagi');
writeln('szybkosc: ',grupy[0].szybkosc:10:6);
writeln('waga: ',grupy[0].waga:10:6);

writeln;
write('Zmieniasz? ');
kll:=readkey;
writeln;
if upcase(kll)='T' then begin
   write('szybkosc: ');
   readln(grupy[0].szybkosc);
   write('waga: ');
   readln(grupy[0].waga);
end;

kll:=#255;
end;

{*}PROCEDURE z_silabickop;
begin
clrscr;
kll:=#255;
naglowekmenu('Sila bicia i kopania');
writeln('bicie: ',grupy[0].sila_bicia);
writeln('kopanie: ',grupy[0].sila_kop);

writeln;
write('Zmieniasz? ');
kll:=readkey;
writeln;
if upcase(kll)='T' then begin
   write('bicie: ');
   readln(grupy[0].sila_bicia);
   write('kopanie: ');
   readln(grupy[0].sila_kop);
end;

kll:=#255;
end;

{*}PROCEDURE z_mran;
var
ktore,klat:integer;
begin
clrscr;
kll:=#255;
naglowekmenu('Miejsce ran, z ktorych leje sie krew');
ktore:=0;
klat:=0;
gotoxy(50,3);writeln('Klawisze:');
gotoxy(50,4);writeln('[/] [*] : zmiana animacji');
gotoxy(50,5);writeln('[+] [-] : zmiana klatki');
gotoxy(50,6);writeln('kursor  : przesuwanie punktu');
gotoxy(50,7);writeln('[Home] [End] : zmiana DX');
gotoxy(50,8);writeln('[PgUp] [PgDn] : zmiana DY');
repeat
   pokaz_klatke(64+trunc(ktore/1.2)*8+klat);

   gotoxy(3,4);
   case ktore of
     0:write('urwane rece-jedna reka');
     1:write('urwane rece-druga reka');
     2:write('urwana noga           ');
     3:write('urwana glowa          ');
   end;

   for a:=0 to 7 do begin
       gotoxy(38,12+a);
       write('klatka ',a,': ',grupy[0].ranykrew[ktore,a].x,'x',grupy[0].ranykrew[ktore,a].y,
             '  dx:',grupy[0].ranykrew[ktore,a].dx:6:2,
             '  dy:',grupy[0].ranykrew[ktore,a].dy:6:2,'    ');
   end;

   if kolory[pobr^[64+trunc(ktore/1.2)*8+klat, grupy[0].ranykrew[ktore,klat].y, grupy[0].ranykrew[ktore,klat].x]]>=7 then
      textbackground(0)
      else
      textbackground(7);
   textcolor(kolory[pobr^[64+trunc(ktore/1.2)*8+klat, grupy[0].ranykrew[ktore,klat].y, grupy[0].ranykrew[ktore,klat].x]]);
   gotoxy(4+grupy[0].ranykrew[ktore,klat].x*2,7+grupy[0].ranykrew[ktore,klat].y);
   write('±±');
   textbackground(0); textcolor(7);

   kll:=readkey;
   if (kll=#43) then begin inc(klat);if klat>=8 then klat:=0 end;
   if (kll=#45) then begin dec(klat);if klat<0 then klat:=7 end;
   if (kll=#42) then begin inc(ktore);if ktore>=4 then ktore:=0 end;
   if (kll=#47) then begin dec(ktore);if ktore<=-1 then ktore:=3 end;
   if kll=#0 then begin
      kll:=readkey;
      if (kll=#77) and (grupy[0].ranykrew[ktore,klat].x<14) then inc(grupy[0].ranykrew[ktore,klat].x);
      if (kll=#75) and (grupy[0].ranykrew[ktore,klat].x>0) then dec(grupy[0].ranykrew[ktore,klat].x);
      if (kll=#80) and (grupy[0].ranykrew[ktore,klat].y<14) then inc(grupy[0].ranykrew[ktore,klat].y);
      if (kll=#72) and (grupy[0].ranykrew[ktore,klat].y>0) then dec(grupy[0].ranykrew[ktore,klat].y);

      if (kll=#71) and (grupy[0].ranykrew[ktore,klat].dx<3) then
         grupy[0].ranykrew[ktore,klat].dx:=grupy[0].ranykrew[ktore,klat].dx+0.02;
      if (kll=#79) and (grupy[0].ranykrew[ktore,klat].dx>-3) then
         grupy[0].ranykrew[ktore,klat].dx:=grupy[0].ranykrew[ktore,klat].dx-0.02;
      if (kll=#73) and (grupy[0].ranykrew[ktore,klat].dy<3) then
         grupy[0].ranykrew[ktore,klat].dy:=grupy[0].ranykrew[ktore,klat].dy+0.02;
      if (kll=#81) and (grupy[0].ranykrew[ktore,klat].dy>-3) then
         grupy[0].ranykrew[ktore,klat].dy:=grupy[0].ranykrew[ktore,klat].dy-0.02;
   end;
until kll=#27;
end;

{*}PROCEDURE z_muderz;
var
ktore:byte;
begin
clrscr;
kll:=#255;
naglowekmenu('Miejsce i kierunek uderzenia');
ktore:=0;
gotoxy(50,3);writeln('Klawisze:');
gotoxy(50,4);writeln('[*]     : zmiana animacji');
gotoxy(50,5);writeln('[+] [-] : zmiana klatki');
gotoxy(50,6);writeln('kursor  : przesuwanie punktu');
gotoxy(50,7);writeln('[Home] [End] : zmiana DX');
gotoxy(50,8);writeln('[PgUp] [PgDn] : zmiana DY');
repeat
   pokaz_klatke(88+grupy[0].bicie[ktore].klatka+ktore*8);
   gotoxy(3,4);
   if ktore=0 then write('kopanie:')
              else write('bicie:  ');

   gotoxy(43,11);write('kopanie:');
   gotoxy(45,12);write('klatka: ',grupy[0].bicie[0].klatka,' ');
   gotoxy(45,13);write('   ',grupy[0].bicie[0].x,'x',grupy[0].bicie[0].y,'      ');
   gotoxy(45,14);write('dx: ',grupy[0].bicie[0].dx:6:2,'   ');
   gotoxy(45,15);write('dy: ',grupy[0].bicie[0].dy:6:2,'   ');
   gotoxy(43,17);write('bicie:');
   gotoxy(45,18);write('klatka: ',grupy[0].bicie[1].klatka,' ');
   gotoxy(45,19);write('   ',grupy[0].bicie[1].x,'x',grupy[0].bicie[1].y,'      ');
   gotoxy(45,20);write('dx: ',grupy[0].bicie[1].dx:6:2,'   ');
   gotoxy(45,21);write('dy: ',grupy[0].bicie[1].dy:6:2,'   ');

   if kolory[pobr^[88+grupy[0].bicie[ktore].klatka+ktore*8,grupy[0].bicie[ktore].y,grupy[0].bicie[ktore].x]]>=7 then
      textbackground(0)
      else
      textbackground(7);
   textcolor(kolory[pobr^[88+grupy[0].bicie[ktore].klatka+ktore*8,grupy[0].bicie[ktore].y,grupy[0].bicie[ktore].x]]);
   gotoxy(4+grupy[0].bicie[ktore].x*2,7+grupy[0].bicie[ktore].y);
   write('±±');
   textbackground(0); textcolor(7);

   kll:=readkey;
   if (kll=#43) and (grupy[0].bicie[ktore].klatka<7) then inc(grupy[0].bicie[ktore].klatka);
   if (kll=#45) and (grupy[0].bicie[ktore].klatka>0) then dec(grupy[0].bicie[ktore].klatka);
   if (kll=#42) then begin inc(ktore);if ktore>=2 then ktore:=0 end;
   if kll=#0 then begin
      kll:=readkey;
      if (kll=#77) and (grupy[0].bicie[ktore].x<14) then inc(grupy[0].bicie[ktore].x);
      if (kll=#75) and (grupy[0].bicie[ktore].x>0) then dec(grupy[0].bicie[ktore].x);
      if (kll=#80) and (grupy[0].bicie[ktore].y<14) then inc(grupy[0].bicie[ktore].y);
      if (kll=#72) and (grupy[0].bicie[ktore].y>0) then dec(grupy[0].bicie[ktore].y);

      if (kll=#71) and (grupy[0].bicie[ktore].dx<3) then
         grupy[0].bicie[ktore].dx:=grupy[0].bicie[ktore].dx+0.02;
      if (kll=#79) and (grupy[0].bicie[ktore].dx>0) then
         grupy[0].bicie[ktore].dx:=grupy[0].bicie[ktore].dx-0.02;
      if (kll=#73) and (grupy[0].bicie[ktore].dy<3) then
         grupy[0].bicie[ktore].dy:=grupy[0].bicie[ktore].dy+0.02;
      if (kll=#81) and (grupy[0].bicie[ktore].dy>-3) then
         grupy[0].bicie[ktore].dy:=grupy[0].bicie[ktore].dy-0.02;
   end;
until kll=#27;
end;

{*}PROCEDURE z_szani;
const aniop:array[0..12] of string[26]=
      ('idzie                     ',
       'biegnie                   ',
       'spada machajac rekami     ',
       'spada krecac sie          ',
       '',
       '',
       'panikuje                  ',
       'biegnie - ranny; bez rak  ',
       'biegnie - ranny; bez nogi ',
       'biegnie - ranny; bez glowy',
       'skacze [animacja biegnie] ',
       'kopie                     ',
       'bije piescia              ');

var
juz:boolean;
a:byte;
begin
repeat
clrscr;
kll:=#255;
gotoxy(50,5);writeln('0 - najszybciej');
gotoxy(50,6);writeln('255 - najwolniej');
gotoxy(1,1);
naglowekmenu('Szybkosci animacji');
for a:=0 to 12 do
    if not (a in [4,5]) then
       wybormenu(chr(a+65),aniop[a]+' : [ '+l2t(grupy[0].ani_corobi[a+1],0)+' ]');

writeln;

write('Zmieniasz ktores? ');

kll:=readkey;
writeln;
juz:=true;
if upcase(kll) in ['A'..'D','G'..'M'] then begin
   writeln('Podaj nowa szybkosc dla : ',aniop[ord(upcase(kll))-65]);
   readln(grupy[0].ani_corobi[ord(upcase(kll))-64]);
   juz:=false;
end;

until juz;

kll:=#255;
end;

{*}PROCEDURE z_imie;
begin
clrscr;
kll:=#255;
naglowekmenu('Nazwa postaci');
writeln('Postaci nazywaja sie:');
writeln(imie);

writeln;
write('Zmieniasz? ');
kll:=readkey;
writeln;
if upcase(kll)='T' then begin
   writeln('Pisz duzymi literami! Male litery, takie jak: "a,c,e,l,n,o,s,x,z" pojawia sie'#13#10'jako polskie znaki');
   write('nowa nazwa: ');
   readln(imie);
end;

kll:=#255;
end;

{*}PROCEDURE z_autor;
begin
clrscr;
kll:=#255;
naglowekmenu('Autor postaci');
writeln('Autor postaci:');
writeln(autor);

writeln;
if not zabezpieczenie then begin
   write('Zmieniasz? ');
   kll:=readkey;
   writeln;
   if upcase(kll)='T' then begin
      writeln('Pisz duzymi literami! Male litery, takie jak: "a,c,e,l,n,o,s,x,z" pojawia sie'#13#10'jako polskie znaki');
      write('autor: ');
      readln(autor);

      writeln('Czy zabezpieczyc imie i nazwisko autora przed zmiana?');
      kll:=readkey;
      if upcase(kll)='T' then zabezpieczenie:=true;
   end;
end else begin
   writeln('Imie autora zabezpieczone, nie mozna juz go zmienic.');
   readkey;
end;

kll:=#255;
end;

{*}PROCEDURE z_dzwieki;
const dzwop:array[0..12] of string[32]=
     ('krzyk przy ranie 1              ',
      'krzyk przy ranie 2              ',
      'krzyk przy ranie 3              ',
      'krzyk przy uderzeniu w sciane   ',
      'krzyk w panice                  ',
      'wyrzucanie trzymanego przedmiotu',
      'glos podczas trzymania 1        ',
      'glos podczas trzymania 1        ',
      'skakanie                        ',
      'cios piescia                    ',
      'kopniecie                       ',
      'uderzenie mieska w sciane       ',
      'smierc                          ');
var a:byte;
juz:boolean;
begin
repeat
clrscr;
kll:=#255;
naglowekmenu('Zmiana dzwiekow');
for a:=0 to 12 do
    wybormenu(chr(a+65),dzwop[a]+' : [ '+dzww[a].n+' ]');

writeln;
write('Ktore zmieniasz? ');
kll:=readkey;
writeln;
juz:=true;
if upcase(kll) in ['A'..'M'] then begin
   writeln('podaj nazwe pliku bez rozszerzenia dla : ',dzwop[ord(upcase(kll))-65]);
   readln(dzww[ord(upcase(kll))-65].n);
   juz:=false;
end;
until juz;

kll:=#255;
end;

{*}PROCEDURE standard;
var a1:integer;
begin
with grupy[0] do begin
     kolorkrwi.od:=180;
     kolorkrwi.ile:=4;

     ranykrew[0,0].x:=5; {lewa reka}
     ranykrew[0,0].y:=5;
     ranykrew[0,0].dx:=-1;
     ranykrew[0,0].dy:=0;
     ranykrew[0,1].x:=6;
     ranykrew[0,1].y:=5;
     ranykrew[0,1].dx:=-0.7;
     ranykrew[0,1].dy:=0;
     ranykrew[0,2].x:=7;
     ranykrew[0,2].y:=6;
     ranykrew[0,2].dx:=-0.3;
     ranykrew[0,2].dy:=0;
     ranykrew[0,3].x:=9;
     ranykrew[0,3].y:=6;
     ranykrew[0,3].dx:=0;
     ranykrew[0,3].dy:=0;
     ranykrew[0,4].x:=10;
     ranykrew[0,4].y:=5;
     ranykrew[0,4].dx:=0.6;
     ranykrew[0,4].dy:=0;
     ranykrew[0,5].x:=9;
     ranykrew[0,5].y:=5;
     ranykrew[0,5].dx:=1;
     ranykrew[0,5].dy:=0;
     ranykrew[0,6].x:=8;
     ranykrew[0,6].y:=6;
     ranykrew[0,6].dx:=0.8;
     ranykrew[0,6].dy:=0;
     ranykrew[0,7].x:=6;
     ranykrew[0,7].y:=6;
     ranykrew[0,7].dx:=0;
     ranykrew[0,7].dy:=0;

     ranykrew[1,0].x:=10; {prawa reka}
     ranykrew[1,0].y:=5;
     ranykrew[1,0].dx:=0.6;
     ranykrew[1,0].dy:=0;
     ranykrew[1,1].x:=9;
     ranykrew[1,1].y:=5;
     ranykrew[1,1].dx:=1;
     ranykrew[1,1].dy:=0;
     ranykrew[1,2].x:=8;
     ranykrew[1,2].y:=6;
     ranykrew[1,2].dx:=0.8;
     ranykrew[1,2].dy:=0;
     ranykrew[1,3].x:=6;
     ranykrew[1,3].y:=6;
     ranykrew[1,3].dx:=0;
     ranykrew[1,3].dy:=0;
     ranykrew[1,4].x:=5;
     ranykrew[1,4].y:=5;
     ranykrew[1,4].dx:=-1;
     ranykrew[1,4].dy:=0;
     ranykrew[1,5].x:=6;
     ranykrew[1,5].y:=5;
     ranykrew[1,5].dx:=-0.7;
     ranykrew[1,5].dy:=0;
     ranykrew[1,6].x:=8;
     ranykrew[1,6].y:=6;
     ranykrew[1,6].dx:=-0.3;
     ranykrew[1,6].dy:=0;
     ranykrew[1,7].x:=9;
     ranykrew[1,7].y:=6;
     ranykrew[1,7].dx:=0;
     ranykrew[1,7].dy:=0;

     ranykrew[2,0].x:=7; {noga}
     ranykrew[2,0].y:=10;
     ranykrew[2,0].dx:=-0.2;
     ranykrew[2,0].dy:=0.5;
     ranykrew[2,1].x:=6;
     ranykrew[2,1].y:=10;
     ranykrew[2,1].dx:=-0.3;
     ranykrew[2,1].dy:=0.4;
     ranykrew[2,2].x:=6;
     ranykrew[2,2].y:=10;
     ranykrew[2,2].dx:=-0.4;
     ranykrew[2,2].dy:=0.3;
     ranykrew[2,3].x:=6;
     ranykrew[2,3].y:=11;
     ranykrew[2,3].dx:=-0.5;
     ranykrew[2,3].dy:=0.2;
     ranykrew[2,4].x:=7;
     ranykrew[2,4].y:=12;
     ranykrew[2,4].dx:=-0.4;
     ranykrew[2,4].dy:=0.3;
     ranykrew[2,5].x:=7;
     ranykrew[2,5].y:=11;
     ranykrew[2,5].dx:=-0.3;
     ranykrew[2,5].dy:=0.4;
     ranykrew[2,6].x:=6;
     ranykrew[2,6].y:=10;
     ranykrew[2,6].dx:=-0.2;
     ranykrew[2,6].dy:=0.5;
     ranykrew[2,7].x:=6;
     ranykrew[2,7].y:=9;
     ranykrew[2,7].dx:=-0.2;
     ranykrew[2,7].dy:=0.5;

     ranykrew[3,0].x:=7; {glowa}
     ranykrew[3,0].y:=3;
     ranykrew[3,0].dx:=0;
     ranykrew[3,0].dy:=-1.5;
     ranykrew[3,1].x:=8;
     ranykrew[3,1].y:=3;
     ranykrew[3,1].dx:=0;
     ranykrew[3,1].dy:=-1.3;
     ranykrew[3,2].x:=7;
     ranykrew[3,2].y:=4;
     ranykrew[3,2].dx:=0;
     ranykrew[3,2].dy:=-1.1;
     ranykrew[3,3].x:=8;
     ranykrew[3,3].y:=4;
     ranykrew[3,3].dx:=0;
     ranykrew[3,3].dy:=-1  ;
     ranykrew[3,4].x:=7;
     ranykrew[3,4].y:=3;
     ranykrew[3,4].dx:=0;
     ranykrew[3,4].dy:=-1.1;
     ranykrew[3,5].x:=8;
     ranykrew[3,5].y:=3;
     ranykrew[3,5].dx:=0;
     ranykrew[3,5].dy:=-1.2;
     ranykrew[3,6].x:=7;
     ranykrew[3,6].y:=4;
     ranykrew[3,6].dx:=0;
     ranykrew[3,6].dy:=-1.3;
     ranykrew[3,7].x:=8;
     ranykrew[3,7].y:=4;
     ranykrew[3,7].dx:=0;
     ranykrew[3,7].dy:=-1.4;

     szybkosc:=1;
     waga:=0.04;
     sila_bicia:=5;
     sila_kop  :=8;
     with bicie[0] do begin {noga}
       x:=14;
       y:=9;
       dx:=1;
       dy:=-0.7;
       klatka:=3;
     end;
     with bicie[1] do begin {reka}
       x:=14;
       y:=5;
       dx:=1.3;
       dy:=-0.2;
       klatka:=4;
     end;

     ani_corobi[ 0]:=0;
     ani_corobi[ 1]:=5;
     ani_corobi[ 2]:=4;
     ani_corobi[ 3]:=2;
     ani_corobi[ 4]:=3;
     ani_corobi[ 5]:=0;
     ani_corobi[ 6]:=0;
     ani_corobi[ 7]:=4;
     ani_corobi[ 8]:=4;
     ani_corobi[ 9]:=5;
     ani_corobi[10]:=4;
     ani_corobi[11]:=3;
     ani_corobi[12]:=2;
     ani_corobi[13]:=2;
end;
dzww[0].n:='ua1'    ;
dzww[1].n:='ua2'    ;
dzww[2].n:='ua3'    ;
dzww[3].n:='uh'     ;
dzww[4].n:='panika' ;
dzww[5].n:='wyrzuca';
dzww[6].n:='haha'   ;
dzww[7].n:='hyhy'   ;
dzww[8].n:='skok'   ;
dzww[9].n:='cios'   ;
dzww[10].n:='kop'   ;
dzww[11].n:='miesko';
dzww[12].n:='smierc';

imie:='POSTACI';
end;

{*}BEGIN
textbackground(0);
textcolor(7);
new(pobr);
new(mobr);
standard;
ps2p:='';
ppobr:='';
pmobr:='';
autor:='AUTOR';
zabezpieczenie:=false;
ustalpalete;
repeat
  wyjscie:=false;
  menju;
  case upcase(kll) of
   'A':begin
       write('Podaj nazwe pliku S2P: ');
       readln(wyr);
       if pos('.',wyr)=0 then wyr:=wyr+'.S2P';
       wczytaj(wyr);
       while keypressed do readkey; readkey;
       end;
   'B':begin
       write('Podaj nazwe dla pliku S2P: ');
       readln(wyr);
       if pos('.',wyr)=0 then wyr:=wyr+'.S2P';
       zapisz(wyr);
       while keypressed do readkey; readkey;
       end;
   'C':begin
       write('Podaj nazwe pliku z obrazkami postaci: ');
       readln(wyr);
       if pos('.',wyr)=0 then wyr:=wyr+'.OBR';
       wczytaj_pobr(wyr);
       while keypressed do readkey; readkey;
       end;
   'D':begin
       write('Podaj nazwe pliku z obrazkami mieska: ');
       readln(wyr);
       if pos('.',wyr)=0 then wyr:=wyr+'.OBR';
       wczytaj_mobr(wyr);
       while keypressed do readkey; readkey;
       end;
   'E':z_kolorkrwi;
   'F':z_mran;
   'G':z_szybwag;
   'H':z_silabickop;
   'I':z_muderz;
   'J':z_szani;
   'K':z_imie;
   'L':z_dzwieki;
   'M':z_autor;
   'S':begin
       write('Ar ju siur?');
       kll:=readkey;
       if upcase(kll)='T' then standard;
       end;
   'Q':begin
       write('Ar ju siur?');
       kll:=readkey;
       if upcase(kll)='T' then wyjscie:=true;
       end;

  end;
until wyjscie;


dispose(mobr);
dispose(pobr);
end.