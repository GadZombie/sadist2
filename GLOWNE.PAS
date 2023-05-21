unit glowne;
{$G+,N+}
interface
uses crt,vars,maskp,xms,dat_file;

{*}PROCEDURE trybgraf;
{*}PROCEDURE trybtext;
{*}PROCEDURE Putpix(x, y : word; Kolor : byte);
{*}PROCEDURE Putpixt(x, y : word; Kolor : byte);
{*}PROCEDURE PutpixN(x,y:word);
{*}FUNCTION Getpix(x, y : word):byte;
{*}FUNCTION getpix_x(xobr,yobr:longint):byte;
{*}PROCEDURE putpix_x(xobr,yobr:longint;kol:byte);
{*}PROCEDURE putpix_xT(xobr,yobr:longint;kol:byte);
{*}PROCEDURE hlineT(x1,x2,y:longint;kol:byte);
{*}PROCEDURE hline_x(x1,x2,y:longint;kol:byte);
{*}PROCEDURE hline_smiec_x(x1,x2,y:longint;kol1,kol2:byte);
{*}PROCEDURE hline_textura_x(x1,x2,y:longint);
{*}PROCEDURE hline_ciem_x(x1,x2,y:longint;kol:byte);
{*}PROCEDURE DrawLine (x1, y1, x2, y2 : Integer; c : Byte;przezr:boolean);
{*}PROCEDURE bar(x1,y1,x2,y2:word;kolor:byte);
{*}PROCEDURE Ebar(x1,y1,x2,y2:word;kolor:byte);
{*}PROCEDURE EbarT(x1,y1,x2,y2:word;kolor:byte);
{*}PROCEDURE pisz(xobr,yobr:integer;tekst:string;kolor1:integer);
{*}PROCEDURE piszm(xobr,yobr:integer;tekst:string;kolor1:integer);
{*}PROCEDURE piszc(xobr,yobr:integer;tekst:string;kolor1:integer);
{*}PROCEDURE wczytaj_fonty;
{*}PROCEDURE Get_Keyb_Int; interrupt;
{*}PROCEDURE cala_paleta(z_czekaniem:boolean);
{*}PROCEDURE Fadein(szybkosc,_od,_do:byte);
{*}PROCEDURE Fadeout(szybkosc,_od,_do:byte);
{*}PROCEDURE Fadeout2(r,g,b,sz,szybkosc:byte);
{*}PROCEDURE Fadein2(_od,_do,szybkosc,szyb:byte;zerowanie:boolean);
{*}PROCEDURE wczytaj_pal(nazwa:string);
{*}PROCEDURE FillChar2(var X; Count: Word; Value:Byte);
{*}PROCEDURE move2(var Source,Dest);
{*}PROCEDURE Move3(var source, dest; count: word);
{*}PROCEDURE move5(var Source,Dest);
{*}PROCEDURE synchro;
{*}PROCEDURE MaskPicXMSwXMS(X,Y,Width,Height:integer; Maskcolor:byte;
             offset:longint;odwroc:shortint);
{*}PROCEDURE MaskPicXMSwXMS2(X,Y,Width,Height:integer; Maskcolor:byte;
             offset:longint;odwroc:shortint);
{*}FUNCTION l2t(liczba:longint;ilosc_lit:byte):string;
{*}FUNCTION upcasestr(t:string):string;
{*}PROCEDURE znajdz_kolor(rr,gg,bb:byte;var nr:byte;od_kol:byte);
{*}PROCEDURE obrazki;

implementation

{*}PROCEDURE trybgraf;
begin
asm
  mov ax, $13
  int $10
end;
end;

{*}PROCEDURE trybtext;
begin
asm
  mov ax, $3
  int $10
end;
end;

{*}PROCEDURE Putpix(x,y:word;Kolor:byte);
begin
  if (x>=scr_x1) and (x<=scr_x2) and (y>=scr_y1) and (y<=scr_y2) then Scr^[y,x]:=Kolor
end;

{*}FUNCTION Getpix(x,y:word):byte;
begin
  if (x>=scr_x1) and (x<=scr_x2) and (y>=scr_y1) and (y<=scr_y2) then getpix:=Scr^[y,x]
     else getpix:=0
end;

