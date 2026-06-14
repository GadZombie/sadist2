unit Upostaci;



interface

{*}PROCEDURE postaci_wolnawola;
{*}PROCEDURE postac_zranodupadku;
{*}PROCEDURE postaci;
{*}PROCEDURE sprawdzaj_czy_trzeba_nowych_postaci;

{*}PROCEDURE zwierzatka;

implementation
uses crt,dos,myszunit,
     vars,cosin,
     xms,maskp,dzwieki2,SMix,resztki,glowne,
     nowe,menusy,winieta,timer,loudsejw,robteren;

var
ktora_animacja:longint;
c,d:byte;
licz:word;
a2,a3,_mmx,_mmy,_kat,_sila:integer;
jest_palacy,walnou,pokaz_sileikat,zablokowany:boolean;

podxy7:byte;

{postaci}
{*}PROCEDURE postaci_wolnawola;
{wolna wola -robi rozne rzeczy losowo}
var a2:integer;
begin
with post^[a] do begin
     if random(120)=0 then {zmien ruch}
        case random(39) of
           0..5 :comarobic:=0;  {stoi}
           6..17:comarobic:=1;  {idzie}
          18..29:comarobic:=2;  {biegnie}
          30    :comarobic:=6;  {blokuje}
          31    :begin {panikuje}
                 comarobic:=7;
                 StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+4],false,15+a mod 5,15+a mod 5);
                 end;
          32..38:kier:=-kier;   {odwroc sie}
        end;

     if (corobi in [1,2]) and (random(700)=0) and {skok}
        (podxy7<>0) then begin
        if not zablokowany then y:=y-1;
        dy:=-1;
        if random(2)=0 then dx:=kier;
        corobi:=11;
        StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+8],false,15+a mod 5,15+a mod 5);
     end;

     for a2:=1 to maxpoc do
         if poc^[a2].jest then begin
            if (poc^[a2].wygl in [2,3,7]) and {uciekaja przed dynamitem,granatem i bomba}
               (x>=poc^[a2].x shr 10-50) and
               (x<=poc^[a2].x shr 10+50) and
               (y>=poc^[a2].y shr 10-40) and
               (y<=poc^[a2].y shr 10+40) then begin
               b:=comarobic;
               case random(70) of
                    0:if (x>=poc^[a2].x shr 10) then kier:=1
                                               else kier:=-1;
                    1:comarobic:=7;
                    2..6:comarobic:=2;
               end;
               if (corobi=5) and (b<>comarobic) then cotrzyma:=0;
            end else
            if (poc^[a2].wygl=5) and {uciekaja przed ogniem}
               (x>=poc^[a2].x shr 10-50) and
               (x<=poc^[a2].x shr 10+50) and
               (y>=poc^[a2].y shr 10-40) and
               (y<=poc^[a2].y shr 10+40) then begin
               case random(100) of
                    0:comarobic:=7;
                    2..6:comarobic:=2;
                    10..30:if (x>=poc^[a2].x shr 10) then kier:=1
                                                    else kier:=-1;
               end;
            end else
            if (poc^[a2].wygl=9) and {przeskakuja napalm}
               (x>=poc^[a2].x shr 10-20) and
               (x<=poc^[a2].x shr 10+20) and
               (y>=poc^[a2].y shr 10-7) and
               (y<=poc^[a2].y shr 10+10) and
               (random(30)=0) then begin
                   dy:=-1;
                   if not zablokowany then y:=y-1;
                   dx:=kier;
                   corobi:=11;
                   StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+8],false,15+a mod 5,15+a mod 5);
            end;
         end;

     for a2:=1 to maxpost do {uciekaja przed plonacymi postaciami}
         if (a<>a2) and (post^[a2].jest) and
            (post^[a2].palisie) and
            (x>=post^[a2].x-50) and
            (x<=post^[a2].x+50) and
            (y>=post^[a2].y-40) and
            (y<=post^[a2].y+40) then begin
            case random(70) of
                 0:comarobic:=7;
                 2..6:comarobic:=2;
                 10..50:if (x>=post^[a2].x) then kier:=1
                                           else kier:=-1;
            end;
         end;

     for a2:=1 to maxmin do
         if min^[a2].jest then begin
            if (min^[a2].czas>=1) then begin {uciekaja przed dzialajacymi minami}
               if (x>=min^[a2].x shr 10-40) and
                  (x<=min^[a2].x shr 10+40) and
                  (y>=min^[a2].y shr 10-40) and
                  (y<=min^[a2].y shr 10+40) and (random(10)=0) then begin
                      if (x>=min^[a2].x shr 10) then kier:=1
                                               else kier:=-1;
                      comarobic:=2;
               end;
            end else
                if (min^[a2].czas<=0) then begin {przeskakuja zwykle}
                   if (x>=min^[a2].x shr 10-20) and
                      (x<=min^[a2].x shr 10+20) and
                      (y>=min^[a2].y shr 10-20) and
                      (y<=min^[a2].y shr 10+20) and
                      (corobi in [1,2]) and
                      (((x<=min^[a2].x shr 10) and (kier=1)) or
                       ((x>=min^[a2].x shr 10) and (kier=-1))) and
                      (random(10)=0) then begin
                      dy:=-1;
                      if not zablokowany then y:=y-1;
                      dx:=kier;
                      corobi:=11;
                      StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+8],false,15+a mod 5,15+a mod 5);
                   end;
              end;
     end;

     if ((corobi<>5) and (random(3)=0)) or
        ((corobi=5) and (random(100)=0)) then
     for a2:=1 to maxkow do {uciekaja przed spadajacymi kowadlami}
         if (kow^[a2].jest) and
            (x>=kow^[a2].x shr 10-30) and
            (x<=kow^[a2].x shr 10+30) and
            (y<=kow^[a2].y shr 10+100) then begin
             if (x>=kow^[a2].x shr 10) then kier:=1
                                else kier:=-1;
             if (not (comarobic in [2..4,8..13])) then comarobic:=2;
         end;

     if ((corobi<>5) and (random(5)=0)) or
        ((corobi=5) and (random(100)=0)) then
     for a2:=1 to maxpacz do {uciekaja przed spadajacymi paczkami}
         if (pacz^[a2].jest) and
            (not pacz^[a2].trzymany) and
            (abs(pacz^[a2].dy)>400) and
            (x>=pacz^[a2].x shr 10-30) and
            (x<=pacz^[a2].x shr 10+30) and
            (y<=pacz^[a2].y shr 10+100) then begin
             if (x>=pacz^[a2].x shr 10) then kier:=1
                                else kier:=-1;
             if (not (comarobic in [2..4,8..13])) then comarobic:=2;
         end;

     if (celow.bron=7) and {uciekaja przed snajperka}
        (x>=mmx+ekr.x-20) and
        (x<=mmx+ekr.x+20) and
        (y>=mmy+ekr.y-20) and
        (y<=mmy+ekr.y+20) and
        (random(50)=0) then comarobic:=7;

     if (celow.bron=16) and {uciekaja przed pila}
        (guzik[1]) and
        (x>=mmx+ekr.x-70) and
        (x<=mmx+ekr.x+70) and
        (y>=mmy+ekr.y-70) and
        (y<=mmy+ekr.y+70) and
        (random(3)=0) then comarobic:=7;
end;
end;

{*}PROCEDURE postac_zranodupadku;
var
a2,a3:integer;
s1,s2:single;

begin
with post^[a] do begin
a2:=trunc(sqrt(sqr(dx)+sqr(dy)))*5;
if a2>5 then begin
   dec(a2,5);
   dec(sila,a2 div 8);
   inc(punkty,a2 div 8);
   s1:=360/a2*3/kfg.il_krwi;
   s2:=a2/30;
   if not kfg.dzieci then
   for a3:=0 to trunc((a2 div 3)*kfg.il_krwi) do
       nowysyf(trunc(post^[a].x)-2+random(5),trunc(post^[a].y)-2+random(5),
               _sin(trunc(a3*s1))*(0.4+random*s2),
               _cos(trunc(a3*s1))*(0.4+random*s2),
               grupy[grupa].kolorkrwi.od+random(grupy[grupa].kolorkrwi.ile)
               ,1,true,0,0,random(2));
   if (zmiana[1]=0) and (a2>=13) then
      StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+3],false,15+a mod 5,15+a mod 5);
end;
end;
end;

