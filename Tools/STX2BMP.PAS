uses crt,dos;

const
pals:array[0..255,0..2] of byte=
(( 0, 0, 0),( 9, 9, 9),(18,18,18),(27,27,27),(36,36,36),(45,45,45),(54,54,54),(63,63,63),
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
( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),
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

plik,BMPFile,GDRfile:File;
Palette:Array [0..255,0..3] of Byte;
OffSet,Lines,Counter:Word;
reg:registers;
count,il:byte;
a,b:integer;
zm:boolean;
Header:BMPHeader;
i,j,
rx,ry:integer;

wysbmp,szerbmp,licznik,ofs:longint;
nazwa,nazwa_bez_roz:string;

{*}FUNCTION upcasestr(t:string):string;
var a:byte;
begin
for a:=1 to length(t) do t[a]:=upcase(t[a]);
upcasestr:=t;
end;

{-----------------------}
{*}BEGIN
{$I+}
writeln;
writeln('Konwerter z STX na 256-kolorowe BMP');
if paramcount=0 then begin
   writeln('Uzywanie:');
   writeln('  STX2BMP plik.stx');
   halt;
end;

nazwa:=paramstr(1);

nazwa_bez_roz:=nazwa;
if pos('.',nazwa)=0 then begin
   writeln('Musisz podac nazwe pliku z rozszerzeniem!! Np: STX2BMP RYS.STX');
   halt;
end
   else
   while (pos('.',nazwa_bez_roz)>0) and (length(nazwa_bez_roz)>1) do begin
      delete(nazwa_bez_roz,length(nazwa_bez_roz),1);
   end;

getmem(scr,sizeof(scr^));
fillchar(scr^,64000,0);

Assign (GDRFile,nazwa);
filemode:=0;
Reset (GDRFile, 1);
blockread(gdrfile,RX,2);
blockread(gdrfile,RY,2);

szerbmp:=rx;
{if szerbmp<50 then }szerbmp:=50;

wysbmp:=ry;
{if wysbmp<50 then }wysbmp:=50;

with header do begin
  bfType           :=19778;
  bfSize           :=szerbmp*wysbmp;
  bfReserved       :=0;
  bfOffBits        :=1078;
  biSize           :=40;
  biWidth          :=szerbmp;
  biHeight         :=wysbmp;
  biPlanes         :=1;
  biBitCount       :=8;
  biCompression    :=0;
  biSizeImage      :=szerbmp*wysbmp;
  biXPelsPerMeter  :=2834;
  biYPelsPerMeter  :=2834;
  biClrUsed        :=0;
  biClrImportant   :=0;
end;
for a:=0 to 255 do begin
    Palette[a,3]:=0;
    Palette[a,2]:=Pals[a,0] shl 2;
    Palette[a,1]:=Pals[a,1] shl 2;
    Palette[a,0]:=Pals[a,2] shl 2;
end;

{zapis BMP}
Assign (BMPFile,nazwa_bez_roz+'.BMP');
filemode:=1;
Rewrite(BMPFile, 1);
blockwrite(BMPFile, Header, SizeOf (Header));
blockwrite(BMPFile, Palette, 1024);

licznik:=0;
while licznik<RY do begin {odczyt}
{    seek(GDRFile,rx*ry+4-(1+licznik)*rx);}
    blockread (GDRFile,scr^[((ry-1)-licznik)*320],RX);
    a:=rx;
    while a<50 do begin
       move(scr^[(ry-licznik)*320],scr^[(ry-licznik)*320+a],rx);
       inc(a,rx);
    end;
    inc(licznik);
end;

a:=ry;
while a<50 do begin
    move(scr^,scr^[longint(a)*320],(longint(ry))*320);
    inc(a,ry);
end;

{asm
  mov ax,13h
  int 10h
end;
move(scr^,mem[$a000:0],64000);
readkey;}

{zapis}
licznik:=0;
if szerbmp mod 4<>0 then szerbmp:=szerbmp+(4-szerbmp mod 4);
ofs:=0;
if ry>50 then ofs:=ry-50;
while licznik<wysbmp do begin
{    seek(GDRFile,rx*ry+4-(1+licznik)*rx);}
    blockwrite(BMPFile,scr^[(licznik+ofs)*320],szerbmp);
    inc(licznik);
end;
close(BMPFile);

close(GDRFile);
writeln('Plik '+nazwa_bez_roz+'.BMP zapisany poprawnie!');

freemem(scr,sizeof(scr^));
end.