{*}PROCEDURE Putpixt(x,y:word;Kolor:byte);
begin
  if (x>=scr_x1) and (x<=scr_x2) and (y>=scr_y1) and (y<=scr_y2) then
     Scr^[y,x]:=chmur^[scr^[y,x],Kolor]
end;

{*}PROCEDURE PutpixN(x,y:word);
begin
  if (x>=scr_x1) and (x<=scr_x2) and (y>=scr_y1) and (y<=scr_y2) then
     Scr^[y,x]:=negatyw^[scr^[y,x]]
end;

{*}FUNCTION getpix_x(xobr,yobr:longint):byte;
var
aa:byte;
begin
if (xobr>=0) and (xobr<maxx) and (yobr>=0) and
   (((pogoda.dziura=0) and (yobr<=419)) or ((pogoda.dziura>=1) and (yobr<=399)))
   then begin
   xms2mem(_xms[1].h,offsety[2]+yobr*maxx+xobr,aa,1);
   getpix_x:=aa;
   end
      else getpix_x:=0
end;

{*}PROCEDURE putpix_x(xobr,yobr:longint;kol:byte);
var
aa:word;
ab:byte;
begin
if (yobr>=0) and (yobr<maxy) and (xobr>=0) and (xobr<maxx) then begin
   xms2mem(_xms[1].h,offsety[2]+yobr*maxx+xobr+1,ab,1);
   aa:=kol+ab shl 8;
   mem2xms(aa,_xms[1].h,offsety[2]+yobr*maxx+xobr,1)
end
end;

{*}PROCEDURE putpix_xT(xobr,yobr:longint;kol:byte);
var
aa:word;
ab:array[0..1] of byte;
begin
if (yobr>=0) and (yobr<maxy) and (xobr>=0) and (xobr<maxx) then begin
   xms2mem(_xms[1].h,offsety[2]+yobr*maxx+xobr,ab,2);
   aa:=chmur^[ab[0],kol]+(ab[1] shl 8);
   mem2xms(aa,_xms[1].h,offsety[2]+yobr*maxx+xobr,1);
end;
end;

{*}PROCEDURE hlineT(x1,x2,y:longint;kol:byte);
var
buf:array[0..maxx-1] of byte;
p1:integer;
begin
IF (y>=0) and (y<200-ekr.menuwys) and (x2>=0) and (x1<=319) THEN begin
   if x1<0 then x1:=0;
   if x2>=319 then x2:=319;
   for p1:=x1 to x2 do scr^[y,p1]:=chmur^[scr^[y,p1],kol];
END;
end;

{*}PROCEDURE hline_x(x1,x2,y:longint;kol:byte);
var
buf:array[0..maxx-1] of byte;
p1,p2:integer;
begin
IF (y>=0) and (y<maxy) and (x2>=0) and (x1<=maxx) THEN begin
xms2mem(_xms[1].h,offsety[2]+y*maxx+x1,buf,x2-x1+1);
if x1<0 then p1:=abs(x1)
        else p1:=0;
if x2>=maxx then p2:=x2-x1-(x2-maxx)
            else p2:=x2-x1+1-p1;
fillchar2(buf[p1],p2,0);
mem2xms(buf,_xms[1].h,offsety[2]+y*maxx+x1,x2-x1+1);
END;
end;

{*}PROCEDURE hline_smiec_x(x1,x2,y:longint;kol1,kol2:byte);
var
buf:array[0..maxx-1] of byte;
a,p1,p2:integer;
begin
IF (y>=0) and (y<maxy) and (x2>=0) and (x1<=maxx) THEN begin
xms2mem(_xms[1].h,offsety[2]+y*maxx+x1,buf,x2-x1+1);
if x1<0 then p1:=abs(x1)
        else p1:=0;
if x2>=maxx then p2:=x2-x1-(x2-maxx)
            else p2:=x2-x1+1-p1;
for a:=p1 to p1+p2-1 do buf[a]:=kol1+random(kol2-kol1+1);
{fillchar2(buf[p1],p2,0);}
mem2xms(buf,_xms[1].h,offsety[2]+y*maxx+x1,x2-x1+1);
END;
end;

