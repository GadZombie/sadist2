uses crt,dos,mysz;

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

{$I myszka.asc}
{$I font.asc}

type
Ekran=array [0..199,0..319] of byte;
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
Scr,obr:^Ekran;

plik,BMPFile,GDRfile:File;
Palette:Array [0..255,0..3] of Byte;
a:byte;
Header:BMPHeader;
rx,ry:integer;

wysbmp,szerbmp,licznik,ofst:longint;
nazwa,nazwa_bez_roz:string;

okna:array[0..1] of record
     x,y,sz,wys:integer;
     nazwa:string;
     end;


{*}PROCEDURE move2(var Source,Dest); assembler;
asm
  push       ds
  les        di,Dest
  lds        si,Source
  mov        cx,16000
  db 66h;    rep movsw
  pop        ds
end;

{*}PROCEDURE MaskPic(X,Y,Width,Height:integer; Maskcolor:byte; var Sprite, Dest);
 Begin
  If (x <= -width) or (x >= 320) or (y <= -height) or (y >= 200) then exit;
 Asm
   PUSH  DS
   LDS   SI,Sprite
   LES   DI,DEST
   MOV   AX,WIDTH
   MOV   DX,AX
   PUSH  DX
   ADD   AX,X
   PUSH  Width
   CMP   AX,320
   JG    @RightCut
   SUB   AX,X
   JC    @LeftCut
   JMP   @CheckBottom
 @RightCut:
   SUB   AX,Width
   SUB   AX,320
   NEG   AX
   MOV   Width,AX
   JMP   @CheckBottom
 @LeftCut:
   ADD   AX,X
   MOV   Width,AX
   SUB   DX,AX
   ADD   SI,DX
   XOR   BX,BX
   MOV   X,BX
 @CheckBottom:
   MOV   AX,Height
   ADD   AX,Y
   CMP   AX,200
   JG    @BottomCut
   SUB   AX,Y
   JC    @TopCut
   POP   BX
   JMP   @Display
 @BottomCut:
   POP   BX
   SUB   AX,Height
   SUB   AX,200
   NEG   AX
   MOV   Height,AX
   JMP   @Display
 @TopCut:
  ADD   AX,Y
  POP   BX
  PUSH  AX
  MOV   AX,Y
  NEG   AX
  IMUL  BX
  ADD   SI,AX
  POP   AX
  MOV   Height,AX
  MOV   BX,0
  MOV   Y,BX
 @Display:
   MOV   AX,320
   IMUL  [Y]
   MOV   DI,AX
   ADD   DI,X
{ ADD   DI,8}
   POP   DX
   MOV   BX,Width
   MOV   CX,Height
  @HeightLoop:
   PUSH  SI
   PUSH  DI
   PUSH  CX
   MOV   CX,BX
  @WidthLoop:
   MOV   AL,Byte Ptr [DS:SI]
   CMP   AL,Maskcolor
   JZ    @Skipped
   MOV   Byte Ptr [ES:DI],AL
  @Skipped:
   INC   SI
   INC   DI
   DEC   CX
   JNZ  @WidthLoop
   POP   CX
   POP   DI
   POP   SI
   ADD   DI,320
   ADD   SI,DX
   DEC   CX
   JNZ  @HeightLoop
   POP   DS
 End;
End;