{*}PROCEDURE case_corobi;
begin
with post^[a] do
          case corobi of
             0:begin {stoi}
               ktora_animacja:=0;
               IF NOT PAUZA THEN BEGIN
               doani:=2;
               if random(30)=0 then ani:=random(8);
               END;
               end;
             1:begin {idzie}
               IF (NOT PAUZA) AND (not zablokowany) and (bonusy.przyklejpost=0) then x:=x+(kier/2)*grupy[grupa].szybkosc;
               ktora_animacja:=3;
               end;
             2:begin {biegnie}
               if (NOT PAUZA) AND (not zablokowany) and (bonusy.przyklejpost=0) then x:=x+kier*grupy[grupa].szybkosc;
               ktora_animacja:=4;
               end;
             3:begin {spada machajac rekami}
               ktora_animacja:=6;
               IF NOT PAUZA THEN BEGIN
               if dy>0.7 then dy:=dy-0.05;
               if (abs(dx)>1) or ((comarobic=7) and (random(20)=0)) or (dy<-1) then corobi:=4;
               END;
               end;
             4:begin {spada krecac sie}
               IF NOT PAUZA THEN BEGIN
               if doani<=0 then begin
                  if kier>=0 then begin
                     if dx>=0 then inc(ani)
                              else dec(ani)
                  end
                     else begin
                     if dx>=0 then dec(ani)
                              else inc(ani)
                  end;
                  doani:=grupy[grupa].ani_corobi[corobi];
                  if ani>=8 then ani:=0;
                  if ani<0 then ani:=7;
               end;
               if (comarobic<>7) and (abs(dx)<0.3) and {zacznij machac rekami jesli nie panikujesz}
                  (dy>0) and (random(30)=0) then corobi:=3;
               END;
               ktora_animacja:=7;
               end;
             5:begin {trzyma granat}
               ktora_animacja:=1;
               IF NOT PAUZA THEN BEGIN
               doani:=2;
               if random(10)=0 then ani:=random(7);
               if random(40)=0 then
                  StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+6+random(2)],false,15+a mod 5,15+a mod 5);
               if ((cotrzyma=1) and (random(400)=0)) or
                  ((cotrzyma=2) and (random(100)=0)) then begin
                  ani:=7;
                  cotrzyma:=0;
                  comarobic:=0;
                  StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+5],false,15+a mod 5,15+a mod 5);
               end;
               END;
               end;
             6:begin {blokuje}
               ktora_animacja:=2;
               IF NOT PAUZA THEN BEGIN
               doani:=2;
               if random(30)=0 then ani:=random(8);
               END;
               end;
             7:begin {panikuje}
               IF NOT PAUZA THEN BEGIN
               if (not zablokowany) and (bonusy.przyklejpost=0) then x:=x+kier*grupy[grupa].szybkosc;
               if random(50)=0 then begin
                  kier:=-kier;
                  if random(5)=0 then
                  StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+4],false,15+a mod 5,15+a mod 5);
               end;
               END;
               ktora_animacja:=5;
               end;
             8:begin {biegnie - ranny; bez rak}
               IF NOT PAUZA THEN BEGIN
               if (bonusy.przyklejpost=0) and (not zablokowany) then begin
                  if (pogoda.dziura<=1) or
                     (pogoda.dziura>=2) and (y<pogoda.pozwody) then
                     x:=x+kier*grupy[grupa].szybkosc
                     else begin x:=x+kier/5;if abs(dy)>1 then dy:=dy/1.5 end;
               end;
               if random(50)=0 then kier:=-kier;
               END;
               ktora_animacja:=8;
               end;
             9:begin {skacze - ranny; bez nogi}
               IF NOT PAUZA THEN BEGIN
               if (bonusy.przyklejpost=0) and (not zablokowany) then begin
                  if (pogoda.dziura<=1) or
                     (pogoda.dziura>=2) and (y<pogoda.pozwody) then
                     x:=x+(kier/3)*grupy[grupa].szybkosc
                     else begin x:=x+kier/5;if abs(dy)>1 then dy:=dy/1.5 end;
               end;
               if random(50)=0 then kier:=-kier;
               END;
               ktora_animacja:=9;
               end;
            10:begin {biegnie - ranny; bez glowy}
               IF NOT PAUZA THEN BEGIN
               if (bonusy.przyklejpost=0) and (not zablokowany) then begin
                  if (pogoda.dziura<=1) or
                     (pogoda.dziura>=2) and (y<pogoda.pozwody) then
                     x:=x+kier*grupy[grupa].szybkosc
                     else begin x:=x+kier/5;if abs(dy)>1 then dy:=dy/1.5 end;
               end;
               if random(50)=0 then kier:=-kier;
               END;
               ktora_animacja:=10;
               end;
            11:begin {skacze [animacja biegnie]}
               if (NOT PAUZA) and (not zablokowany) AND (bonusy.przyklejpost=0) then x:=x+kier*grupy[grupa].szybkosc;
               ktora_animacja:=4;
               end;
            12:begin {kopie}
               ktora_animacja:=11;
               IF NOT PAUZA THEN BEGIN
               walnou:=false;
               if (ani=grupy[grupa].bicie[0].klatka) and (doani=grupy[grupa].ani_corobi[corobi]) then begin
                if (ktorego_walnie>0) and (ktorego_walnie<=maxpost) and (post^[ktorego_walnie].jest) and
                   (post^[ktorego_walnie].y>=y-7+grupy[grupa].bicie[0].y-7) and
                   (post^[ktorego_walnie].y<=y+7+grupy[grupa].bicie[0].y-7) and
                   (((kier=1) and (post^[ktorego_walnie].x<=x+7+grupy[grupa].bicie[0].x-7) and
                                  (post^[ktorego_walnie].x>=x-7+grupy[grupa].bicie[0].x-7)) or
                   ((kier=-1) and (post^[ktorego_walnie].x<=x+8-grupy[grupa].bicie[0].x+7) and
                                  (post^[ktorego_walnie].x>=x+8-grupy[grupa].bicie[0].x-7))) then begin
                  post^[ktorego_walnie].dx:=post^[ktorego_walnie].dx+(grupy[grupa].bicie[0].dx*kier);
                  post^[ktorego_walnie].dy:=post^[ktorego_walnie].dy+grupy[grupa].bicie[0].dy;

                  if (post^[ktorego_walnie].x>x) and (post^[ktorego_walnie].kier=1) then post^[ktorego_walnie].kier:=-1;
                  if (post^[ktorego_walnie].x<x) and (post^[ktorego_walnie].kier=-1) then post^[ktorego_walnie].kier:=1;

                  if not kfg.dzieci then
                  for a2:=0 to trunc((10+random(10))*kfg.il_krwi) do
                      nowysyf(trunc(post^[ktorego_walnie].x)-2+random(5),trunc(post^[ktorego_walnie].y)-2+random(5),
                      ((grupy[grupa].bicie[0].dx*(random/2+0.5))+random/2-0.25)*kier,
                      (grupy[grupa].bicie[0].dy*(random/2+0.5))+random/2-0.25,
                      grupy[post^[ktorego_walnie].grupa].kolorkrwi.od+random(grupy[post^[ktorego_walnie].grupa].kolorkrwi.ile)
                      ,1,true,0,0,0);
                  dec(post^[ktorego_walnie].sila,random(grupy[grupa].sila_kop div 2)+grupy[grupa].sila_kop div 2);
                  StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+10],false,15+a mod 5,15+a mod 5);
                  if random(3)=0 then
                     StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*post^[ktorego_walnie].grupa+random(3)],false,
                                15+ktorego_walnie mod 5,15+ktorego_walnie mod 5);
                  ktorego_walnie:=0;
                  walnou:=true;
                end else
                if (ktore_mieso_walnie>0) and
                  (mies^[ktore_mieso_walnie].jest) and
                  (mies^[ktore_mieso_walnie].y shr 10>=y-7+grupy[grupa].bicie[0].y-7) and
                  (mies^[ktore_mieso_walnie].y shr 10<=y+7+grupy[grupa].bicie[0].y-7) and
                  (((kier=1) and (mies^[ktore_mieso_walnie].x shr 10<=x+7+grupy[grupa].bicie[0].x-7) and
                                 (mies^[ktore_mieso_walnie].x shr 10>=x-7+grupy[grupa].bicie[0].x-7)) or
                  ((kier=-1) and (mies^[ktore_mieso_walnie].x shr 10<=x+8-grupy[grupa].bicie[0].x+7) and
                                 (mies^[ktore_mieso_walnie].x shr 10>=x+8-grupy[grupa].bicie[0].x-7))) then begin
                  mies^[ktore_mieso_walnie].dx:=mies^[ktore_mieso_walnie].dx+trunc((grupy[grupa].bicie[0].dx*kier)*2048);
                  mies^[ktore_mieso_walnie].dy:=mies^[ktore_mieso_walnie].dy+trunc(grupy[grupa].bicie[0].dy*2048);
                  ktore_mieso_walnie:=0;
                  walnou:=true;
                  StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+10],false,15+a mod 5,15+a mod 5);
                end;
                if not walnou then begin {jesli ten, w kogo wymierzyl juz odszedl, to szukaj komu innemu przylac}
                 ktorego_walnie:=0;
                 for a2:=maxpost downto 1 do {porownuj z innymi postaciami}
                    if (a2<>a) and (post^[a2].jest) then begin
                       if (post^[a2].y>=y-7+grupy[grupa].bicie[0].y-7) and
                          (post^[a2].y<=y+7+grupy[grupa].bicie[0].y-7) and
                          (((kier=1) and (post^[a2].x<=x+7+grupy[grupa].bicie[0].x-7) and
                                         (post^[a2].x>=x-7+grupy[grupa].bicie[0].x-7)) or
                           ((kier=-1) and (post^[a2].x<=x+8-grupy[grupa].bicie[0].x+7) and
                                          (post^[a2].x>=x+8-grupy[grupa].bicie[0].x-7))) then begin
                             ktorego_walnie:=a2;
                             a2:=1;
                             doani:=grupy[grupa].ani_corobi[corobi]+1;
                       end;
                    end;
                 if ktorego_walnie=0 then
                  for a2:=maxmies downto 1 do {porownuj z miesem jesli nie ma kogo kopnac}
                    if (mies^[a2].jest) then begin
                       if (mies^[a2].rodz in [0..15,100,101,103]) and
                          (mies^[a2].y shr 10>=y-7+grupy[grupa].bicie[0].y-7) and
                          (mies^[a2].y shr 10<=y+7+grupy[grupa].bicie[0].y-7) and
                          (((kier=1) and (mies^[a2].x shr 10<=x+7+grupy[grupa].bicie[0].x-7) and
                                         (mies^[a2].x shr 10>=x-7+grupy[grupa].bicie[0].x-7)) or
                           ((kier=-1) and (mies^[a2].x shr 10>=x+8-grupy[grupa].bicie[0].x+7) and
                                          (mies^[a2].x shr 10<=x+8-grupy[grupa].bicie[0].x-7))) then begin
                             mies^[a2].dx:=mies^[a2].dx+trunc((grupy[grupa].bicie[0].dx*kier)*2048);
                             mies^[a2].dy:=mies^[a2].dy+trunc(grupy[grupa].bicie[0].dy*2048);
                             ktore_mieso_walnie:=a2;
                             a2:=1;
                             doani:=grupy[grupa].ani_corobi[corobi]+1;
                       end;
                    end;
                 for a2:=maxpacz downto 1 do {porownuj z paczka jak wciaz nie kopnal}
                    if (pacz^[a2].jest) then begin
                       if (pacz^[a2].y shr 10>=y-7+grupy[grupa].bicie[0].y-7) and
                          (pacz^[a2].y shr 10<=y+7+grupy[grupa].bicie[0].y-7) and
                          (((kier=1) and (pacz^[a2].x shr 10<=x+7+grupy[grupa].bicie[0].x-7) and
                                         (pacz^[a2].x shr 10>=x-7+grupy[grupa].bicie[0].x-7)) or
                           ((kier=-1) and (pacz^[a2].x shr 10<=x+8-grupy[grupa].bicie[0].x+7) and
                                          (pacz^[a2].x shr 10>=x+8-grupy[grupa].bicie[0].x-7))) then begin
                             corobi:=12;
                             doani:=grupy[grupa].ani_corobi[corobi]+1;
                             pacz^[a2].rozwalasie:=true;
                             a2:=1;
                       end;
                    end;
                end;

               end;
               if (ani=7) and (doani=1) then corobi:=comarobic;
               END;
               end;
            13:begin {bije reka}
               ktora_animacja:=12;
               IF NOT PAUZA THEN BEGIN
               walnou:=false;
               if (ani=grupy[grupa].bicie[1].klatka) and (doani=grupy[grupa].ani_corobi[corobi]) then begin
                if (ktorego_walnie>0) and (ktorego_walnie<=maxpost) and (post^[ktorego_walnie].jest) and
                   (post^[ktorego_walnie].y>=y-7+grupy[grupa].bicie[1].y-7) and
                   (post^[ktorego_walnie].y<=y+7+grupy[grupa].bicie[1].y-7) and
                   (((kier=1) and (post^[ktorego_walnie].x<=x+7+grupy[grupa].bicie[1].x-7) and
                                  (post^[ktorego_walnie].x>=x-7+grupy[grupa].bicie[1].x-7)) or
                   ((kier=-1) and (post^[ktorego_walnie].x<=x+8-grupy[grupa].bicie[1].x+7) and
                                  (post^[ktorego_walnie].x>=x+8-grupy[grupa].bicie[1].x-7))) then begin
                  post^[ktorego_walnie].dx:=post^[ktorego_walnie].dx+(grupy[grupa].bicie[1].dx*kier);
                  post^[ktorego_walnie].dy:=post^[ktorego_walnie].dy+grupy[grupa].bicie[1].dy;

                  if (post^[ktorego_walnie].x>x) and (post^[ktorego_walnie].kier=1) then post^[ktorego_walnie].kier:=-1;
                  if (post^[ktorego_walnie].x<x) and (post^[ktorego_walnie].kier=-1) then post^[ktorego_walnie].kier:=1;

                  if not kfg.dzieci then
                  for a2:=0 to trunc((10+random(10)*kfg.il_krwi)) do
                      nowysyf(trunc(post^[ktorego_walnie].x)-2+random(5),trunc(post^[ktorego_walnie].y)-2+random(5),
                      ((grupy[grupa].bicie[1].dx*(random/2+0.5))+random/2-0.25)*kier,
                      (grupy[grupa].bicie[1].dy*(random/2+0.5))+random/2-0.25,
                      grupy[post^[ktorego_walnie].grupa].kolorkrwi.od+random(grupy[post^[ktorego_walnie].grupa].kolorkrwi.ile)
                      ,1,true,0,0,0);
                  dec(post^[ktorego_walnie].sila,random(grupy[grupa].sila_bicia div 2)+grupy[grupa].sila_bicia div 2);
                  StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+9],false,15+a mod 5,15+a mod 5);
                  if random(3)=0 then
                     StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*post^[ktorego_walnie].grupa+random(3)],false,
                                15+ktorego_walnie mod 5,15+ktorego_walnie mod 5);
                  ktorego_walnie:=0;
                  walnou:=true;
                end;
                if not walnou then begin {jesli ten, w kogo wymierzyl juz odszedl, to szukaj komu innemu przylac}
                 ktorego_walnie:=0;
                 for a2:=maxpost downto 1 do {porownuj z innymi postaciami}
                    if (a2<>a) and (post^[a2].jest) then begin
                       if (post^[a2].y>=y-7+grupy[grupa].bicie[1].y-7) and
                          (post^[a2].y<=y+7+grupy[grupa].bicie[1].y-7) and
                          (((kier=1) and (post^[a2].x<=x+7+grupy[grupa].bicie[1].x-7) and
                                         (post^[a2].x>=x-7+grupy[grupa].bicie[1].x-7)) or
                           ((kier=-1) and (post^[a2].x<=x+8-grupy[grupa].bicie[1].x+7) and
                                          (post^[a2].x>=x+8-grupy[grupa].bicie[1].x-7))) then begin
                             ktorego_walnie:=a2;
                             a2:=1;
                             doani:=grupy[grupa].ani_corobi[corobi]+1;
                       end;
                    end;
                end;
                if not walnou then begin {jesli dalej nie walnal, to moze zwierzatko?}
                 for a2:=maxzwi downto 1 do {porownuj ze zwierzetami}
                    if (zwi^[a2].jest) then begin
                       if (zwi^[a2].y shr 10>=y-7+grupy[grupa].bicie[1].y-7) and
                          (zwi^[a2].y shr 10<=y+7+grupy[grupa].bicie[1].y-7) and
                          (((kier=1) and (zwi^[a2].x shr 10<=x+7+grupy[grupa].bicie[1].x-7) and
                                         (zwi^[a2].x shr 10>=x-7+grupy[grupa].bicie[1].x-7)) or
                           ((kier=-1) and (zwi^[a2].x shr 10<=x+8-grupy[grupa].bicie[1].x+7) and
                                          (zwi^[a2].x shr 10>=x+8-grupy[grupa].bicie[1].x-7))) then begin
                          d:=random(10)+6;
                          if not kfg.dzieci then
                          for b:=0 to trunc(d*kfg.il_krwi) do
                              nowysyf(zwi^[a2].x shr 10,zwi^[a2].y shr 10,
                                      ((grupy[grupa].bicie[1].dx*(random/2+0.5))+random/2-0.25)*kier,
                                      (grupy[grupa].bicie[1].dy*(random/2+0.5))+random/2-0.25,
                                      180+random(4),1,true,0,0,0);
                          dec(zwi^[a2].sila,d div 2);
                          zwi^[a2].dx:=zwi^[a2].dx+trunc((grupy[grupa].bicie[1].dx*kier)*1024);
                          zwi^[a2].dy:=zwi^[a2].dy+trunc(grupy[grupa].bicie[1].dy*1024);
                          a2:=1;
                          ktorego_walnie:=0;
                          walnou:=true;
                          StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+9],false,15+a mod 5,15+a mod 5);
                       end;
                    end;
                end;
               end;
               if (ani=7) and (doani=1) then corobi:=comarobic;
               END;
               end;
            14:begin {topi sie}
               ktora_animacja:=5;
               IF NOT PAUZA THEN BEGIN
               if random(200)=0 then kier:=-kier;
               if (not zablokowany) then x:=x+kier/8;
               end;
               END;
          end;