{*}PROCEDURE hline_textura_x(x1,x2,y:longint);
var
buf:array[0..maxx-1] of byte;
buf2:array[0..639] of byte;
a,p2:integer;
begin
IF (y>=0) and (y<maxy) and (x2>=0) and (x1<=maxx) THEN begin
xms2mem(_xms[1].h,offsety[2]+y*maxx+x1,buf,x2-x1+1);
if x1<0 then x1:=0;
if x2>=maxx then p2:=x2-x1-(x2-maxx)
            else p2:=x2-x1+1;
xms2mem(_xms[1].h,offsety[12]+(y mod texturar.ry)*320,buf2,texturar.rx);
xms2mem(_xms[1].h,offsety[12]+(y mod texturar.ry)*320,buf2[texturar.rx],texturar.rx);

for a:=0 to p2-1 do buf[a]:=buf2[(x1+a) mod texturar.rx];
mem2xms(buf,_xms[1].h,offsety[2]+y*maxx+x1,(x2-x1+1) div 2*2);
END;
end;

{*}PROCEDURE hline_ciem_x(x1,x2,y:longint;kol:byte);
var
buf:array[-100..maxx+100] of byte;
a:longint;
p1,p2:integer;
begin
IF (y>=0) and (y<maxy) and (x2>=0) and (x1<=maxx) THEN begin
xms2mem(_xms[1].h,offsety[2]+y*maxx+x1,buf[0],x2-x1+1);
if x1<0 then p1:=abs(x1)
        else p1:=0;
if x2>=maxx then p2:=x2-x1-(x2-maxx)
            else p2:=x2-x1+1-p1;
for a:=0 to p2-1 do
    if (buf[p1+a]>=160) and (buf[p1+a]<=167) then begin
       if buf[p1+a] mod 8>0 then dec(buf[p1+a])
    end
       else buf[p1+a]:=ciempal[buf[p1+a]];
mem2xms(buf[0],_xms[1].h,offsety[2]+y*maxx+x1,x2-x1+1);
END;
end;

{*}PROCEDURE DrawLine (x1, y1, x2, y2 : Integer; c : Byte;przezr:boolean);
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
    if przezr then PutPix (X, Y, chmur^[getpix(x,y),c])
              else PutPix (X, Y, c);
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

{*}PROCEDURE bar(x1,y1,x2,y2:word;kolor:byte);
var
  y : word;
begin
  for y := y1 to y2 do
      if (y>=0) and (y<=199) then FillChar(Scr^[y, x1], x2-x1+1, kolor);
end;

{*}PROCEDURE Ebar(x1,y1,x2,y2:word;kolor:byte);
begin
  drawline(x1,y1,x1,y2,kolor,false);
  drawline(x2,y1,x2,y2,kolor,false);
  drawline(x1,y1,x2,y1,kolor,false);
  drawline(x1,y2,x2,y2,kolor,false);
  {FillChar(Scr^[y1, x1], x2-x1+1, kolor);
  FillChar(Scr^[y2, x1], x2-x1+1, kolor);}
end;

{*}PROCEDURE EbarT(x1,y1,x2,y2:word;kolor:byte);
begin
  drawline(x1,y1,x1,y2,kolor,true);
  drawline(x2,y1,x2,y2,kolor,true);
  drawline(x1,y1,x2,y1,kolor,true);
  drawline(x1,y2,x2,y2,kolor,true);
end;

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
    if xobr+(a-1)*7>scr_x2 then a:=length(tekst) else begin
     if (tekst[a]<>' ') then
        maskpic3(xobr+(a-1)*7,yobr,7,7,0,kolor1,fonty^[numer],scr^);
    end;
end;
end;

{*}PROCEDURE piszm(xobr,yobr:integer;tekst:string;kolor1:integer);
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
         '`':numer:=59;
    end;
    if xobr+(a-1)*4>scr_x2 then a:=length(tekst) else begin
     if (tekst[a]<>' ') then
        maskpic2(xobr+(a-1)*4,yobr,4,6,0,kolor1,fontym^[numer],scr^);
    end;
end;
end;

{*}PROCEDURE piszc(xobr,yobr:integer;tekst:string;kolor1:integer);
begin
pisz(xobr-trunc(length(tekst)*3.5),yobr,tekst,kolor1);
end;

{*}PROCEDURE wczytaj_fonty;
begin
datassign(plik,'dane\s2.dat','fontn.obr',2);
blockread(plik,fonty^,2989);close(plik);
datassign(plik,'dane\s2.dat','font.obr',2);
blockread(plik,fontym^,1440);close(plik);
end;

