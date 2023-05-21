{$A+,B-,D+,E-,F+,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
uses crt,dos;

const
Tmaxmin=200;

type
Tmin=array[1..Tmaxmin] of record
    jest:boolean;
    x,y,dx,dy:longint;
    stal:byte;
    ostkier:single;
    czas:integer;
    end;

Tnowemin=array[1..Tmaxmin] of record
    jest:boolean;
    x,y:longint;
    dx,dy:integer;
    stal:byte;
    ostkier:single;
    czas:integer;
    end;

var
kl:char;
nazwa,kattemp:string;
plik,doplik:file;
blad:byte;
DirInfo:SearchRec;
bylybledy:boolean;

{dla wczytywania wer.1}
b:byte;
fp,l,a:longint;
maxminn:word;
bufpogoda:array[0..43] of byte;
bufgrupy:array[0..4,0..20] of byte;
min:^Tmin;
nowemin:^Tnowemin;
pamsmin,
pamnowesmin:longint;

rozmiarterenu:longint; {rozmiar samych spakowanych danych terenu}

{*}procedure wczytaj_s2t_1(nazwa:string;var blad:byte);
var ior:integer;
begin
blad:=0;
pamsmin:=sizeof(min^) div Tmaxmin;
pamnowesmin:=sizeof(nowemin^) div Tmaxmin;
textcolor(15);
write(nazwa,' : ');
textcolor(7);
writeln('odczyt');
assign(plik,nazwa);
{$I-}
reset(plik,1);
{$I+}
ior:=ioresult;
if ior=0 then begin
   seek(plik,filesize(plik)-sizeof(fp));
   blockread(plik, fp, sizeof(fp));
   seek(plik,fp);
   rozmiarterenu:=fp;
   write('ofs:',fp);
   blockread(plik, b, sizeof(b)); {odczyt nr wersji}
   if b=1 then begin {wersja 1}
      write('|wersja pliku: 1 ');
      blockread(plik, bufpogoda, 44);
      write('|p');
      for a:=0 to 4 do {odczyt punktow wyjscia itd}
          blockread(plik, bufgrupy[a], 21); {ustawienia wylotu kazdej z grup}
      write('|g');
      blockread(plik, maxminn, sizeof(maxminn));
      write('|m=',maxminn);
      blockread(plik, min^, maxminn*pamsmin);
      write('|min');
   end else begin
       writeln('| inna wersja pliku, plik nie bedzie konwertowany');
       blad:=245; {245: nie konwertuj!}
       end;
   close(plik);
end else begin
   write('Blad nr ',ior,' przy dostepie do pliku');
   if ior=5 then writeln(' (plik tylko do odczytu)')
      else writeln;
   blad:=ior;
end;
end;

{*}procedure zapisz_s2t_2(nazwa:string);
var
buf:array[0..999] of byte;
odcz,zapi:Word;
dan:longint;
begin
assign(plik,nazwa);
reset(plik,1);
write('| zapis ');
assign(doplik,'temps2t.tmp');
rewrite(doplik,1);
dan:=0;
repeat
  blockread(plik,buf,sizeof(buf),odcz);
  inc(dan,odcz);
  while dan>rozmiarterenu do begin dec(odcz);dec(dan) end;
  blockwrite(doplik,buf,odcz,zapi);
until (odcz=0) or (zapi<>odcz) or (dan>=rozmiarterenu);

b:=2;
blockwrite(doplik, b, sizeof(b)); {zapis nr wersji}
blockwrite(doplik, bufpogoda, 44);
for a:=0 to 4 do {zapis punktow wyjscia itd}
    blockwrite(doplik, bufgrupy[a], 21); {ustawienia wylotu kazdej z grup}
blockwrite(doplik, maxminn, sizeof(maxminn));
blockwrite(doplik, nowemin^, maxminn*pamnowesmin);

blockwrite(doplik, fp, sizeof(fp));
close(doplik);
close(plik);

rename(doplik,kattemp+'\'+nazwa);

writeln('| OK');
end;

{*}procedure popraw_miny1;
begin
write('| poprawianie ');
for a:=1 to maxminn do
  with nowemin^[a] do begin
        jest:=min^[a].jest;
     if jest then begin
           x:=min^[a].x;
           y:=min^[a].y;
          dx:=integer(min^[a].dx);
          dy:=integer(min^[a].dy);
        stal:=min^[a].stal;
     ostkier:=min^[a].ostkier;
        czas:=min^[a].czas;
     end else begin
           x:=0;
           y:=0;
          dx:=0;
          dy:=0;
        stal:=0;
     ostkier:=0;
        czas:=0;
     end;
  end;
end;

{*}begin
writeln;
writeln('Konwerter plikow *.S2T [terenow dla Sadist II] z wersji 1 na wersje 2.');
writeln('Program skonwertuje wszystkie pliki *.S2T znajdujace sie w bierzacym katalogu.');
writeln('Czy chcesz kontynuowac? [T/N]');
while keypressed do readkey;
kl:=readkey;
if not (kl in ['T','t']) then halt(0);
new(min);
new(nowemin);
bylybledy:=false;

write('Tworzenie katalogu tymczasowego ');
randomize;
a:=0;
repeat
  kattemp:='';
  for b:=1 to 8 do kattemp:=kattemp+chr(random(25)+65);
  FindFirst(kattemp,directory,DirInfo);
  if doserror<>0 then a:=1;
until a=1;
mkdir(kattemp);
writeln('OK');

FindFirst('*.S2T',Anyfile,DirInfo);
while DosError=0 do begin
  nazwa:=DirInfo.Name;
  wczytaj_s2t_1(nazwa,blad);
  if blad=0 then begin
     popraw_miny1;
     zapisz_s2t_2(nazwa);
  end else bylybledy:=true;
  FindNext(DirInfo);
end;

writeln(#13#10'Zakonczono konwersje plikow.');
if bylybledy then writeln('* Nie wszystkie pliki zostaly skonwertowane! *');
writeln('Czy chcesz skopiowac je spowrotem z katalogu tymczasowego do tego,'+
        #13#10'w ktorym byly? [T/N]');
while keypressed do readkey;
kl:=readkey;
writeln;
if kl in ['T','t'] then begin
   write('Przenoszenie plikow... ');
   FindFirst(kattemp+'\*.S2T',Anyfile,DirInfo);
   while DosError=0 do begin
      writeln('\'+kattemp+'\'+dirinfo.name+' -> \'+dirinfo.name);
      assign(plik,dirinfo.name);
      erase(plik);
      assign(plik,kattemp+'\'+dirinfo.name);
      rename(plik,dirinfo.name);
      FindNext(DirInfo);
   end;
   writeln('OK');
   write('Usuwanie katalogu tymczasowego. ');
   rmdir(kattemp);
   writeln('OK');
end else begin
   writeln('Skonwertowane tereny zostaly w katalogu tymczasowym: '+kattemp);
end;

writeln(#13#10'Ten program nie bedzie Ci juz potrzebny, chyba, ze otrzymasz od kogos stara'+
        #13#10'wersje pliku z jakims terenem. Mozesz spokojnie uruchomic konwerter'+
        #13#10'w katalogu z juz skonwertowanymi plikami - nie zostana one ponownie'+
        #13#10'skonwertowane.');
dispose(nowemin);
dispose(min);
end.