end;

{*}PROCEDURE postaci;
var
b,d2:integer;
pokx,poky:real;
sprbuf:array[0..15] of byte;
s1:single;

{+}PROCEDURE sterowanie_z_klawiatury;
begin
with post^[a] do begin
             b:=0;
             if (kl[77]) and (corobi<>11) then begin {prawo}
                kier:=1;
                if kl[47] then comarobic:=1 else comarobic:=2;
                b:=1;
                if celow.st_kat>=180 then
                   celow.st_kat:=180-celow.st_kat mod 180;
             end;
             if (kl[75]) and (corobi<>11) then begin {lewo}
                kier:=-1;
                if kl[47] then comarobic:=1 else comarobic:=2;
                b:=1;
                if celow.st_kat<180 then
                   celow.st_kat:=180+(180-celow.st_kat);
                if celow.st_kat=360 then celow.st_kat:=0;
             end;

                if (kier=1) and (celow.st_kat>=180) then
                   celow.st_kat:=180-celow.st_kat mod 180;
                if (kier=-1) and (celow.st_kat<180) then
                   celow.st_kat:=180+(180-celow.st_kat);

                if celow.st_kat=360 then celow.st_kat:=0;

             if (kl[46]) and (corobi in [0,1,2,5..7]) and (abs(dy)<0.3)
                and (podxy7<>0) then begin {skok}
                dy:=-1;
                if not (corobi in [0,5,6]) then dx:=kier;
                corobi:=11;
                StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+8],false,15+a mod 5,15+a mod 5);
             end;
             if (kl[45]) then begin
               if (celow.temp=0) then begin {strzal}
                _mmx:=mmx;
                _mmy:=mmy;
                _kat:=celow.kat;
                _sila:=celow.sila;
                mmx:=trunc(post^[a].x)-ekr.x+trunc(_sin(trunc(celow.st_kat))*8);
                mmy:=trunc(post^[a].y)-ekr.y-trunc(_cos(trunc(celow.st_kat))*8);
                celow.kat:=celow.st_kat;
                celow.sila:=celow.st_sila;
                strzel_mysza;

                if (celow.bron<100) and (typybroni1[celow.bron].odrz>0) then begin
                   if typybroni1[celow.bron].uzal then begin
                      dx:=dx-_sin(trunc(celow.kat))/((50/(celow.sila+1))*typybroni1[celow.bron].odrz);
                      dy:=dy+_cos(trunc(celow.kat))/((50/(celow.sila+1))*typybroni1[celow.bron].odrz)
                   end else begin
                      dx:=dx-_sin(trunc(celow.kat))/typybroni1[celow.bron].odrz;
                      dy:=dy+_cos(trunc(celow.kat))/typybroni1[celow.bron].odrz
                   end;
                end;

                mmx:=_mmx;
                mmy:=_mmy;
                celow.kat:=_kat;
                celow.sila:=_sila;
               end;
               celow.strzela:=true;
             end;
             if kl[80] then begin {celownik w dol}
                celow.st_kat:=celow.st_kat+(5*kier);
                if (kier=1) and (celow.st_kat>175) then celow.st_kat:=175;
                if (kier=1) and (celow.st_kat<5) then celow.st_kat:=5;
                if (kier=-1) and (celow.st_kat<185) then celow.st_kat:=185;
                if (kier=-1) and (celow.st_kat>355) then celow.st_kat:=355;
                if (celow.bron=11) and (celow.jest_pochodnia=0) and (celow.strzela) and (random(10)=0) then begin
                   StartSound(Sound[22],false,9,9); {dzwiek przesuwania lasera}
                   celow.jest_pochodnia:=10;
                end;
                pokaz_sileikat:=true;
             end;
             if kl[72] then begin {celownik w gore}
                celow.st_kat:=celow.st_kat-(5*kier);
                if (kier=1) and (celow.st_kat>175) then celow.st_kat:=175;
                if (kier=1) and (celow.st_kat<5) then celow.st_kat:=5;
                if (kier=-1) and (celow.st_kat<185) then celow.st_kat:=185;
                if (kier=-1) and (celow.st_kat>355) then celow.st_kat:=355;
                if (celow.bron=11) and (celow.jest_pochodnia=0) and (celow.strzela)  and (random(10)=0) then begin
                   StartSound(Sound[22],false,9,9); {dzwiek przesuwania lasera}
                   celow.jest_pochodnia:=10;
                end;
                pokaz_sileikat:=true;
             end;
             if kl[30] then begin {wieksza sila}
                celow.st_sila:=celow.st_sila+2;
                if celow.st_sila>99 then celow.st_sila:=99;
                pokaz_sileikat:=true;
             end;
             if kl[44] then begin {mniejsza sila}
                celow.st_sila:=celow.st_sila-2;
                if celow.st_sila<0 then celow.st_sila:=0;
                pokaz_sileikat:=true;
             end;

             if (b=0) and (not (corobi in [5,12,13])) then comarobic:=0; {jak nie idzie i nie trzyma nic, to stoi}
             if kfg.pokazuj_sterowanego then begin
                if post^[a].x-ekr.x<120 then dec(ekr.x);
                if post^[a].x-ekr.x>200 then inc(ekr.x);
                if post^[a].y-ekr.wy<80-ekr.menuwys div 2 then dec(ekr.wy);
                if (post^[a].y-ekr.wy>120-ekr.menuwys div 2) and (ekr.wy<200+ekr.menuwys) then inc(ekr.wy);
             end;
             if (kl[31]) and (not (corobi in [3,4,8..10,12,13])) then begin {kop}
                corobi:=12;ani:=0;
                ktorego_walnie:=0;
                ktore_mieso_walnie:=0;
                for a2:=maxpost downto 1 do {porownuj z innymi postaciami}
                    if (a2<>a) and (post^[a2].jest) then begin
                       if (post^[a2].y>=y-7+grupy[grupa].bicie[0].y-7) and
                          (post^[a2].y<=y+7+grupy[grupa].bicie[0].y-7) and
                          (((kier=1) and (post^[a2].x<=x+7+grupy[grupa].bicie[0].x-7) and
                                         (post^[a2].x>=x-7+grupy[grupa].bicie[0].x-7)) or
                           ((kier=-1) and (post^[a2].x<=x+8-grupy[grupa].bicie[0].x+7) and
                                          (post^[a2].x>=x+8-grupy[grupa].bicie[0].x-7))) then begin
                             ktorego_walnie:=a2;
                             a2:=1;
                       end;
                    end;
                if ktorego_walnie=0 then
                 for a2:=maxmies downto 1 do {porownuj z miesem jesli nie ma kogo kopnac}
                    if (mies^[a2].jest) then begin
                       if (mies^[a2].rodz in [0..15,100,101,103]) and
                          (mies^[a2].y shr 10>=y-7+grupy[grupa].bicie[0].y-7) and
                          (mies^[a2].y shr 10<=y+7+grupy[grupa].bicie[0].y-7) and
                          (((kier=1) and (mies^[a2].x shr 10<=x+7+grupy[grupa].bicie[0].x-7) and
                                         (mies^[a2].x shr 10>=x-7+grupy[grupa].bicie[0].x-7)) or
                           ((kier=-1) and (mies^[a2].x shr 10<=x+8-grupy[grupa].bicie[0].x+7) and
                                          (mies^[a2].x shr 10>=x+8-grupy[grupa].bicie[0].x-7))) then begin
                             ktore_mieso_walnie:=a2;
                             a2:=1;
                       end;
                    end;
                if ktore_mieso_walnie=0 then
                 for a2:=maxmies downto 1 do {porownuj z paczka jak wciaz nie kopnal}
                    if (pacz^[a2].jest) then begin
                       if (pacz^[a2].y shr 10>=y-7+grupy[grupa].bicie[0].y-7) and
                          (pacz^[a2].y shr 10<=y+7+grupy[grupa].bicie[0].y-7) and
                          (((kier=1) and (pacz^[a2].x shr 10<=x+7+grupy[grupa].bicie[0].x-7) and
                                         (pacz^[a2].x shr 10>=x-7+grupy[grupa].bicie[0].x-7)) or
                           ((kier=-1) and (pacz^[a2].x shr 10<=x+8-grupy[grupa].bicie[0].x+7) and
                                          (pacz^[a2].x shr 10>=x+8-grupy[grupa].bicie[0].x-7))) then begin
                             a2:=1;
                       end;
                    end;
             end;
             if (kl[32]) and (not (corobi in [3,4,8..10,12,13])) then begin {cios reka}
                corobi:=13;ani:=0;
                ktorego_walnie:=0;
                ktore_mieso_walnie:=0;
                for a2:=maxpost downto 1 do {porownuj z innymi postaciami}
                    if (a2<>a) and (post^[a2].jest) then begin
                       if (post^[a2].y>=y-7+grupy[grupa].bicie[1].y-7) and
                          (post^[a2].y<=y+7+grupy[grupa].bicie[1].y-7) and
                          (((kier=1) and (post^[a2].x<=x+7+grupy[grupa].bicie[1].x-7) and
                                         (post^[a2].x>=x-7+grupy[grupa].bicie[1].x-7)) or
                           ((kier=-1) and (post^[a2].x<=x+8-grupy[grupa].bicie[1].x+7) and
                                          (post^[a2].x>=x+8-grupy[grupa].bicie[1].x-7))) then begin
                             ktorego_walnie:=a2;
                             a2:=1;
                       end;
                    end;
             end;