{*}PROCEDURE Get_Keyb_Int;
begin
asm
  in al,$60;
  xor cx,cx
  xor bx,bx
  mov bl,al
  and bl,$7F;
  test al,$80;
  jnz @@set
  inc cl;
  @@set:
  mov byte ptr[bx+Kl],cl;
  int Old_Int;
end;
end;

{*}PROCEDURE cala_paleta(z_czekaniem:boolean);
var
count:byte;
begin
if z_czekaniem then begin
   count:=port[$3DA];
   while $8 and count<>0 do count:=port[$3DA];
   while $8 and count=0 do count:=port[$3DA];
end;
port[$3C8]:=0;
for count:=0 to 255 do begin
    port[$3C9]:=pal[count,0];
    port[$3C9]:=pal[count,1];
    port[$3C9]:=pal[count,2];
end;
end;

{*}PROCEDURE Fadein(szybkosc,_od,_do:byte);
var
a,b:byte;
zm:boolean;
begin
for a:=_od to _do do begin
    pal[a,0]:=0;
    pal[a,1]:=0;
    pal[a,2]:=0;
end;
b:=0;
while b<=63 do begin
    inc(b,szybkosc);
    if b>64 then b:=64;
    for a:=0 to 255 do begin
        pal[a,0]:=trunc(pal_gl[a,0]*(b/64));if pal[a,0]>63 then pal[a,0]:=63;
        pal[a,1]:=trunc(pal_gl[a,1]*(b/64));if pal[a,1]>63 then pal[a,1]:=63;
        pal[a,2]:=trunc(pal_gl[a,2]*(b/64));if pal[a,2]>63 then pal[a,2]:=63;
    end;
    cala_paleta(true);
    while keypressed do readkey;
end;
end;

{*}PROCEDURE Fadeout(szybkosc,_od,_do:byte);
var
a:byte;
b:integer;
zm:boolean;
begin
b:=63;
while b>0 do begin
    dec(b,szybkosc);
    if b<0 then b:=0;
    for a:=0 to 255 do begin
        pal[a,0]:=trunc(pal_gl[a,0]*(b/64));
        pal[a,1]:=trunc(pal_gl[a,1]*(b/64));
        pal[a,2]:=trunc(pal_gl[a,2]*(b/64));
    end;
    cala_paleta(true);
    while keypressed do readkey;
end;

end;

{*}PROCEDURE Fadeout2(r,g,b,sz,szybkosc:byte);
var
a,c:byte;
zm:boolean;
begin
pal:=pal_gl;
repeat
zm:=false;
for a:=0 to 255 do begin
    for c:=1 to szybkosc do begin
    if pal[a,0]>r then begin zm:=true;dec(pal[a,0]);end;
    if pal[a,0]<r then begin zm:=true;inc(pal[a,0]);end;
    end;
    for c:=1 to szybkosc do begin
    if pal[a,1]>g then begin zm:=true;dec(pal[a,1]);end;
    if pal[a,1]<g then begin zm:=true;inc(pal[a,1]);end;
    end;
    for c:=1 to szybkosc do begin
    if pal[a,2]>b then begin zm:=true;dec(pal[a,2]);end;
    if pal[a,2]<b then begin zm:=true;inc(pal[a,2]);end;
    end;
end;
cala_paleta(true);
while keypressed do readkey;
delay(sz);
until not zm;
end;

{*}PROCEDURE Fadein2(_od,_do,szybkosc,szyb:byte;zerowanie:boolean);
var
a,b:byte;
zm:boolean;
begin
repeat
zm:=false;
for a:=_od to _do do begin
    for b:=1 to szybkosc do begin
        if pal[a,0]<pal_gl[a,0] then begin zm:=true;inc(pal[a,0]);end;
        if pal[a,0]>pal_gl[a,0] then begin zm:=true;dec(pal[a,0]);end;
    end;
    for b:=1 to szybkosc do begin
        if pal[a,1]<pal_gl[a,1] then begin zm:=true;inc(pal[a,1]);end;
        if pal[a,1]>pal_gl[a,1] then begin zm:=true;dec(pal[a,1]);end;
    end;
    for b:=1 to szybkosc do begin
        if pal[a,2]<pal_gl[a,2] then begin zm:=true;inc(pal[a,2]);end;
        if pal[a,2]>pal_gl[a,2] then begin zm:=true;dec(pal[a,2]);end;
    end;