{*}PROCEDURE MaskPic2(X,Y,Width,Height:integer; Maskcolor,color:byte; var Sprite,Dest);
 Begin
  If (x <= -width) or (x >= 320) or (y <= -height) or (y >= 200) then exit;
 Asm
   PUSH  DS
   LDS   SI,Sprite
   LES   DI,DEST
   MOV   AX,WIDTH
   MOV   DX,AX
   PUSH  DX
   ADD   AX,X
   PUSH  Width
   CMP   AX,320
   JG    @RightCut
   SUB   AX,X
   JC    @LeftCut
   JMP   @CheckBottom
 @RightCut:
   SUB   AX,Width
   SUB   AX,320
   NEG   AX
   MOV   Width,AX
   JMP   @CheckBottom
 @LeftCut:
   ADD   AX,X
   MOV   Width,AX
   SUB   DX,AX
   ADD   SI,DX
   XOR   BX,BX
   MOV   X,BX
 @CheckBottom:
   MOV   AX,Height
   ADD   AX,Y
   CMP   AX,200
   JG    @BottomCut
   SUB   AX,Y
   JC    @TopCut
   POP   BX
   JMP   @Display
 @BottomCut:
   POP   BX
   SUB   AX,Height
   SUB   AX,200
   NEG   AX
   MOV   Height,AX
   JMP   @Display
 @TopCut:
  ADD   AX,Y
  POP   BX
  PUSH  AX
  MOV   AX,Y
  NEG   AX
  IMUL  BX
  ADD   SI,AX
  POP   AX
  MOV   Height,AX
  MOV   BX,0
  MOV   Y,BX
 @Display:
   MOV   AX,320
   IMUL  [Y]
   MOV   DI,AX
   ADD   DI,X
{ ADD   DI,8}
   POP   DX
   MOV   BX,Width
   MOV   CX,Height
  @HeightLoop:
   PUSH  SI
   PUSH  DI
   PUSH  CX
   MOV   CX,BX
  @WidthLoop:
   MOV   AL,Byte Ptr [DS:SI]
   CMP   AL,Maskcolor
   JZ    @Skipped
   MOV	 AL,color
   MOV   Byte Ptr [ES:DI],AL
  @Skipped:
   INC   SI
   INC   DI
   DEC   CX
   JNZ  @WidthLoop
   POP   CX
   POP   DI
   POP   SI
   ADD   DI,320
   ADD   SI,DX
   DEC   CX
   JNZ  @HeightLoop
   POP   DS
 End;
End;

