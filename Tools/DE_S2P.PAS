uses crt,dos;

const
naglowek:array[1..25] of char='Sadist II Zestaw postaci1';

type
Tpobr=array[0..103,0..14,0..14] of byte;
Tmobr=array[0..15,0..6,0..6] of byte;

var
plik:file;
a:integer;
nazwas2p,
nazwaobrp,
nazwaobrm:string;

pobr:^Tpobr;
mobr:^Tmobr;
imie,autor:string[25];
dzww:array[0..12] of record
                     n:string[8];
                     os,r:longint;
                     end;

{*}PROCEDURE zapisz_pobr(nazwa:string);
var
io:integer;
b:byte;
begin
{$I+} io:=ioresult; {$I-}
assign(plik,nazwa);
{$I-}
rewrite(plik,1);
b:=15;
blockwrite(plik,b,1);
blockwrite(plik,b,1);
blockwrite(plik,pobr^,sizeof(pobr^));
close(plik);
io:=ioresult;
if io=0 then writeln('Obrazki zapisane poprawnie')
        else writeln('Blad numer ',io);
{$I+}
end;

{*}PROCEDURE zapisz_mobr(nazwa:string);
var
io:integer;
b:byte;
begin
{$I+} io:=ioresult; {$I-}
assign(plik,nazwa);
{$I-}
rewrite(plik,1);
b:=7;
blockwrite(plik,b,1);
blockwrite(plik,b,1);
blockwrite(plik,mobr^,sizeof(mobr^));
close(plik);
io:=ioresult;
if io=0 then writeln('Obrazki miesa zapisane poprawnie')
        else writeln('Blad numer ',io);
{$I+}
end;

{*}PROCEDURE zapisz_dzwieki;
var
io:integer;
dzwplik:file;
NumRead, NumWritten: Word;
Buf: array[1..2048] of Char;
dlug:longint;
begin
{$I+} io:=ioresult; {$I-}
assign(plik,nazwas2p);
{$I-}
reset(plik,1);
{
for a:=0 to 12 do begin
  Assign(dzwplik, dzww[a].n+'.raw');
  reset(dzwplik,1);
  dzww[a].r:=filesize(dzwplik);
  if a=0 then dzww[a].os:=filepos(plik)+sizeof(dzww)
         else dzww[a].os:=dzww[a-1].os+dzww[a-1].r;
  Close(dzwplik);
end;
blockwrite(plik,dzww,sizeof(dzww));
}

for a:=0 to 12 do begin
  Assign(dzwplik, dzww[a].n+'.raw');
  Rewrite(dzwplik, 1);
  Writeln('zapisuje plik ', dzww[a].n,'.raw');
  writeln('Dzwiek ',a+1,': ',dzww[a].n,' [offset:',dzww[a].os,', rozmiar:',dzww[a].r,']');
  dlug:=dzww[a].r;
  seek(plik,dzww[a].os);
  repeat
    Blockread (plik, Buf, SizeOf(Buf), NumRead);
    dec(dlug,numread);
    while dlug<0 do begin inc(dlug); dec(numread) end;
    Blockwrite(dzwplik, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead) or (dlug<=0);
  Close(dzwplik);
end;

io:=ioresult;
if io=0 then writeln('S2P zapisany poprawnie')
        else writeln('Blad numer ',io);
{$I+}
end;

{*}PROCEDURE wczytaj;
var io:integer;
begin
{$I+} io:=ioresult; {$I-}
assign(plik,nazwas2p);
{$I-}
reset(plik,1);

blockread(plik,naglowek,sizeof(naglowek));
blockread(plik,imie,sizeof(imie));
blockread(plik,autor,sizeof(autor));
blockread(plik,pobr^,sizeof(pobr^));
blockread(plik,mobr^,sizeof(mobr^));

seek(plik,24637);
blockread(plik,dzww,sizeof(dzww));

close(plik);
io:=ioresult;
if io=0 then writeln('S2P odczytany poprawnie')
        else begin
             writeln('Blad numer ',io);
             halt;
             end;
{$I+}
end;

{*}PROCEDURE standard;
var a1:integer;
begin
dzww[0].n:='ua1'    ;
dzww[1].n:='ua2'    ;
dzww[2].n:='ua3'    ;
dzww[3].n:='uh'     ;
dzww[4].n:='panika' ;
dzww[5].n:='wyrzuca';
dzww[6].n:='haha'   ;
dzww[7].n:='hyhy'   ;
dzww[8].n:='skok'   ;
dzww[9].n:='cios'   ;
dzww[10].n:='kop'   ;
dzww[11].n:='miesko';
dzww[12].n:='smierc';

imie:='POSTACI';
autor:='GAD';
end;

{*}BEGIN
if paramcount=0 then begin
   writeln('Podaj nazwe pliku S2P jako parametr (bez rozszerzenia)');
   halt;
end;

textbackground(0);
textcolor(7);
clrscr;
new(pobr);
new(mobr);
standard;

nazwas2p:=paramstr(1)+'.S2P';
nazwaobrp:=paramstr(1)+'.OBR';
if length(paramstr(1))<=7 then nazwaobrm:=paramstr(1)+'M.OBR'
   else begin
     nazwaobrm:=paramstr(1)+'.OBR';
     nazwaobrm[8]:='M'
   end;

wczytaj;

writeln;
writeln('Zestaw postaci: ',imie);
writeln('Autor: ',autor);
writeln;
writeln('Nazwa pliku z obrazkami: '+nazwaobrp);
writeln('Nazwa pliku z obrazkami miesa: '+nazwaobrm);
writeln;
for a:=0 to 12 do writeln('Dzwiek ',a+1,': ',dzww[a].n,' [offset:',dzww[a].os,', rozmiar:',dzww[a].r,']');
writeln;

zapisz_dzwieki;
zapisz_pobr(nazwaobrp);
zapisz_mobr(nazwaobrm);


dispose(mobr);
dispose(pobr);
end.