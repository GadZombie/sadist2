uses crt,dos;

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
pals:array[0..255,0..2] of byte;
OffSet,Lines,Counter:Word;
reg:registers;
count,il:byte;
a,b:byte;
zm:boolean;
Header:BMPHeader;
i,j,
rx,ry:integer;

licznik:longint;
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
writeln('Konwerter z S2B na 256-kolorowe BMP');
if paramcount=0 then begin
   writeln('Uzywanie:');
   writeln('  S2B2BMP plik.s2b');
   halt;
end;

nazwa:=paramstr(1);

nazwa_bez_roz:=nazwa;
if pos('.',nazwa)=0 then begin
   writeln('Musisz podac nazwe pliku z rozszerzeniem!! Np: S2B2BMP RYS.S2B');
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

rx:=640;
ry:=300;
with header do begin
  bfType           :=19778;
  bfSize           :=rx*ry;
  bfReserved       :=0;
  bfOffBits        :=1078;
  biSize           :=40;
  biWidth          :=rx;
  biHeight         :=ry;
  biPlanes         :=1;
  biBitCount       :=8;
  biCompression    :=0;
  biSizeImage      :=rx*ry;
  biXPelsPerMeter  :=2834;
  biYPelsPerMeter  :=2834;
  biClrUsed        :=0;
  biClrImportant   :=0;
end;

{zapis BMP}
Assign (BMPFile,nazwa_bez_roz+'.BMP');
filemode:=2;
Rewrite(BMPFile, 1);
blockwrite(BMPFile, Header, SizeOf (Header));

seek(GDRFile,204432-144);
blockread(GDRFile, pals,144);
for a:=0 to 255 do begin
    Palette[a,3]:=0;
    Palette[a,2]:=Pals[a,0] shl 2;
    Palette[a,1]:=Pals[a,1] shl 2;
    Palette[a,0]:=Pals[a,2] shl 2;
end;
blockwrite(BMPFile, Palette, 1024);


seek(GDRFile,4);

licznik:=0;
while licznik<Header.biHeight do begin
    seek(GDRFile,(204432-144-12288)-(1+licznik)*rx);
    BlockRead (GDRFile,scr^,rx);
    for i:=0 to 640 do dec(scr^[i],208);
    blockwrite(BMPFile,scr^,rx);
    inc(licznik);
end;

close(BMPFile);

close(GDRFile);
writeln('Plik '+nazwa_bez_roz+'.BMP zapisany poprawnie!');

freemem(scr,sizeof(scr^));
end.