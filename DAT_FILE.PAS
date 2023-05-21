unit dat_file;

interface
uses crt;
var

DATplik:record
   rozmiar,
   offset:longint;
end;

{ DATassign
 Procedura zastepujaca Assign(plik); i Reset(plik,1); , przypisuje
 zmienna plikowa do pliku DAT i ustawia pozycje do odczytu w miejscu
 poczatku zadanego pliku wewnatrz. Funkcja NIE zamyka pliku, wiec
 pamietaj o Close(plik); jak juz odczytasz z niego co potrzebujesz,
 za to za kazdym razem otwiera, wiec MUSISZ zamykac plik, bo po pewnym
 czasie napotkasz na blad "Too many open files"

 plik: zmienna plikowa
 DATnazwa: nazwa duzego pliku DAT, w ktorym bedzie szukanie
 PlikNazwa: nazwa pliku, ktorego szukac
 poz: dodatkowe przesuniecie (cos jak seek, tylko od razu wliczone);
      jesli nie potrzebujesz z tego korzystac, zwyczajnie wpisz 0  }
{*}PROCEDURE DATassign(var plik:file;DATnazwa,PlikNazwa:string;poz:longint);
{ DATseek
 Procedura podobna do poprzedniej, lecz nie otwiera juz pliku, tylko
 przesuwa pozycje pliku do wyznaczonej. Niestety, zeby nie bylo bledow,
 trzeba od nowa wyszukiwac plik. Jesli czesto korzystasz w programie
 z procedury Seek(file); , to lepiej nie korzystaj z DATseek, tylko
 sprawdz jaki ma offset pozadany plik i odwoluj sie bezposrednio do
 pliku DAT. DATseek jest dobre i skuteczne, lecz przez wyszukiwanie
 pliku wewnatrz duzego, jest nieco wolniejsze. }
{*}PROCEDURE DATseek(var plik:file;DATnazwa,PlikNazwa:string;poz:longint);

implementation

{funkcja pomocnicza, zamienia male litery na duze i usuwa spacje ze
 stringa}
{*}FUNCTION duze(co:string):string;
var a:byte;
begin
 for a:=1 to length(co) do co[a]:=upcase(co[a]);
 while pos(' ',co)>0 do delete(co,pos(' ',co),1);
 duze:=co;
end;

{*}PROCEDURE DATassign(var plik:file;DATnazwa,PlikNazwa:string;poz:longint);
var
 b:byte;
 ilosc,licznik:integer;
 wyr:string[12];
 rozmiar,offset:longint;
begin
 licznik:=0;                {ustawienie licznika plikow na 0}
 assign(plik,DATnazwa);
 reset(plik,1);             {otwarcie pliku}
 seek(plik,5);              {pominiecie naglowka DAT1}
 blockread(plik,b,1);       {odczyt dlugosci tekstu w naglowku...}
 seek(plik,6+b);            {...i jego pominiecie}
 blockread(plik,ilosc,2);   {odczyt ilosci plikow}
 repeat                     {odszukanie poczatku pliku w duzym...}
    inc(licznik);
    blockread(plik,wyr,13);
    blockread(plik,rozmiar,sizeof(rozmiar));
    blockread(plik,offset,sizeof(offset));
 until (licznik>ilosc) or (duze(wyr)=duze(PlikNazwa));
 seek(plik,offset+poz);         {...i ustawienie pozycji na niego}
 DATplik.offset:=offset;
 DATplik.rozmiar:=rozmiar;
end;

{*}PROCEDURE DATseek(var plik:file;DATnazwa,PlikNazwa:string;poz:longint);
var
 b:byte;
 ilosc,licznik:integer;
 wyr:string[12];
 rozmiar,offset:longint;
begin
 licznik:=0;                {ustawienie licznika plikow na 0}
 seek(plik,5);              {pominiecie naglowka DAT1}
 blockread(plik,b,1);       {odczyt dlugosci tekstu w naglowku...}
 seek(plik,6+b);            {...i jego pominiecie}
 blockread(plik,ilosc,2);   {odczyt ilosci plikow}
 repeat                     {odszukanie poczatku pliku w duzym...}
    inc(licznik);
    blockread(plik,wyr,13);
    blockread(plik,rozmiar,sizeof(rozmiar));
    blockread(plik,offset,sizeof(offset));
 until (licznik>ilosc) or (duze(wyr)=duze(PlikNazwa));
 seek(plik,offset+poz);     {...i ustawienie pozycji na niego z uwzglednie-
                             niem przesuniecia}
end;

end.