{*}PROCEDURE pisz(xobr,yobr:integer;tekst:string;kolor1:integer);
var xf,yf,numer:byte;a:longint;
begin
for a:=1 to length(tekst) do begin
    case tekst[a] of
         'A'..'Z':numer:=ord(tekst[a])-65;
         '0'..'9':numer:=ord(tekst[a])-22;
         'a':numer:=36;
         'c':numer:=37;
         'e':numer:=38;
         'l':numer:=39;
         'n':numer:=40;
         'o':numer:=41;
         's':numer:=42;
         'x':numer:=43;
         'z':numer:=44;
         '.':numer:=45;
         ',':numer:=46;
         ':':numer:=47;
         '!':numer:=48;
         '"':numer:=49;
         '-':numer:=50;
         '?':numer:=51;
        '''':numer:=52;
         '(':numer:=53;
         ')':numer:=54;
         '/':numer:=55;
         '+':numer:=56;
         '@':numer:=57;
         '_':numer:=58;
         '%':numer:=59;
         '*':numer:=60;
    end;
    if xobr+(a-1)*5>319 then a:=length(tekst) else begin
     if (tekst[a]<>' ') then
        maskpic2(xobr+(a-1)*5,yobr,5,6,0,kolor1,font[numer],scr^);
    end;
end;
end;

{*}PROCEDURE bar(x1,y1,x2,y2:word;kolor:byte);
var y:longint;
begin
if x1>x2 then begin y:=x1;x1:=x2;x2:=y end;
if y1>y2 then begin y:=y1;y1:=y2;y2:=y end;
if x1<0 then x1:=0;
if x2>319 then x2:=319;
if y1<0 then y1:=0;
if y2>199 then y2:=199;
if (x1>319) or (x2<0) or (y1>199) or (y2<0) then exit;

for y:=y1 to y2 do
    FillChar(Scr^[y, x1], x2-x1+1, kolor);
end;

{*}PROCEDURE cala_paleta;
var
count:byte;
begin
port[$3C8]:=0;
for count:=0 to 255 do begin
    port[$3C9]:=pals[count,0];
    port[$3C9]:=pals[count,1];
    port[$3C9]:=pals[count,2];
end;
end;

{*}FUNCTION upcasestr(t:string):string;
var a:byte;
begin
for a:=1 to length(t) do t[a]:=upcase(t[a]);
upcasestr:=t;
end;

{*}PROCEDURE linia(x1,y1,x2,y2:Integer;c:Byte);
var
  DeltaX, DeltaY, NumPixels, Counter,
  D, Dinc1, Dinc2,
  X, Xinc1, Xinc2,
  Y, Yinc1, Yinc2 : Integer;

begin
  DeltaX := abs (x2 - x1);
  DeltaY := abs (y2 - y1);
  if (DeltaX >= DeltaY) then begin
    NumPixels := Deltax + 1;
    D := (DeltaY shl 1) - DeltaX;
    Dinc1 := DeltaY shl 1;
    Dinc2 := (DeltaY - DeltaX) shl 1;
    Xinc1 := 1;
    Xinc2 := 1;
    Yinc1 := 0;
    Yinc2 := 1;
  end else begin
    NumPixels := DeltaY + 1;
    D := (DeltaX shl 1) - DeltaY;
    Dinc1 := DeltaX shl 1;
    Dinc2 := (DeltaX - DeltaY) shl 1;
    Xinc1 := 0;
    Xinc2 := 1;
    Yinc1 := 1;
    Yinc2 := 1;
  end;
  if x1 > x2 then begin
    Xinc1 := -Xinc1;
    Xinc2 := -Xinc2;
  end;
  if y1 > y2 then begin
    Yinc1 := -Yinc1;
    Yinc2 := -Yinc2;
  end;
  X := x1;
  Y := y1;
  for Counter := 1 to NumPixels do begin
    obr^[y,x]:=c;
    if (D < 0) then begin
      inc (D, Dinc1);
      inc (X, Xinc1);
      inc (Y, Yinc1);
    end else begin
      inc (D, Dinc2);
      inc (X, Xinc2);
      inc (Y, Yinc2);
    end;
  end;
end;

{-okienka--------------------------------------------------------------------}
{*}PROCEDURE pokaz_okna;
var a,b:byte;
begin
for a:=0 to 0 do with okna[a] do begin
    bar(x,y,x+sz-1,y+7,3);
    bar(x,y+7,x+sz-1,y+wys-1,4);
    pisz(x+1,y+1,nazwa,7);
end;

with okna[0] do begin {paleta}
   for a:=0 to 3 do
       for b:=0 to 63 do
           bar(x+1+b*4,y+8+a*3, x+4+b*4,y+10+a*3, a*64+b);
end;
end;

{----------------------------------------------------------------------------}
{*}PROCEDURE zapisz_stx2bmp(nazstx,nazbmp:string);
begin
fillchar(scr^,64000,0);

Assign (GDRFile,nazwa);
filemode:=0;
Reset (GDRFile, 1);
blockread(gdrfile,RX,2);
blockread(gdrfile,RY,2);

szerbmp:=rx;
wysbmp:=ry;

with header do begin
  bfType           :=19778;
  bfSize           :=szerbmp*wysbmp+sizeof(header);
  bfReserved       :=0;
  bfOffBits        :=sizeof(header);
  biSize           :=40;
  biWidth          :=szerbmp;
  biHeight         :=wysbmp;
  biPlanes         :=1;
  biBitCount       :=8;
  biCompression    :=0;
  biSizeImage      :=szerbmp*wysbmp;
  biXPelsPerMeter  :=0;
  biYPelsPerMeter  :=0;
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
Assign (BMPFile,nazbmp);
filemode:=1;
Rewrite(BMPFile, 1);
blockwrite(BMPFile, Header, SizeOf (Header));
blockwrite(BMPFile, Palette, 1024);

licznik:=0;
while licznik<RY do begin {odczyt}
    blockread (GDRFile,scr^[(ry-licznik)*320],RX);
    a:=rx;
    inc(licznik);
end;

{zapis}
licznik:=0;
if szerbmp mod 4<>0 then szerbmp:=szerbmp+(4-szerbmp mod 4);
ofst:=0;
if ry>50 then ofst:=ry-50;
while licznik<wysbmp do begin
{    seek(GDRFile,rx*ry+4-(1+licznik)*rx);}
    blockwrite(BMPFile,scr^[(licznik+ofst)*320],szerbmp);
    inc(licznik);
end;
close(BMPFile);
close(GDRFile);
end;

{*}PROCEDURE start;
begin
new(scr);
new(obr);
asm
  mov ax,13h
  int 10h
end;
if not sprawdzczyjestmysz then begin writeln('brak myszy');halt end;
ustawoknomyszy(0,0,639,199);
cala_paleta;

with okna[0] do begin {paleta}
   x:=5;
   y:=5;
   sz:=258;
   wys:=21;
   nazwa:='PALETA';
end;

end;

{*}PROCEDURE dzialaj;
begin
repeat
  move2(obr^,scr^);
  sprawdzmysz;

{  if not sguzik[1] then begin smx:=mmx; smy:=mmy end;}
  if guzik[1] then linia(smx shr 1,smy,mmx,mmy,23);

  pokaz_okna;

  maskpic(mmx-7,mmy-7,15,15,0,obrmysz,scr^);
  move2(scr^,mem[$a000:0]);
until keypressed;
end;

{-----------------------}
{*}BEGIN
start;
dzialaj;

asm
  mov ax,3h
  int 10h
end;
dispose(obr);
dispose(scr);
end.