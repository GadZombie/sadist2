{
-----------------------------------------------------------------------------
|                           Studio Komputerowe GAD:                         |
|Grzegorz "GAD" Drozd,  e-mail:gad@gad.koti.com.pl,  http://gad.koti.com.pl/|
|                                                                           |
|Dozwolone jest kopiowanie, modyfikowanie i wykorzystywanie w swoich progra-|
|mach calosci lub czesci tego pliku, lecz pod jednym warunkiem: Nalezy w ta-|
|kim programie umiescic moje imie, nazwisko, adres e-mail oraz adres mojej  |
|strony WWW, a takze zaznaczyc, ze w programie zostal wykorzystany moj pod- |
|program.                                                                   |
-----------------------------------------------------------------------------

 Unit do sprawdzania parametrow z linii polecen. Jest to jakby rozszerzenie
 funkcji paramstr(). Dokladny opis tej funkcji ponizej.

 ver.1.0.
}

unit GADparam;

interface

{funkcja zamieniajaca string na duze litery}
FUNCTION upcasestr(t:string):string;

{Glowna funkcja: szukaja, czy zostal podany w linii polecen podany parametr  }
{Parametry funkcji:                                                          }
{ TezBezPierwszegoZnaku:boolean                                              }
{  true:parametr bedzie szukany tez bez pierwszego znaku, kiedy mozliwe jest }
{       podanie na zasadzie /par -par itp.                                   }
{  false:bedzie poszukiwany dokladnie tak samo zapisany                      }
{ WaznaWielkoscLiter:boolean                                                 }
{  true:poszukiwany bedzie parametr zapisany dokladnie tak samo pod wzgledem }
{       wielkosci liter                                                      }
{ false:bedzie obojetne, jak zostanie zapisany parametr, np:                 }
{       PaRameTR i paraMETR beda dzialaly jednakowo                          }
{ Szukany:string                                                             }
{  to wlasnie tego parametru bedziemy szukac w linii polecen                 }
{Funkcja zwroci wartosc true, jesli znajdzie parametr lub false, jesli go nie}
{znajdzie.                                                                   }
FUNCTION parametr(TezBezPierwszegoZnaku, WaznaWielkoscLiter:boolean;
                     Szukany:string): boolean;

implementation

{*}FUNCTION upcasestr(t:string):string;
var a:byte;
begin
for a:=1 to length(t) do t[a]:=upcase(t[a]);
upcasestr:=t;
end;

{*}FUNCTION parametr(TezBezPierwszegoZnaku, WaznaWielkoscLiter:boolean;
                     Szukany:string): boolean;
var
a:word;
par:string;
begin
parametr:=false; {poczatkowo nie ma tego parametru, dopiero go szukamy}
if not waznawielkoscliter then szukany:=upcasestr(szukany); {nie wazna wielkosc    }
                                                            {liter- przerob szukane}
                                                            {na duze litery        }
if paramcount>=1 then {sprawdz czy w ogole jest jakis parametr}
   for a:=1 to paramcount do begin {liczymy}
       par:=paramstr(a);
       if not waznawielkoscliter then par:=upcasestr(par); {przerob na duze litery}
       if par=szukany then begin {jest znaleziony!}
          parametr:=true;
          exit; {zakoncz wczesniej}
       end else {wciaz nie znaleziony?}
           if tezbezpierwszegoznaku then begin {szukaj moze tez bez pierwszego znaku?}
              delete(par,1,1); {wytnij go}
              if par=szukany then begin {jest znaleziony!}
                 parametr:=true;
                 exit; {zakoncz wczesniej}
              end;
           end;
   end;

end;


end.