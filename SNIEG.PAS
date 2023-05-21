uses crt,myszunit;

const
max=3000;

type
Tscr=array[0..199,0..319] of byte;

var
opad:array[1..max] of record
    jest:boolean;
    x,y:longint;
    kol:byte;
    end;
a,wiatr,b,
xs:longint;
scr,tlo:^Tscr;
c,opcja:integer;
kl:char;
sypie:boolean;

{*}PROCEDURE sprawdz_mysz;
var
a:byte;
button:integer;
begin
Smx:=mmx*2;Smy:=mmy;
sprawdzstanmyszy(button,mmx,mmy);
Smx2:=mmx;Smy2:=mmy;
if (guzik[2]) then begin ustawpozycjemyszy(Smx,Smy);mmx:=Smx;mmy:=Smy;end;
if button=0 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=false;guzik[2]:=false;end;
if button=1 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=true ;guzik[2]:=false;end;
if button=2 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=false;guzik[2]:=true ;end;
if button=3 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=true ;guzik[2]:=true ;end;
for a:=1 to 2 do begin
    if (not Sguzik[a]) and (guzik[a]) then begin
       klik[a]:=true;doklik[a]:=40;
       if dodwuklik[a]=0 then dodwuklik[a]:=10;
    end
        else klik[a]:=false;

    if (klik[a]) and (dodwuklik[a]>=1) and (dodwuklik[a]<=9) then begin
       dwuklik[a]:=true;
       dodwuklik[a]:=0
    end
       else dwuklik[a]:=false;
    if dodwuklik[a]>0 then dec(dodwuklik[a]);

    if not guzik[a] then begin doklik[a]:=0;juzklik[a]:=0;end;
    if doklik[a]>0 then dec(doklik[a]);
    if doklik[a]=1 then begin
       klik[a]:=true;
       if juzklik[a]>=10 then doklik[a]:=3
                         else begin doklik[a]:=10;inc(juzklik[a]);end;
    end;

end;
mmx:=mmx div 2;
mmy:=mmy;
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

{*}PROCEDURE bar(x1,y1,x2,y2:integer;kolor:byte);
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
    FillChar(tlo^[y, x1], x2-x1+1, kolor);
end;

{*}PROCEDURE Putpix(x,y:word;Kolor:byte);
begin
  if (x>=0) and (x<=319) and (y>=0) and (y<=199) then scr^[y,x]:=Kolor
end;

{*}PROCEDURE Putpixtlo(x,y:word;Kolor:byte);
begin
  if (x>=0) and (x<=319) and (y>=0) and (y<=199) then tlo^[y,x]:=Kolor
end;

{*}PROCEDURE DrawLine (x1, y1, x2, y2 : Integer; c : Byte);
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
    PutPixtlo (X, Y, c);
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

{*}PROCEDURE sprawdzprawo(var Dest;y,b:word;var c:integer);
var _c:integer;
begin
_c:=-1;
Asm
  PUSH  DS
  LDS   DI,Dest
  mov   bx,b
  xor   cx,cx
  mov   di,y
  add   di,b
 @petla:
  mov   al,byte ptr ds:[di]
  cmp   al,0
  je @dalej
  mov   _c,cx
  jmp  @starczy
 @dalej:
  dec   di
  dec   bx
  inc   cx
  cmp   bx,-1
  jne  @petla
 @starczy:
  POP   DS
End;
c:=_c;
end;

{*}PROCEDURE sprawdzlewo(var Dest;y,b:word;var c:integer);
var _c:integer;
begin
_c:=-1;
Asm
  PUSH  DS
  LDS   DI,Dest
  mov   bx,b
  xor   cx,cx
  mov   di,y
  add   di,b
 @petla:
  mov   al,byte ptr ds:[di]
  cmp   al,0
  je @dalej
  mov   _c,cx
  jmp  @starczy
 @dalej:
  inc   di
  inc   bx
  inc   cx
  cmp   bx,320
  jne  @petla
 @starczy:
  POP   DS
