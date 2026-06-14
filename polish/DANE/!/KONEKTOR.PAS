uses crt,dos;

const
   ver:string[3]='1.3';
   nagl:array[1..5] of char=(#255,'D','A','T','1');
   maxkat=3000;
   maxplik=2500;
type
 Tkat=record
         nazwa:array[1..maxkat] of string[13];
         rozmiar:array[1..maxkat] of longint;
         end;
 Tduzy=record
      nazwa:array[1..maxplik] of string[13];
      rozmiar:array[1..maxplik] of longint;
      offset:array[1..maxplik] of longint;
      jest:array[1..maxplik] of boolean;
      end;
var
 FromF, ToF: file;
 NumRead, NumWritten: Word;
 Buf: array[1..2048] of Char;

 DirInfo:SearchRec;
 F: file;
 Attr: Word;
 wyr:string;

 naglowek:string[74];
 nazwa_duzego,nazwa_projektu,nazwa_spisu:string[12];
 zapis_spisu,spis_plikow_w_duzym,bol:boolean;
 ustaw_alfab:byte;
 ustaw_alfab_duzy:shortint;

 katalog:^Tkat;
 duzy:^Tduzy;
 a,b,c,d,xk:integer;
 yk,nr:array[1..2] of integer;
 kl:char;
 li:longint;
 ilosc_plikow:longint;

{*}PROCEDURE WlKurs;assembler;
asm
   mov ah,01h
   mov ch,8
   mov cl,9
   int 10h
end;

{*}PROCEDURE WylKurs;assembler;
asm
   mov ah,01h
   mov ch,9
   mov cl,0
   int 10h
end;

{*}FUNCTION podziel(co:longint):string;
var wyr:string;d:byte;
begin
str(co,wyr);
d:=length(wyr);
if d>3 then insert('.',wyr,d-2);
if d>6 then insert('.',wyr,d-5);
if d>9 then insert('.',wyr,d-8);
podziel:=wyr;
end;

{*}FUNCTION duze(co:string):string;
var a:byte;
begin
for a:=1 to length(co) do co[a]:=upcase(co[a]);
while pos(' ',co)>0 do delete(co,pos(' ',co),1);
duze:=co;
end;

{*}PROCEDURE tip(co:string;wys:byte);
begin
textcolor(1);textbackground(7);
gotoxy(1,22+wys);write('                                                                                ');
textcolor(0);
gotoxy(trunc(41-(length(co)/2)),22+wys);write(co);
end;

{*}PROCEDURE podstawowy_tip;
begin
   case xk of
   1:begin
      tip('Wybierz pliki, ktore chcesz dodac do pliku '''+nazwa_duzego+'''',0);
      tip('ENTER-wybiera plik, TAB-przejscie do edycji w duzym pliku',1);
     end;
   2:begin
      tip('Wybierz pliki, ktore chcesz usunac z pliku '''+nazwa_duzego+'''',0);
      tip('DELETE-usuwa plik, TAB-przejscie do wyboru plikow w katalogu',1);
     end;
   end;
end;

{*}FUNCTION EnterText(x,y:integer;ile_lit:byte;wyr2:string):string;
var
   sc,c,c1:byte;
   wyr3,wyr4:string;
   kl:char;
   a:integer;
begin
wyr4:=wyr2;
c:=length(wyr2);c1:=c;sc:=c;wyr3:='<inny>';
wlkurs;
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
      if (kl=#71) then c:=0;
      if (kl=#79) then c:=c1;
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
wylkurs;
end;

{*}FUNCTION dlugosc_naglowka:longint;
begin
if spis_plikow_w_duzym then
   dlugosc_naglowka:=sizeof(nagl)+length(naglowek)+1+sizeof(nr[2])+
    (13+longint(sizeof(duzy^.rozmiar[a]))+longint(sizeof(duzy^.offset[a])))*longint(nr[2])
else
   dlugosc_naglowka:=length(naglowek);
end;

{*}PROCEDURE kontrola;
{sprawdzanie fizycznej obecnosci plikow i ich poprawnosci}
var
a,a2:integer;
pier:word;
F:file;
begin
  filemode:=0;
  {$I-}
  pier:=0;
  for a:=1 to nr[2] do begin
    assign(F,duzy^.nazwa[a]);
    reset(F);
    if (IOResult<>0) or (duze(duzy^.nazwa[a])=duze(nazwa_duzego)) then begin
       duzy^.jest[a]:=false;
       duzy^.rozmiar[a]:=0;
       duzy^.offset[a]:=0;
       if (duze(duzy^.nazwa[a])=duze(nazwa_duzego)) then close(F);
       end else begin
       close(F);
       if pier=0 then pier:=a;
       FindFirst(duzy^.nazwa[a], Anyfile+Hidden, DirInfo);
       Assign(F, DirInfo.Name);
       GetFAttr(F, Attr);
       if (Attr and Anyfile <> 0) then begin
           duzy^.rozmiar[a]:=dirinfo.size;
           if a=pier then
              duzy^.offset[a]:=dlugosc_naglowka;
           if a>pier then begin
              for a2:=a-1 downto 1 do begin
                  if duzy^.jest[a2] then begin
                     duzy^.offset[a]:=duzy^.offset[a2]+duzy^.rozmiar[a2];
                     a2:=1;
                  end;
              end;
           end;
       end;
       duzy^.jest[a]:=true;
    end;
  end;
  {$I+}
  filemode:=2;
end;

{*}PROCEDURE kontrola_zwykla;
{sprawdzanie obecnosci plikow w liscie plikow}
var
a,a2,a3:integer;
pier:word;
size:longint;
jest:boolean;
begin
  pier:=0;
  for a:=1 to nr[2] do begin
    jest:=false;
    for a3:=1 to nr[1] do begin
        if (duze(katalog^.nazwa[a3])=duze(duzy^.nazwa[a])) then begin
           jest:=true;
           size:=katalog^.rozmiar[a3];
           a3:=nr[1];
        end;
    end;
    if (not jest) or (duze(duzy^.nazwa[a])=duze(nazwa_duzego)) then begin
       duzy^.jest[a]:=false;
       duzy^.rozmiar[a]:=0;
       duzy^.offset[a]:=0;
       end
          else begin
       if pier=0 then pier:=a;
       duzy^.rozmiar[a]:=size;
       if a=pier then duzy^.offset[a]:=dlugosc_naglowka;
       if a>pier then begin
          for a2:=a-1 downto 1 do begin
              if duzy^.jest[a2] then begin
                 duzy^.offset[a]:=duzy^.offset[a2]+duzy^.rozmiar[a2];
                 a2:=1;
              end;
          end;
       end;
       duzy^.jest[a]:=true;
    end;
  end;
end;

{*}PROCEDURE kontrola_szybka;
{poprawianie offsetow}
var
a,a2:integer;
pier:word;
begin
  pier:=0;
  for a:=1 to nr[2] do begin
    if (duze(duzy^.nazwa[a])=duze(nazwa_duzego)) then begin
       duzy^.jest[a]:=false;
       duzy^.rozmiar[a]:=0;
       duzy^.offset[a]:=0;
       end
          else begin
       if pier=0 then pier:=a;
       if a=pier then duzy^.offset[a]:=dlugosc_naglowka;
       if a>pier then begin
          for a2:=a-1 downto 1 do begin
              if duzy^.jest[a2] then begin
                 duzy^.offset[a]:=duzy^.offset[a2]+duzy^.rozmiar[a2];
                 a2:=1;
              end;
          end;
       end;
       duzy^.jest[a]:=true;
    end;
  end;
end;

{*}PROCEDURE dodaj_pliki;
var
dod,dnazwa,droz:string;
d1,d2,b1,b2:byte;
dodaj,ok:boolean;
begin
textcolor(15);textbackground(1);
gotoxy(32,10);write('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
gotoxy(32,11);write('³ Dodaj pliki: ³');
gotoxy(32,12);write('³              ³');
gotoxy(32,13);write('³              ³');
gotoxy(32,14);write('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
textcolor(0);textbackground(7);
gotoxy(34,13);write('úúúúúúúúúúúú');
gotoxy(34,13);dod:=entertext(34,13,12,'*.*');
dod:=duze(dod);
d1:=0;
for b:=1 to length(dod) do begin
    if (dod[b]='.') and (d1=0) then d1:=b;
    if (b=length(dod)) and (d1=0) then d1:=b;
end;

for a:=1 to nr[1] do begin
    wyr:=duze(katalog^.nazwa[a]);
    d2:=0;
    for b:=1 to length(wyr) do begin
        if (wyr[b]='.') and (d2=0) then d2:=b;
        if (b=length(wyr)) and (d2=0) then d2:=b;
    end;
    dodaj:=true;
    ok:=false;
    b1:=0;
    b2:=0;
    repeat
       inc(b1);
       inc(b2);
       if (dod[b1]<>'?') and (dod[b1]<>'*') and (dod[b1]<>wyr[b2]) then dodaj:=false;
       if (dod[b1]='*') and (b1<=d1) then begin b1:=d1;b2:=d2;end
          else
          if (dod[b1]='*') and (b1>d1) then b1:=length(dod);
    until (not dodaj) or (b1=length(dod));

    if (dodaj) and (nr[2]<maxplik) then begin
       inc(nr[2]);
       duzy^.nazwa[nr[2]]:=katalog^.nazwa[a];
       if duze(duzy^.nazwa[nr[2]])<>duze(nazwa_duzego) then begin
          duzy^.rozmiar[nr[2]]:=katalog^.rozmiar[a];
          duzy^.jest[nr[2]]:=true;
          if nr[2]=1 then duzy^.offset[nr[2]]:=length(naglowek);
          if nr[2]>1 then duzy^.offset[nr[2]]:=duzy^.offset[nr[2]-1]+duzy^.rozmiar[nr[2]-1];
       end
          else duzy^.jest[nr[2]]:=false;
       yk[2]:=nr[2];
    end;
end;
kontrola_zwykla;
end;

{*}PROCEDURE odejmij_pliki;
var
dod,dnazwa,droz:string;
d1,d2,b1,b2:byte;
odejmij,ok:boolean;
a1:integer;
begin
textcolor(15);textbackground(1);
gotoxy(31,10);write('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
gotoxy(31,11);write('³ Odejmij pliki: ³');
gotoxy(31,12);write('³                ³');
gotoxy(31,13);write('³                ³');
gotoxy(31,14);write('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
textcolor(0);textbackground(7);
gotoxy(34,13);write('úúúúúúúúúúúú');
gotoxy(34,13);dod:=entertext(34,13,12,'*.*');
dod:=duze(dod);
d1:=0;
for b:=1 to length(dod) do begin
    if (dod[b]='.') and (d1=0) then d1:=b;
    if (b=length(dod)) and (d1=0) then d1:=b;
end;

a:=1;
while a<=nr[2] do begin
    wyr:=duze(duzy^.nazwa[a]);
    d2:=0;
    for b:=1 to length(wyr) do begin
        if (wyr[b]='.') and (d2=0) then d2:=b;
        if (b=length(wyr)) and (d2=0) then d2:=b;
    end;
    odejmij:=true;
    ok:=false;
    b1:=0;
    b2:=0;
    repeat
       inc(b1);
       inc(b2);
       if (dod[b1]<>'?') and (dod[b1]<>'*') and (dod[b1]<>wyr[b2]) then odejmij:=false;
       if (dod[b1]='*') and (b1<=d1) then begin b1:=d1;b2:=d2;end
          else
          if (dod[b1]='*') and (b1>d1) then b1:=length(dod);
    until (not odejmij) or (b1=length(dod));

    if (odejmij) then begin
       for a1:=a to nr[2]-1 do begin
           duzy^.nazwa[a1]:=duzy^.nazwa[a1+1];
           duzy^.rozmiar[a1]:=duzy^.rozmiar[a1+1];
           duzy^.jest[a1]:=duzy^.jest[a1+1];
       end;
       a:=0;
       duzy^.nazwa[nr[2]]:='';
       duzy^.rozmiar[nr[2]]:=0;
       duzy^.offset[nr[2]]:=0;
       duzy^.jest[nr[2]]:=true;
       dec(nr[2]);
    end;
    inc(a);
end;
if yk[2]>nr[2] then yk[2]:=nr[2];
if nr[2]=0 then kl:=#9;
kontrola_zwykla;
end;

{*}PROCEDURE ustaw_duzy_alfabetycznie(jak:byte);
begin
textcolor(15);textbackground(1);
gotoxy(32,10);write('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
gotoxy(32,11);write('³              ³');
gotoxy(32,12);write('³  Sortowanie  ³');
gotoxy(32,13);write('³              ³');
gotoxy(32,14);write('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
for a:=1 to nr[2] do
    while length(duzy^.nazwa[a])<12 do duzy^.nazwa[a]:=duzy^.nazwa[a]+' ';
IF jak=1 then {rozsz}
   for a:=1 to nr[2] do begin
       wyr:=duzy^.nazwa[a];
       duzy^.nazwa[a]:=copy(wyr,10,3);
       duzy^.nazwa[a]:=duzy^.nazwa[a]+'.'+copy(wyr,1,8);
   end;
IF jak in [0,1] then {naz,rozsz}
   repeat
       b:=0;
       for a:=1 to nr[2]-1 do begin
           if duzy^.nazwa[a]>duzy^.nazwa[a+1] then begin
              wyr:=duzy^.nazwa[a];duzy^.nazwa[a]:=duzy^.nazwa[a+1];duzy^.nazwa[a+1]:=wyr;
              li:=duzy^.rozmiar[a];duzy^.rozmiar[a]:=duzy^.rozmiar[a+1];duzy^.rozmiar[a+1]:=li;
              b:=1;
           end;
       end;
   until b=0;
IF jak=2 then {rozmiar}
   repeat
       b:=0;
       for a:=1 to nr[2]-1 do begin
           if duzy^.rozmiar[a]>duzy^.rozmiar[a+1] then begin
              wyr:=duzy^.nazwa[a];duzy^.nazwa[a]:=duzy^.nazwa[a+1];duzy^.nazwa[a+1]:=wyr;
              li:=duzy^.rozmiar[a];duzy^.rozmiar[a]:=duzy^.rozmiar[a+1];duzy^.rozmiar[a+1]:=li;
              b:=1;
           end;
       end;
   until b=0;
IF jak=1 then {rozsz}
   for a:=1 to nr[2] do begin
       wyr:=duzy^.nazwa[a];
       duzy^.nazwa[a]:=copy(wyr,5,8);
       duzy^.nazwa[a]:=duzy^.nazwa[a]+'.'+copy(wyr,1,3);
   end;

kontrola;
textcolor(15);textbackground(1);
while keypressed do readkey;
gotoxy(30,10);write('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
gotoxy(30,11);write('³                   ³');
gotoxy(30,12);write('³ Pliki posortowane ³');
gotoxy(30,13);write('³                   ³');
gotoxy(30,14);write('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
readkey;
end;

{*}PROCEDURE ustaw_katalog_alfabetycznie(jak:byte);
begin
for a:=1 to nr[1] do
    while length(katalog^.nazwa[a])<12 do katalog^.nazwa[a]:=katalog^.nazwa[a]+' ';
IF jak=1 then {rozsz}
   for a:=1 to nr[1] do begin
       wyr:=katalog^.nazwa[a];
       katalog^.nazwa[a]:=copy(wyr,10,3);
       katalog^.nazwa[a]:=katalog^.nazwa[a]+'.'+copy(wyr,1,8);
   end;
IF jak in [0,1] then {naz,rozsz}
   repeat
       b:=0;
       for a:=1 to nr[1]-1 do begin
           if katalog^.nazwa[a]>katalog^.nazwa[a+1] then begin
              wyr:=katalog^.nazwa[a];katalog^.nazwa[a]:=katalog^.nazwa[a+1];katalog^.nazwa[a+1]:=wyr;
              li:=katalog^.rozmiar[a];katalog^.rozmiar[a]:=katalog^.rozmiar[a+1];katalog^.rozmiar[a+1]:=li;
              b:=1;
           end;
       end;
   until b=0;
IF jak=2 then {rozmiar}
   repeat
       b:=0;
       for a:=1 to nr[1]-1 do begin
           if katalog^.rozmiar[a]>katalog^.rozmiar[a+1] then begin
              wyr:=katalog^.nazwa[a];katalog^.nazwa[a]:=katalog^.nazwa[a+1];katalog^.nazwa[a+1]:=wyr;
              li:=katalog^.rozmiar[a];katalog^.rozmiar[a]:=katalog^.rozmiar[a+1];katalog^.rozmiar[a+1]:=li;
              b:=1;
           end;
       end;
   until b=0;
IF jak=1 then {rozsz}
   for a:=1 to nr[1] do begin
       wyr:=katalog^.nazwa[a];
       katalog^.nazwa[a]:=copy(wyr,5,8);
       katalog^.nazwa[a]:=katalog^.nazwa[a]+'.'+copy(wyr,1,3);
   end;
end;

{*}PROCEDURE zapisz;
var
krok:real;
procc:longint;
a2:integer;
rr:word;
wyr2:string;
begin
kontrola;
textcolor(15);textbackground(1);
gotoxy(14,10);write('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
gotoxy(14,11);write('³                                                  ³');
gotoxy(14,12);write('³                                                  ³');
gotoxy(14,13);write('³                                                  ³');
gotoxy(14,14);write('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
wyr:='Zapisuje : '''+nazwa_duzego+'''...';
gotoxy(round(40-(length(wyr)/2)),11);write(wyr);

textcolor(0);textbackground(7);
gotoxy(34,12);write('            ');
textcolor(4);textbackground(1);
gotoxy(16,13);write('ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ');

krok:=(duzy^.offset[nr[2]]+duzy^.rozmiar[nr[2]])/48;
procc:=0;
Assign(ToF, nazwa_duzego);
{l$lI-}
Rewrite(ToF, 1);

if spis_plikow_w_duzym then begin
   blockwrite(tof,nagl,sizeof(nagl));
   d:=length(naglowek)+1;
   blockwrite(tof,naglowek,d);
end
   else
   begin
   wyr:=naglowek;d:=length(wyr);
   for c:=1 to d do begin b:=ord(wyr[c]);blockwrite(ToF,b,1);end;
   end;
if spis_plikow_w_duzym then begin
   blockwrite(tof,nr[2],sizeof(nr[2]));
   for a:=1 to nr[2] do begin
       wyr:='            ';
       wyr:=duze(duzy^.nazwa[a]);
       blockwrite(tof,wyr,13);
       blockwrite(tof,duzy^.rozmiar[a],sizeof(duzy^.rozmiar[a]));
       blockwrite(tof,duzy^.offset[a],sizeof(duzy^.offset[a]));
   end;
end;

for a:=1 to nr[2] do begin
    wyr:=duzy^.nazwa[a];
    textcolor(0);textbackground(7);
    gotoxy(round(40-(length(wyr)/2)),12);write(wyr);

   if duzy^.jest[a] then begin
    Assign(FromF, duzy^.nazwa[a]);
    Reset(FromF, 1);
    repeat
        BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
        BlockWrite(ToF, Buf, NumRead, NumWritten);
    until (NumRead = 0) or (NumWritten <> NumRead);
    procc:=procc+filesize(FromF);
    Close(FromF);
    textcolor(10);textbackground(1);
    gotoxy(16,13);
    for a2:=0 to trunc(procc/krok) do write('Ü');
   end
      else begin
       wyr:='Tego pliku nie ma, lub jest uszkodzony !';
       textcolor(12);textbackground(1);
       gotoxy(round(40-(length(wyr)/2)),11);write(wyr);
       textcolor(15);
       wyr:='Zapisuje : '''+nazwa_duzego+'''...';
       gotoxy(15,11);write('                                                  ');
       gotoxy(round(40-(length(wyr)/2)),11);write(wyr);
      end;
end;
Close(ToF);

IF zapis_spisu THEN BEGIN
   Assign(ToF, nazwa_spisu);
   Rewrite(ToF, 1);
   wyr:='Plik '+nazwa_duzego+' :'+#13#10;d:=length(wyr);
   for c:=1 to d do begin b:=ord(wyr[c]);blockwrite(ToF,b,1);end;
   wyr:='nazwa       '+'³    rozmiar'+'³     offset'+#13#10;d:=length(wyr);
   for c:=1 to d do begin b:=ord(wyr[c]);blockwrite(ToF,b,1);end;
   for a:=1 to nr[2] do begin
       wyr:=duzy^.nazwa[a];d:=length(wyr);
       for c:=1 to d do begin b:=ord(wyr[c]);blockwrite(ToF,b,1);end;
       wyr:=podziel(duzy^.rozmiar[a]);while length(wyr)<11 do insert(' ',wyr,1);wyr:='³'+wyr;d:=length(wyr);
       for c:=1 to d do begin b:=ord(wyr[c]);blockwrite(ToF,b,1);end;
       wyr:=podziel(duzy^.offset[a]);while length(wyr)<11 do insert(' ',wyr,1);wyr:='³'+wyr+#13#10;d:=length(wyr);
       for c:=1 to d do begin b:=ord(wyr[c]);blockwrite(ToF,b,1);end;
   end;
   Close(ToF);
END;
textcolor(15);textbackground(1);
gotoxy(24,10);write('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
gotoxy(24,11);write('³                              ³');
gotoxy(24,12);write('³                              ³');
gotoxy(24,13);write('³                              ³');
gotoxy(24,14);write('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');

rr:=IOResult;
if rr=0 then wyr:='Zapisane :)'
        else begin
             str(rr,wyr2);
             wyr:='Wystapil blad '+wyr2+' :(';
        end;

gotoxy(round(40-(length(wyr)/2)),12);write(wyr);
readkey;
for a:=10 to 14 do begin
    gotoxy(14,a);write('                                                    ');
end;
{$I+}
end;

{*}PROCEDURE zapisz_projekt;
var
krok:real;
procc:longint;
a2:integer;
begin
textcolor(15);textbackground(1);
gotoxy(24,10);write('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
gotoxy(24,11);write('³                              ³');
gotoxy(24,12);write('³                              ³');
gotoxy(24,13);write('³                              ³');
gotoxy(24,14);write('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
wyr:='Zapisuje : '''+nazwa_projektu+'''...';
gotoxy(round(40-(length(wyr)/2)),12);write(wyr);

Assign(ToF, nazwa_projektu);
{$I-}
Rewrite(ToF, 1);
blockwrite(ToF, nr[2], sizeof(nr[2]));
blockwrite(ToF, nazwa_duzego, sizeof(nazwa_duzego));
blockwrite(ToF, naglowek, sizeof(naglowek));
blockwrite(ToF, duzy^.nazwa, 14*nr[2]);
blockwrite(ToF, nazwa_spisu, sizeof(nazwa_spisu));
blockwrite(ToF, zapis_spisu, sizeof(zapis_spisu));
blockwrite(ToF, spis_plikow_w_duzym, sizeof(spis_plikow_w_duzym));
blockwrite(ToF, ustaw_alfab_duzy, 1);
Close(ToF);

if IOResult = 0 then wyr:='       Projekt zapisany       '
                else wyr:='       Wystapil blad :(       ';
gotoxy(25,12);write(wyr);
readkey;
for a:=10 to 14 do begin
    gotoxy(24,a);write('                                ');
end;
{$I+}
end;

{*}PROCEDURE wczytaj_projekt(komunikaty:byte);
var
a2:integer;
wyr2:string;
rr:word;
begin
if komunikaty=1 then begin
textcolor(15);textbackground(1);
gotoxy(24,10);write('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
gotoxy(24,11);write('³                              ³');
gotoxy(24,12);write('³                              ³');
gotoxy(24,13);write('³                              ³');
gotoxy(24,14);write('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
wyr:='Wczytuje : '''+nazwa_projektu+'''...';
gotoxy(round(40-(length(wyr)/2)),12);write(wyr);
end;

Assign(ToF, nazwa_projektu);
{$I-}
Reset(ToF, 1);

rr:=IOResult;
if rr=0 then begin
  blockread(ToF, nr[2], sizeof(nr[2]));
  blockread(ToF, nazwa_duzego, sizeof(nazwa_duzego));
  blockread(ToF, naglowek, sizeof(naglowek));
  blockread(ToF, duzy^.nazwa, 14*nr[2]);
  blockread(ToF, nazwa_spisu, sizeof(nazwa_spisu));
  blockread(ToF, zapis_spisu, sizeof(zapis_spisu));
  blockread(ToF, spis_plikow_w_duzym, sizeof(spis_plikow_w_duzym));
  blockread(ToF, ustaw_alfab_duzy, 1);
  Close(ToF);
  kontrola;
end;
case rr of
     0:wyr:='Projekt wczytany';
     2:wyr:='Nie ma takiego pliku!';
     1,3..255:begin
       str(rr,wyr2);
       wyr:='Wystapil blad '+wyr2+' :(';
       end;
end;
if komunikaty=1 then begin
gotoxy(25,12);write('                              ');
gotoxy(round(40-(length(wyr)/2)),12);write(wyr);
readkey;
for a:=10 to 14 do begin
    gotoxy(24,a);write('                                ');
end;
end;
{$I+}
end;

{*}PROCEDURE pokaz_glowne;
begin
textbackground(1);
for a:=2 to 20 do begin
    gotoxy(1,a);
    write('                                                                              ');
end;
textbackground(0);textcolor(9);
gotoxy(3 ,2);write('ÉÍnazwaÍÍÍÍrozÍÍÍÍÍÍÍrozmiarÍ»');
gotoxy(33,2);write('ÉÍnazwaÍÍÍÍrozÍÍÍÍÍÍÍrozmiarÍÍÍÍÍÍÍÍÍÍoffsetÍ»');
for a:=3 to 19 do begin
    gotoxy(3 ,a);write('º                            º');
    gotoxy(33,a);write('º                                            º');
end;
gotoxy(3 ,20);write('ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼');
gotoxy(33,20);write('ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼');
textbackground(1);textcolor(0);
for a:=2 to 20 do begin
    gotoxy(1 ,a);write('°');
    gotoxy(80,a);write('°');
end;
podstawowy_tip;
textbackground(0);textcolor(11);
case ustaw_alfab of
   0:begin
     gotoxy(5,2);write('nazwa');
     end;
   1:begin
     gotoxy(14,2);write('roz');
     end;
   2:begin
     gotoxy(24,2);write('rozmiar');
     end;
end;
end;

{*}PROCEDURE pokaz_ed_projekt;
begin
textbackground(1);
for a:=2 to 20 do begin
    gotoxy(1,a);
    write('                                                                              ');
end;
textcolor(15);textbackground(1);gotoxy(4,3);write('Nazwa pliku projektu:');
textcolor( 8);textbackground(7);gotoxy(4,4);write('úúúúúúúúúúúú');gotoxy(4,4);textcolor(0);write(nazwa_projektu);
textcolor(15);textbackground(1);gotoxy(4,5);write('Nazwa duzego pliku:');
textcolor( 8);textbackground(7);gotoxy(4,6);write('úúúúúúúúúúúú');gotoxy(4,6);textcolor(0);write(nazwa_duzego);
textcolor(15);textbackground(1);gotoxy(4,7);write('Naglowek duzego pliku:');
textcolor( 8);textbackground(7);gotoxy(4,8);
write('úúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúú');
textcolor(0);gotoxy(4,8);write(naglowek);
textcolor(15);textbackground(1);gotoxy(4,9);write('Zapis spisu plikow:');
gotoxy(24,9);if zapis_spisu then write('tak') else write('nie');
textcolor(15);textbackground(1);gotoxy(4,10);write('Nazwa pliku ze spisem:');
textcolor( 8);textbackground(7);gotoxy(4,11);write('úúúúúúúúúúúú');gotoxy(4,11);textcolor(0);write(nazwa_spisu);
textcolor(15);textbackground(1);gotoxy(4,12);write('Dodanie spisu plikow w naglowku duzego pliku:');
gotoxy(50,12);if spis_plikow_w_duzym then write('tak') else write('nie');
textcolor(15);textbackground(1);gotoxy(4,14);write('Sortowanie plikow w duzym pliku wg:');
gotoxy(40,14);
case ustaw_alfab_duzy of
   0:write('nazwy');
   1:write('rozszerzenia');
   2:write('rozmiaru');
end;
textcolor(30);textbackground(1);gotoxy(54,14);write('[ENTER-sortuje!]');
textcolor(15);textbackground(1);gotoxy(4,16);write('Zapisz projekt');
textcolor(15);textbackground(1);gotoxy(4,17);write('Wczytaj projekt');
textcolor(15);textbackground(1);gotoxy(4,18);write('Powrot');

tip('Edycja projektu',0);
tip('',1);
end;

{*}PROCEDURE ed_projekt;
const
wysok:array[1..10] of byte= (3,5,7,9,10,12,14,16,17,18);
var
ky:byte;
pier,a2:word;
begin
pokaz_ed_projekt;
ky:=1;
repeat
  textcolor(12);textbackground(1);gotoxy(2,wysok[ky]);write('ş');
  kl:=readkey;
  if kl=#0 then begin
   kl:=readkey;
   textcolor(12);textbackground(1);gotoxy(2,wysok[ky]);write('  ');
   if (kl=#80) and (ky<sizeof(wysok)) then inc(ky)
      else
      if (kl=#80) and (ky=sizeof(wysok)) then ky:=1;
   if (kl=#72) and (ky>1) then dec(ky)
      else
      if (kl=#72) and (ky=1) then ky:=sizeof(wysok);

   if ky=7 then begin
      if kl=#75 then begin
         dec(ustaw_alfab_duzy);
         if ustaw_alfab_duzy<=-1 then ustaw_alfab_duzy:=2;
      end;
      if kl=#77 then begin
         inc(ustaw_alfab_duzy);
         if ustaw_alfab_duzy>=3 then ustaw_alfab_duzy:=0;
      end;
   end;
  end;
  if (kl=#13) then
     case ky of
       1:begin
         nazwa_projektu:=entertext(4,4,12,nazwa_projektu);
         nazwa_projektu:=duze(nazwa_projektu);
         end;
       2:begin
         nazwa_duzego:=entertext(4,6,12,nazwa_duzego);
         nazwa_duzego:=duze(nazwa_duzego);
         kontrola_zwykla;
         end;
       3:begin
         naglowek:=entertext(4,8,74,naglowek);
         duzy^.offset[1]:=length(naglowek);
         for a:=2 to nr[2] do duzy^.offset[a]:=duzy^.offset[a-1]+duzy^.rozmiar[a-1];
         end;
       4:zapis_spisu:=not zapis_spisu;
       5:begin
         nazwa_spisu:=entertext(4,11,12,nazwa_spisu);
         nazwa_spisu:=duze(nazwa_spisu);
         end;
       6:spis_plikow_w_duzym:=not spis_plikow_w_duzym;
       7:begin
         ustaw_duzy_alfabetycznie(ustaw_alfab_duzy);
         pokaz_ed_projekt;
         end;
       8:begin
         zapisz_projekt;
         pokaz_ed_projekt;
         end;
       9:begin
         wczytaj_projekt(1);
         pokaz_ed_projekt;
         end;
     end;
  textcolor(15);textbackground(1);gotoxy(24,9);if zapis_spisu then write('tak') else write('nie');
  gotoxy(50,12);if spis_plikow_w_duzym then write('tak') else write('nie');
  gotoxy(40,14);
  case ustaw_alfab_duzy of
     0:write('nazwy       ');
     1:write('rozszerzenia');
     2:write('rozmiaru    ');
  end;
  textcolor(8);textbackground(7);gotoxy(4,4);write('úúúúúúúúúúúú');gotoxy(4,4);textcolor(0);write(nazwa_projektu);
  textcolor(8);gotoxy(4,6);write('úúúúúúúúúúúú');textcolor(0);gotoxy(4,6);write(nazwa_duzego);
  textcolor(8);gotoxy(4,8);write('úúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúú');
  textcolor(8);textbackground(7);gotoxy(4,11);write('úúúúúúúúúúúú');gotoxy(4,11);textcolor(0);write(nazwa_spisu);
  textcolor(0);gotoxy(4,8);write(naglowek);
until ((kl=#13) and (ky=10)) or (kl=#27);
pokaz_glowne;
kontrola;
end;

{*}PROCEDURE odswiez;
var jj:boolean;
begin
jj:=false;
for a:=1 to nr[1] do begin
    if duze(katalog^.nazwa[a])=duze(nazwa_duzego) then begin
       FindFirst(duze(nazwa_duzego), Anyfile+Hidden, DirInfo);
       katalog^.rozmiar[a]:=dirinfo.size;
       a:=nr[1];
       jj:=true;
    end;
end;

if (not jj) and (nr[1]<=maxkat) then begin
   FindFirst(duze(nazwa_duzego), Anyfile+Hidden, DirInfo);
   inc(nr[1]);
   katalog^.rozmiar[nr[1]]:=dirinfo.size;
   katalog^.nazwa[nr[1]]:=dirinfo.name;
   for c:=1 to length(katalog^.nazwa[nr[1]]) do begin
       if (katalog^.nazwa[nr[1]][c]>=#65) and (katalog^.nazwa[nr[1]][c]<=#90) then
          katalog^.nazwa[nr[1]][c]:=chr(ord(katalog^.nazwa[nr[1]][c])+32);
   end;
   c:=1;
   while (katalog^.nazwa[nr[1]][c]<>'.') and (c<length(katalog^.nazwa[nr[1]])) do inc(c);
   if c<length(katalog^.nazwa[nr[1]]) then begin
      for b:=1 to 9-c do insert(' ',katalog^.nazwa[nr[1]],c);
   end;
   ustaw_katalog_alfabetycznie(ustaw_alfab);
end;
textcolor(14);textbackground(4);gotoxy(3,1);write('Katalog,plikow:',nr[1]);
if ilosc_plikow>maxkat then begin
   textcolor(12);
   write('(',ilosc_plikow,')');
end;

end;

{*}PROCEDURE glowne;
begin
for a:=1 to nr[1] do katalog^.nazwa[a]:='';
FindFirst('*.*', Anyfile+Hidden, DirInfo);inc(nr[1]);
nr[1]:=0;
ilosc_plikow:=0;
while (DosError=0) do begin
   Assign(F, DirInfo.Name);
   GetFAttr(F, Attr);
   if (Attr and Anyfile <> 0) and (DirInfo.Name<>'.') and (DirInfo.Name<>'..') then begin
      inc(ilosc_plikow);
      if ilosc_plikow mod 64=0 then begin gotoxy(26,5);writeln(ilosc_plikow);end;
      if ilosc_plikow<=maxkat then begin
         inc(nr[1]);
         katalog^.rozmiar[nr[1]]:=dirinfo.size;
         katalog^.nazwa[nr[1]]:=dirinfo.name;
         for c:=1 to length(katalog^.nazwa[nr[1]]) do begin
             if (katalog^.nazwa[nr[1]][c]>=#65) and (katalog^.nazwa[nr[1]][c]<=#90) then
                katalog^.nazwa[nr[1]][c]:=chr(ord(katalog^.nazwa[nr[1]][c])+32);
         end;
         c:=1;
         while (katalog^.nazwa[nr[1]][c]<>'.') and (c<length(katalog^.nazwa[nr[1]])) do inc(c);
         if c<length(katalog^.nazwa[nr[1]]) then begin
            for b:=1 to 9-c do insert(' ',katalog^.nazwa[nr[1]],c);
         end;
      end;
   end;
   FindNext(DirInfo);
end;
ustaw_katalog_alfabetycznie(ustaw_alfab);

{------------}
yk[1]:=1;
yk[2]:=1;
clrscr;
textcolor(0);textbackground(4);
gotoxy(1,1);
write('                                                                                ');

textcolor(1);textbackground(4);
gotoxy(1,25);write('                                                                               ');
{Mem[$B800:3998]:=Ord('²');}Mem[$B800:3999]:=4 shl 4+1;
textcolor(11);gotoxy(6,25);write('Konektor ver.'+ver);
textcolor(14);gotoxy(42,25);write('(c)2000 S.K.GAD');
textcolor(0);gotoxy(58,25);write('gad@gad.koti.com.pl');

textcolor(1);textbackground(0);
gotoxy(1,24);write('²±°                                                                          °±²');

textcolor(15);gotoxy(5,24);write('F1-edycja projektu ³ F2-utworzenie pliku ³ F3-sortow. kat. ³ F10-wyjscie');

textcolor(14);textbackground(4);gotoxy(3,1);write('Katalog,plikow:',nr[1]);
if ilosc_plikow>maxkat then begin
   textcolor(12);
   write('(',ilosc_plikow,')');
end;

pokaz_glowne;
repeat
   textcolor(14);textbackground(4);
   gotoxy(34,1);
   gotoxy(34,1);write('            ');
   gotoxy(34,1);write(nazwa_duzego+',');
   gotoxy(55,1);write('   ');
   gotoxy(47,1);write('plikow:',nr[2]);
   gotoxy(66,1);write('              ');
   gotoxy(59,1);write('rozmiar:');
   if nr[2]>0 then begin
      a:=nr[2];
      while (duzy^.rozmiar[a]=0) and (a>0) do dec(a);
      write(podziel(duzy^.offset[a]+duzy^.rozmiar[a]));
   end
      else write('0');
   textcolor(1);textbackground(6);gotoxy(1,21);
   write('ÄÄ[                                                                          ]ÄÄ');
   textcolor(10);gotoxy(trunc(41-(length(naglowek)/2)),21);write(naglowek);
   textbackground(0);
   for a:=2 to 18 do begin
      if a<>10 then begin
       textcolor(8);gotoxy(4,1+a);
       if (a+yk[1]-10<1) or (a+yk[1]-10>nr[1]) then
          write(' úúúúúúúú úúú   úúúúúúúúúúú ');
       textcolor(15);gotoxy(4,1+a);
       if (a<>10) and (a+yk[1]-10>=1) and (a+yk[1]-10<=nr[1]) then
          write(' ',katalog^.nazwa[a+yk[1]-10],'   ',podziel(katalog^.rozmiar[a+yk[1]-10]):11,' ');
       textcolor(9);
       gotoxy(17,1+a);write('³');
      end;
   end;
   textbackground(0);
   for a:=2 to 18 do begin
      if a<>10 then begin
       textcolor(8);gotoxy(34,1+a);
       if (a+yk[2]-10<1) or (a+yk[2]-10>nr[2]) then
          writeln(' úúúúúúúú úúú   úúúúúúúúúúú   úúúúúúúúúúúúú ');
       if duzy^.jest[a+yk[2]-10] then textcolor(15)
                                 else textcolor(12);
       gotoxy(34,1+a);
       if (a<>10) and (a+yk[2]-10>=1) and (a+yk[2]-10<=nr[2]) then
       if duzy^.jest[a+yk[2]-10] then
          write(' ',duzy^.nazwa[a+yk[2]-10],'   ',podziel(duzy^.rozmiar[a+yk[2]-10]):11,'   ',
                  podziel(duzy^.offset[a+yk[2]-10]):13,' ')
          else
          write(' ',duzy^.nazwa[a+yk[2]-10],'   -----------   ------------- ');

       textcolor(9);
       gotoxy(48,1+a);write('³');
       gotoxy(62,1+a);write('³');
      end;
   end;

   case xk of
        1:begin textcolor(15);textbackground(4); end;
        2:begin textcolor(15);textbackground(0); end;
   end;
   gotoxy(4,11);write(' ',katalog^.nazwa[yk[1]],'   ',podziel(katalog^.rozmiar[yk[1]]):11,' ');
   textcolor(9);
   gotoxy(17,11);write('³');
   case xk of
        2:begin if duzy^.jest[yk[2]] then textcolor(15) else textcolor(12);textbackground(4);end;
        1:begin if duzy^.jest[yk[2]] then textcolor(15) else textcolor(12);textbackground(0);end;
   end;
   gotoxy(34,11);
   if nr[2]>0 then begin
      if duzy^.jest[yk[2]] then
         write(' ',duzy^.nazwa[yk[2]],'   ',podziel(duzy^.rozmiar[yk[2]]):11,'   ',podziel(duzy^.offset[yk[2]]):13,' ')
         else
         write(' ',duzy^.nazwa[yk[2]],'   -----------   ------------- ');
   end
      else begin
      textcolor(8);
      write(' úúúúúúúú úúú   úúúúúúúúúúú   úúúúúúúúúúúúú ');
      end;
   textcolor(9);
   gotoxy(48,11);write('³');
   gotoxy(62,11);write('³');

  kl:=readkey;
  if kl=#0 then begin
   kl:=readkey;
   if (kl=#80) and (yk[xk]<nr[xk]) then inc(yk[xk]);
   if (kl=#72) and (yk[xk]>1) then dec(yk[xk]);
   if (kl=#73) then begin dec(yk[xk],18);if yk[xk]<1 then yk[xk]:=1;end;
   if (kl=#81) then begin inc(yk[xk],18);if yk[xk]>nr[xk] then yk[xk]:=nr[xk];end;
   if (kl=#71) then yk[xk]:=1;
   if (kl=#79) then yk[xk]:=nr[xk];

   if (kl=#83) and (xk=2) then begin
      for a:=yk[2] to nr[2]-1 do begin
          duzy^.nazwa[a]:=duzy^.nazwa[a+1];
          duzy^.rozmiar[a]:=duzy^.rozmiar[a+1];
          duzy^.jest[a]:=duzy^.jest[a+1];
      end;
      if yk[2]=1 then begin
         duzy^.offset[1]:=dlugosc_naglowka;
         for a:=2 to nr[2]-1 do begin
             duzy^.offset[a]:=duzy^.offset[a-1]+duzy^.rozmiar[a-1];
         end;
      end;
      if yk[2]>1 then begin
         for a:=yk[2] to nr[2]-1 do begin
             duzy^.offset[a]:=duzy^.offset[a-1]+duzy^.rozmiar[a-1];
         end;
      end;
      duzy^.nazwa[nr[2]]:='';
      duzy^.rozmiar[nr[2]]:=0;
      duzy^.offset[nr[2]]:=0;
      duzy^.jest[nr[2]]:=true;
      dec(nr[2]);
      if yk[2]>nr[2] then yk[2]:=nr[2];
      if nr[2]=0 then kl:=#9;
   end;
  end;
   if (kl=#93) and (xk=2) and (yk[2]<nr[2]) then begin {przesuwanie w dol po prawej}
      wyr:=duzy^.nazwa[yk[2]+1];
      duzy^.nazwa[yk[2]+1]:=duzy^.nazwa[yk[2]];
      duzy^.nazwa[yk[2]]:=wyr;

      li:=duzy^.rozmiar[yk[2]+1];
      duzy^.rozmiar[yk[2]+1]:=duzy^.rozmiar[yk[2]];
      duzy^.rozmiar[yk[2]]:=li;

{      bol:=duzy^.jest[yk[2]+1];
      duzy^.jest[yk[2]+1]:=duzy^.jest[yk[2]];
      duzy^.jest[yk[2]]:=bol;}

      inc(yk[2]);
      kontrola_szybka;
   end;
   if (kl=#91) and (xk=2) and (yk[2]>1) then begin {przesuwanie w gore po prawej}
      wyr:=duzy^.nazwa[yk[2]-1];
      duzy^.nazwa[yk[2]-1]:=duzy^.nazwa[yk[2]];
      duzy^.nazwa[yk[2]]:=wyr;

      li:=duzy^.rozmiar[yk[2]-1];
      duzy^.rozmiar[yk[2]-1]:=duzy^.rozmiar[yk[2]];
      duzy^.rozmiar[yk[2]]:=li;

{      bol:=duzy^.jest[yk[2]-1];
      duzy^.jest[yk[2]-1]:=duzy^.jest[yk[2]];
      duzy^.jest[yk[2]]:=bol;}

      dec(yk[2]);
      kontrola_szybka;
   end;
   if (kl=#13) and (xk=1) and (nr[2]<maxplik) then begin
      inc(nr[2]);
      duzy^.nazwa[nr[2]]:=katalog^.nazwa[yk[1]];
      if duze(duzy^.nazwa[nr[2]])<>duze(nazwa_duzego) then begin
         duzy^.rozmiar[nr[2]]:=katalog^.rozmiar[yk[1]];
         duzy^.jest[nr[2]]:=true;
         if nr[2]=1 then duzy^.offset[nr[2]]:=dlugosc_naglowka;
         if nr[2]>1 then duzy^.offset[nr[2]]:=duzy^.offset[nr[2]-1]+duzy^.rozmiar[nr[2]-1];
      end
         else duzy^.jest[nr[2]]:=false;
      yk[2]:=nr[2];
      kontrola_zwykla;
   end;
   if kl=#43 then begin dodaj_pliki;pokaz_glowne;end;
   if kl=#45 then begin odejmij_pliki;pokaz_glowne;end;

   if (kl=#9) then begin
      if xk=1 then xk:=2
              else xk:=1;
      if nr[2]=0 then xk:=1;
      podstawowy_tip;
   end;

   if kl=#59 then ed_projekt;
   if (kl=#60) and (nr[2]>=1) then begin zapisz;odswiez;pokaz_glowne;end;
   if kl=#61 then begin
      inc(ustaw_alfab);
      if ustaw_alfab>=3 then ustaw_alfab:=0;
      ustaw_katalog_alfabetycznie(ustaw_alfab);
      pokaz_glowne;
   end;
until (kl=#68);
end;

{*}PROCEDURE wstep;
begin
new(katalog);
new(duzy);
textbackground(1);gotoxy(1,25);for a:=0 to 24 do begin writeln;delay(7);end;
textcolor(15);textbackground(1);
clrscr;
wylkurs;
gotoxy(2,2);write('Konektor ver.'+ver+' (c)2000 S.K.GAD');
gotoxy(2,4);write('Odczyt konfiguracji... ');

nazwa_projektu:='PROJEKT.KPR';
nazwa_duzego:='BEZNAZWY.DAT';
nazwa_spisu:='SPISPLIK.TXT';
naglowek:='Studio Komputerowe GAD - Plik z danymi.';
zapis_spisu:=true;
spis_plikow_w_duzym:=false;
ustaw_alfab:=1;
assign(Tof,'KONEKTOR.CFG');
{$I-}
reset(Tof,1);
if IOResult=0 then begin
   blockread(Tof,nazwa_projektu,sizeof(nazwa_projektu));
   blockread(Tof,ustaw_alfab,1);
   close(ToF);
   wczytaj_projekt(0);
   writeln('OK :)');
end
   else writeln('Blad :(');
{$I+}
xk:=1;
gotoxy(2,5);write('Trwa liczenie plikow...');
end;

{*}PROCEDURE zakonczenie;
begin
textcolor(15);textbackground(1);gotoxy(1,25);
for a:=0 to 24 do begin writeln;delay(7);end;
gotoxy(2,2);write('Zapis konfiguracji... ');
assign(Tof,'KONEKTOR.CFG');
{$I-}
rewrite(Tof,1);
if IOResult=0 then begin
   blockwrite(Tof,nazwa_projektu,sizeof(nazwa_projektu));
   blockwrite(Tof,ustaw_alfab,1);
   close(ToF);
   writeln('OK :)');
end
   else writeln('Blad :(');
{$I+}

textcolor(7);
textbackground(0);gotoxy(1,25);for a:=0 to 24 do begin writeln;delay(7);end;
clrscr;
gotoxy(1,1);
writeln('Konektor ver.'+ver+' (c)2000 S.K.GAD');
writeln('Grzegorz "GAD" Drozd');
writeln('e-mail:gad@gad.koti.com.pl');
writeln('http://gad.koti.com.pl/');
dispose(katalog);
dispose(duzy);
wlkurs;
end;

{*}BEGIN
wstep;
glowne;
zakonczenie;
END.