end;
cala_paleta(true);
while keypressed do readkey;
delay(szyb);
until not zm;
end;

{*}PROCEDURE wczytaj_pal(nazwa:string);
begin
datassign(plik,'dane\s2.dat',nazwa,0);
blockread(plik,pal_gl,768);
close(plik);
end;

{*}PROCEDURE FillChar2(Var X; Count: Word; Value:Byte); Assembler;
Asm
  les di,x
  mov cx,Count
  shr cx,1
  mov al,value
  mov ah,al
  rep StoSW
  test count,1
  jz @end
  StoSB
@end:
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

{*}PROCEDURE Move3(var source, dest; count: word); assembler;
  asm
   push ds
   lds  si,source
   les  di,dest
   mov  cx,count
   mov  ax,cx
   cld
   shr  cx,2
   db   66h
   rep  movsw
   mov  cl,al
   and  cl,3
   rep  movsb
   pop  ds
end;

{*}PROCEDURE move5(var Source,Dest); assembler;
asm
  push       ds
  les        di,Dest
  lds        si,Source
  mov        cx,80
  db 66h;    rep movsw
  pop        ds
end;

{*}PROCEDURE synchro; assembler;
asm
  mov dx,3dah
  @wait:
  in al,dx
  test al,8
  je @wait
end;

{*}PROCEDURE MaskPicXMSwXMS(X,Y,Width,Height:integer; Maskcolor:byte;
             offset:longint;odwroc:shortint);
var
buf:array[0..59,0..59] of byte;
rx,a:byte;
ofs:longint;
begin
if (x<=-width) or (x>=maxx) or (y<=-height) or (y>=maxy) then exit;
if width mod 2=1 then rx:=width+1 else rx:=width;
for a:=0 to height-1 do begin
    xms2mem(_xms[1].h,offsety[2]+(longint(y)+longint(a))*maxx+x,scr2^[a],rx+2);
end;
maskpicxms(0,0,width,height,maskcolor,offset,scr2^,odwroc,true);

if x+rx>maxx then rx:=maxx-x-1;
ofs:=0;
if x<0 then ofs:=abs(x);

for a:=0 to height-1 do
    mem2xms(scr2^[a,ofs],_xms[1].h,offsety[2]+(longint(y)+longint(a))*maxx+x+ofs,rx-ofs);
end;

{*}PROCEDURE MaskPicXMSwXMS2(X,Y,Width,Height:integer; Maskcolor:byte;
             offset:longint;odwroc:shortint);
var
buf:array[0..59,0..59] of byte;
rx,a:byte;
ofs:longint;
begin
if (x<=-width) or (x>=maxx) or (y<=-height) or (y>=maxy) then exit;
if width mod 2=1 then rx:=width+1 else rx:=width;
for a:=0 to height-1 do begin
    xms2mem(_xms[1].h,offsety[2]+(longint(y)+longint(a))*maxx+x,scr2^[a],rx+2);
end;
maskpic2xms(0,0,width,height,maskcolor,0,offset,scr2^,odwroc,true);

if x+rx>maxx then rx:=maxx-x-1;
ofs:=0;
if x<0 then ofs:=abs(x);

for a:=0 to height-1 do
    mem2xms(scr2^[a,ofs],_xms[1].h,offsety[2]+(longint(y)+longint(a))*maxx+x+ofs,rx-ofs);
end;

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

{*}FUNCTION upcasestr(t:string):string;
var a:byte;
begin
for a:=1 to length(t) do t[a]:=upcase(t[a]);
upcasestr:=t;
end;

{*}PROCEDURE znajdz_kolor(rr,gg,bb:byte;var nr:byte;od_kol:byte);
var a:byte;roznica,pom:word;
begin
roznica:=50000; {jakas duza wartosc}
for a:=od_kol to 255 do begin
    pom:=abs(pal[a,0]-rr) + abs(pal[a,1]-gg) + abs(pal[a,2]-bb);
    if pom<roznica then begin
       roznica:=pom;
       nr:=a;
       if roznica=0 then a:=255;
    end;{if}
end;{for}
end;{procedure}

