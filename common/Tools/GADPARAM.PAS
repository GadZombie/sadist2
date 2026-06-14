{
-----------------------------------------------------------------------------
|                           Studio Komputerowe GAD:                         |
|   Grzegorz "GAD" Drozd,    e-mail:gad@gad.qs.pl,      http://gad.qs.pl/   |
|                                                                           |
|Dozwolone jest kopiowanie, modyfikowanie i wykorzystywanie w swoich progra-|
|mach calosci lub czesci tego pliku, lecz pod jednym warunkiem: Nalezy w ta-|
|kim programie umiescic moje imie, nazwisko, adres e-mail oraz adres mojej  |
|strony WWW, a takze zaznaczyc, ze w programie zostal wykorzystany moj pod- |
|program.                                                                   |
-----------------------------------------------------------------------------

 Unit do sprawdzania parametrow z linii polecen. Jest to jakby rozszerzenie
 funkcji paramstr(). Dokladny opis funkcji ponizej.

 ver.1.1.
}

unit GADparam;

interface

{funkcja zamieniajaca string na duze litery}
FUNCTION upcasestr(t:string):string;

{Funkcja szukajaca, czy zostal podany w linii polecen podany parametr        }
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

{Funkcja szukajaca, czy zostal podany w linii polecen podany parametr, spraw-}
{dzajac go od poczatku az do konkretnego znaku. NP: /wybor:5 - szukajac slowa}
{"wybor" az do znaku ":" znajdzie sie to slowo, a to, co po ":", zostanie    }
{zwrocone w zmiennej "reszta".                                               }
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
{ Znak:char                                                                  }
{  do tego znaku bedzie przeszukiwany parametr                               }
{ Reszta:string                                                              }
{  w tej zmiennej zostanie zwrocona reszta parametru (to, co po znaku)       }
{Funkcja zwroci wartosc true, jesli znajdzie parametr lub false, jesli go nie}
{znajdzie.                                                                   }
FUNCTION parametrdoznaku(TezBezPierwszegoZnaku,
                     WaznaWielkoscLiter:boolean;
                     Szukany:string;
                     Znak:char;
                     var Reszta:string): boolean;

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

{*}FUNCTION parametrdoznaku(TezBezPierwszegoZnaku,
                     WaznaWielkoscLiter:boolean;
                     Szukany:string;
                     Znak:char;
                     var Reszta:string): boolean;
var
a,b:word;
par:string;
begin
parametrdoznaku:=false; {poczatkowo nie ma tego parametru, dopiero go szukamy}
if not waznawielkoscliter then szukany:=upcasestr(szukany); {nie wazna wielkosc    }
                                                            {liter- przerob szukane}
                                                            {na duze litery        }
if paramcount>=1 then {sprawdz czy w ogole jest jakis parametr}
   for a:=1 to paramcount do begin {liczymy}
       par:=paramstr(a);
       Reszta:='';
       b:=1;
       while b<=length(par) do begin
           if (par[b]=znak) then begin
              reszta:=copy(par,b+1,length(par)-b);
              delete(par,b,length(par)-b+1);
              b:=255;
           end;
           inc(b);
       end;
       if not waznawielkoscliter then par:=upcasestr(par); {przerob na duze litery}
       if par=szukany then begin {jest znaleziony!}
          parametrdoznaku:=true;
          exit; {zakoncz wczesniej}
       end else {wciaz nie znaleziony?}
           if tezbezpierwszegoznaku then begin {szukaj moze tez bez pierwszego znaku?}
              delete(par,1,1); {wytnij go}
              if par=szukany then begin {jest znaleziony!}
                 parametrdoznaku:=true;
                 exit; {zakoncz wczesniej}
              end;
           end;
       Reszta:='';
   end;

end;


end.