end;
end;

begin
licz:=0;    {ile zginelo teraz?}
il_post:=0; {ilosc postaci w grze - licznik}
il_zazn:=0; {ilosc zaznaczonych postaci - licznik}
ktora_zazn:=0; {ktora postac jest zaznaczona; ma znaczenie tylko przy jednej!}
jest_palacy:=false; {czy pali sie ktos na ekranie?}
pokaz_sileikat:=false;
for a:=0 to 4 do grupy[a].jestpost:=0; {ilosc post w kazdej z grup}
if (celow.sterowanie>0) and (not post^[celow.sterowanie].jest) then celow.sterowanie:=0;
for a:=1 to maxpost do
    if post^[a].jest then begin
       inc(il_post);
       with post^[a] do begin
         inc(grupy[grupa].jestpost);
         if (niesmiertelny>=0) and (sila<>niesmiertelny) then sila:=niesmiertelny;
         if zazn then begin inc(il_zazn);ktora_zazn:=a;end;
         IF NOT PAUZA THEN BEGIN
          podxy7:=getpix_x(trunc(x),trunc(y+7));

          zablokowany:=false;
          if (getpix_x(trunc(x),trunc(y+6))<>0) and (getpix_x(trunc(x),trunc(y-2))<>0) then begin
             d:=0;
             for b:=-2 to 6 do
                 if (y+b>=0) and (y+b<maxy) then begin
                    xms2mem(_xms[1].h,offsety[2]+trunc(y+longint(b))*maxx+trunc(x-6),sprbuf[0],14);
                    for c:=0 to 12 do
                        if sprbuf[c]<>0 then inc(d);
                 end;
             if ((d>=100) and (d<105) and (random(4)=0)) or (d>=105) then zablokowany:=true;
          end;

          if (zablokowany) and (random(10)=0) then begin
             kier:=-kier;
             ani:=random(8);
          end;

          if (celow.sterowanie=a) and (not zazn) then celow.sterowanie:=0;
          if celow.sterowanie=a then sterowanie_z_klawiatury;
          if x<2 then begin kier:=1;dx:=abs(dx);x:=2;end;
          if x>maxx-2 then begin kier:=-1;dx:=-abs(dx);x:=maxx-2;end;
          if not zablokowany then begin
             x:=x+dx;
             y:=y+dy;
          end;
          pokx:=x;
          poky:=y;
          if dx>0 then dx:=dx-0.025;
          if dx<0 then dx:=dx+0.025;
          if (not(corobi in [3,4])) and (abs(dx)<=0.03) then dx:=0;
          if (abs(dy)<=0.04) and (podxy7<>0) then dy:=0;
          {uwzglednij wiatr}
          if (corobi in [3,4]) and
             ((pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y<pogoda.pozwody))) then
               dx:=dx+pogoda.wiatr/1024;

          if dx>5 then dx:=5;
          if dx<-5 then dx:=-5;
          if dy>5 then dy:=5;
          if dy<-5 then dy:=-5;

          if (wolnawola) and (celow.sterowanie<>a) and (not palisie) and (rany=0) and (bonusy.spokojni=0) then
             postaci_wolnawola;

          if (palisie) and (sila>0) and (zmiana[3]=0) and (random(3)=0) then dec(sila);

          if corobi=14 then begin b:=1;corobi:=7 end else b:=0;
          dec(doani);                                               {animacja}
          if (doani<=0) and (corobi<>4) then begin inc(ani);doani:=grupy[grupa].ani_corobi[corobi];end;
          if (ani>=8) and (corobi<>4) then ani:=0;                  { - || - }
          if b=1 then corobi:=14;

          podxy7:=getpix_x(trunc(x),trunc(y+7));
          if podxy7=0 then begin {sprawdzaj pod kolesiem ziemie}
             if dy<5 then dy:=dy+grupy[grupa].waga;
          end else begin
             if kfg.ranyodupadkow then postac_zranodupadku;
             if bonusy.pinball=0 then dy:=-abs(dy/5)
                                 else begin
                                  dy:=-abs(dy*1.2);
                                  if abs(dy)>=0.3 then
                                  StartSound(Sound[48],false,15+a mod 5,15+a mod 5)
                                 end;
          end;

          if (bonusy.lekkiepost>0) and (y>10) then dy:=dy-grupy[grupa].waga*1.5;
          if (bonusy.ciezkopost>0) and (y<maxy) then dy:=dy+grupy[grupa].waga*2.5;

          if {(x-3>=0) and (x-3<maxx) and }(y-5>=0) and {odbijaj nad glowa w dol w razie czego}
             (((pogoda.dziura=0) and (y-5<=419)) or ((pogoda.dziura>=1) and (y-5<=399)))
             then begin
                xms2mem(_xms[1].h,offsety[2]+trunc(y-5)*maxx+trunc(x-3),sprbuf[0],7);
                for b:=0 to 6 do
                    if sprbuf[b]<>0 then begin
                       if kfg.ranyodupadkow then postac_zranodupadku;
                       if bonusy.pinball=0 then dy:=abs(dy)
                                           else begin
                                            dy:=abs(dy*1.2);
                                            if abs(dy)>=0.3 then
                                            StartSound(Sound[48],false,15+a mod 5,15+a mod 5)
                                           end;
                       b:=6;
                    end;
             end;

          if (zmiana[1]=0) then begin {duszenie sie}
             if (getpix_x(trunc(x),trunc(y-3))<>0) then begin
                inc(dusisie);
                if (dusisie>=100) and (sila>0) then dec(sila);
             end else dusisie:=0;
          end;

          if ((abs(dy)>1.3) or (abs(dx)>1)) and (not (corobi in [3,11])) then
             corobi:=4; {jesli za szybko spada, to sie zaczyna krecic}
             {jak nie, to niech robi co mial robic:}
          if (abs(dy)<=0.3) and (abs(dx)<0.3) and (podxy7<>0) and
             (not (corobi in [12,13])) and (not trzymany) then begin
             if (comarobic=7) and (corobi<>7) and (random(5)=0) then
                StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+4],false,15+a mod 5,15+a mod 5);
             corobi:=comarobic;
          end;

          if (not zablokowany) and (((not(corobi in [0,5,6,12,13])) and
             (abs(dx)<=0.01) and (abs(dy)<=0.01)) or (abs(dx)>0.01) or (abs(dy)>0.01)) then
          for b:=0 to 1 do {jesli jest "na nim" teren, to go podnies do gory}
              if getpix_x(trunc(x),trunc(y+6))<>0 then y:=y-1
                else
          if (not zablokowany) and (((not(corobi in [0,5,6,12,13])) and
             (abs(dx)<=0.01) and (abs(dy)<=0.01)) or (abs(dx)>0.01) or (abs(dy)>0.01)) then
          for b:=0 to 1 do {jesli jest "na nim" teren, to go przesun na dol}
              if getpix_x(trunc(x),trunc(y-6))<>0 then y:=y+1;

          {kopanie sie nawzajem ich samych}
          if (kfg.bijasie) and (celow.sterowanie<>a) and (not (corobi in [3,4,6..10,12..14])) and
             (pogoda.agresja>0) and (bonusy.spokojni=0) and (random(25-pogoda.agresja)=0) then begin
             c:=random(2);
             for a2:=maxpost downto 1 do {porownuj z innymi postaciami}
                 if (a2<>a) and (post^[a2].jest) and
                    (((not pogoda.szalency) and (not grupy[grupa].bracia[post^[a2].grupa]))
                     or (pogoda.szalency)) and
                    (post^[a2].y>=y-7+grupy[grupa].bicie[c].y-7) and
                    (post^[a2].y<=y+7+grupy[grupa].bicie[c].y-7) and
                    (((kier=1) and (post^[a2].x<=x+7+grupy[grupa].bicie[c].x-7) and
                                   (post^[a2].x>=x-7+grupy[grupa].bicie[c].x-7)) or
                    ((kier=-1) and (post^[a2].x<=x+8-grupy[grupa].bicie[c].x+7) and
                                   (post^[a2].x>=x+8-grupy[grupa].bicie[c].x-7))) then begin
                    ktorego_walnie:=a2;
                    a2:=1;
                    corobi:=12+c;ani:=0;
                 end;
          end;

          if (corobi=0) and (random(20)=0) then {jak stoi to sprawdzaj obok niego miecho...}
             for a2:=maxmies downto 1 do {porownuj z miesem jesli nie ma kogo kopnac}
                 if (mies^[a2].jest) then begin
                    if (mies^[a2].rodz in [0..15,100,101,103]) and {jesli obok jest miesko to kopnij}
                       (mies^[a2].y shr 10>=y-7+grupy[grupa].bicie[0].y-7) and
                       (mies^[a2].y shr 10<=y+7+grupy[grupa].bicie[0].y-7) and
                       (((mies^[a2].x shr 10<=x+7+grupy[grupa].bicie[0].x-7) and
                         (mies^[a2].x shr 10>=x-7+grupy[grupa].bicie[0].x-7)) or
                        ((mies^[a2].x shr 10<=x+8-grupy[grupa].bicie[0].x+7) and
                         (mies^[a2].x shr 10>=x+8-grupy[grupa].bicie[0].x-7))) then begin
                          mies^[a2].dx:=mies^[a2].dx+trunc((grupy[grupa].bicie[0].dx*kier)*2048);
                          mies^[a2].dy:=mies^[a2].dy+trunc(grupy[grupa].bicie[0].dy*2048);
                          if ((mies^[a2].x shr 10<=x+7+grupy[grupa].bicie[0].x-7) and
                             (mies^[a2].x shr 10>=x-7+grupy[grupa].bicie[0].x-7)) then kier:=1;
                          if ((mies^[a2].x shr 10<=x+8-grupy[grupa].bicie[0].x+7) and
                             (mies^[a2].x shr 10>=x+8-grupy[grupa].bicie[0].x-7)) then kier:=-1;
                          ktore_mieso_walnie:=a2;
                          a2:=1;
                          corobi:=12;ani:=0;
                    end;
                 end;
          if (kfg.postotwierajapaczki) and (celow.sterowanie<>a) and (corobi in [0..2]) and
             (random(20)=0) then {sprawdzaj obok niego paczki}
                 for a2:=maxpacz downto 1 do {porownuj z paczka jak wciaz nie kopnal}
                    if (pacz^[a2].jest) then begin
                       if (pacz^[a2].y shr 10>=y-7+grupy[grupa].bicie[0].y-7) and
                          (pacz^[a2].y shr 10<=y+7+grupy[grupa].bicie[0].y-7) and
                          (((kier=1) and (pacz^[a2].x shr 10<=x+7+grupy[grupa].bicie[0].x-7) and
                                         (pacz^[a2].x shr 10>=x-7+grupy[grupa].bicie[0].x-7)) or
                           ((kier=-1) and (pacz^[a2].x shr 10<=x+8-grupy[grupa].bicie[0].x+7) and
                                          (pacz^[a2].x shr 10>=x+8-grupy[grupa].bicie[0].x-7))) then begin
                             a2:=1;
                             corobi:=12;ani:=0;
                       end;
                    end;

          if not zablokowany then begin {sprawdzanie czy wszedl na sciane i go odwrocenie/odbicie w poziomie}
           b:=12;c:=0;
           while (getpix_x(trunc(x+5),trunc(y-7+b))<>0) and (b>=3) do begin dec(b);inc(c);end;
           if c>=6 then begin
             if kfg.ranyodupadkow then postac_zranodupadku;
             kier:=-abs(kier);
             x:=x-dx;
             if bonusy.pinball=0 then dx:=-abs(dx)
                                 else begin
                                  dx:=-abs(dx*1.2);
                                  if abs(dx)>=0.3 then
                                  StartSound(Sound[48],false,15+a mod 5,15+a mod 5)
                                 end;
           end;
           b:=12;c:=0;
           while (getpix_x(trunc(x-5),trunc(y-7+b))<>0) and (b>=3) do begin dec(b);inc(c);end;
           if c>=6 then begin
             if kfg.ranyodupadkow then postac_zranodupadku;
             kier:=abs(kier);
             x:=x-dx;
             if bonusy.pinball=0 then dx:=abs(dx)
                                 else begin
                                  dx:=abs(dx*1.2);
                                  if abs(dx)>=0.3 then
                                  StartSound(Sound[48],false,15+a mod 5,15+a mod 5)
                                 end;
           end;
          end;

          if (sila>0) and (sila<=14) and (random(4+sila)=0) and
             (not kfg.dzieci) then begin {kapanie krwi jak ma malo sily}
             for d:=0 to trunc(kfg.il_krwi) do
             nowysyf(trunc(x)-1+random(3),trunc(y)-1+random(3),
                    (random/2-0.25)*((15-sila)/7), (random-0.5)*((15-sila)/7),
                    grupy[grupa].kolorkrwi.od+random(grupy[grupa].kolorkrwi.ile),1,true,0,0,0);
             if random(10)=0 then
             nowysyf(trunc(x)-1+random(3),trunc(y)-1+random(3),
                    (random-0.5)*((15-sila)/7), (random-0.5)*((15-sila)/7),
                    grupy[grupa].kolorkrwi.od+random(grupy[grupa].kolorkrwi.ile),1,true,0,0,3);

          end;

          for a2:=1 to maxpost do {porownuj z innymi postaciami}
              if post^[a2].jest then begin
                 if (corobi=6) and {zawracaj innych jesli bloker}
                    (not (post^[a2].corobi in [0,5,6])) and
                    (post^[a2].y>=y-12) and
                    (post^[a2].y<=y+12) then begin
                    if (post^[a2].x>=x-7) and {w lewo}
                       (post^[a2].x<=x) then begin
                       post^[a2].kier:=-abs(post^[a2].kier);
                       post^[a2].dx:=-abs(post^[a2].dx);
                    end;
                    if (post^[a2].x<=x+7) and {w prawo}
                       (post^[a2].x>=x) then begin
                       post^[a2].kier:=abs(post^[a2].kier);
                       post^[a2].dx:=abs(post^[a2].dx);
                    end;
                 end;
              end;


          if (sila<=0) and (niesmiertelny=-1) then begin {smierc}
           IF NOT KFG.DZIECI THEN BEGIN
            if (not palisie) or ((palisie) and (sila<-2)) then begin {rozbryzganie po scianie, czyli smierc na kawalki}
             s1:=360/trunc(49*kfg.il_krwi);
             for b:=0 to trunc(49*kfg.il_krwi) do begin
                c:=random(4);
                if c>1 then d:=1+random(2) else d:=1;
                nowysyf(trunc(x)-4+random(9),trunc(y)-4+random(9),
                        _sin(trunc(b*s1))*(0.2+random*3),
                        _cos(trunc(b*s1))*(0.2+random*3),
                        grupy[grupa].kolorkrwi.od+random(grupy[grupa].kolorkrwi.ile),d,true,0,0,c);
             end;
             for b:=0 to 5 do
                if (rany=0) or
                   ((rany=1) and (not (b in [0,1])) or {pomin rece}
                   ((rany=2) and (b<>2)) or {lub noge}
                   ((rany=3) and (b<>4))) {lub glowe...w zaleznosci od tego, co mu juz urwalo;)}
                   then
                nowemieso(trunc(x)+czescipoz[b].x,trunc(y)+czescipoz[b].y,
                          random*5-2.5,random*5-2.5,
                          czesci[b]+grupa*4,palisie);
             inc(stats.zabitych);
             StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*grupa+12],false,15+a mod 5,15+a mod 5);
            end
            else begin {smierc po spaleniu, wiec na popiol}
             for b:=0 to 79 do begin
                nowysyf(trunc(x)-5+random(11),trunc(y)-5+random(11),
                        _sin(trunc(b*4.5))*(random/2),
                        _cos(trunc(b*4.5))*(random/2),
                        random(6)+120,1+random(2),true,0,0,0);
             end;
             StartSound(Sound[15],false,6,8);
             inc(stats.spalonych);
            end;
           END ELSE BEGIN {dla dzieci}
            if (not palisie) or ((palisie) and (sila<-2)) then
               inc(stats.zabitych)
               else {smierc po spaleniu}
                  inc(stats.spalonych);
            {StartSound(Sound[15],false,6,8);}
            nowywyb(trunc(x),trunc(y),5,0);
           END;
           if jest then begin
              inc(licz);
              inc(il_trupow);
           end;
           jest:=false;
           zazn:=false;
          end;

          {wpada do wody etc.}
          if (y>=maxy+100) and (not trzymany) then begin
             niesmiertelny:=-1;
             sila:=0;
          end;
          if (pogoda.dziura=0) and (y>=maxy+7) and (not trzymany) then begin {blad-znajdzie sie pod ziemia}
             if jest then begin                           {gdy nie ma dziury}
                inc(stats.utopionych);
                inc(il_trupow);
             end;
             jest:=false;
          end;
          if (pogoda.dziura>=1) and (y>=pogoda.pozwody+2) {and (not trzymany) }then begin
             if (pogoda.dziura=1) and (y>=maxy+7) and (not trzymany) then begin {przepasc}
                if jest then begin
                   inc(stats.utopionych);
                   inc(licz);
                   inc(il_trupow);
                end;
                jest:=false;
             end;
             if (pogoda.dziura in [2,4]) then begin {woda & kwas}
                corobi:=14;
                if (y>pogoda.pozwody) and (y<pogoda.pozwody+7) then begin
                   plum(trunc(x),13,trunc(abs(dy)*10),dx/2,dy/2);
                   if sqrt(sqr(dx)+sqr(dy))>2 then dec(sila,trunc(sqrt(sqr(dx)+sqr(dy))*2));
                end;
                if (y>pogoda.pozwody+4) and (rany=0) and (sila>10) and (dy>-0.4) then dy:=dy-0.15;
                if (zmiana[2]=0) and (y>pogoda.pozwody+7) then begin
                   nowybom(trunc(x),trunc(y-4));
                   if random(100)=0 then StartSound(Sound[50],false,15+a mod 5,15+a mod 5);
                end;
                if (zmiana[3]=0) and (sila>0) then dec(sila);
                if (pogoda.dziura=4) and (zmiana[1]=0) and (sila>0) then dec(sila); {kwas}
                if (pogoda.dziura=4) and (rany=0) and (random(40)=0) then begin
                   rany:=random(3)+1;
                   case rany of
                      1: {oderwane rece}
                        for d2:=0 to 1 do
                        nowemieso(trunc(post^[a].x)+czescipoz[d2].x,trunc(post^[a].y)+czescipoz[d2].y,
                            0,0,
                            post^[a].grupa*4,post^[a].palisie);
                      2: {oderwana noga}
                        nowemieso(trunc(post^[a].x)+czescipoz[2].x,trunc(post^[a].y)+czescipoz[2].y,
                            0,0,
                            1+post^[a].grupa*4,post^[a].palisie);
                      3: {oderwana glowa}
                        nowemieso(trunc(post^[a].x)+czescipoz[4].x,trunc(post^[a].y)+czescipoz[4].y,
                            0,0,
                            2+post^[a].grupa*4,post^[a].palisie);

                   end;
                   nowydym(trunc(x),trunc(y+3),5,2);
                end;
                if (sila<=0) and (niesmiertelny=-1) then begin   {utopienie sie}
                   if jest then begin
                      inc(stats.utopionych);
                      inc(licz);
                      inc(il_trupow);
                   end;
                   jest:=false;
                   StartSound(Sound[50],false,15+a mod 5,15+a mod 5);
                   for b:=0 to 5 do
                       if (rany=0) or
                         ((rany=1) and (not (b in [0,1])) or {pomin rece}
                         ((rany=2) and (b<>2)) or {lub noge}
                         ((rany=3) and (b<>4))) {lub glowe...w zaleznosci od tego, co mu juz urwalo;)}
                         then
                         nowemieso(trunc(x)+czescipoz[b].x,trunc(y)+czescipoz[b].y,
                          0,0,
                          czesci[b]+grupa*4,palisie);
                end;
                if (palisie) and (zmiana[3]=0) then palisie:=false;
             end;
             if (pogoda.dziura=3) then begin {lawa}
                corobi:=14;
                if (y>pogoda.pozwody+4) and (rany=0) and (sila>10) and (dy>-0.3) then dy:=dy-0.15;
                if (zmiana[2]=0) and (sila>0) then dec(sila);
                if (sila<=0) and (niesmiertelny=-1) then begin
                   if jest then begin
                      inc(stats.spalonych);
                      inc(licz);
                      inc(il_trupow);
                   end;
                   jest:=false;
                   for b:=0 to 5 do
                       if (rany=0) or
                         ((rany=1) and (not (b in [0,1])) or {pomin rece}
                         ((rany=2) and (b<>2)) or {lub noge}
                         ((rany=3) and (b<>4))) {lub glowe...w zaleznosci od tego, co mu juz urwalo;)}
                         then
                         nowemieso(trunc(x)+czescipoz[b].x,trunc(y)+czescipoz[b].y,
                          0,0,
                          czesci[b]+grupa*4,palisie);
                end;
                if (not palisie) and (zmiana[3]=0) then palisie:=true;
             end;
          end;

          if (pogoda.dziura in [2,4]) and
             (y-2<=pogoda.pozwody) and (y+6>=pogoda.pozwody) {and (not trzymany) }then
             plum(trunc(x),9,5,dx/2,dy/2);
          if (pogoda.dziura=3) and
             (y-1<=pogoda.pozwody) and (y+6>=pogoda.pozwody) {and (not trzymany) }then begin
             if zmiana[3]=0 then begin
                nowydym(trunc(x),pogoda.pozwody-1,4+random(4),random(2));
                if random(3)=0 then StartSound(Sound[29], false,7,8);
             end;
             corobi:=7;
             if (zmiana[3]=0) and (sila>0) then dec(sila);
             if random(15)=0 then palisie:=true;
          end;
          if (pogoda.dziura=3) and
             (y+5>=pogoda.pozwody) {and (not trzymany) }then begin
             if abs(dx)>0.5 then dx:=dx/1.7;
             if abs(dy)>0.5 then dy:=dy/1.7;
          end;
          if (pogoda.dziura=4) and
             (y-4<=pogoda.pozwody) and (y+6>=pogoda.pozwody) {and (not trzymany) }then begin
             if zmiana[3]=0 then begin
                nowydym(trunc(x),pogoda.pozwody-1,4+random(4),random(2));
                if random(3)=0 then StartSound(Sound[29], false,7,8);
                if (rany=0) and (random(40)=0) then begin
                   nowemieso(trunc(x)+czescipoz[2].x,trunc(y)+czescipoz[2].y,
                             0,0,
                             1+post^[a].grupa*4,post^[a].palisie);
                   rany:=2;
                end;
             end;
             if random(5)=0 then corobi:=7;
             if (zmiana[3]=0) and (sila>0) then dec(sila);
          end;

          if (bonusy.przyklejpost>0) and (rany=0) then corobi:=7;
          if (bonusy.panika>0) and (rany=0) then corobi:=7;

          if rany>0 then begin {jesli jest ranny...}
             if kier=1 then a2:=0
                       else a2:=15;
             case rany of
                1:begin {urwane rece}
                  comarobic:=8;
                  corobi:=8;
                  if (zmiana[2]=0) and (not kfg.dzieci) then
                    for d:=0 to trunc(kfg.il_krwi) do begin
                     nowysyf(trunc(x)+kier*grupy[grupa].ranykrew[0,ani].x,trunc(y)+grupy[grupa].ranykrew[0,ani].y,
                        kier*(random*0.4-0.2+grupy[grupa].ranykrew[0,ani].dx),
                        (random*0.4-0.2+grupy[grupa].ranykrew[0,ani].dy),
                        grupy[grupa].kolorkrwi.od+random(grupy[grupa].kolorkrwi.ile),1,true,0,0,0);
                     nowysyf(trunc(x)+kier*grupy[grupa].ranykrew[1,ani].x,trunc(y)+grupy[grupa].ranykrew[1,ani].y,
                        kier*(random*0.4-0.2+grupy[grupa].ranykrew[1,ani].dx),
                        (random*0.4-0.2+grupy[grupa].ranykrew[1,ani].dy),
                        grupy[grupa].kolorkrwi.od+random(grupy[grupa].kolorkrwi.ile),1,true,0,0,0);
                    end;
                  if (kfg.traceniesily) and (sila>0) and (zmiana[2]=0) then dec(sila);
                  end;
                2:begin {urwana noga}
                  comarobic:=9;
                  corobi:=9;
                  if (zmiana[2]=0) and (not kfg.dzieci) then begin
                    for d:=0 to trunc(kfg.il_krwi) do
                     nowysyf(trunc(x)+kier*grupy[grupa].ranykrew[2,ani].x,trunc(y)+grupy[grupa].ranykrew[2,ani].y,
                        kier*(random*0.4-0.2+grupy[grupa].ranykrew[2,ani].dx),
                        (random*0.4-0.2+grupy[grupa].ranykrew[2,ani].dy),
                        grupy[grupa].kolorkrwi.od+random(grupy[grupa].kolorkrwi.ile),1,true,0,0,0);
                  end;
                  if (kfg.traceniesily) and (sila>0) and (zmiana[2]=0) then dec(sila);
                  end;
                3:begin {urwana glowa}
                  comarobic:=10;
                  corobi:=10;
                  if (zmiana[2]=0) and (not kfg.dzieci) then begin
                    for d:=0 to trunc(kfg.il_krwi) do
                     nowysyf(trunc(x)+kier*grupy[grupa].ranykrew[3,ani].x,trunc(y)+grupy[grupa].ranykrew[3,ani].y,
                        kier*(random*0.4-0.2+grupy[grupa].ranykrew[3,ani].dx),
                        (random*0.4-0.2+grupy[grupa].ranykrew[3,ani].dy),
                        grupy[grupa].kolorkrwi.od+random(grupy[grupa].kolorkrwi.ile),1,true,0,0,0);
                  end;
                  if (kfg.traceniesily) and (sila>0) then dec(sila);
                  end;
             end;
          end; {E jesli jest ranny...}

          if (bonusy.spokojni>0) and (rany=0) and (random(40)=0) then
             case random(10) of
                  0..3 :begin comarobic:=0;corobi:=0 end;  {stoi}
                  4..7 :begin comarobic:=1;corobi:=1 end;  {idzie}
                  8..9 :kier:=-kier;   {odwroc sie}
             end;
          if (zablokowany) and (rany=0) and (random(7)=0) then corobi:=7;
         END;{PAUZA}
          case_corobi;

          if blyska=0 then
             maskpicxms(trunc(x-7-ekr.x),trunc(y-7-ekr.y),15,15,0,
                        offsetyp[grupa]+225*(ktora_animacja*8+ani),scr^,kier,false)
             else begin
             maskpic2xms(trunc(x-7-ekr.x),trunc(y-7-ekr.y),15,15,0,blyska+60,
                        offsetyp[grupa]+225*(ktora_animacja*8+ani),scr^,kier,false);
             dec(blyska);
             end;
          if (kfg.aureolki) and (niesmiertelny>=0) then
             maskpicxms(trunc(x-2-ekr.x),trunc(y-10-ekr.y),5,3,0,offsety[27]+190,scr^,1,true);
          if palisie then begin {pokaz ogien jak sie pali itd}
             MaskPicTxms(trunc(x-7-ekr.x),trunc(y-7-ekr.y),15,15,0,offsety[10]+longint(ogienani)*225,scr^);
            IF NOT PAUZA THEN BEGIN
             if (zmiana[3]=0) and (random(4)=0) then {dym}
                nowydym(trunc(x)-2+random(5),trunc(y)-7+random(3),3+random(3),0);
             if zmiana[2]=0 then begin inc(ogienani);if ogienani>=6 then ogienani:=0;end;
             if (random(30)=0) and (bonusy.spokojni=0) then comarobic:=7; {zaczyna panikowac}
             if (zmiana[2]=0) then {iskierki}
                nowysyf(trunc(x)-4+random(9),trunc(y)-4+random(9),
                        random/2-0.25,-random-0.2,199,0,true,15,2,0);
             if (zmiana[3]=0) and (random(5)=0) then {lecace plomienie}
                strzal(trunc(x)-2+random(5),trunc(y)-random(5),
                       random/2-0.25,-random/8-0.01,
                       3,1,5,7-random(4));
            END;
             if (x>=ekr.x-15) and (y>=ekr.y-15) and
                (x<=ekr.x+335) and (y<=ekr.y+215-ekr.menuwys) then jest_palacy:=true;
          end;
          if zazn then begin
             maskpicxms(trunc(x-2-ekr.x),trunc(y-13-ekr.y),5,5,0,offsety[27]+25*grupa,scr^,1,true);
             if (kfg.wskazniki_post) and {rysowanie wskaznikow zaznaczonych}
                ((x>326+ekr.x) or (x+7<ekr.x) or
                (y>208-ekr.menuwys+ekr.y) or (y+7<ekr.y)) then begin
                b:=trunc(x)-ekr.x;
                d2:=trunc(y)-ekr.y;
                if b<0 then b:=0;
                if b>319 then b:=319;
                if d2<0 then d2:=0;
                if d2>199-ekr.menuwys then d2:=199-ekr.menuwys;
                maskpic3xms(b-2,d2-2,5,5,0,kgrup[grupa]+4,offsety[27]+165,scr^,true);
             end;
          end;

          if celow.sterowanie=a then begin {pokaz celownik itp jesli sterowany}
             maskpicxms((trunc(post^[a].x)-ekr.x)-10+trunc(_sin(trunc(celow.st_kat))*(9+celow.st_sila/3)),
                        (trunc(post^[a].y)-ekr.y)-10-trunc(_cos(trunc(celow.st_kat))*(9+celow.st_sila/3)),
                        21,21,0,offsety[4]+441*3,scr^,1,false);
             if pokaz_sileikat then begin
                piszm(trunc(post^[a].x)-ekr.x-7,trunc(post^[a].y)-ekr.y+6,l2t(celow.st_kat,3)+'`',159);
                piszm(trunc(post^[a].x)-ekr.x-7,trunc(post^[a].y)-ekr.y+12,'S:'+l2t(celow.st_sila,2),159);
             end;
          end;

       end;
    end;

