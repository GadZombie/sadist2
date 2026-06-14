uses crt;

var
plik:text;
a:integer;
nazwa,
nazwapl:string;

{*}FUNCTION EnterText(x,y:integer ;ile_lit:byte ;wyr2:string    ):string;
var
   sc,c,c1:byte;
   wyr3,wyr4:string;
   kl:char;
   a:integer;
begin
wyr4:=wyr2;
c:=length(wyr2);c1:=c;sc:=c;wyr3:='<inny>';
repeat
if (wyr3<>wyr2) or (c<>sc) then begin
   textcolor(8);textbackground(7);
   for a:=c1+1 to ile_lit do begin
       gotoxy(x+a-1,y);write('ú');
   end;
   textcolor(0);
   for a:=1 to c1 do begin
       gotoxy(x+a-1,y);write(wyr2[a]);
   end;
   gotoxy(x+c,y);
   wyr3:=wyr2;sc:=c;
end;
kl:=#255;
if keypressed then begin
   kl:=readkey;
   if (kl<>#13) and (kl<>#8) and (kl<>#0) and (kl<>#255) and (kl<>#27) and (c1<ile_lit) then begin
      insert(kl,wyr2,c+1);inc(c);inc(c1);kl:=#255;
   end;
   if (kl=#8) and (c>=1) then begin
      delete(wyr2,c,1);
      dec(c);dec(c1);kl:=#255;
   end;
   if kl=#0 then begin
      kl:=readkey;
      if (kl=#75) and (c>0) then dec(c);
      if (kl=#77) and (c<c1) then inc(c);
      if (kl=#83) and (c<c1) then begin
         for a:=c+1 to c1 do wyr2[a]:=wyr2[a+1];
         delete(wyr2,c1,1);
         dec(c1);
      end;

      kl:=#255;
   end;
end;
until (kl=#13) or (kl=#27);
if kl=#27 then EnterText:=wyr4
          else EnterText:=wyr2;
textcolor(7);
textbackground(0);
end;

{*}begin
textcolor(7);
textbackground(0);
clrscr;

gotoxy(1,1); writeln('pelna nazwa terenu:');
nazwa:=entertext(2,2,78,'');
if nazwa='' then halt(0);

nazwapl:='';
for a:=1 to length(nazwa) do begin
    if upcase(nazwa[a])<>' ' then nazwapl:=nazwapl+chr(ord(upcase(nazwa[a]))+32);
    if length(nazwapl)>=8 then a:=length(nazwa);
end;
gotoxy(1,3); writeln('nazwa pliku terenu:');
nazwapl:=entertext(2,4,78,nazwapl);

end.