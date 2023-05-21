uses crt,dos,lzssunit,gadparam;

const
pal:array[0..255,0..2] of byte=(
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
( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0));

type
Ekran=array [0..63999] of byte;
BMPHeader = record
  bfType           : Word;
  bfSize,
  bfReserved,
  bfOffBits,
  biSize,
  biWidth,
  biHeight         : LongInt;
  biPlanes,
  biBitCount       : Word;
  biCompression,
  biSizeImage,
  biXPelsPerMeter,
  biYPelsPerMeter,
  biClrUsed,
  biClrImportant   : LongInt;
end;

var
Scr:^Ekran;

plik,BMPFile,GDRfile:file;
Palette,pal2:array [0..255,0..3] of byte;
nowapal:array [0..255] of byte;
OffSet,Lines,Counter:Word;
count:byte;
a,b:byte;
zm:boolean;
Header:BMPHeader;
i,j:integer;
wyr:string;

naglplus:word;
c,szerbmp,licznik:longint;
nazwa,nazwa_bez_roz:string;
bity,
kr,kg,kb,
masr,masg,masb,
szukodkol:byte;

{do kompresji}
var
InFile, OutFile : file;

{pierdoly zapisywane w terenie}
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
maxmin:word;


{kompresja LZSS}
Function ReadProc(var ReadBuf; var NumRead : word) : word; far;
Begin
  BlockRead(InFile, ReadBuf, LZRWBufSize, NumRead);
  write('.');
End; { ReadProc }

Function WriteProc(var WriteBuf; Count : word; var NumWritten : word) : word;
far;Begin
  BlockWrite(OutFile, WriteBuf, Count, NumWritten);
  write('.');
End; { WriteProc }

{E kompresja LZSS}

{*}PROCEDURE standard_kfg;
begin
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
maxmin:=100;
end;


{*}PROCEDURE zapisz_teren;
var
b:byte;
fp:longint;
blad:integer;
a:longint;

buf:array[0..1999] of byte;
begin
standard_kfg;
fillchar(buf,sizeof(buf),0);
{$I-}
if LZInit then begin
      assign(inFile,'temp.tmp'); {kompresja}
      filemode:=0;
      reset(inFile,1);
      assign(OutFile,nazwa_bez_roz+'.S2T');
      filemode:=1;
      rewrite(OutFile, 1);

      LZSquash(ReadProc, WriteProc);

      close(inFile);

      {zapis min, tla itd}
      fp:=filepos(outfile);
      b:=2; {numer wersji}
      blockwrite(outfile, b, sizeof(b));
      blockwrite(outfile, pogoda, 44); {wszystko z pogody procz drogi pioruna}
      for a:=0 to 4 do {zapis punktow wyjscia itd}
          blockwrite(outfile, grupy[a], 21); {ustawienia wylotu kazdej z grup}

      blockwrite(outfile, maxmin,sizeof(maxmin));
      blockwrite(outfile, buf, 20*maxmin);
      blockwrite(outfile, fp, sizeof(fp));

      close(OutFile);
      {$I+}
      blad:=ioresult;
      {$I-}
      assign(plik,'temp.tmp');
      erase(plik);
   LZDone;
end else begin
    writeln ('Brak pamieci na kompresje pliku!!');
    halt
end;
end;


{*}FUNCTION upcasestr(t:string):string;
var a:byte;
begin
for a:=1 to length(t) do t[a]:=upcase(t[a]);
upcasestr:=t;
end;

{*}FUNCTION fnear(r,g,b, odkol :byte):byte;
var
 i,found:byte;
 dist1,dist2 :word;

begin
 dist1:=65535;
 for i:=odkol to 207 do
 begin
  dist2:=(abs(pal[i,0]-r)+abs(pal[i,1]-g)+abs(pal[i,2]-b));
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

