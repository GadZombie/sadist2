unit mysz;

{
 Unit do obslugi myszy w Turbo/Borland Pascal'u.
 Autor: Grzegorz "GAD" Drozd
 gad@gad.koti.com.pl , gad@gad.qs.pl
 http://gad.koti.com.pl/

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

PROCEDURE sprawdzmysz;
FUNCTION mysz_w(x1,y1,x2,y2:integer):boolean;
PROCEDURE czekaj_az_pusci_guziki;

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

{*}PROCEDURE sprawdzmysz;
var
a:byte;
button:integer;

begin
IF jest_mysz then begin
Smx:=mmx shl 1;Smy:=mmy;
sprawdzstanmyszy(button,mmx,mmy);
if (smx<>mmx) or (smy<>mmy) then ruch_mysz:=true else ruch_mysz:=false;
Smx2:=mmx;Smy2:=mmy;
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
mmx:=mmx shr 1;
END ELSE begin{brak myszy}
   mmx:=0;
   mmy:=0;
   smx:=0;
   smy:=0;
   ruch_mysz:=false;
   klik[1]:=false;
   klik[2]:=false;
   guzik[1]:=false;
   guzik[2]:=false;
end;
end;

{*}FUNCTION mysz_w(x1,y1,x2,y2:integer):boolean;
begin
if (mmx>=x1) and (mmx<=x2) and (mmy>=y1) and (mmy<=y2) then mysz_w:=true
                                                       else mysz_w:=false;
end;

{*}PROCEDURE czekaj_az_pusci_guziki;
begin
repeat
  sprawdzmysz;
until (not guzik[1]) and (not guzik[2]);
end;

end.