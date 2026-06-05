unit myszunit;

{
 Unit do obslugi myszy w Turbo/Borland Pascal'u.
 Autor: Grzegorz "GAD" Drozd
 gad@gad.art.pl
 http://gad.art.pl/

}

interface
var
Smx,Smy,Smx2,Smy2,mx,my,_Smx2,_Smy2,mmx,mmy:integer;
guzik,Sguzik,klik,dwuklik:array[1..2] of boolean;
doklik,juzklik,dodwuklik:array[1..2] of byte;
ruch_mysz,jest_mysz:boolean;

FUNCTION sprawdzczyjestmysz:boolean;
PROCEDURE WlKursmyszy;
PROCEDURE WylKursmyszy;
PROCEDURE sprawdzstanmyszy(var guziki,pozx,pozy:integer);
PROCEDURE ustawpozycjemyszy(pozx,pozy:integer);
PROCEDURE ustawczuloscmyszy(czx,czy:integer);
PROCEDURE sprawdzczuloscmyszy(var czx,czy:integer);
PROCEDURE ustawoknomyszy(x1,y1,x2,y2:integer);


implementation

{*}FUNCTION sprawdzczyjestmysz:boolean;
var tak:boolean;
begin
asm
   xor ax,ax
   int $33
   or  ax,ax
   jnz @jest
   xor bx,bx
   jmp @koniec
  @jest:
   mov bl,1
  @koniec:
   mov tak,bl
end;
sprawdzczyjestmysz:=tak;
jest_mysz:=tak;
end;

{*}PROCEDURE WlKursmyszy;assembler;
asm
   mov ax,1
   int $33
end;

{*}PROCEDURE WylKursmyszy;assembler;
asm
   mov ax,2
   int $33
end;

{*}PROCEDURE sprawdzstanmyszy(var guziki,pozx,pozy:integer);
var guz,px,py:integer;
begin
asm
   mov ax,3
   int $33
   mov guz,bx
   mov px,cx
   mov py,dx
end;
guziki:=guz;
pozx:=px;
pozy:=py;
end;

{*}PROCEDURE ustawpozycjemyszy(pozx,pozy:integer); assembler;
asm
   mov ax,4
   mov cx,pozx
   mov dx,pozy
   int $33
end;

{*}PROCEDURE ustawczuloscmyszy(czx,czy:integer); assembler;
asm
   mov ax,$F
   mov cx,czx
   mov dx,czy
   int $33
end;

{*}PROCEDURE sprawdzczuloscmyszy(var czx,czy:integer);
var czzx,czzy:integer;
begin
asm
  int $33
  mov czzx,cx
  mov czzy,dx
end;
czx:=czzx;
czy:=czzy;
end;

{*}PROCEDURE ustawoknomyszy(x1,y1,x2,y2:integer); assembler;
asm
   mov ax,$7
   mov cx,x1
   mov dx,x2
   int $33
   mov ax,$8
   mov cx,y1
   mov dx,y2
   int $33
end;

end.