{*}PROCEDURE obrazki;
var
buf:array[0..999] of byte;
a:longint;
b:byte;
c:word;

begin
{$I+}a:=ioresult;{$I-}

offsety[1]:=      0; {tlo niebo}
offsety[2]:= 192000; {tlo ziemia}
offsety[3]:=1300000; {obrazki}

   {      0.. 191999 - 192kb na 3xEkran niebo}
   { 192000..1299999 - 512+512kb na 8xEkran teren+kopia ekranu przy trzesieniu ziemi}
   {1300000..1999999 -  ??kb na obrazki}

{obrazki do xms}
{offsety[3]  postaci}
{------wczytaj postaci------}

offsety[4]:=offsety[3]+5*25000; {kursory myszy}
datassign(plik,'dane\s2.dat','myszka.obr',2);
for a:=0 to 11 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[4]+a*1000, 1000);
end;
close(plik);

{ememememmemmemmmmm}
datassign(plik,'dane\s2.dat','pila.obr',2);
for a:=0 to 2 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[4]+a*1000+12000, 1000);
end;
close(plik);

offsety[5]:=offsety[4]+15000; {wybuchy}
datassign(plik,'dane\s2.dat','wybuch.obr',2);
for a:=0 to 71 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[5]+a*1000, 1000);
end;
close(plik);

offsety[6]:=offsety[5]+72000; {dymy}
datassign(plik,'dane\s2.dat','dym.obr',2);
for a:=0 to 5 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[6]+a*1000, 1000);
end;
close(plik);

{wczytanie menusuff z gdruff}
offsety[7]:=offsety[6]+6000; {menu1 bronie}
datassign (plik,'dane\s2.dat','menu1.gdr',0);
blockread(plik,GDRHead,sizeof(GDRHead));
fillchar2(scr^,64000,0);
for a:=0 to GDRHead.RY-1 do blockread(plik,scr^[a],GDRHead.RX);
close(plik);
mem2xms(scr^,_xms[1].h,offsety[7],12800);

datassign (plik,'dane\s2.dat','menu2.gdr',0);  {menu2 inne}
blockread(plik,GDRHead,sizeof(GDRHead));
fillchar2(scr^,64000,0);
for a:=0 to GDRHead.RY-1 do blockread(plik,scr^[a],GDRHead.RX);
close(plik);
mem2xms(scr^,_xms[1].h,offsety[7]+12800,12800);

datassign (plik,'dane\s2.dat','menu3.gdr',0);  {menu3 postaci}
blockread(plik,GDRHead,sizeof(GDRHead));
fillchar2(scr^,64000,0);
for a:=0 to GDRHead.RY-1 do blockread(plik,scr^[a],GDRHead.RX);
close(plik);
mem2xms(scr^,_xms[1].h,offsety[7]+25600,12800);

datassign (plik,'dane\s2.dat','menu4.gdr',0);  {menu4 pogoda}
blockread(plik,GDRHead,sizeof(GDRHead));
fillchar2(scr^,64000,0);
for a:=0 to GDRHead.RY-1 do blockread(plik,scr^[a],GDRHead.RX);
close(plik);
mem2xms(scr^,_xms[1].h,offsety[7]+38400,12800);

datassign (plik,'dane\s2.dat','menu5.gdr',0);  {menu5 rysowanie}
blockread(plik,GDRHead,sizeof(GDRHead));
fillchar2(scr^,64000,0);
for a:=0 to GDRHead.RY-1 do blockread(plik,scr^[a],GDRHead.RX);
close(plik);
mem2xms(scr^,_xms[1].h,offsety[7]+51200,12800);

datassign (plik,'dane\s2.dat','menu6.gdr',0);  {menu5 glowne menu}
blockread(plik,GDRHead,sizeof(GDRHead));
fillchar2(scr^,64000,0);
for a:=0 to GDRHead.RY-1 do blockread(plik,scr^[a],GDRHead.RX);
close(plik);
mem2xms(scr^,_xms[1].h,offsety[7]+64000,12800);

datassign (plik,'dane\s2.dat','czekaj.gdr',0);  {znaczek sadist}
blockread(plik,GDRHead,sizeof(GDRHead));
for a:=0 to 255 do begin
    palczekaj[a,0]:=GDRHead.pal[a,0];
    palczekaj[a,1]:=GDRHead.pal[a,1];
    palczekaj[a,2]:=GDRHead.pal[a,2];
