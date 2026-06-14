uses crt,myszunit,resztki;

const
max=1500;

type
Tscr=array[0..199,0..319] of byte;

var
opad:array[1..max] of record
    jest:boolean;
    x,y:longint;
    kol,plan,rodz:byte; {rodz:0-snieg,1-deszcz}
    end;
a,wiatr,
xs:longint;
scr,tlo:^Tscr;

{*}PROCEDURE move2(var Source,Dest); assembler;
asm
  push       ds
  les        di,Dest
  lds        si,Source
  mov        cx,16000
  db 66h;    rep movsw
  pop        ds
end;

{*}PROCEDURE Putpix(x,y:word;Kolor:byte);
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
    PutPix (X, Y, c);
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



begin
asm
  mov ax,13h
  int 10h
end;
sprawdzczyjestmysz;
ustawoknomyszy(0,0,639,199);
new(scr);
new(tlo);
fillchar(scr^,64000,0);
fillchar(tlo^,64000,0);
fillchar(opad,sizeof(opad),0);
wiatr:=0;
randomize;
for a:=0 to 9 do drawline(random(320),random(200),random(320),random(200),9);
repeat
wiatr:=wiatr+random(9)-4;

if guzik[2] then wiatr:=wiatr+(smx2-smx);

if wiatr<-1000 then wiatr:=-1000;
if wiatr>1000 then wiatr:=1000;
move2(tlo^,scr^);
for a:=1 to max do with opad[a] do begin
    if (not jest) then begin
       if random(40)=0 then begin
          x:=longint(random(320))*1024;
          y:=0;
          kol:=27+random(4);
          jest:=true;
       end else
       if (guzik[1]) and (random(40)=0) then begin
          x:=(mmx-6+random(13))*1024;
          y:=mmy;
          kol:=28+random(4);
          jest:=true;
       end;
    end else begin
       if tlo^[y+1,x shr 10]=0 then y:=y+1;
       if tlo^[y,(x+wiatr) shr 10]=0 then x:=x+wiatr;
       if (y>=198) then jest:=false;
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
scr^[mmy,mmx]:=4;

move2(scr^,mem[$A000:0]);
until keypressed;

dispose(tlo);
dispose(scr);
asm
  mov ax,3h
  int 10h
end;
end.