End;
c:=_c;
end;


begin
if not sprawdzczyjestmysz then begin
   Writeln('Potrzeba myszy!');
   halt(0);
end;
asm
  mov ax,13h
  int 10h
end;
ustawoknomyszy(0,0,639,199);
new(scr);
new(tlo);
fillchar(scr^,64000,0);
fillchar(tlo^,64000,0);
fillchar(opad,sizeof(opad),0);
wiatr:=0;
randomize;

opcja:=0;

repeat
wiatr:=wiatr+random(9)-4;

if guzik[2] then wiatr:=wiatr+(smx2-smx);

if wiatr<-1000 then wiatr:=-1000;
if wiatr>1000 then wiatr:=1000;
move2(tlo^,scr^);
for a:=1 to max do with opad[a] do begin
    if (not jest) then begin
       if (sypie) and (random(60)=0) then begin
          x:=longint(random(320))*1024;
          y:=0;
          kol:=27+random(4);
          jest:=true;
       end else
       if (guzik[1]) and (opcja=0) and (random(40)=0) then begin
          x:=(mmx-6+random(13))*1024;
          y:=mmy;
          kol:=28+random(4);
          jest:=true;
       end;
    end else begin
       if tlo^[y+1,x shr 10]=0 then y:=y+1;

       if (wiatr>0) and (tlo^[y,(x+wiatr) shr 10]=0) then begin
          sprawdzprawo(tlo^,y*320,x shr 10,c);
          if c<0 then x:=x+wiatr
             else if c>20 then x:=x+c*wiatr shr 8
       end else
       if (wiatr<0) and (tlo^[y,(x+wiatr) shr 10]=0) then begin
          sprawdzlewo(tlo^,y*320,x shr 10,c);
          if c<0 then x:=x+wiatr
             else if c>20 then x:=x-c*abs(wiatr) shr 8
       end;


       if (y>=198) or (x<0) or (x shr 10>319) then jest:=false;
       xs:=x shr 10;
       if tlo^[y+1,xs]<>0 then begin
          if (tlo^[y+1,xs-1]=0) and (tlo^[y,xs-1]=0) and (random(500)>2) then x:=x-1024 else
          if (tlo^[y+1,xs+1]=0) and (tlo^[y,xs+1]=0) and (random(500)>2) then x:=x+1024 else
          jest:=false;
       end;


       if (x>=0) and (x shr 10<=319) and (y>=0) and (y<=199) then
          if not jest then tlo^[y,x shr 10]:=kol
             else scr^[y,x shr 10]:=kol;
    end;
end;
sprawdz_mysz;
putpix(mmx,mmy,40-opcja*3);
putpix(mmx+1,mmy,43-opcja*3);
putpix(mmx,mmy+1,43-opcja*3);
putpix(mmx-1,mmy,43-opcja*3);
putpix(mmx,mmy-1,43-opcja*3);

if (opcja=1) and (guzik[1]) then drawline(smx shr 1,smy,mmx,mmy,9);

if (opcja=2) and (guzik[1]) then bar(mmx-6,mmy-6,mmx+6,mmy+6,0);

kl:=#255;
if keypressed then begin
   kl:=readkey;
   if kl=#32 then sypie:=not sypie;
   if kl=#0 then begin
      kl:=readkey;
      if kl=#59 then opcja:=0;
      if kl=#60 then opcja:=1;
      if kl=#61 then opcja:=2;
   end;
end;


move2(scr^,mem[$A000:0]);
until kl=#27;

dispose(tlo);
dispose(scr);
asm
  mov ax,3h
  int 10h
end;
writeln('Snieg z rzeczywistym wiatrem (c) 2001 GAD');
writeln('eml:gad@gad.art.pl');
writeln('http://gad.art.pl/');
while keypressed do readkey;
end.