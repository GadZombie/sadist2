uses crt,dos;

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
chm=array[1..255] of array[0..255] of byte;

var
Scr:^Ekran;
chmur:^chm;

plik,BMPFile,GDRfile:File;
Palette,pal2:Array [0..255,0..3] of Byte;
{pal:Array [0..255,0..2] of Byte;}
OffSet,Lines,Counter:Word;
reg:registers;
count:byte;
a,b:byte;
zm:boolean;
Header:BMPHeader;
i,j:integer;

szerbmp,licznik:longint;
nazwa,nazwa_bez_roz:string;

{*}FUNCTION upcasestr(t:string):string;
var a:byte;
begin
for a:=1 to length(t) do t[a]:=upcase(t[a]);
upcasestr:=t;
end;

{*}FUNCTION fnear(r,g,b :byte):byte;
var
 i,found:byte;
 dist1,dist2 :word;

begin
 dist1:=65535;
 for i:=1 to 223 do
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
writeln('Konwerter z 256-kolorowych BMP na format S2B - tlo do Sadist II');
if paramcount=0 then begin
   writeln('Uzywanie:');
   writeln('  BMP2S2B plik.bmp');
   writeln('Bitmapa musi byc 640x300, w 48-kolorach, ale zapisana jako 256-kolorowa');
   halt;
end;

nazwa:=paramstr(1);

nazwa_bez_roz:=nazwa;
if pos('.',nazwa)=0 then begin
   writeln('Musisz podac nazwe bitmapy z rozszerzeniem!! Np: BMP2S2B RYS.BMP');
   halt;
end
   else
   while (pos('.',nazwa_bez_roz)>0) and (length(nazwa_bez_roz)>1) do begin
      delete(nazwa_bez_roz,length(nazwa_bez_roz),1);
   end;

getmem(scr,sizeof(scr^));
new(chmur);

Assign (BMPFile,nazwa);
filemode:=0;
Reset (BMPFile, 1);
BlockRead (BMPFile, Header, SizeOf (Header)); {odczyt danych naglowka bmp}
BlockRead (BMPFile, Palette, 1024);
for Counter := 0 to 255 do begin
    Palette[Counter,0] := Palette[Counter, 0] shr 2;
    Palette[Counter,1] := Palette[Counter, 1] shr 2;
    Palette[Counter,2] := Palette[Counter, 2] shr 2;
end;

{zapis GDR}
writeln('Wymiary: ',Header.biWidth,'x',Header.biHeight);

if (Header.biWidth<>640) or (Header.biHeight<>300) then begin
   writeln('Zle wymiary! Max 320x200');
   halt;
end;
if (Header.biBitCount<>8) then begin
   writeln('Zla ilosc kolorow! Musi byc 256');
   halt;
end;

Assign (GDRFile,nazwa_bez_roz+'.S2B');
filemode:=1;
Rewrite(GDRFile, 1);

licznik:=0;
szerbmp:=Header.biWidth;
if szerbmp mod 4<>0 then szerbmp:=szerbmp+(4-szerbmp mod 4);

while licznik<Header.biHeight do begin
    seek(BMPFile,Header.biHeight*szerbmp+1078-(1+licznik)*szerbmp);
    BlockRead (BMPFile,scr^,szerbmp);
    for i:=0 to 640 do inc(scr^[i],208);
    blockwrite(GDRFile,scr^,Header.biWidth);
    inc(licznik);
end;
close(BMPFile);

writeln('Tworzenie tablicy przezroczystosci...');
for a:=0 to 47 do begin
    pal[a+208,0]:=Palette[a,2];
    pal[a+208,1]:=Palette[a,1];
    pal[a+208,2]:=Palette[a,0];
end;
for i:=208 to 255 do
  for j:=0 to 255 do
    chmur^[i][j]:=fnear(
    (pal[i,0]+pal[j,0]*2) div 3,
    (pal[i,1]+pal[j,1]*2) div 3,
    (pal[i,2]+pal[j,2]*2) div 3);

blockwrite(GDRfile,chmur^[208],12288);

blockwrite(GDRfile,pal[208],144);

close(GDRFile);
writeln('Plik '+nazwa_bez_roz+'.S2B jako tlo do Sadist II zapisany poprawnie!');

dispose(chmur);
freemem(scr,sizeof(scr^));
end.