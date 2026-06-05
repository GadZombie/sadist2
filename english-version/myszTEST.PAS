uses mysz,crt;

var
g,px,py,
czx,czy:integer;
scr:array[0..199,0..319] of byte absolute $A000:0;


begin
clrscr;
if sprawdzczyjestmysz then writeln('mysz jest')
                      else begin writeln('brak myszy'); halt(1) end;
asm
  mov ax,13h
  int 10h
end;
fillchar(scr,64000,0);
{wlkursmyszy;}
ustawoknomyszy(140*2,80,180*2,120);
ustawczuloscmyszy(10,10);
sprawdzczuloscmyszy(czx,czy);
writeln('czx:',czx);
writeln('czy:',czy);

repeat
   sprawdzmysz;
   scr[mmy,mmx]:=9;
   if guzik[1] then scr[mmy,mmx]:=15;
   if guzik[2] then scr[mmy,mmx]:=7;
until keypressed;

wylkursmyszy;


end.