{-----------------------}
{*}BEGIN
{$I+}
writeln;
textcolor(15);
writeln('Konwerter z bitmap na format S2T - teren do Sadist II: Ostatni krzyk.');
textcolor(7);
writeln;
if paramcount=0 then begin
   writeln('Uzywanie:');
   writeln('  BMP2S2T plik.bmp [/bezkrwi] [/bezmetalu]');
   writeln('Bitmapa musi byc w rozmiarach 1280x400, w palecie 256 kolorow lub 24-bitowej.');
   writeln('Kolor czarny (R:00,G:00,B:00) zostanie uznany jako kolor przezroczysty (maski),'#13#10'czyli puste miejsce.');
   writeln('Opcjonalne parametry:');
   writeln(' /krew  - wlacza w palecie kolory krwi (ten kolor wysycha i kapie)');
   writeln(' /metal - wlacza w palecie kolory metalu (niezniszczalne)');
   writeln('Powyzsze przelaczniki sa standardowo wylaczone, gdyz "kolory aktywne" zwykle'#13#10'nie sa pozadane.');
   writeln(' /r:RR - ustawia kolor maski R na wartosc z zakresu 0-63');
   writeln(' /g:GG - ustawia kolor maski G na wartosc z zakresu 0-63');
   writeln(' /b:BB - ustawia kolor maski B na wartosc z zakresu 0-63');
   writeln;
   halt;
end;

nazwa:=paramstr(1);

nazwa_bez_roz:=nazwa;
if pos('.',nazwa)=0 then begin
   writeln('Musisz podac nazwe bitmapy z rozszerzeniem!! Np: BMP2S2T RYS.BMP');
   halt;
end
   else
   while (pos('.',nazwa_bez_roz)>0) and (length(nazwa_bez_roz)>1) do begin
      delete(nazwa_bez_roz,length(nazwa_bez_roz),1);
   end;

new(scr);

Assign (BMPFile,nazwa);
filemode:=0;
Reset (BMPFile, 1);
BlockRead (BMPFile, Header, SizeOf (Header)); {odczyt danych naglowka bmp}

if (Header.biWidth<>1280) or (Header.biHeight<>400) then begin
   writeln('Zle wymiary! Musi byc 1280x400');
   halt;
end;
if not (Header.biBitCount in [8,24]) then begin
   writeln('Zla ilosc kolorow! Musi byc 256 lub 24bit');
   halt;
end;
if Header.biCompression<>0 then begin
   writeln('Bitmapa jest skompresowana!');
   halt;
end;

naglplus:=sizeof(Header);
bity:=3;
if Header.biBitCount = 8 then begin
   BlockRead (BMPFile, Palette, 1024);
   for Counter := 0 to 255 do begin
       Palette[Counter,0] := Palette[Counter, 0] shr 2;
       Palette[Counter,1] := Palette[Counter, 1] shr 2;
       Palette[Counter,2] := Palette[Counter, 2] shr 2;
   end;
   naglplus:=1078;
   bity:=1;
end;
seek(BMPFile,Header.bfOffBits);
writeln('Bitmapa wlasciwa, trwa konwersja...');

if not parametr(false,false,'/KREW') then begin
   for a:=176 to 183 do begin
       pal[a,0]:=255;
       pal[a,1]:=255;
       pal[a,2]:=255;
   end;
end else writeln('Kolory krwi wlaczone z linii polecen');
if not parametr(false,false,'/METAL') then begin
   for a:=160 to 167 do begin
       pal[a,0]:=255;
       pal[a,1]:=255;
       pal[a,2]:=255;
   end;
end else writeln('Kolory metalu wlaczone z linii polecen');

masr:=0;
masg:=0;
masb:=0;
if parametrdoznaku(false,false,'/R',':',wyr) then begin
   val(wyr,c,i);
   if i=0 then begin
      if (c>=0) and (c<=63) then masr:=c else
         writeln('Kolor maski R podany blednie');
   end else writeln('Kolor maski R podany blednie');
end;
if parametrdoznaku(false,false,'/G',':',wyr) then begin
   val(wyr,c,i);
   if i=0 then begin
      if (c>=0) and (c<=63) then masg:=c else
         writeln('Kolor maski G podany blednie');
   end else writeln('Kolor maski G podany blednie');
end;
if parametrdoznaku(false,false,'/B',':',wyr) then begin
   val(wyr,c,i);
   if i=0 then begin
      if (c>=0) and (c<=63) then masb:=c else
         writeln('Kolor maski B podany blednie');
   end else writeln('Kolor maski B podany blednie');
end;
if (masr<>0) or (masg<>0) or (masb<>0) then begin
   writeln('Kolory maski ustawione na: R:',masr,' G:',masg,' B:',masb,'.');
   szukodkol:=1;
end else szukodkol:=0;

Assign (GDRFile,'TEMP.TMP');
filemode:=1;
Rewrite(GDRFile, 1);

licznik:=0;
szerbmp:=Header.biWidth;
if szerbmp mod 4<>0 then szerbmp:=szerbmp+(4-szerbmp mod 4);

if Header.biBitCount = 8 then begin
   writeln('Bitmapa 256-kolorowa. Tworzenie nowej palety.');
   for a:=0 to 255 do nowapal[a]:=fnear(palette[a,2],palette[a,1],palette[a,0],szukodkol);
end else
   writeln('Bitmapa 24-bitowa.');

writeln('Konwersja BMP na obraz we wlasciwej palecie.');
while licznik<Header.biHeight do begin
    seek(BMPFile,Header.biHeight*szerbmp*bity+naglplus-(1+licznik)*szerbmp*bity);
    BlockRead (BMPFile,scr^,szerbmp*bity);
    if bity=1 then {256kol}
       for i:=0 to 1280 do
           if (palette[scr^[i],0]=masr) and (palette[scr^[i],1]=masg) and (palette[scr^[i],2]=masb)
              then scr^[i]:=0
              else scr^[i]:=nowapal[scr^[i]];

    if bity=3 then {24bit}
       for i:=0 to 1280 do begin
           kr:=scr^[i*3+2] div 4;
           kg:=scr^[i*3+1] div 4;
           kb:=scr^[i*3] div 4;
           if (kr=masr) and (kg=masg) and (kb=masb) then scr^[i]:=0 else
              scr^[i]:=fnear(kr,kg,kb,szukodkol);
       end;

    blockwrite(GDRFile,scr^,1280);
    inc(licznik);
    write(licznik div 4,'%   '#13);
end;
writeln;writeln;
close(BMPFile);
close(GDRFile);
writeln('Kompresja pliku terenu...');

zapisz_teren;
writeln;
writeln;
writeln('Plik '+nazwa_bez_roz+'.S2T jako teren do Sadist II zapisany poprawnie!');

dispose(scr);
end.