if (jest_palacy) and (ciagle_dzwieki[1]=0) then begin
   if StartSound(Sound[14], true,11,11) then ciagle_dzwieki[1]:=1;
end;
if (ciagle_dzwieki[1]=1) and (not jest_palacy) then begin
   ciagle_dzwieki[1]:=0;stopSound(11);
end;

if (NOT PAUZA) AND (licz>0) then begin
   ost_combo:=licz;
   if ost_combo>stats.najlkombo then stats.najlkombo:=ost_combo;
   komentarz_po_trupach(licz);
   if ost_combo>=2 then inc(punkty,sqr(longint(ost_combo)));
end;
end;

{*}PROCEDURE sprawdzaj_czy_trzeba_nowych_postaci;
var b,c:integer;
begin
IF NOT PAUZA THEN
for a:=0 to 4 do
    if grupy[a].jestpost<grupy[a].maxpost then begin
       if (not grupy[a].wyrzuca) and
          ((grupy[a].jestpost/grupy[a].maxpost<=grupy[a].procent/100) or
           (grupy[a].jestpost=0)) then
          grupy[a].wyrzuca:=true;
       if grupy[a].kiedynast<grupy[a].czestot then inc(grupy[a].kiedynast);
       if (grupy[a].wyrzuca) and (grupy[a].kiedynast>=grupy[a].czestot) then begin
          b:=-1;
          for c:=1 to maxpost do if not post^[c].jest then begin b:=c;c:=maxpost;end;
          if b>=1 then with post^[b] do begin
             grupy[a].kiedynast:=0;
             jest:=true;
             if not grupy[a].wylot then begin x:=random(1220)+30;y:=10;dx:=random*4-2;end
                                   else begin x:=grupy[a].wylx;y:=grupy[a].wyly;dx:=0;end;
             dy:=0.75+random/3;
             ani:=random(4);
             ogienani:=random(6);
             doani:=random(3);
             if grupy[a].corobi<5 then comarobic:=corobitab[grupy[a].corobi]
                else comarobic:=corobitab[random(5)];
             corobi:=4;
             if grupy[a].kierunek=0 then kier:=random(2)*2-1
                                    else kier:=grupy[a].kierunek;
             sila:=grupy[a].sila;
             rany:=0;
             zazn:=false;
             grupa:=a;
             trzymany:=false;
             palisie:=false;
             dusisie:=0;
             blyska:=0;
             wolnawola:=grupy[a].wolnawol;
             niesmiertelny:=-1;
             inc(grupy[a].jestpost);
             if grupy[a].jestpost>=grupy[a].maxpost then grupy[a].wyrzuca:=false;
             inc(stats.postaci);
          end;
       end;
    end;