end;
fillchar2(scr^,64000,0);
blockread(plik,scr^,56672);
close(plik);
mem2xms(scr^,_xms[1].h,offsety[7]+76800,56672);

offsety[8]:=offsety[7]+134800; {inne rzeczy do rzucania, kowadlo}
datassign(plik,'dane\s2.dat','innerzut.obr',2);
for a:=0 to 0 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[8]+a*1000, 1000);
end;
close(plik);
datassign(plik,'dane\s2.dat','kowadlo.obr',2);
blockread(plik,buf,250,c);
mem2xms(buf, _xms[1].h, offsety[8]+1000, 250);
close(plik);

offsety[9]:=offsety[8]+2000; {jaszczurka do intra}
datassign(plik,'dane\s2.dat','jaszczur.obr',2);
for a:=0 to 33 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[9]+a*1000, 1000);
end;
close(plik);

datassign (plik,'dane\s2.dat','intronap.gdr',0);  {napis w intro od 34000}
blockread(plik,GDRHead,sizeof(GDRHead));
fillchar2(scr^,64000,0);
for a:=0 to GDRHead.RY-1 do blockread(plik,scr^[a],GDRHead.RX);
close(plik);
for a:=0 to GDRHead.RY-1 do mem2xms(scr^[a],_xms[1].h,offsety[9]+34000+a*302,302);


offsety[10]:=offsety[9]+48000; {ogien na ludziach}
datassign(plik,'dane\s2.dat','ogien1.obr',2);
for a:=0 to 1 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[10]+a*1000, 1000);
end;
close(plik);

datassign(plik,'dane\s2.dat','ogien2.obr',2);
for a:=0 to 0 do begin {ogien do miotacza}
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[10]+2000+a*1000, 1000);
end;
close(plik);

datassign(plik,'dane\s2.dat','ogien3.obr',2);
for a:=0 to 0 do begin {ogien na miesie}
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[10]+3000+a*1000, 1000);
end;
close(plik);

offsety[11]:=offsety[10]+4000; {zarezerwowane 64kb na ekrany itp}

offsety[12]:=offsety[11]+128000; {zarezerwowane 64kb na texture do rysowania}

offsety[13]:=offsety[12]+64000; {zarezerwowane 30kb na liste tekstur}
offsety[14]:=offsety[13]+30000; {zarezerwowane 30kb na liste wierzchow}

offsety[15]:=offsety[14]+30000; {tablica smieci od 0 do 2 [do terenu]}
for a:=0 to 999 do buf[a]:=random(3);
mem2xms(buf, _xms[1].h, offsety[15], 1000);

offsety[16]:=offsety[15]+1000; {zarezerwowane 5kb na miniature tla+12kb na przyklad terenu z koloru}
offsety[17]:=offsety[16]+17000;  {zarezerwowane 30kb na liste postaci - nazwy plikow}
offsety[18]:=offsety[17]+30000; {zarezerwowane 30kb na liste postaci - nazwy zestawow}

offsety[19]:=offsety[18]+30000; {ikony do menu z postaciami}
datassign(plik,'dane\s2.dat','ikony.obr',2);
for a:=0 to 7 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[19]+a*1000, 1000);
end;
close(plik);
datassign(plik,'dane\s2.dat','ikony3.obr',2);
blockread(plik,buf,525,c);
mem2xms(buf, _xms[1].h, offsety[19]+11000, 1000);
close(plik);
datassign(plik,'dane\s2.dat','pytajnik.obr',2);
blockread(plik,buf,233,c);
mem2xms(buf, _xms[1].h, offsety[19]+11700, 234);
close(plik);
datassign(plik,'dane\s2.dat','ikony2.obr',2);
for a:=0 to 4 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[19]+12000+a*1000, 1000);
end;
close(plik);

offsety[20]:=offsety[19]+17000; {zwierzatka}
datassign(plik,'dane\s2.dat','ptaszki.obr',2);
for a:=0 to 1 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[20]+a*1000, 1000);
end;
close(plik);

offsety[21]:=offsety[20]+2000; {elementy do rysowania}
datassign(plik,'dane\s2.dat','obiekty.obr',2);
for a:=0 to 1 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[21]+a*1000, 1000);
end;
close(plik);