end;

{---------------rybki, ptaszki--------------------------}
{*}PROCEDURE zwierzatka;
const
rodzklatka  :array[0..3] of longint=({p}0,14, {r}6,10);  {poczatkowe klatki}
rodzilklatek:array[0..3] of byte   =({p}6, 6, {r}4, 4);  {ilosci klatek}
var
kier:shortint;
px,py,l,l2:longint;
pdx,pdy,s1:single;
begin
for a:=1 to maxzwi do begin
   with zwi^[a] do begin
     if jest then begin
       IF NOT PAUZA THEN BEGIN
        dec(doani);
        if doani<=0 then begin
           if rodz=1 then doani:=1+(abs(dx) div 500)
                     else doani:=2+(abs(dx) div 300);
           inc(ani);
           if ani>=rodzilklatek[rodz] then ani:=0;
        end;
        x:=x+longint(dx);
        y:=y+longint(dy);

        if corobi=0 then begin
           dy:=dy+random(21)-10;
           dx:=dx+random(21)-10;
           if (pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y div 1024<pogoda.pozwody)) then
              dx:=dx+pogoda.wiatr div 2;
           if ((rodz<>1) and (random(10)=0)) or
              ((rodz=1) and (random(2)=0)) then begin
              dx:=dx+longint(random(200))-100;
              dy:=dy+longint(random(200))-100;
           end;
           if (random(300)=0) and ((rodz<=1) or ((rodz>=2) and (
              ((pogoda.dziura>=2) and (y div 1024>=pogoda.pozwody)))))
              then dx:=-dx;
        end;

        if (getpix_x((x+longint(dx)) shr 10, (y+longint(dy)) shr 10)>0) then begin
           x:=x-longint(dx);
           y:=y-longint(dy);
           dx:=-dx div 2;
           dy:=-dy div 2;
           if (rodz>=1) and
              (((pogoda.dziura>=2) and (y<longint(pogoda.pozwody) shl 10)) or
               (pogoda.dziura<=1)) then dy:=dy div 2;
        end;

        if rodz<=1 then begin {ptaszki}
           if rodz=0 then begin
              if (dx>0) and (dx<200) then dx:=200;
              if (dx<0) and (dx>-200) then dx:=-200;
              if (abs(dx)<500) and (zmiana[4]=0) and (random(2000)=0) then begin {sra}
                 for l:=0 to 1+random(3) do
                     nowysyf(x shr 10,y shr 10,
                             -dx/1000-0.025+random/20, -0.025+random/20,
                             random(6)+121,1,true,0,0,0);
              end;
           end;
           if (pogoda.dziura>=2) and (y>=longint(pogoda.pozwody) shl 10) and
              (zmiana[1]=0) and (sila>0) then begin
              dec(sila);
              dx:=dx div 2;
              dy:=dy div 2;
           end;
           if (pogoda.dziura>=2) and (y<=longint(pogoda.pozwody+1) shl 10) and
              (y>=longint(pogoda.pozwody-2) shl 10) and (dy>0) then dy:=dy-400;
        end;
        if rodz>=2 then begin {rybki}
           if ((pogoda.dziura>=2) and (y<=longint(pogoda.pozwody) shl 10)) or
              (pogoda.dziura<=1) then begin
              dy:=dy+80;
              if (zmiana[4]=0) and (random(5)=0) and (sila>0) then dec(sila);
           end;
           if (pogoda.dziura>=3) and (y>=longint(pogoda.pozwody) shl 10) and
              (zmiana[1]=0) and (sila>0) then dec(sila);

           if (pogoda.dziura>=2) and (y>longint(pogoda.pozwody-1) shl 10) and
              (y<longint(pogoda.pozwody+2) shl 10) and (dy<0) then dy:=dy+400;
        end;
        if (pogoda.dziura>=2) and (y>longint(pogoda.pozwody-2) shl 10) and
              (y<longint(pogoda.pozwody+2) shl 10) and (abs(dy)>0.1) then
              plum(x shr 10,4,6,dx/3000,sqrt(sqr(longint(dx))+sqr(longint(dy)))/5000+0.1);

        if rodz=1 then begin {netoperki moga siadac na sufitach}
           if (corobi=0) and (random(4)=0) and
              (getpix_x(x shr 10,y shr 10-1)>0) and
              (getpix_x(x shr 10,y shr 10)=0) and
              (getpix_x(x shr 10,y shr 10+1)=0) then begin
              corobi:=1;
              dx:=0;
              dy:=0;
           end;
           if (corobi=1) and (random(200)=0) then begin
              corobi:=0;
              dx:=longint(random(1024))-512;
              dy:=random(400)+100;
           end;
           if (corobi=1) and
              (((abs(dx)>50) or (abs(dy)>50)) or
               (getpix_x(x shr 10,y shr 10-1)=0)) then begin
              corobi:=0;
              dx:=longint(random(1024))-512;
              dy:=random(400)+100;
           end;
        end;

        if zmiana[1]=0 then begin
           if rodz in [0,2] then begin l:=1;l2:=0 end
                            else begin l:=-1;l2:=20 end;
           for b:=1 to maxpost do {uciekaja przed postaciami lub je gonia}
               if (post^[b].jest) and
                  (x shr 10>=post^[b].x-(30+l2)) and
                  (x shr 10<=post^[b].x+(30+l2)) and
                  (y shr 10>=post^[b].y-(30+l2)) and
                  (y shr 10<=post^[b].y+(30+l2)) then begin
                 if ((rodz>=2) and (((pogoda.dziura>=2) and (y>=longint(pogoda.pozwody) shl 10)) or (pogoda.dziura<=1)))
                    or (rodz<=1) then begin
                  if (rodz=1) and (random(200)=0) then StartSound(Sound[47], false,6,8);
                  if x shr 10>=post^[b].x then dx:=dx+100*l
                                         else dx:=dx-100*l;
                  if y shr 10>=post^[b].y-2 then dy:=dy+100*l
                                           else dy:=dy-100*l;
                  if (rodz in [0,2]) and (random(20)=0) then begin dx:=-dx;dy:=-dy;end;
                 end;
                  if (rodz in [1,3]) and {piranie i netoperki gryza ludzi!}
                     (x shr 10>=post^[b].x-4) and
                     (x shr 10<=post^[b].x+4) and
                     (y shr 10>=post^[b].y-6) and
                     (y shr 10<=post^[b].y+6) then begin
                     if (rodz=1) and (random(100)=0) then StartSound(Sound[47], false,6,8);
                     l:=1+random(3);
                     if not kfg.dzieci then
                     for d:=0 to trunc(l*kfg.il_krwi) do
                         nowysyf(x shr 10,y shr 10,
                                 -0.3+random*0.6,
                                 -0.3+random*0.6,
                                 grupy[post^[b].grupa].kolorkrwi.od+random(grupy[post^[b].grupa].kolorkrwi.ile)
                                 ,1,true,0,0,0);
                     nowybom(x shr 10,y shr 10);
                     if (bonusy.spokojni=0) and (celow.sterowanie<>b) then begin
                        if (post^[b].corobi<>7) and (random(20)=0) then
                           StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*post^[b].grupa+4],false,15+b mod 5,15+b mod 5)
                           else if random(6)=0 then
                           StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*post^[b].grupa+random(3)],
                                      false,15+b mod 5,15+b mod 5);
                        case random(4) of
                          0:post^[b].corobi:=7; {panikuje}
                          1:begin
                            if (post^[b].x>x shr 10) and (post^[b].kier=1) then post^[b].kier:=-1;
                            if (post^[b].x<x shr 10) and (post^[b].kier=-1) then post^[b].kier:=1;
                            post^[b].corobi:=13; {bije}
                            end;
                        end;
                        if (post^[b].wolnawola) and (random(30)=0) then post^[b].comarobic:=7;
                     end;
                     if (post^[b].sila>0) and (random(3)=0) then dec(post^[b].sila);
                     if (rodz=3) and (post^[b].rany=0) and (post^[b].sila<=30) and (random(50)=0) then
                        post^[b].rany:=random(3)+1;
                  end;
                  b:=maxpost;
               end;
           if (getpix_x(x shr 10, y shr 10)>0) then dec(sila);
        end;

        if dx>1024 then dx:=dx-30;
        if dx<-1024 then dx:=dx+30;
        if dy>abs(dx) div 2 then dy:=dy-30;
        if dy<-abs(dx) div 2 then dy:=dy+30;

        if dx>0 then kier:=1 else kier:=-1;
       END;
        if corobi=0 then
           maskpicxms(x shr 10-3-ekr.x ,y shr 10-3-ekr.wy,7,7,0,
                      offsety[20]+49*(rodzklatka[rodz]+ani),scr^,kier,false)
           else
           if rodz=1 then
              maskpicxms(x shr 10-3-ekr.x ,y shr 10-3-ekr.wy,7,7,0,
                         offsety[20]+49*20,scr^,kier,false);
       IF NOT PAUZA THEN BEGIN
        if (x<-5000) or (x>maxx1+5000) or (y<-5000) then jest:=false;
        if (y>maxy1+1000) then dec(sila);
        if (sila<=0) then begin
           jest:=false;
           if not kfg.dzieci then begin
              s1:=24/kfg.il_krwi;
              for c:=0 to trunc(14*kfg.il_krwi) do
               nowysyf(x shr 10,y shr 10,
                       _sin(trunc(longint(c)*s1))*(0.1+random),
                       _cos(trunc(longint(c)*s1))*(0.1+random),
                       180+random(4),
                       1,true,0,0,0);
              for c:=1 to random(4) do
               nowysyf(x shr 10,y shr 10,
                       random*3-1.5,
                       random*3-1.5,
                       180+random(4),
                       1,true,0,0,3);
           end;
           inc(stats.zwierzatek);
           if rodz=0 then StartSound(Sound[46], false,6,8);
        end;
       END;
     end else if (NOT PAUZA) AND (kfg.zwierzsamewychodza) and (random(500)=0) then begin
        if pogoda.dziura=2 then  {jakie zwierze?}
           a:=random(4)
           else a:=random(2);

        b:=random(2);
        if b=0 then begin   {z bokow}
           if a<=1 then py:=random(pogoda.pozwody)
                   else py:=random(400-pogoda.pozwody)+pogoda.pozwody;
           px:=random(2)*maxx;
           if px=0 then pdx:=random/2+0.2 else pdx:=-random/2-0.2;
           pdy:=random/2-0.25;
        end else begin      {z gory(ptaki) lub z dolu(ryby)}
           if a<=1 then begin
              py:=0;
              pdy:=random/3;
           end else begin
              py:=maxy;
              pdy:=-random/3;
           end;
           px:=random(maxx);
           pdx:=random-0.5;
        end;
        if getpix_x(px,py)=0 then
           nowezwi(px,py,pdx,pdy,a);
     end;

   end;
end;

end;
{-E-------------rybki, ptaszki--------------------------}

end.