offsety[22]:=offsety[21]+2000; {paczki}
datassign(plik,'dane\s2.dat','paczka.obr',2);
blockread(plik,buf,1000,c);
mem2xms(buf, _xms[1].h, offsety[22], 1000);
close(plik);

offsety[23]:=offsety[22]+1000; {ikony bonusow}
datassign(plik,'dane\s2.dat','bonusy.obr',2);
for a:=0 to 1 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[23]+a*1000, 1000);
end;
close(plik);

offsety[24]:=offsety[23]+2000; {rysunek zegara do loud/sejw}
datassign(plik,'dane\s2.dat','czekaj.obr',2);
for a:=0 to 3 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[24]+a*1000, 1000);
end;
close(plik);

offsety[25]:=offsety[24]+4000; {zarezerwowane 40kb na lupe}

offsety[26]:=offsety[25]+40000;
datassign(plik,'dane\s2.dat','pocisk1.obr',2);
blockread(plik,buf,392);
mem2xms(buf, _xms[1].h, offsety[26], 392); {0}
close(plik);
datassign(plik,'dane\s2.dat','pocisk2.obr',2);
blockread(plik,buf,392);
mem2xms(buf, _xms[1].h, offsety[26]+392, 392); {8}
close(plik);
datassign(plik,'dane\s2.dat','pocisk3.obr',2);
blockread(plik,buf,392);
mem2xms(buf, _xms[1].h, offsety[26]+784, 392); {16}
close(plik);
datassign(plik,'dane\s2.dat','mina.obr',2);
blockread(plik,buf,784);
mem2xms(buf, _xms[1].h, offsety[26]+1176, 784); {24}
close(plik);
datassign(plik,'dane\s2.dat','pocisk4.obr',2);
blockread(plik,buf,392);
mem2xms(buf, _xms[1].h, offsety[26]+1960, 392); {40}
close(plik);

offsety[27]:=offsety[26]+3000;
datassign(plik,'dane\s2.dat','zaznaczo.obr',2);
blockread(plik,buf,125);
mem2xms(buf, _xms[1].h, offsety[27], 125); {0}
close(plik);
datassign(plik,'dane\s2.dat','x.obr',2);
blockread(plik,buf,40);
mem2xms(buf, _xms[1].h, offsety[27]+125, 40); {5}
close(plik);
datassign(plik,'dane\s2.dat','wskaznik.obr',2);
blockread(plik,buf,50);
mem2xms(buf, _xms[1].h, offsety[27]+165, 50); {7}
close(plik);

offsety[28]:=offsety[27]+500; {zarezerwowane 32kb na wierzch (byle trawabuf)}

offsety[29]:=offsety[28]+32000; {ikony broni}
(*datassign(plik,'dane\s2.dat','ikbroni.obr',2);
for a:=0 to 12 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[29]+a*1000, 1000);
end;
close(plik);
*)
offsety[30]:=offsety[29]+13000; {paleta kolorow w menu do rysowania}

for b:=0 to 23 do begin
    for a:=0 to 17 do buf[a]:=kolter[1+(b div 2)+(a div 3)*12];
    mem2xms(buf, _xms[1].h, offsety[30]+longint(b)*18, 18);
end;

offsety[31]:=offsety[30]+1000; {glowne menu * 2}
datassign (plik,'dane\s2.dat','tlo.gdr',0);
blockread(plik,GDRHead,sizeof(GDRHead));
blockread(plik,scr^,64000);
mem2xms(scr^,_xms[1].h,offsety[31],64000);
close(plik);

datassign (plik,'dane\s2.dat','menuglow.gdr',8);
blockread(plik,scr^,64000);
mem2xms(scr^,_xms[1].h,offsety[31]+64000,64000);
close(plik);

offsety[32]:=offsety[31]+128000; {guziki w glownym menu}
datassign(plik,'dane\s2.dat','guzmenu.obr',2);
for a:=0 to 8 do begin
    blockread(plik,buf,1000,c);
    mem2xms(buf, _xms[1].h, offsety[32]+a*1000, 1000);
end;
close(plik);


{---}
{$I+}
a:=ioresult; {olanie wszelkich bledow, niech dziala dalej, a ioresult:=0 :)}
{$I-}
end;

end.