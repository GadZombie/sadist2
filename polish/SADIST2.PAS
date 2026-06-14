{gry:
 -ludzkie rzutki
 -chodzenie kolesiem i przebywanie drogi
-------------------

 -dzwiek trzesienia ziemi
 -ikony w rogu ekranu wybranej broni
 -przy sterowaniu postacia: moze obrazek trzymanej broni?
 -ustawianie sily burzy
 -brakuje dzwiekow w glownym menu

======================
 kanaly dzwiekowe:
 0-glos pana
 1-nalot
 2..4-wybuchy
 5-strzelanie myszka:
   bazuka,
   minigan,
   strzelba,
   snajper,
   miotacz  [C],
   samonaprowadzajacy
   laser [C],
   prad [C],
   kula ognista,
   ludzie (boing),
   rozpoczecie pily,
   dzwiek pochodni
 6-piorun,
   spadajaca/rozwalajaca sie paczka,
   koles sie spala,
   wrzask zabijanego ptaka
 7..8-puski wody/lawy/kwasu,
   spadajaca/rozwalajaca sie paczka,
   koles sie spala,
   wrzask zabijanego ptaka
 9..10-przesuwanie lasera,
   odbicie sie miny/granatu/bomby
   pip miny,
   spadanie kowadla,
   kopniecie mieska ---------------------
   rozbicie sie cegly
   uderzenie mieska w sciane ---------------
 11-ogien na ekranie [C]
 12-syk bomby/dynamitu [C]
 13-pila tnie  [C]
    pila wlaczona i nie tnie
    pila tnie kogos/cos
 14-deszcz [C]
 15..19-wrzaski postaci
 20..24-dzwieki postaci (kopanie, miesko itp)
}


{$N+}
uses crt,dos,myszunit,
     vars,cosin,
     xms,maskp,dzwieki2,SMix,resztki,resztki2,glowne,
     nowe,menusy,winieta,timer,loudsejw,robteren,upostaci,gadparam;

{*}PROCEDURE podlicz_opady;
begin
pogoda.il_sniegu:=0;
for a:=1 to maxopad do if opad^[a].jest then inc(pogoda.il_sniegu)
end;

{*}PROCEDURE opady(plany:byte);
const
sniegkol:array[0..3] of byte=(6,7,127,63);
var
_x,_y,
wtr,sn,
mozebycmaxopadow:longint;
spr:array[0..1,-1..2] of byte;
begin
mozebycmaxopadow:=pogoda.wielkopadow*(maxopad div 50);
wtr:=pogoda.wiatr*50;
for a:=1 to maxopad do begin
    if (opad^[a].jest) then begin
     if ((plany=0) and (opad^[a].plan<>2)) or
        ((plany=1) and (opad^[a].plan=2)) then begin
       with opad^[a] do begin
        IF NOT PAUZA THEN BEGIN
         if plan=1 then begin
          if rodz=0 then begin
             if getpix_x(x shr 10,y+1)=0 then inc(y);
             xms2mem(_xms[1].h,offsety[2]+longint(y)*maxx+(x shr 10-1),spr[0],4);
             xms2mem(_xms[1].h,offsety[2]+(longint(y)+1)*maxx+(x shr 10-1),spr[1],4);
          end else begin
             if getpix_x(x shr 10,y+2)=0 then inc(y,2);
             xms2mem(_xms[1].h,offsety[2]+longint(y)*maxx+(x shr 10-1),spr[0],4);
             xms2mem(_xms[1].h,offsety[2]+(longint(y)+2)*maxx+(x shr 10-1),spr[1],4);
          end;

          if x<1024 then begin spr[0,-1]:=0; spr[1,-1]:=0 end
             else if x>=maxx1 then begin spr[0,1]:=0; spr[1,1]:=0 end;

          if getpix_x((x+wtr) shr 10,longint(y))=0 then x:=x+wtr;
          if spr[1,0]<>0 then begin
             if rodz=0 then begin
                if (spr[1,-1]=0) and (spr[0,-1]=0) and (random(500)>2) then x:=x-1024 else
                if (spr[1, 1]=0) and (spr[0, 1]=0) and (random(500)>2) then x:=x+1024 else
                jest:=false
             end else begin
                if (spr[1,-1]=0) and (spr[0,-1]=0) and (random(50)>2) then x:=x-1024 else
                if (spr[1, 1]=0) and (spr[0, 1]=0) and (random(50)>2) then x:=x+1024 else
                   begin if y<399 then inc(y); jest:=false end
             end
          end else
              if (rodz=0) then begin
                 if ((spr[0,-1]<>0) or (spr[0,1]<>0)) and (random(500)=0) then jest:=false else begin
                    sn:=integer(random(3))-1;
                    if spr[0,sn]=0 then x:=x+sn*1024
                    end
              end;

         end
            else
            if (plan=2) and ((rodz>=1) or ((rodz=0) and (zmiana[2]=0))) then begin
               inc(y);
               inc(x,pogoda.wiatr shl 5);
               end
            else
            if (plan=0) then begin
               if rodz=0 then inc(y,2)
                         else inc(y,4);
               inc(x,pogoda.wiatr shl 7);
            end;

          if (x<-2048) or (x>maxx1+2048) or (y>maxy) then jest:=false;
          if (pogoda.dziura>=2) and (y>pogoda.pozwody) then jest:=false;
        END;
          _x:=longint(x) shr 10-ekr.x;
          _y:=y-ekr.wy;
          if plan=0 then begin
             case rodz of
               0:for b:=0 to 1 do putpix(_x+random(2),_y+random(2),kol);
               1:begin
                 putpixt(_x,_y,kol);
                 putpixt(_x+pogoda.wiatr div 12,_y+1,kol)
                 end;
               2:begin
                 putpix(_x,_y,kol);
                 putpix(_x+pogoda.wiatr div 12,_y+1,kol)
                 end;
             end;
          end
             else begin
               if rodz in [0,2] then putpix(_x,_y,kol)
                                else putpixt(_x,_y,kol);
             end;
          if (NOT PAUZA) AND (plan=1) and (not jest) and (x>=0) and (x<=maxx1) and (y>=0) and (y<=maxy) and
             ((pogoda.dziura=0) or ((pogoda.dziura=1) and (y<maxy))
             or ((pogoda.dziura>=2) and (y<pogoda.pozwody))) then begin
             inc(_x,ekr.x);
             inc(_y,ekr.y);
             case rodz of
               0:putpix_x(_x,_y,kol); {polz snieg}
               1:begin {zamocz deszczem}
                 b:=getpix_x(_x,_y);
                 if ((b<>0) and ((b<160) or (b>167))) or (y=399) then
                    putpix_x(_x,_y,168+random(8));
                 end;
               2:begin {zamocz krwia}
                 if (y=399) or (getpix_x(_x,_y)<>0) then putpix_x(_x,_y,kol);
                 end;
             end;
          end;
       end;
     end;
    end
     else
       if (NOT PAUZA) AND (
       ((pogoda.snieg) or (pogoda.deszcz) or (pogoda.deszczkrwi)) and
          ((random(650-pogoda.wielkopadow*10)=0) or (pogoda.il_sniegu<=1)) and
          (pogoda.bylo_sniegu<mozebycmaxopadow)
          ) then
         with opad^[a] do begin
          if (zmiana[2]=0) and (kfg.wieloplanowyopady) then plan:=random(3)
                         else plan:=1;
          rodz:=random(3);
          repeat
             b:=0;
             if (rodz=0) and (not pogoda.snieg) then b:=1;
             if (rodz=1) and (not pogoda.deszcz) then b:=1;
             if (rodz=2) and (not pogoda.deszczkrwi) then b:=1;
             if b=1 then begin inc(rodz);if rodz>=3 then rodz:=0;end;
          until b=0;
          if rodz=0 then kol:=sniegkol[random(4)]
             else if rodz=1 then kol:=125+random(3)
                  else kol:=180+random(4);

          b:=random(18-abs(pogoda.wiatr div 2));
          if (pogoda.wiatr=0) or ((pogoda.wiatr<>0) and (b>=1)) then begin {z gory}
             x:=longint(random(1280)) shl 10;
             if rodz=0 then y:=0
                       else y:=-random(3);
          end else {z lewej}
             if (pogoda.wiatr>0) and (b=0) then begin
                y:=random(maxy);
                if rodz=0 then x:=0
                          else x:=-(longint(random(3)) shl 10);
             end else {z prawej}
             if (pogoda.wiatr<0) and (b=0) then begin
                y:=random(maxy);
                if rodz=0 then x:=maxx1
                          else x:=maxx1+(longint(random(3)) shl 10);
             end;
          jest:=true;
          inc(pogoda.il_sniegu);
       end;
end;
end;

{*}PROCEDURE syfki;
const
ob:array[0..3,1..2,0..1] of shortint=
   ((( 1, 0),( 0,-1)),
    (( 0, 1),( 1, 0)),
    ((-1, 0),( 0, 1)),
    (( 0,-1),(-1, 0)));
var
_x,_y:longint;
buf:array[-1..1] of byte;
pokx,poky:longint;
begin
for a:=1 to maxsyf do begin
    if syf^[a].jest then begin
       with syf^[a] do begin
         IF NOT PAUZA THEN BEGIN
          x:=x+longint(dx);
          y:=y+longint(dy);
          pokx:=x;
          poky:=y;
          if (pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y div 1024<pogoda.pozwody)) then
             dx:=dx+pogoda.wiatr div 2;
          if dx>0 then dec(dx);
          if dx<0 then inc(dx);
          if (graw) and (dy<32000) then dy:=dy+50;
          if czas>1 then dec(czas);
          if (kol>=185) and (kol<=199) and (zmiana[szybiskr]=0) then dec(kol);
          if getpix_x((x+longint(dx)) shr 10,(y+longint(dy)) shr 10)<>0 then begin
             if jakkonczy<>1 then begin
                if getpix_x((x+longint(dx)*2) shr 10,y shr 10)<>0 then begin x:=x-longint(dx);dx:=-dx div 2;end;
                y:=y-longint(dy);dy:=-dy div 2;
             end
               else begin jest:=false;x:=x+longint(dx);y:=y+longint(dy);pokx:=x;poky:=y;end;
          end;
          xms2mem(_xms[1].h,offsety[2]+(((y+longint(dy)) shr 10)+1)*maxx+((x+longint(dx)) shr 10-1),buf[-1],3);
          if (abs(dx)<=100) and (abs(dy)<=100) and (czas<>1) and
             (buf[0]<>0) then begin
             if (buf[-1]=0) and (buf[1]=0) then x:=x+((longint(random(2))*2-1)*512)
                else jest:=false
          end;
          if (x<0) or (x>maxx1) or (y>maxy1) or (czas=1) then begin
             jest:=false;
             if (jakkonczy=1) and (y>maxy1) and (pogoda.dziura=0) then poky:=maxy1;
          end;
          if (pogoda.dziura>=2) and (y shr 10>pogoda.pozwody+1) then begin
             if ((kol>=168) and (kol<=175)) or
                ((kol>=200) and (kol<=206)) then begin jest:=false;jakkonczy:=0 end
                else if zmiana[1]=0 then begin
                   if abs(dx)>512 then dx:=dx div 2;
                   if abs(dy)>512 then dy:=dy div 2;
                end;
             if (pogoda.dziura=3) and (random(30)=0) then begin
                jest:=false;
                jakkonczy:=0; {w ogniu sie spala, wiec nie moze zostac w powietrzu}
             end;
          end;
          if (kol=184) then begin jest:=false;jakkonczy:=0 end;
          if (zmiana[1]=0) then begin
             if dx>0 then inc(obr);
             if dx<0 then dec(obr);
             if obr>=4 then obr:=0;
             if obr<0 then obr:=3;
          end;
          if (rozm=3) and (zmiana[1]=0) and
             ((kfg.il_krwi>=1) or ((kfg.il_krwi<1) and (kfg.il_krwi>0) and (random(trunc(5-kfg.il_krwi*5))=0))) then begin
             if (kol>=184) and (kol<=199) then b:=0 else b:=1;
             nowysyf(x shr 10,y shr 10,0,0,
                     kol,b,true,0,0,0);
             if ((pogoda.dziura>=2) and (y shr 10>pogoda.pozwody+1)) or
                (random(40)=0) or (not kfg.smierczglutami) then rozm:=1;
          end;
         END;
         IF PAUZA THEN BEGIN
          pokx:=x;
          poky:=y;
         END;
          _x:=longint(pokx) shr 10-ekr.x;
          _y:=longint(poky) shr 10-ekr.y;
          putpix(_x,_y,kol);
          if (rozm>=1) and (rozm<3) then putpix(_x+longint(ob[obr,1,0]),_y+longint(ob[obr,1,1]),kol);
          if rozm=2 then putpix(_x+longint(ob[obr,2,0]),_y+longint(ob[obr,2,1]),kol);
          if (not jest) and (jakkonczy<>0) and
             (x>=0) and (x<=maxx1) and (y>=0) and
             (((y<=maxy1) and (pogoda.dziura>=1)) or (pogoda.dziura=0)) then begin
             inc(_x,ekr.x);
             inc(_y,ekr.y);
             putpix_x(_x,_y,kol);
             if rozm>=1 then putpix_x(_x+longint(ob[obr,1,0]),_y+longint(ob[obr,1,1]),kol);
             if rozm=2 then putpix_x(_x+longint(ob[obr,2,0]),_y+longint(ob[obr,2,1]),kol);
          end;
       end;
    end;
end;

end;

{*}PROCEDURE dymy;
var
a,b:integer;
begin
for a:=1 to maxdym do begin
    if dym^[a].jest then begin
      IF NOT PAUZA THEN BEGIN
       dym^[a].x:=dym^[a].x+pogoda.wiatr shl 5;
       if zmiana[1]=0 then dec(dym^[a].y);
      END;
       MaskPicTxms((dym^[a].x shr 10)-9-ekr.x,dym^[a].y-9-ekr.wy,20,20,0,
                   offsety[6]+(longint(dym^[a].wygl)*5+(5-longint(dym^[a].ani)))*400,scr^);
      IF NOT PAUZA THEN BEGIN
       if dym^[a].doani<=0 then begin dec(dym^[a].ani);dym^[a].doani:=4+random(3);end;
       if dym^[a].ani<=0 then dym^[a].jest:=false;
       dec(dym^[a].doani);
       if (dym^[a].x<-5000) or (dym^[a].x>maxx1+5000) or
          (dym^[a].y<-5) or (dym^[a].y>maxy+5) then dym^[a].jest:=false;
       if (pogoda.dziura>=2) and (dym^[a].y>pogoda.pozwody) then begin
          dym^[a].jest:=false;
          nowybom(dym^[a].x shr 10, dym^[a].y);
       end;
      END;
    end;
end;
end;

{*}PROCEDURE wybuchy;
var
a,b:integer;
begin
for a:=1 to maxwyb do begin
    if wyb^[a].jest then begin
       MaskPicTxms(wyb^[a].x-30-ekr.x,wyb^[a].y-30-ekr.wy,60,60,0,
                   offsety[5]+(longint(wyb^[a].wygl)*5+(5-longint(wyb^[a].ani)))*3600,scr^);
      IF NOT PAUZA THEN BEGIN
       if zmiana[2]=0 then dec(wyb^[a].ani);
       if wyb^[a].ani<=0 then wyb^[a].jest:=false;
      END;
    end;
end;
end;

{*}PROCEDURE miny;
var
b,c:integer;
s,_w:byte;
ss:single;
buf:array[0..65] of byte;
pokx,poky:longint;
begin
il_min:=0;
for a:=1 to maxmin do begin
    if min^[a].jest then begin
       inc(il_min);
       with min^[a] do begin
         IF NOT PAUZA THEN BEGIN
          x:=x+longint(dx);
          y:=y+longint(dy);
          pokx:=x;
          poky:=y;
          if dx>0 then dec(dx);
          if dx<0 then inc(dx);

          ss:=longint(dx)/2048;
          if ss<-2 then ss:=-2;
          if ss>2 then ss:=2;
          ostkier:=ostkier+ss;
          if ostkier>=8 then ostkier:=ostkier-8;
          if ostkier<0 then ostkier:=ostkier+8;
          s:=getpix_x((x+longint(dx)) shr 10,(y+longint(dy)) shr 10);
          if (getpix_x((x+longint(dx)) shr 10,((y+longint(dy)) shr 10)+1)=0) then begin
             if (pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y div 1024<pogoda.pozwody)) then
                dx:=dx+pogoda.wiatr div 5;
             dy:=dy+70;
             end
             else if abs(dx)<200 then ostkier:=0;
          if (czas=0) or (czas>10) then begin {albo nieaktywna, albo jeszcze ma duzo czasu, to sprawdzaj}
           for b:=maxpost downto 1 do {sprawdz kolizje z postaciami}
             if (post^[b].jest) and
                (x shr 10>=post^[b].x-5) and
                (x shr 10<=post^[b].x+5) and
                (y shr 10>=post^[b].y) and
                (y shr 10<=post^[b].y+9) then begin
                czas:=6+random(10);
             end;
           for b:=maxmies downto 1 do {sprawdz kolizje z miesem}
             if (mies^[b].jest) and
                (x shr 10>=mies^[b].x shr 10-3) and
                (x shr 10<=mies^[b].x shr 10+3) and
                (y shr 10>=mies^[b].y shr 10-3) and
                (y shr 10<=mies^[b].y shr 10+3) then begin
                czas:=6+random(10);
             end;
          end;

          if (czas>1) and (zmiana[1]=0) then dec(czas); {odliczanie do wybuchu}
          if (czas=1) then begin {wybuch miny}
             jest:=false;
             wybuch(x shr 10,y shr 10,18+random(6),true,true,false,false,true)
          end;
          if s<>0 then begin {odbicie sie miny}
             if getpix_x((x+longint(dx)*2) shr 10,y shr 10)<>0 then begin x:=x-longint(dx);dx:=-dx div 2 end;
             y:=y-longint(dy);dy:=-dy div 2;
             if (stal=0) and ((abs(dx)>212) or (abs(dy)>212)) then begin
                StartSound(Sound[45], false,9,10);
                stal:=20;
             end;
          end else if stal>0 then dec(stal);

          if (x<0) or (x>maxx1) or (y>maxy1+5000) then jest:=false;

          if ((y shr 10>pogoda.pozwody) and (pogoda.dziura>=2)) then begin
             if (y shr 10>pogoda.pozwody) and (y shr 10<pogoda.pozwody+4) and
                ((abs(dy)>100) or (abs(dx)>100)) then
                plum(x shr 10,5,15,longint(dx)/3000,sqrt(sqr(longint(dx))+sqr(longint(dy)))/5000+0.1);
             if zmiana[1]=0 then begin
                if abs(dx)>512 then dx:=dx div 2;
                if abs(dy)>1024 then dy:=dy div 2;
             end;
             if (pogoda.dziura=3) and ((czas=0) or (czas>10)) then czas:=random(9)+2;
          end;

          if (czas>0) and (zmiana[1]=0) and (czas mod 10=9) then
             startsound(sound[42],false,9,10);

         END;
          if czas mod 10<=5 then b:=0 else b:=8;
         IF PAUZA THEN BEGIN
          pokx:=x;
          poky:=y;
         END;
          maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                     offsety[26]+1176+49*(trunc(ostkier)+b),scr^,1,true);
       end;
    end;
end;
end;

{*}PROCEDURE pociski;
const
szyb_spad:array[0..9] of shortint=(25,15,45,60,0,5,70,30,45,60); {wagi pociskow}
bombobr:array[0..7,0..1] of shortint= {obrot bomby}
         ((3,0),(2,2),(0,3),(-2,2),(-3,0),(-2,-2),(0,-3),(2,-2));
dynobr:array[0..7,0..1] of shortint= {obrot dynamitu}
        ((3,0),(3,3),(-1,3),(-3,3),(-3,-1),(-3,-3),(0,-3),(3,-3));
wskaz_kol:array[1..9] of byte=(2,17,0,255{brak},255{brak},44,10,2,255{brak}); {kolory wskaznikow}
var
a1,b,c,ko,dko:integer;
s:byte;
jest_bomba:boolean;
ss:single;
pokx,poky:longint;
buf:array[0..65] of byte;
begin
{rodzaje: [rodz]
 0-pocisk z bazuki, spada, za ekranem znika, wybucha przy zetknieciu z czyms
 1-granat, spada, za ekranem znika, odbija sie od scian, wybucha po czasie
 2-bomba, spada, za ekranem znika, odbija sie od scian, wybucha po czasie na kawalki
 3-ogien, leci do gory, za ekranem znika, nie wybucha, ale opala
 4-pocisk samonaprow., spada, za ekranem znika, wybucha przy zetknieciu z czyms, leci do celu
 5-pocisk z nalotu, spada, nie znika za ekranem, wybucha przy zetknieciu z czyms lub po czasie
 6-ognista kula, spada, za ekranem znika, wybucha przy zetknieciu z czyms i zapala
 7-ogien z kuli ognistej, za ekranem znika, nie wybucha, ale opala
 8-pocisk napalm, spada, za ekranem znika, wybucha przy zetknieciu z czyms
 9-ogien z napalmu, spada, za ekranem znika, nie wybucha, ale opala, wyzera ziemie
}
jest_bomba:=false;
for a:=1 to maxpoc do begin
    if poc^[a].jest then begin
      if poc^[a].wygl=4 then dko:=4 else dko:=1;
      for ko:=1 to dko do begin
       with poc^[a] do begin
         IF NOT PAUZA THEN BEGIN
          x:=x+longint(dx);
          y:=y+longint(dy);
          pokx:=x; {pozycja, gdzie ma sie pokazac obrazek, nawet jesli sie przesunie}
          poky:=y; {...przy odbiciu}
          if dx>0 then dec(dx);
          if dx<0 then inc(dx);
          if rodz=4 then begin {pocisk samonaprowadzajacy}
             if (x div 1024>celow.celx) and (dx>-3074) then dec(dx,80);
             if (x div 1024<celow.celx) and (dx<3074) then inc(dx,80);
             if (y div 1024>celow.cely) and (dy>-3074) then dec(dy,80);
             if (y div 1024<celow.cely) and (dy<3074) then inc(dy,80);
          end;
          if (getpix_x((x+longint(dx)) shr 10,((y+longint(dy)) shr 10)+1)=0) or
             (rodz in [0,4,5,6,8]) then begin
             if not (wygl in [4,5]) then dy:=dy+szyb_spad[wygl]
                else if rodz=3 then dec(dy,5);
          end;
          s:=getpix_x((x+longint(dx)) shr 10,(y+longint(dy)) shr 10);
          if ((pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y div 1024<pogoda.pozwody))) and
             ((wygl<>4) and (rodz<>7)) and (getpix_x((x+longint(dx)) shr 10,((y+longint(dy)) shr 10)+1)=0) and
             (trzyma_go=0) then
             dx:=dx+(pogoda.wiatr*25) div szyb_spad[wygl];
          for b:=maxpost downto 1 do {sprawdz kolizje z postaciami}
             if (post^[b].jest) and
                (x shr 10>=post^[b].x-5) and
                (x shr 10<=post^[b].x+5) and
                (y shr 10>=post^[b].y-5) and
                (y shr 10<=post^[b].y+5) then begin
                  if rodz in [1,2] then begin
                   if post^[b].corobi<>0 then begin
                      x:=x-2*longint(dx);
                      y:=y-2*longint(dy);
                      dx:=-dx div 4;
                      dy:=-dy div 4;
                   end else begin {kiedy stoi, to lapie granat}
                      if (rodz in [1,2]) and (trzyma_go=0) then begin
                        if (random(6)=0) then begin
                           post^[b].comarobic:=5;
                           post^[b].corobi:=5;
                           trzyma_go:=b;
                           post^[b].cotrzyma:=1;
                           post^[b].ani:=0;
                           dx:=0;
                           dy:=0;
                        end else begin
                            x:=x-2*longint(dx);
                            y:=y-2*longint(dy);
                            dx:=-dx div 4;
                            dy:=-dy div 4;
                            end;
                      end;
                   end;
                  end else begin
                      s:=1;
                      if wygl<>4 then begin
                         x:=x-2*longint(dx);
                         y:=y-2*longint(dy);
                      end
                        else begin
                         x:=x-longint(dx);
                         y:=y-longint(dy);
                      end;
                  end;
             end;
          if (trzyma_go>0) then begin
             x:=trunc(post^[trzyma_go].x) shl 10;
             y:=trunc(post^[trzyma_go].y+1) shl 10;
             if (random(10)=0) then ostkier:=random(8);
          end;
          if (trzyma_go>0) and (post^[trzyma_go].cotrzyma=0) then begin
             dx:=longint(random(2038))-1024;
             dy:=-random(1500)-1000;
             y:=y-(10 shl 10);
             trzyma_go:=0;
          end;
             {jesli post. trzymajaca go robi cos innego, to upusc granat}
          if (trzyma_go>0) and ((post^[trzyma_go].corobi<>5) or (not post^[trzyma_go].jest)) then begin
             post^[trzyma_go].comarobic:=0;
             trzyma_go:=0;
          end;

          if (kfg.zwierz) and (wygl in [0,1,4..6,8,9]) then {sprawdz kolizje ze zwierzakami}
            for b:=maxzwi downto 1 do
              if (zwi^[b].jest) and
                (x>=zwi^[b].x-2500) and
                (x<=zwi^[b].x+2500) and
                (y>=zwi^[b].y-2500) and
                (y<=zwi^[b].y+2500) then begin
                 s:=1;
                 if wygl<>4 then begin
                    x:=x-2*longint(dx);
                    y:=y-2*longint(dy);
                 end
                    else begin
                    x:=x-longint(dx);
                    y:=y-longint(dy);
                 end;
              end;
          if (kfg.paczki) and (wygl in [0,1,4..6,8,9]) then {sprawdz kolizje z paczkami}
            for b:=maxpacz downto 1 do
              if (pacz^[b].jest) and
                (x>=pacz^[b].x-5000) and
                (x<=pacz^[b].x+5000) and
                (y>=pacz^[b].y-5000) and
                (y<=pacz^[b].y+5000) then begin
                 s:=1;
                 pacz^[b].rozwalasie:=true;
                 if wygl<>4 then begin
                    x:=x-2*longint(dx);
                    y:=y-2*longint(dy);
                 end
                    else begin
                    x:=x-longint(dx);
                    y:=y-longint(dy);
                 end;
              end;

          if ((y>longint(pogoda.pozwody) shl 10) and (pogoda.dziura>=2)) then begin {pod woda}
             if (y>longint(pogoda.pozwody) shl 10) and (y<longint(pogoda.pozwody) shl 10+4096) then
               case wygl of
                0:plum(x shr 10,2,15,longint(dx)/3000,sqrt(sqr(longint(dx))+sqr(longint(dy)))/6000+0.01);
                1..3,7,8:plum(x shr 10,5,10,longint(dx)/3000,sqrt(sqr(longint(dx))+sqr(longint(dy)))/5000+0.1);
                4:plum(x shr 10,1,6,longint(dx)/8000,0.9);
                6:plum(x shr 10,7,20,longint(dx)/5000,sqrt(sqr(longint(dx))+sqr(longint(dy)))/5000+0.1);
               end;
             if wygl in [5,9] then jest:=false; {ogien znika}
             if rodz=4 then rodz:=0; {samonaprow. zamienia sie w zwykly}
             if zmiana[1]=0 then begin
                if abs(dx)>300 then dx:=dx div 2;
                if abs(dy)>300 then dy:=dy div 2;
                if wygl in [3,6,7] then nowybom(x shr 10,y shr 10);
                if (wygl=4) and (abs(dx)<=300) and (abs(dy)<=300) then begin
                   jest:=false;
                   nowysyf(x shr 10,y shr 10,
                           random-0.5,random-0.5,
                           4+random(3),2,true,0,0,0);
                end;
             end;
             if (pogoda.dziura=3) and (random(10)=0) then begin
                s:=1;
                if czas>1 then czas:=1;
             end;
          end;

          if (czas>1) and (zmiana[1]=0) then dec(czas); {odliczanie do wybuchu}
          if (rodz=4) and (czas=1) then begin rodz:=0;czas:=0;end; {po czasie poc.samonaprow. staje sie zwykly}
          if ((s<>0) and (wygl in [0,1,4,5,6,8,9])) or (czas=1) then begin {wybuch pocisku}
             if (wygl<>9) or ((wygl=9) and (random(20)=0)) then jest:=false;
             x:=x+longint(dx);y:=y+longint(dy);
             if not (wygl in [4..6,8,9]) then wybuch(x shr 10,y shr 10,sila,true,true,false,false,true)
                else if wygl=4 then wybuch(x shr 10,y shr 10,sila,true,false,false,false,true)
                  else if wygl in [5,9] then begin
                       osmalenie(x shr 10,y shr 10,4);
                       wybuch(x shr 10,y shr 10,12,false,false,false,true,false);
                        if wygl=9 then begin
                          b:=getpix_x(x shr 10,y shr 10);
                          if (random(50)=0) and (b<>0) then
                             startsound(sound[28+random(2)],false,7,8);
                          if not (b in [0,160..167]) then begin
                             putpix_x(x shr 10,y shr 10,0);
                             x:=x-longint(dx)*(2+random(2))-(integer(random(5))-2)*512;
                             y:=y-longint(dy)*(2+random(2))-(integer(random(4))-2)*512
                          end
                             else if b<>0 then begin y:=y-dy*2;x:=x-dx*2 end;
                          if y>=maxy1 then dec(y,1024);
                          dx:=trunc(dx/1.2);
                          dy:=dy div 2;
                        end;
                       end
                  else if wygl=6 then begin
                       wybuch(x shr 10,y shr 10,sila,true,true,false,true,true);
                       for a1:=0 to 20 do
                           nowysyf(x shr 10,y shr 10,random*4-2,random*4-2,
                                   199,0,true,60,2,random(2)*3);

                       end;

             if wygl=2 then {resztki granatu}
                for b:=0 to 19 do
                nowysyf(x shr 10,y shr 10,
                        _sin(trunc(b*18))*(1+random/2),
                        _cos(trunc(b*18))*(1+random/2),
                        random(5)+17,random(2)*2,true,0,0,0);

             if wygl=3 then begin{resztki bomby}
                for b:=0 to 19 do
                nowysyf(x shr 10,y shr 10,
                        _sin(trunc(b*18))*(1+random/2),
                        _cos(trunc(b*18))*(1+random/2),
                        random(4)+1,random(2)*2,true,0,0,0);
                for b:=0 to 5 do
                strzal(x shr 10,y shr 10,
                       random*3-1.5,
                       random*3-1.5,
                       0,10,0,0);
             end;
             if wygl=6 then begin {rozpadniecie sie kuli ognistej}
                for b:=0 to 39 do
                strzal(x shr 10,y shr 10,
                       _sin(trunc(b*36+(b div 10)*22))*(0.2+random/3+(b div 10)/4),
                       _cos(trunc(b*36+(b div 10)*22))*(0.2+random/3+(b div 10)/4),
                       7,1,5,10+random(10));
             end;
             if wygl=8 then begin{napalm}
                wybuch(x shr 10,y shr 10,sila,true,true,false,true,true);
                wybuch(x shr 10,y shr 10,sila+5,false,true,false,true,true);
                for b:=0 to 10+sila*3+random(10) do
                strzal(x shr 10,y shr 10,
                       random*3-1.5,
                       random*2-0.5,
                       9,10,9,100-random(30));
             end;
          end;
          if ((s<>0) and (wygl in [2,3,7])) then begin {odbicie sie pocisku}
             if getpix_x((x+longint(dx)*2) shr 10,y shr 10)<>0 then begin
                if wygl<>7 then begin x:=x-longint(dx);dx:=-dx div 2 end
                           else begin x:=x-longint(dx);dx:=-dx div 4 end;
             end;
             if wygl<>7 then begin y:=y-longint(dy);dy:=-dy div 2 end
                        else begin y:=y-longint(dy);dy:=-dy div 4 end;
             if (stal=0) and ((abs(dx)>212) or (abs(dy)>212)) then begin
                case wygl of
                  2:StartSound(Sound[5], false,9,10);
                  3:StartSound(Sound[45], false,9,10);
                  {7:dynamit}
                end;
                stal:=20;
                end;
          end else if stal>0 then dec(stal);

          if (not (rodz in [5,10])) and ((x<0) or (x>maxx1) or (y>maxy1+7000) or
             ((y<-100000) and (wygl=4))) then jest:=false
             else
          if (rodz in [5,10]) and (y>maxy1+50000) then jest:=false;

         END;
         IF PAUZA THEN BEGIN
          pokx:=x;
          poky:=y;
         END;
          case wygl of
           0:begin {odlamek}
             putpix(longint(pokx) shr 10-ekr.x,longint(poky) shr 10-ekr.y,100+random(5));
             if (NOT PAUZA) AND (zmiana[3]=0) then
                nowysyf(pokx shr 10,poky shr 10,
                        random/2-0.25,random/2-0.6,198,0,true,20,2,0);
             end;
           1,8:begin {pocisk z bazuki}
             if dx>=600 then begin {prawo}
                if dy>=600 then begin {prawo-dol}
                  maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                             offsety[26]+49,scr^,1,true);ostkier:=1;end;
                if dy<=-600 then begin {prawo-gora}
                  maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                             offsety[26]+343,scr^,1,true);ostkier:=7;end;
                if (abs(dy)<600) then begin {prawo}
                  maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                             offsety[26],scr^,1,true);ostkier:=0;end;
             end else
             if dx<=-600 then begin {lewo}
                if dy>=600 then begin {lewo-dol}
                  maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                             offsety[26]+147,scr^,1,true);ostkier:=3;end;
                if dy<=-600 then begin {lewo-gora}
                  maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                             offsety[26]+245,scr^,1,true);ostkier:=5;end;
                if (abs(dy)<600) then begin {lewo}
                  maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                             offsety[26]+196,scr^,1,true);ostkier:=4;end;
             end else
             if (abs(dx)<600) then begin {srodek poziomo}
                if dy>=600 then begin {dol}
                  maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                             offsety[26]+98,scr^,1,true);ostkier:=2;end;
                if dy<=-600 then begin {gora}
                  maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                             offsety[26]+294,scr^,1,true);ostkier:=6;end;
                if (abs(dy)<600) then {srodek pionowo, nie zmieniaj ostatniego polozenia}
                  maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                             offsety[26]+49*(trunc(ostkier)),scr^,1,true);
             end;
             if (NOT PAUZA) AND (zmiana[3]=0) then
                nowydym((pokx-2*longint(dx)) shr 10,(poky-2*longint(dy)) shr 10,5,random(2));
             end;
           2:begin {granat}
             IF (NOT PAUZA) THEN BEGIN
             ss:=longint(dx)/2048;
             if ss<-2 then ss:=-2;
             if ss>2 then ss:=2;
             ostkier:=ostkier+ss;
             if ostkier>=8 then ostkier:=ostkier-8;
             if ostkier<0 then ostkier:=ostkier+8;
             END;
             maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                        offsety[26]+392+49*trunc(ostkier),scr^,1,true);
             end;
           3:begin {bomba}
             IF (NOT PAUZA) THEN BEGIN
             ss:=longint(dx)/2748;
             if ss<-1.5 then ss:=-1.5;
             if ss>1.5 then ss:=1.5;
             ostkier:=ostkier+ss;
             if ostkier>=8 then ostkier:=ostkier-8;
             if ostkier<0 then ostkier:=ostkier+8;
             if (zmiana[2]=0) then
                nowysyf((pokx) shr 10+bombobr[trunc(ostkier),0],(poky) shr 10+bombobr[trunc(ostkier),1],
                        random-0.5,random-0.5,199,0,true,15,2,0);
             END;
             maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                       offsety[26]+784+49*trunc(ostkier),scr^,1,true);
             end;
           {4: niewidoczny - do strzelb itp}
           5,9:begin {ogien z miotacza}
             XMS2Mem(_xms[1].h,offsety[10]+2000+longint(random(10))*49,buf,49);
             MaskPic(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,buf,scr^);
             if (wygl=9) and (NOT PAUZA) AND (zmiana[3]=0) and (random(20)=0) then
                nowydym(pokx shr 10,poky shr 10,5,random(2));
             end;
           6:begin {ognista kula}
             XMS2Mem(_xms[1].h,offsety[10]+2000+longint(random(10))*49,buf,49);
             MaskPic(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,buf,scr^);
             IF (NOT PAUZA) THEN BEGIN
             if (zmiana[4]=0) then nowydym((pokx-2*longint(dx)) shr 10,(poky-2*longint(dy)) shr 10,5,0);
             if (zmiana[3]=2) then strzal(pokx shr 10,poky shr 10, 0,0, 3,1,5,7);
             END;
             end;
           7:begin {dynamit}
             IF (NOT PAUZA) THEN BEGIN
             ss:=longint(dx)/2048;
             if ss<-2 then ss:=-2;
             if ss>2 then ss:=2;
             ostkier:=ostkier+ss;

             if (s<>0) and (abs(ss)<0.2) and (abs(dy)<400) then begin {jesli glupio stoi, to go przewracaj}
                if trunc(ostkier) in [1,5] then ostkier:=ostkier-0.2;
                if trunc(ostkier) in [3,7] then ostkier:=ostkier+0.2;
             end;

             if ostkier>=8 then ostkier:=ostkier-8;
             if ostkier<0 then ostkier:=ostkier+8;
             if (zmiana[2]=0) then
                nowysyf((pokx) shr 10+dynobr[trunc(ostkier),0],(poky) shr 10+dynobr[trunc(ostkier),1],
                        random-0.5,random-0.5,199,0,true,15,2,0);
             END;
             maskpicxms(longint(pokx) shr 10-ekr.x-3,longint(poky) shr 10-ekr.y-3,7,7,0,
                        offsety[26]+1960+49*trunc(ostkier),scr^,1,true);
             end;
          end;
          if (not (wygl in [0,4,5,9])) and (kfg.wskazniki_poc) and {rysowanie wskaznikow pociskow}
             ((x shr 10>319+ekr.x) or (x shr 10<ekr.x) or
              (y shr 10>199-ekr.menuwys+ekr.y) or (y shr 10<ekr.y)) then begin
              b:=longint(x) shr 10-ekr.x;
              c:=longint(y) shr 10-ekr.y;
              if b<0 then b:=0;
              if b>319 then b:=319;
              if c<0 then c:=0;
              if c>199-ekr.menuwys then c:=199-ekr.menuwys;
              maskpic3xms(b-2,c-2,5,5,0,wskaz_kol[wygl],offsety[27]+165,scr^,true);
          end;
          if (not jest) and (trzyma_go>0) and (post^[trzyma_go].jest) then post^[trzyma_go].comarobic:=0;
          if (wygl in [3,7]) and (x shr 10>=ekr.x-15) and (y shr 10>=ekr.y-15) and
             (x shr 10<=ekr.x+335) and (y shr 10<=ekr.y+215-ekr.menuwys) then jest_bomba:=true;
       end;
       if not poc^[a].jest then ko:=dko;
      end;
    end;
end;
if (jest_bomba) and (ciagle_dzwieki[0]=0) then begin
   if StartSound(Sound[6], true,12,12) then ciagle_dzwieki[0]:=1;
end;
if (ciagle_dzwieki[0]=1) and (not jest_bomba) then begin
   ciagle_dzwieki[0]:=0;stopSound(12);
end;
end;

{*}PROCEDURE kowadla;
var
_x,_y:longint;
a2,b,c,ko:integer;
buf:array[-10..14] of byte;
dzwk:boolean;
begin
for a:=1 to maxkow do begin
 if kow^[a].jest then begin
   if (NOT PAUZA) AND (kow^[a].dy<5000) then kow^[a].dy:=kow^[a].dy+120;
   for ko:=kow^[a].dy div 1024 downto 0 do
    if kow^[a].jest then begin
       with kow^[a] do begin
         IF NOT PAUZA THEN BEGIN
          if ko=0 then y:=y+longint(dy) mod 1024
                  else y:=y+1024;

          if stoi<=1 then begin {sprawdz kolizje z postaciami}
             for b:=maxpost downto 1 do
                if (post^[b].jest) and
                   (post^[b].x>=x shr 10-14) and
                   (post^[b].x<=x shr 10+15) and
                   (post^[b].y>=y shr 10-5) and
                   (post^[b].y<=y shr 10+13) and
                   (post^[b].sila>0) then begin
                      inc(punkty,post^[b].sila div 2);
                      post^[b].sila:=-3;
                   end;
             for b:=maxmin downto 1 do {...i minami}
                if (min^[b].jest) and
                   (min^[b].x shr 10>=x shr 10-12) and
                   (min^[b].x shr 10<=x shr 10+12) and
                   (min^[b].y shr 10>=y shr 10-5) and
                   (min^[b].y shr 10<=y shr 10+10) and
                   (min^[b].czas>=0) then
                     min^[b].czas:=1+random(6);

             if (stoi=1) and (kfg.miecho) then
               for b:=maxmies downto 1 do {...i mieskiem}
                if (mies^[b].jest) and
                   (mies^[b].x shr 10>=x shr 10-14) and
                   (mies^[b].x shr 10<=x shr 10+15) and
                   (mies^[b].y shr 10>=y shr 10-5) and
                   (mies^[b].y shr 10<=y shr 10+10) then begin
                     mies^[b].jest:=false;
                     if (mies^[b].rodz<100) then
                        for c:=0 to trunc(29*kfg.il_krwi) do
                        nowysyf(mies^[b].x shr 10,mies^[b].y shr 10,
                                _sin(trunc(c*12/kfg.il_krwi))*(random*1.6),
                                _cos(trunc(c*12/kfg.il_krwi))*(random*1.6),
                                grupy[mies^[b].rodz div 4].kolorkrwi.od+random(grupy[mies^[b].rodz div 4].kolorkrwi.ile),
                                1,true,0,0,0);
                end;
             if (kfg.zwierz) then
               for b:=maxzwi downto 1 do {...i zwierzatkami}
                if (zwi^[b].jest) and
                   (zwi^[b].x shr 10>=x shr 10-14) and
                   (zwi^[b].x shr 10<=x shr 10+15) and
                   (zwi^[b].y shr 10>=y shr 10-5) and
                   (zwi^[b].y shr 10<=y shr 10+10) and
                   (zwi^[b].sila>0) then begin
                   zwi^[b].sila:=0;
                   inc(punkty,10);
                end;
             if (kfg.paczki) then
               for b:=maxpacz downto 1 do {...i paczkami}
                if (pacz^[b].jest) and
                   (pacz^[b].x shr 10>=x shr 10-15) and
                   (pacz^[b].x shr 10<=x shr 10+15) and
                   (pacz^[b].y shr 10>=y shr 10-5) and
                   (pacz^[b].y shr 10<=y shr 10+10) then pacz^[b].rozwalasie:=true;
          end;

          {sprawdz co jest pod nim}
          if y+5120<=maxy1a then begin
             xms2mem(_xms[1].h,offsety[2]+(y shr 10+5)*maxx+x shr 10-10,buf,22);
             if x-10240<0 then fillchar(buf,abs((x-10240) div 1024),0);
             if x+10240>maxx1 then fillchar(buf[maxx-1-x shr 10],10-(maxx-1-x shr 10),0);
          end
             else begin
                if pogoda.dziura=0 then fillchar2(buf,22,1)
                                   else fillchar2(buf,22,0);
             end;
          c:=0;
          for b:=-10 to 10 do if buf[b]>0 then inc(c);

          if pogoda.dziura>=2 then begin
             if (y shr 10>pogoda.pozwody-5) and (y shr 10<pogoda.pozwody+5) then begin
                plum(x shr 10,25,10,0,1.5);
                if (pogoda.dziura in [3,4]) and (zmiana[2]=0) then
                   nowydym(x shr 10-10+random(20),pogoda.pozwody-1,4+random(4),random(3));
             end;
             if (y shr 10>=pogoda.pozwody+5) and (y shr 10<=pogoda.pozwody+7) then
                plum(x shr 10,25,50,0,2);
             if (y shr 10>pogoda.pozwody-5) then begin
                if (y shr 10>395) then c:=0;
                if (zmiana[1]=0) and (abs(dy)>1024) then dy:=dy div 2;
                if zmiana[2]=0 then nowybom(x shr 10-10+random(20),y shr 10+5);
             end;
          end;

          if y>maxy1+10000 then jest:=false;

          dzwk:=false;
          if c>=7 then begin
             if ko=0 then y:=y-longint(dy) mod 1024
                     else y:=y-1024;
             dy:=dy div 2;
             inc(stoi);
             dzwk:=true;
          end else begin
              for b:=-10 to 10 do
                 if buf[b]>0 then begin
                    putpix_x(x shr 10+b,y shr 10+5,0);
                    nowysyf(x shr 10+b,y shr 10+5,random*2-1,random*2-1,buf[b],2,true,0,0,0);
                 end;
              stoi:=0;
              end;

          for a2:=1 to maxkow do
              if (a<>a2) and (kow^[a2].jest) and
                 (x>=kow^[a2].x-11 shl 10) and
                 (x<=kow^[a2].x+11 shl 10) and
                 (y>=kow^[a2].y-10 shl 10) and
                 (y<=kow^[a2].y) then begin
                 if (stal=0) and (abs(dy)>212) and
                    ((pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y<longint(pogoda.pozwody) shl 10))) then begin
                    StartSound(Sound[20], false,9,10);
                    stal:=20;
                 end;
                 if ko=0 then y:=y-longint(dy) mod 1024
                         else y:=y-1024;
                 dy:=dy div 2;
                 dzwk:=true;
              end;

          if (not dzwk) and (stal>0) then dec(stal);
          if (dzwk) and (stal=0) and (abs(dy)>212) and
             ((pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y<longint(pogoda.pozwody) shl 10))) then begin
             StartSound(Sound[20], false,9,10);
             stal:=20;
          end;

          if (stoi>=2) then jest:=false;

         END;
          _x:=longint(x) shr 10-ekr.x;
          _y:=longint(y) shr 10-ekr.y;
          if (ko=0) or (not jest) then MaskPicXMS(_x-13,_y-4,25,10,0,offsety[8]+1000,scr^,1,false);
          if (not jest) and (x>=0) and (x<=maxx1) and (y>=0) and
             ((pogoda.dziura=0) or ((pogoda.dziura>=1) and (y<maxy1))) then begin
             inc(_x,ekr.x);
             inc(_y,ekr.y);
             MaskPicXMSwXMS(_x-13,_y-4,25,10,0,offsety[8]+1000,1);
             ko:=0;
          end;
       end;
    end;
 end;
end;

end;

{*}PROCEDURE miesko;
const
graw:array[100..103] of byte=(30,23,55,40);
odbicie:array[100..103] of single=(1.5,1.8,5,3);
    {miesko jest od 0..3 *5grup,
     od 100..103 sa inne obiekty:
       100:pilka
       101:pilka plazowa
       102:cegla
       103:jablko
     }
var
_x,_y,
pokx,poky:longint;
b,c:integer;
juz,niezostaw:boolean;
s1,s2:single;
begin
for a:=1 to maxmies do begin
    if mies^[a].jest then begin
       with mies^[a] do begin
         IF NOT PAUZA THEN BEGIN
          niezostaw:=false;
          x:=x+longint(dx);
          y:=y+longint(dy);
          pokx:=x; {pozycja, gdzie ma sie pokazac obrazek, nawet jesli sie przesunie}
          poky:=y; {...przy odbiciu}
          if dx>0 then dec(dx);
          if dx<0 then inc(dx);
          if rodz<100 then begin
             dy:=dy+45;
             if (getpix_x((x+longint(dx)) shr 10,((y+longint(dy)) shr 10)+1)=0) and (trzyma_go=0) and
                ((pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y div 1024<pogoda.pozwody))) then
                 dx:=dx+(pogoda.wiatr*25) div 45;
          end
             else begin
             dy:=dy+graw[rodz];
             if (getpix_x((x+longint(dx)) shr 10,((y+longint(dy)) shr 10)+1)=0) and (trzyma_go=0) and
                ((pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y div 1024<pogoda.pozwody))) then
                dx:=dx+(pogoda.wiatr*25) div graw[rodz];
          end;
          for b:=maxpost downto 1 do {sprawdz kolizje z postaciami}
             if (post^[b].jest) and
                (x shr 10>=post^[b].x-5) and
                (x shr 10<=post^[b].x+5) and
                (y shr 10>=post^[b].y-5) and
                (y shr 10<=post^[b].y+5) then begin
                   juz:=false;
                   if (post^[b].corobi=0) and {kiedy stoi, to lapie miecho}
                      (trzyma_go=0) and (random(6)=0) then begin
                           post^[b].comarobic:=5;
                           post^[b].corobi:=5;
                           trzyma_go:=b;
                           post^[b].cotrzyma:=2;
                           post^[b].ani:=0;
                           juz:=true;
                      end else {jak idzie, biegnie, to kopie}
                         if (rodz in [0..15,100,101,103]) and (post^[b].corobi in [1,2]) and
                            (y shr 10>=post^[b].y) and (random(7)=0) then begin
                            if random(2)=0 then begin
                               dx:=post^[b].kier*(500+random(1500));
                               dy:=-(500+random(1500));
                               StartSound(Sound[3], false,9,10);
                            end else begin
                                post^[b].corobi:=12;
                                post^[b].ani:=0;
                                post^[b].ktore_mieso_walnie:=a;
                            end;
                            juz:=true;
                         end;
                   if (not juz) and (rodz=102) and (
                      (post^[b].corobi<>5) or (trzyma_go<>b)) and
                      ((abs(dx)>600) or (abs(dy)>600)) then begin
                      wybuch(x shr 10,y shr 10,5,false,false,true,false,true);
                      if ((abs(dx)>2000) or (abs(dy)>2000)) then begin
                         y:=trunc(post^[b].y-3) shl 10;
                         for c:=0 to 10 do {rozbicie sie cegly}
                             nowysyf(pokx shr 10,poky shr 10,
                                  random-0.5,-random+0.3,43+random(5),2,true,0,0,random(3));
                         jest:=false;
                         x:=-15000; {pozbadz sie cegly z ekranu}
                         pokx:=-15000;
                         trzyma_go:=0;
                         StartSound(Sound[4], false,9,10);
                      end;
                      x:=x-2*longint(dx);
                      y:=y-2*longint(dx);
                      dx:=-dx div 4;
                      dy:=-dy div 4;
                      post^[b].dx:=post^[b].dx-integer(longint(dx) shr 10);
                      post^[b].dy:=post^[b].dy-integer(longint(dy) shr 10);
                      post^[b].corobi:=4;
                      if post^[b].comarobic=5 then post^[b].comarobic:=0;
                   end;
             end;
          if (trzyma_go>0) and (post^[trzyma_go].cotrzyma=0) then begin
             dx:=longint(random(2038))-1024;
             dy:=-integer(random(1500))-1000;
             y:=y-(5 shl 10);
             trzyma_go:=0;
          end;
          if (trzyma_go>0) then begin
             x:=trunc(post^[trzyma_go].x) shl 10;
             y:=trunc(post^[trzyma_go].y+1) shl 10;
             dx:=0;
             dy:=0;
             if (random(30)=0) then obr:=random(4);
          end;
             {jesli post. trzymajaca go robi cos innego, to upusc miecho}
          if (trzyma_go>0) and ((post^[trzyma_go].corobi<>5) or (not post^[trzyma_go].jest)) then begin
             post^[trzyma_go].comarobic:=0;
             trzyma_go:=0;
          end;

          if getpix_x((x+longint(dx)) shr 10,(y+longint(dy)) shr 10)<>0 then begin
             if getpix_x((x+longint(dx)*2) shr 10,y shr 10)<>0 then begin
                if rodz<100 then begin x:=x-longint(dx);dx:=-dx div 2 end
                            else begin x:=x-longint(dx);dx:=trunc(-dx/odbicie[rodz]) end;
             end;
             if rodz<100 then begin y:=y-longint(dy);dy:=-dy div 2 end
                         else begin y:=y-longint(dy);dy:=trunc(-dy/odbicie[rodz]) end;
             if rodz<100 then begin
                b:=trunc((sqrt(sqr(longint(dx)/5)+sqr(longint(dy)/5)))/17);
                if b>0 then begin
                   s1:=360/b/kfg.il_krwi;
                   s2:=b/25;
                   for c:=0 to trunc(b*kfg.il_krwi) do
                       nowysyf(x shr 10,y shr 10,
                            _sin(trunc(c*s1))*random*s2,
                            _cos(trunc(c*s1))*random*s2,
                            grupy[rodz div 4].kolorkrwi.od+random(grupy[rodz div 4].kolorkrwi.ile),
                            1,true,0,0,0);
                end;

             end;
             if (stal=0) and ((abs(dx)>212) or (abs(dy)>212)) and
                ((pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y<longint(pogoda.pozwody) shl 10))) then begin
                if rodz<100 then
                   StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*(rodz div 4)+11],false,20,24)
                   else case rodz of
                      100..101:StartSound(Sound[3], false,9,10);
                   end;
                stal:=20;
             end;
             if (rodz=102) and ((abs(dx)>800) or (abs(dy)>800)) then begin
                for b:=0 to 10 do {rozbicie sie cegly}
                    nowysyf(x shr 10,y shr 10,
                            random-0.5,-random+0.3,43+random(5),2,true,0,0,random(3));
                jest:=false;
                x:=-15000; {pozbadz sie cegly z ekranu}
                pokx:=-15000;
                StartSound(Sound[4], false,9,10);
             end;
          end else if stal>0 then dec(stal);

          if (abs(dx)<=60+pogoda.wiatr) and (abs(dy)<=60) and (trzyma_go=0) and
             (getpix_x((x+longint(dx)) shr 10,((y+longint(dy)) shr 10)+1)<>0) then jest:=false;

          if ((y shr 10>pogoda.pozwody) and (pogoda.dziura>=2)) then begin {pod woda/lawa}
             if (y shr 10>pogoda.pozwody) and (y shr 10<pogoda.pozwody+4) then begin
                plum(x shr 10,5,15,longint(dx)/4000,sqrt(sqr(longint(dx))+sqr(longint(dy)))/6000+0.1);
                if (pogoda.dziura>=3) or
                   ((pogoda.dziura>=2) and (palisie)) then nowydym(x shr 10,pogoda.pozwody-1,4+random(4),random(2));
             end;
             if (pogoda.dziura in [2,4]) and (palisie) and (random(10)=0) then palisie:=false;
             if zmiana[1]=0 then begin
                if abs(dx)>512 then dx:=dx div 2;
                if abs(dy)>1024 then dy:=dy div 2;
             end;
             if (pogoda.dziura=3) then begin
                if (not palisie) then palisie:=true;
                if random(30)=0 then begin jest:=false;niezostaw:=true;end;
             end;
          end;

          if (x<0) or (x>maxx1) or (y>maxy1+5000) then jest:=false;
          if (zmiana[3]=0) then begin
             if dx>0 then inc(obr);
             if dx<0 then dec(obr);
             if obr>=4 then obr:=0;
             if obr<0 then obr:=3;
          end;
         END;
         IF PAUZA THEN BEGIN
          pokx:=x;
          poky:=y;
         END;
          _x:=longint(pokx) shr 10-ekr.x;
          _y:=longint(poky) shr 10-ekr.y;
          if rodz<100 then maskpicxms(_x-3,_y-3,7,7,0,offsetym[rodz div 4]+49*((rodz mod 4)*4+obr),scr^,1,false)
                      else maskpicxms(_x-3,_y-3,7,7,0,offsety[8]+49*((rodz-100)*4+obr),scr^,1,false);

          if (palisie) then begin {pali sie}
             MaskPicTxms(_x-3,_y-5,7,9,0,offsety[10]+3000+longint(zmiana[4])*63,scr^);
             if (NOT PAUZA) AND (zmiana[3]=0) and (random(5)=0) then begin{lecace plomienie}
                strzal(x shr 10-2+random(5),y shr 10-2+random(5),
                    random/2-0.25,-random/8-0.01,
                    3,1,5,10-random(4));
                if random(5)=0 then begin
                   palisie:=false;
                   nowydym(x shr 10,y shr 10,3+random(3),0);
                end;
             end;
          end;

         IF NOT PAUZA THEN BEGIN
          if (krew>0) and (zmiana[3]=0) then dec(krew);
          if (rodz<100) and (zmiana[2]=0) and (krew>0) and (random(15-(krew div 27))=0) and
             ((kfg.il_krwi>=1) or ((kfg.il_krwi<1) and (kfg.il_krwi>0) and (random(trunc(5-kfg.il_krwi*5))=0))) and
             ((pogoda.dziura<=1) or ((pogoda.dziura>=2) and (y shr 10<pogoda.pozwody))) then
             nowysyf(x shr 10,y shr 10,random/4-0.125,random/4-0.125,
             grupy[rodz div 4].kolorkrwi.od+random(grupy[rodz div 4].kolorkrwi.ile),1,true,0,0,0);
          if (not jest) and (not niezostaw) and (x>=0) and (x<=maxx1) and (y>=0) and
             ((pogoda.dziura=0) or ((y<=maxy1) and (pogoda.dziura>=1))) then begin
             inc(_x,ekr.x);
             inc(_y,ekr.y);
             if rodz<100 then MaskPicXMSwXMS(_x-3,_y-3,7,7,0,
                                             offsetym[rodz div 4]+49*((rodz mod 4)*4+obr),1)
                         else MaskPicXMSwXMS(_x-3,_y-3,7,7,0,
                                             offsety[8]+49*((rodz-100)*4+obr),1);
             if palisie then nowydym(x shr 10,y shr 10,3+random(3),0);
          end;
         END;
       end;
    end;
end;

end;

{*}PROCEDURE zasychanie_kapanie_krwi;
var
x,y:longint;k:byte;pk:shortint;
gp:array[-1..1,0..3] of byte;
a1:longint;
begin
IF NOT PAUZA THEN BEGIN
for a:=0 to 200 do begin
    x:=random(maxx);
    y:=random(maxy);
    k:=getpix_x(x,y);
    if (k>178) and (k<=183) then
       if random(2)=0 then putpix_x(x,y,k-integer(random(2))-1)
          else begin
               if random(5)=0 then pk:=integer(random(2))*2-1 else pk:=0;
               nowysyf(x+longint(pk),y+1,0,0.1,k,1,true,0,0,0);
               putpix_x(x,y,k-random(2)-1);
               end;
end;

if pogoda.horror then begin{horror}
   for a:=0 to longint(kfg.szybhorror)*100 do begin
       x:=random(maxx);
       y:=random(maxy);
       for a1:=-1 to 1 do
           xms2mem(_xms[1].h,offsety[2]+(y+a1)*maxx+x-1,gp[a1],4);
       if x=maxx-1 then gp[0,2]:=1;
       if x=0 then gp[0,0]:=1;
       if y=maxy-1 then gp[1,0]:=1;
       if y=0 then gp[-1,0]:=1;
       if (gp[0,1]>0) and
          ((gp[-1,1]=0) or (gp[1,1]=0) or (gp[0,0]=0) or (gp[0,2]=0)
          or ((gp[-1,1]>178) and (gp[-1,1]<=182))) then begin
          putpix_x(x,y,182+random(2));
          if (y<maxy-1) and (gp[1,1]=0) and (random(5)=0) then
             nowysyf(x,y+1,0,0.1,183,1,true,0,0,0);
       end;
   end;
end;
END;
end;

{*}PROCEDURE pokaz_menu_na_dole;

 {+}PROCEDURE suwak(x,y,szer,wys,min,max,kolmin,kolmax:integer;var wartosc:byte);
 var
 a,b:integer;
 dl_paska1,dl_paska2:real;
 begin
  ebar(x-1,y-1, x+szer+1,y+wys+1, 5);
  dl_paska1:=(wartosc*100)/max;
  dl_paska2:=(dl_paska1*szer)/100;
  for a:=0 to trunc(dl_paska2) do
      for b:=0 to wys do
          putpix(x+a,y+b,kolmin+trunc(((a*(kolmax-kolmin+1))/(dl_paska2+1))));
  if (guzik[1]) and (mysz_w(x,y,x+szer,y+wys)) then begin
     wartosc:=trunc((mmx-x+1)/(szer/max));
     if wartosc<min then wartosc:=min;
     if wartosc>max then wartosc:=max;
  end;
 end;

const
k1:array[20..26] of byte=(39,15,7,6,126,125,124);
k2:array[23..29] of byte=(124,125,126,6,7,15,39);
corobi:array[0..4] of longint=(0,16,24,32,40);
zwierzaki:array[0..3] of longint=(0,14,6,10);
var
yy:byte;xx:integer;zm:boolean;
buf2:array[0..640] of byte;
begin
xms2mem(_xms[1].h,offsety[7]+12800*longint(ekr.ktore_menu),
        scr^[200-ekr.menuwys],320*(ekr.menuwys));
if (ekr.jak_menu>0) or (ekr.menuwys>0) then case ekr.ktore_menu of
  0:begin {bronie}
    if celow.bron<100 then begin
    ebar( 2+(celow.bron mod 11)*18, 199-ekr.menuwys+ 3+(celow.bron div 11)*19,
         16+(celow.bron mod 11)*18, 199-ekr.menuwys+17+(celow.bron div 11)*19,15);
    case celow.bron of
      0:begin {bazuka}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+9*225,scr^,1,false); {sila}
        suwak(227,199-ekr.menuwys+10,70,4,1,16,120,127,ust_broni.bazuka.sila);
        pisz(300,199-ekr.menuwys+9,l2t(ust_broni.bazuka.sila,2),0);
        end;
      1:begin {granat}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+9*225,scr^,1,false); {sila}
        suwak(227,199-ekr.menuwys+10,70,4,1,16,16,23,ust_broni.granat.sila);
        pisz(300,199-ekr.menuwys+9,l2t(ust_broni.granat.sila,2),0);

        maskpicxms(210,199-ekr.menuwys+21,15,15,0,offsety[19]+8*225,scr^,1,false); {czas}
        suwak(227,199-ekr.menuwys+26,70,4,1,99,16,23,ust_broni.granat.czas);
        pisz(300,199-ekr.menuwys+25,l2t(ust_broni.granat.czas,2),0);
        end;
      2:begin {bomba}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+9*225,scr^,1,false); {sila}
        suwak(227,199-ekr.menuwys+10,70,4,1,16,1,5,ust_broni.bomba.sila);
        pisz(300,199-ekr.menuwys+9,l2t(ust_broni.bomba.sila,2),0);

        maskpicxms(210,199-ekr.menuwys+21,15,15,0,offsety[19]+8*225,scr^,1,false); {czas}
        suwak(227,199-ekr.menuwys+26,70,4,1,99,1,5,ust_broni.bomba.czas);
        pisz(300,199-ekr.menuwys+25,l2t(ust_broni.bomba.czas,2),0);
        end;
      3:begin {dynamit}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+9*225,scr^,1,false); {sila}
        suwak(227,199-ekr.menuwys+10,70,4,1,16,8,15,ust_broni.dynamit.sila);
        pisz(300,199-ekr.menuwys+9,l2t(ust_broni.dynamit.sila,2),0);

        maskpicxms(210,199-ekr.menuwys+21,15,15,0,offsety[19]+8*225,scr^,1,false); {czas}
        suwak(227,199-ekr.menuwys+26,70,4,1,99,8,15,ust_broni.dynamit.czas);
        pisz(300,199-ekr.menuwys+25,l2t(ust_broni.dynamit.czas,2),0);
        end;
      4:begin {karabin}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+9*225,scr^,1,false); {sila}
        suwak(227,199-ekr.menuwys+10,70,4,2,18,120,127,ust_broni.karabin.sila);
        pisz(300,199-ekr.menuwys+9,l2t(ust_broni.karabin.sila,2),0);
        end;
      5:begin {minigan}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+9*225,scr^,1,false); {sila}
        suwak(227,199-ekr.menuwys+10,70,4,2,18,120,127,ust_broni.minigan.sila);
        pisz(300,199-ekr.menuwys+9,l2t(ust_broni.minigan.sila,2),0);
        end;
      6:begin {strzelba}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+9*225,scr^,1,false); {sila}
        suwak(227,199-ekr.menuwys+10,70,4,2,18,120,127,ust_broni.strzelba.sila);
        pisz(300,199-ekr.menuwys+9,l2t(ust_broni.strzelba.sila,2),0);
        end;
      8:begin {miotacz ognia}
        for a:=0 to 1 do begin
            maskpicxms(210+a*18,199-ekr.menuwys+5,15,15,0,offsety[19]+(12+a*12)*225,scr^,1,false);
            if (klik[1]) and (mysz_w(210+a*18,199-ekr.menuwys+5, 224+a*18,199-ekr.menuwys+19))
               then ust_broni.miotacz.rodz:=a;
        end;
        ebar(210+(ust_broni.miotacz.rodz)*18, 199-ekr.menuwys+ 5,
             224+(ust_broni.miotacz.rodz)*18, 199-ekr.menuwys+19,15);
        end;
      9:begin {nalot}
        for a:=0 to 1 do begin
            maskpicxms(210+a*18,199-ekr.menuwys+5,15,15,0,offsety[19]+(23+a)*225,scr^,1,false);
            if (klik[1]) and (mysz_w(210+a*18,199-ekr.menuwys+5, 224+a*18,199-ekr.menuwys+19))
               then ust_broni.nalot.rodz:=a;
        end;
        ebar(210+(ust_broni.nalot.rodz)*18, 199-ekr.menuwys+ 5,
             224+(ust_broni.nalot.rodz)*18, 199-ekr.menuwys+19,15);
        end;
     10:begin {pocisk samonaprowadzajacy}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+9*225,scr^,1,false); {sila}
        suwak(227,199-ekr.menuwys+10,70,4,1,16,120,127,ust_broni.pocsam.sila);
        pisz(300,199-ekr.menuwys+9,l2t(ust_broni.pocsam.sila,2),0);

        maskpicxms(210,199-ekr.menuwys+21,15,15,0,offsety[19]+10*225,scr^,1,false); {ustaw_cel}
        if (klik[1]) and (mysz_w(210,199-ekr.menuwys+21,224,199-ekr.menuwys+35)) then celow.opcja:=7;
        end;
     11:begin {laser}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+9*225,scr^,1,false); {sila}
        suwak(227,199-ekr.menuwys+10,70,4,1,10,8,15,ust_broni.laser.sila);
        pisz(300,199-ekr.menuwys+9,l2t(ust_broni.laser.sila,2),0);

        maskpicxms(210,199-ekr.menuwys+21,15,15,0,offsety[19]+(11+ord(ust_broni.laser.podpala))*225,scr^,1,false); {podpala}
        if (klik[1]) and (mysz_w(210,199-ekr.menuwys+21,224,199-ekr.menuwys+35)) then
           ust_broni.laser.podpala:=not ust_broni.laser.podpala;
        end;
     12:begin {prad}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+9*225,scr^,1,false); {sila}
        suwak(227,199-ekr.menuwys+10,50,4,1,10,56,63,ust_broni.prad.sila);
        pisz(280,199-ekr.menuwys+9,l2t(100+ust_broni.prad.sila*150,4)+'V',0);

        maskpicxms(210,199-ekr.menuwys+21,15,15,0,offsety[19]+(11+ord(ust_broni.prad.podpala))*225,scr^,1,false); {podpala}
        if (klik[1]) and (mysz_w(210,199-ekr.menuwys+21,224,199-ekr.menuwys+35)) then
           ust_broni.prad.podpala:=not ust_broni.prad.podpala;
        end;
     13:begin {kula ognista}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+9*225,scr^,1,false); {sila}
        suwak(227,199-ekr.menuwys+10,70,4,1,16,96,103,ust_broni.kulaog.sila);
        pisz(300,199-ekr.menuwys+9,l2t(ust_broni.kulaog.sila,2),0);
        end;
     14:begin {miny}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+13*225,scr^,1,false); {masz min}
        pisz(228,199-ekr.menuwys+9,l2t(maxmin-il_min,3)+'/'+l2t(maxmin,3),0);

        maskpicxms(210,199-ekr.menuwys+21,15,15,0,offsety[19]+14*225,scr^,1,false); {odpal}
        if (klik[1]) and (mysz_w(210,199-ekr.menuwys+21,224,199-ekr.menuwys+35)) then
           for yy:=1 to maxmin do
               if (min^[yy].jest) and
                  ((min^[yy].czas=0) or (min^[yy].czas>10)) then min^[yy].czas:=random(10)+1;

        maskpicxms(255,199-ekr.menuwys+23,15,15,0,offsety[19]+14*225,scr^,1,false); {dobra}
        maskpicxms(273,199-ekr.menuwys+23,15,15,0,offsety[19]+13*225,scr^,1,false); {zepsuta}
        maskpicxms(291,199-ekr.menuwys+23,15,15,0,offsety[19]+4*225,scr^,1,false); {losowa}
        for a:=0 to 2 do begin
            if (klik[1]) and (mysz_w(255+a*18,199-ekr.menuwys+23, 269+a*18,199-ekr.menuwys+37))
               then ust_broni.miny.zepsute:=a;
        end;
        ebar(255+(ust_broni.miny.zepsute)*18, 199-ekr.menuwys+23,
             269+(ust_broni.miny.zepsute)*18, 199-ekr.menuwys+37,15);

        end;
     18:begin {napalm}
        maskpicxms(210,199-ekr.menuwys+5,15,15,0,offsety[19]+9*225,scr^,1,false); {sila}
        suwak(227,199-ekr.menuwys+10,70,4,1,7,120,127,ust_broni.napalm.sila);
        pisz(300,199-ekr.menuwys+9,l2t(ust_broni.napalm.sila,2),0);
        end;
    end;
    end;
    end;
  1:begin
    if celow.bron>=100 then begin{inne atrakcje}
    ebar(2+(celow.bron-100)*18,199-ekr.menuwys+3,
         16+(celow.bron-100)*18,199-ekr.menuwys+17,15);
    case celow.bron of
      100:begin {smieci}
        for a:=0 to 3 do
            MaskPicXMS(210+a*15,199-ekr.menuwys+7,7,7,0,offsety[8]+49*(a*4),scr^,1,false);
        ebar(208+ust_broni.smieci.co*15,199-ekr.menuwys+5,
             218+ust_broni.smieci.co*15,199-ekr.menuwys+15, 15);
        for a:=0 to 3 do
           if (klik[1]) and (mysz_w(208+a*15,199-ekr.menuwys+5,218+a*15,199-ekr.menuwys+15)) then begin
              ust_broni.smieci.co:=a;
              a:=3
           end;
      end;
      101:begin {miesko}
        if ust_broni.miesko.grupa<=4 then begin
           for a:=0 to 3 do
            MaskPicXMS(210+a*15,199-ekr.menuwys+7,7,7,0,
                       offsetym[ust_broni.miesko.grupa]+49*(a*4) ,scr^,1,false);
           b:=kgrup[ust_broni.miesko.grupa]+7;
        end else begin
           for a:=0 to 3 do
            MaskPicXMS(210+a*15,199-ekr.menuwys+7,7,7,0,
                       offsetym[a]+49*(a*4) ,scr^,1,false);
           b:=6;
        end;
        maskpicxms(270,199-ekr.menuwys+7,7,7,0,offsety[19]+11777,scr^,1,false);
        maskpicxms(285,199-ekr.menuwys+7,7,7,0,offsety[19]+11854,scr^,1,false);

        ebar(208+ust_broni.miesko.co*15,199-ekr.menuwys+5,
             218+ust_broni.miesko.co*15,199-ekr.menuwys+15, 15);
        for a:=0 to 5 do
           if (klik[1]) and (mysz_w(208+a*15,199-ekr.menuwys+5,218+a*15,199-ekr.menuwys+15)) then begin
              ust_broni.miesko.co:=a;
              a:=5
           end;

        for a:=0 to 4 do
            maskpicxms(210+a*18,199-ekr.menuwys+20,15,15,0,offsetyp[a],scr^,1,false);
        maskpicxms(303,199-ekr.menuwys+22,7,11,0,offsety[19]+11700,scr^,1,false);
        ebar(208+ust_broni.miesko.grupa*18,199-ekr.menuwys+18,
             226+ust_broni.miesko.grupa*18,199-ekr.menuwys+36, 15);
        for a:=0 to 5 do
            if (klik[1]) and (mysz_w(208+a*18,199-ekr.menuwys+18,226+a*18,199-ekr.menuwys+36)) then begin
               ust_broni.miesko.grupa:=a;
               a:=5
            end;
      end;
      106:begin {ludzie}
        for a:=0 to 4 do
            maskpicxms(210+a*20,199-ekr.menuwys+7,15,15,0,offsetyp[a],scr^,1,false);
        ebar(208+ust_broni.ludzie.grupa*20,199-ekr.menuwys+5,
             226+ust_broni.ludzie.grupa*20,199-ekr.menuwys+23, 15);

        for a:=0 to 4 do
            if (klik[1]) and (mysz_w(208+a*20,199-ekr.menuwys+5,226+a*20,199-ekr.menuwys+23)) then begin
               ust_broni.ludzie.grupa:=a;
               a:=4
            end;
      end;
      107:begin {zwierzatka}
        for a:=0 to 3 do
            maskpicxms(210+a*15,199-ekr.menuwys+7,7,7,0,offsety[20]+49*zwierzaki[a],scr^,1,false);
        ebar(208+ust_broni.zwierz.rodzaj*15,199-ekr.menuwys+5,
             218+ust_broni.zwierz.rodzaj*15,199-ekr.menuwys+15, 15);

        for a:=0 to 3 do
            if (klik[1]) and (mysz_w(208+a*15,199-ekr.menuwys+5,218+a*15,199-ekr.menuwys+15)) then begin
               ust_broni.zwierz.rodzaj:=a;
               a:=3
            end;

      end;
      109:begin {lupa}
        maskpicxms(210,199-ekr.menuwys+16,15,15,0,offsety[19]+(21+ord(celow.lupa))*225,scr^,1,false); {wlacznik}
        if (klik[1]) and (mysz_w(210,199-ekr.menuwys+16,224,199-ekr.menuwys+30)) then begin
           celow.lupa:=not celow.lupa;
           nowy_tultip('WlaCZENIE LUPY (F2)');
        end;

        if ust_broni.lupa.odwracax=1 then
           maskpicxms(227,199-ekr.menuwys+5,15,15,0,offsety[19]+17*225,scr^,1,false)
           else
           maskpicxms(227,199-ekr.menuwys+5,15,15,0,offsety[19]+18*225,scr^,1,false);
        if (klik[1]) and (mysz_w(227,199-ekr.menuwys+5,241,199-ekr.menuwys+19)) then begin
           ust_broni.lupa.odwracax:=-ust_broni.lupa.odwracax;
           lupa_oblicz;
           nowy_tultip('ODBICIE W POZIOMIE');
        end;

        if ust_broni.lupa.odwracay=1 then
           maskpicxms(227,199-ekr.menuwys+21,15,15,0,offsety[19]+19*225,scr^,1,false)
           else
           maskpicxms(227,199-ekr.menuwys+21,15,15,0,offsety[19]+20*225,scr^,1,false);
        if (klik[1]) and (mysz_w(227,199-ekr.menuwys+21,241,199-ekr.menuwys+35)) then begin
           ust_broni.lupa.odwracay:=-ust_broni.lupa.odwracay;
           lupa_oblicz;
           nowy_tultip('ODBICIE W PIONIE');
        end;

        maskpicxms(244,199-ekr.menuwys+5,15,15,0,offsety[19]+15*225,scr^,1,false); {powiekszenie}
        suwak(261,199-ekr.menuwys+10,36,4,1,24,56,63,byte(ust_broni.lupa.powiekszenie));
        pisz(300,199-ekr.menuwys+9,l2t(ust_broni.lupa.powiekszenie,2),0);

        maskpicxms(244,199-ekr.menuwys+21,15,15,0,offsety[19]+16*225,scr^,1,false); {znieksztalcenie}
        suwak(261,199-ekr.menuwys+26,36,4,5,95,56,63,byte(ust_broni.lupa.znieksztalcenie));
        pisz(300,199-ekr.menuwys+25,l2t(ust_broni.lupa.znieksztalcenie,2),0);

        if (guzik[1]) and (
           (mysz_w(261,199-ekr.menuwys+10,297,199-ekr.menuwys+14)) or
           (mysz_w(261,199-ekr.menuwys+26,297,199-ekr.menuwys+30))) then lupa_oblicz;
        end;
    110:begin {paczki}
        for a:=0 to 2 do begin
            maskpicxms(210+a*18,199-ekr.menuwys+5,15,15,0,
                   offsety[19]+(30+a-ord(ust_broni.paczki.rodzaje[a])*4)*225,
                   scr^,1,false);
            if (klik[1]) and (mysz_w(210+a*18,199-ekr.menuwys+5,224+a*18,199-ekr.menuwys+19)) then
               ust_broni.paczki.rodzaje[a]:=not ust_broni.paczki.rodzaje[a];
        end;
        maskpicxms(210,199-ekr.menuwys+25,15,15,0,
                   offsety[19]+(26+ust_broni.paczki.rzut)*225,
                   scr^,1,false);
        if (klik[1]) and (mysz_w(210,199-ekr.menuwys+25,224,199-ekr.menuwys+39)) then
           if ust_broni.paczki.rzut<3 then inc(ust_broni.paczki.rzut)
              else ust_broni.paczki.rzut:=0;
        if (klik[2]) and (mysz_w(210,199-ekr.menuwys+25,224,199-ekr.menuwys+39)) then
           if ust_broni.paczki.rzut>0 then dec(ust_broni.paczki.rzut)
              else ust_broni.paczki.rzut:=3;
        end;
    end;

    end;
    end;
  2:begin {opcje postaci}
    if il_zazn=0 then pisz(10,199-ekr.menuwys+26,'BRAK ZAZNACZONYCH POSTACI',8)
       else
       if il_zazn=1 then begin
          pisz(10,199-ekr.menuwys+23,'ZAZNACZONA POSTAc NUMER: '+l2t(ktora_zazn,3),0);
          if post^[ktora_zazn].sila<0 then xx:=0 else xx:=post^[ktora_zazn].sila;
          pisz(10,199-ekr.menuwys+31,'SIlA: '+l2t(xx,3),0);
          pisz(90,199-ekr.menuwys+31,'GRUPA',kgrup[post^[ktora_zazn].grupa]);
          if post^[ktora_zazn].wolnawola then ebar(146,199-ekr.menuwys+3,160,199-ekr.menuwys+17,15);
          if celow.sterowanie=ktora_zazn then ebar(200,199-ekr.menuwys+3,214,199-ekr.menuwys+17,15);
          if post^[ktora_zazn].niesmiertelny>=0 then ebar(218,199-ekr.menuwys+3,232,199-ekr.menuwys+17,15)
       end
          else begin
          pisz(10,199-ekr.menuwys+26,'ZAZNACZONYCH POSTACI: '+l2t(il_zazn,3)+' Z '+l2t(il_post,3),0);
          b:=0;
          for a:=1 to maxpost do if (post^[a].zazn) and (post^[a].jest) and (post^[a].wolnawola) then inc(b);
          if b=il_zazn then ebar(146,199-ekr.menuwys+3,160,199-ekr.menuwys+17,15)
                      else if b>0 then ebarT(146,199-ekr.menuwys+3,160,199-ekr.menuwys+17,13);
          for a:=1 to maxpost do
              if (post^[a].jest) and (post^[a].zazn) and (celow.sterowanie=a) then begin
                 ebarT(200,199-ekr.menuwys+3,214,199-ekr.menuwys+17,13);
                 a:=maxpost;
              end;
          b:=0;
          for a:=1 to maxpost do if (post^[a].zazn) and (post^[a].jest) and (post^[a].niesmiertelny>=0) then inc(b);
          if b=il_zazn then ebar(218,199-ekr.menuwys+3,232,199-ekr.menuwys+17,15)
                      else if b>0 then ebarT(218,199-ekr.menuwys+3,232,199-ekr.menuwys+17,13);
          barT(201,199-ekr.menuwys+4,213,199-ekr.menuwys+16,15,scr^,chmur^)
          end;
    end;
  3:begin {pogoda}
    if pogoda.wiatr<>0 then begin {pasek wiatru}
      a:=0;
      xx:=pogoda.wiatr*2;
      repeat
        if a>xx then dec(a)  else inc(a);
        for b:=22 to 27 do begin
           yy:=199-ekr.menuwys+b;
           if yy<=199 then scr^[yy,63+a]:=88+abs(trunc((a*7.9)/xx));
        end;
      until a=xx;
    end;

    if pogoda.autowiatr then ebar(2,199-ekr.menuwys+31, 20,199-ekr.menuwys+39,15);

    xx:=pogoda.wielkopadow*2; {pasek opadow}
    for a:=1 to xx do
       for b:=22 to 27 do begin
           yy:=199-ekr.menuwys+b;
           if yy<=199 then scr^[yy,128+a]:=56+abs(trunc((a*7.9)/xx));
       end;
    if pogoda.autoopady then ebar(128,199-ekr.menuwys+31, 146,199-ekr.menuwys+39,15);

    xx:=pogoda.agresja*2; {pasek agresji}
    for a:=1 to xx do
       for b:=22 to 27 do begin
           yy:=199-ekr.menuwys+b;
           if yy<=199 then scr^[yy,233+a]:=64+abs(trunc((a*7.9)/xx));
       end;

    xx:=(400-pogoda.pozwody) div 5; {pasek poziomu wody}
    if pogoda.dziura=2 then b:=168 else
       if pogoda.dziura=3 then b:=96 else
          if pogoda.dziura=4 then b:=200 else b:=120;
    for a:=1 to xx do begin
        yy:=238-ekr.menuwys-a;
        if yy<=199 then fillchar2(scr^[yy,310],6,b+abs(trunc((a*6.9)/xx)));
    end;

    for b:=20 to 26 do begin {wskazniki granic prawe [gorne]}
        yy:=199-ekr.menuwys+b;
        if yy<=199 then begin
           scr^[yy,63+pogoda.wtrgrp*2]:=k1[b];
           scr^[yy,128+pogoda.wlkopgrp*2]:=k1[b];
        end;
    end;
    for b:=23 to 29 do begin {wskazniki granic lewe [dolne]}
        yy:=199-ekr.menuwys+b;
        if yy<=199 then begin
           scr^[yy,63+pogoda.wtrgrl*2]:=k2[b];
           scr^[yy,128+pogoda.wlkopgrl*2]:=k2[b];
        end;
    end;

    if pogoda.deszcz then ebar(2,199-ekr.menuwys+3, 16,199-ekr.menuwys+17,15);
    if pogoda.snieg  then ebar(20,199-ekr.menuwys+3,34,199-ekr.menuwys+17,15);
    if pogoda.burza  then ebar(38,199-ekr.menuwys+3,52,199-ekr.menuwys+17,15);
    if pogoda.deszczkrwi then ebar(56,199-ekr.menuwys+3,70,199-ekr.menuwys+17,15);
    if pogoda.horror then ebar(74,199-ekr.menuwys+3,88,199-ekr.menuwys+17,15);
    if pogoda.dziura>=1 then
       ebar(92+pogoda.dziura*18,199-ekr.menuwys+3,
            106+pogoda.dziura*18,199-ekr.menuwys+17,15);
    if pogoda.szalency then ebar(182,199-ekr.menuwys+3,196,199-ekr.menuwys+17,15);
    if kfg.bijasie then ebar(200,199-ekr.menuwys+3,214,199-ekr.menuwys+17,15);
    end;
  4:begin {rysowanie}
    xms2mem(_xms[1].h,offsety[13]+rysowanie.textura*10,wyr,10);
    if rysowanie.jakrys=1 then begin
       b:=8;
       ebar(41, 199-ekr.menuwys+2,
            55, 199-ekr.menuwys+13,15)
    end  else b:=120;
    if rysowanie.textura>0 then pisz(60,199-ekr.menuwys+5,l2t(rysowanie.textura,3)+' '+wyr,b)
                           else pisz(60,199-ekr.menuwys+5,'BRAK',b);
    if (klik[1]) and (mysz_w(41,199-ekr.menuwys+2,55,199-ekr.menuwys+13)) and
       (rysowanie.jakrys=1) and (iltextur>0) then begin
       inc(rysowanie.textura);
       if rysowanie.textura>iltextur then rysowanie.textura:=1;
       xms2mem(_xms[1].h,offsety[13]+rysowanie.textura*10,wyr[0],10);
       wczytaj_texture_do_rysowania(wyr+'.STX');
    end;
    if (klik[2]) and (mysz_w(41,199-ekr.menuwys+2,55,199-ekr.menuwys+13)) and
       (rysowanie.jakrys=1) and (iltextur>0) then begin
       dec(rysowanie.textura);
       if rysowanie.textura<1 then rysowanie.textura:=iltextur;
       xms2mem(_xms[1].h,offsety[13]+rysowanie.textura*10,wyr[0],10);
       wczytaj_texture_do_rysowania(wyr+'.STX');
    end;
    if ((klik[1]) or (klik[2])) and (mysz_w(41,199-ekr.menuwys+2,55,199-ekr.menuwys+13)) and
       (rysowanie.jakrys<>1) and (iltextur>0) then begin
       rysowanie.jakrys:=1;
       nowy_tultip('TEKSTURA');
    end;
    {-}
    if rysowanie.jakrys=0 then begin
       ebar(41+ord(not rysowanie.gladko)*18, 199-ekr.menuwys+15,
            55+ord(not rysowanie.gladko)*18, 199-ekr.menuwys+26,15);
       b:=8
    end else b:=120;
    pisz(78,199-ekr.menuwys+18,l2t(rysowanie.kolor,3),b);
    bar(105,199-ekr.menuwys+18,128,199-ekr.menuwys+23,kolter[rysowanie.kolor]+ord(not rysowanie.gladko));
    drawline(106,199-ekr.menuwys+24,129,199-ekr.menuwys+24,1,false);
    drawline(129,199-ekr.menuwys+19,129,199-ekr.menuwys+24,1,false);

    maskpicxms(132,199-ekr.menuwys+15,18,24,0,offsety[30],scr^,1,false);
    a:=rysowanie.kolor-1;
    ebar(131+(a div 12)*3,199-ekr.menuwys+14+(a mod 12)*2,
         135+(a div 12)*3,199-ekr.menuwys+17+(a mod 12)*2,15);

    if (guzik[1]) and (mysz_w(132,199-ekr.menuwys+15 ,149,199-ekr.menuwys+38)) then begin
       rysowanie.kolor:=((mmx-132) div 3)*12+((mmy-(199-ekr.menuwys+15)) div 2) mod 12+1;
       rysowanie.jakrys:=0;
    end;

    if (klik[1]) and (rysowanie.jakrys=0) and
       (((mysz_w(41,199-ekr.menuwys+15,55,199-ekr.menuwys+26)) and (rysowanie.gladko)) or
        ((mysz_w(59,199-ekr.menuwys+15,73,199-ekr.menuwys+26)) and (not rysowanie.gladko))) then begin
       inc(rysowanie.kolor);
       if rysowanie.kolor>72 then rysowanie.kolor:=1;
    end;
    if (klik[2]) and (rysowanie.jakrys=0) and
       (((mysz_w(41,199-ekr.menuwys+15,55,199-ekr.menuwys+26)) and (rysowanie.gladko)) or
        ((mysz_w(59,199-ekr.menuwys+15,73,199-ekr.menuwys+26)) and (not rysowanie.gladko))) then begin
       dec(rysowanie.kolor);
       if rysowanie.kolor<=0 then rysowanie.kolor:=72;
    end;
    if ((klik[1]) or (klik[2])) and (mysz_w(41,199-ekr.menuwys+15,73,199-ekr.menuwys+26)) and
       (rysowanie.jakrys<>0) then begin
       rysowanie.jakrys:=0;
       nowy_tultip('KOLOR');
    end;

    if ((klik[1]) or (klik[2])) and (mysz_w(41,199-ekr.menuwys+15,55,199-ekr.menuwys+26)) then
       rysowanie.gladko:=true;
    if ((klik[1]) or (klik[2])) and (mysz_w(59,199-ekr.menuwys+15,73,199-ekr.menuwys+26)) then
       rysowanie.gladko:=false;

    {-}
    suwak(212,199-ekr.menuwys+8,84,5,1,50,16,23,rysowanie.rozm);
    pisz(300,199-ekr.menuwys+8,l2t(rysowanie.rozm,2),0);
    if (klik[1]) and (mysz_w(187,199-ekr.menuwys+4,300,199-ekr.menuwys+17)) then nowy_tultip('ROZMIAR PeDZLA');
    if (klik[1]) and (mysz_w(187,199-ekr.menuwys+24,300,199-ekr.menuwys+37)) then nowy_tultip('ROZMIAR OBIEKTU');
    {-}
    ebar(152+rysowanie.ksztalt*18, 199-ekr.menuwys+4,
         165+rysowanie.ksztalt*18, 199-ekr.menuwys+17,15);
    if (klik[1]) and (mysz_w(152,199-ekr.menuwys+4,165,199-ekr.menuwys+17)) then begin
       rysowanie.ksztalt:=0;
       nowy_tultip('OKRaGlY PeDZEL');
    end;
    if (klik[1]) and (mysz_w(170,199-ekr.menuwys+4,183,199-ekr.menuwys+17)) then begin
       rysowanie.ksztalt:=1;
       nowy_tultip('KWADRATOWY PeDZEL');
    end;
    {-}
    if rysowanie.jakrys=2 then begin
       b:=8;
       ebar(41, 199-ekr.menuwys+28,
            55, 199-ekr.menuwys+39,15)
    end else b:=120;
    pisz(60,199-ekr.menuwys+31,l2t(rysowanie.obiekt,3),b);
    if (klik[1]) and (mysz_w(41,199-ekr.menuwys+28,55,199-ekr.menuwys+39)) and
       (rysowanie.jakrys=2) then begin
       inc(rysowanie.obiekt);
       if rysowanie.obiekt>15 then rysowanie.obiekt:=1;
    end;
    if (klik[2]) and (mysz_w(41,199-ekr.menuwys+28,55,199-ekr.menuwys+39)) and
       (rysowanie.jakrys=2) then begin
       dec(rysowanie.obiekt);
       if rysowanie.obiekt<=0 then rysowanie.obiekt:=15;
    end;
    if ((klik[1]) or (klik[2])) and (mysz_w(41,199-ekr.menuwys+28,55,199-ekr.menuwys+39)) and
       (rysowanie.jakrys<>2) then begin
       rysowanie.jakrys:=2;
       nowy_tultip('OBIEKT');
    end;
    {-}
    suwak(212,199-ekr.menuwys+28,84,5,1,50,16,23,byte(rysowanie.obrozm));
    pisz(300,199-ekr.menuwys+28,l2t(rysowanie.obrozm,2),0);
    {-}
    if rysowanie.jakrys<=1 then
      for a:=0 to 29 do begin {pokazywanie przykladu rysowania}
        xx:=0;
        while xx<30 do begin
            if rysowanie.jakrys=1 then begin
               xms2mem(_xms[1].h,offsety[12]+(a mod texturar.ry)*320,buf2[xx],texturar.rx);
               inc(xx,texturar.rx);
            end else begin
               if rysowanie.gladko then xms2mem(_xms[1].h,offsety[15]+a*30,buf2[xx],30)
                  else fillchar2(buf2,30,1);
               for b:=0 to 29 do buf2[b]:=buf2[b]+kolter[rysowanie.kolor];
               inc(xx,30);
            end;
        end;
        if 199-ekr.menuwys+5+a<=199 then move3(buf2,scr^[199-ekr.menuwys+6+a,5],30);
      end
      else rysujelement(20,199-ekr.menuwys+21,2);
    end;
  5:begin {glowne menu}
    for a:=0 to 4 do begin
        pisz(4+a*26,199-ekr.menuwys+22,l2t(grupy[a].jestpost,3),kgrup[a]);
        pisz(4+a*26,199-ekr.menuwys+29,l2t(grupy[a].maxpost,3),kgrup[a]);
        maskpicxms(4+a*26,199-ekr.menuwys+6,15,15,0,offsetyp[a],scr^,1,false);
        if not grupy[a].wylot then
           maskpicxms(20+a*26,199-ekr.menuwys+8,5,8,0,offsety[27]+125,scr^,1,true);
    end;

    if ekr.opcja_menu=0 then begin {pokazuj liczniki itp}
       pisz(147,199-ekr.menuwys+2,'POSTACI JEST/MAX:'+l2t(il_post,3)+'/'+l2t(maxpost,3),0);
       pisz(154,199-ekr.menuwys+10,'TRUPoW TUTAJ:'+l2t(il_trupow-il_trup_et,10),0);
       pisz(154,199-ekr.menuwys+18,'TRUPoW RAZEM:'+l2t(il_trupow,10),0);
       pisz(196,199-ekr.menuwys+26,'PUNKTY:'+l2t(punkty,10),0);
       pisz(189,199-ekr.menuwys+34,'OSTATNIE KOMBO:'+l2t(ost_combo,3),0);
    end
     else begin
      if (ekr.opcja_menu>=1) and (ekr.opcja_menu<10) then begin {...lub ustawienia wylotu}

        if grupy[ekr.opcja_menu-1].corobi=5 then
        maskpicxms(139,199-ekr.menuwys+5,7,11,0,offsety[19]+11700,scr^,1,false) {corobi-losowo}
           else
           maskpicxms(135,199-ekr.menuwys+3,15,15,0,offsetyp[ekr.opcja_menu-1]+
                      corobi[grupy[ekr.opcja_menu-1].corobi]*225,scr^,1,false); {corobi}
        maskpicxms(153,199-ekr.menuwys+3,15,15,0,offsety[19]+(grupy[ekr.opcja_menu-1].kierunek+1)*225,scr^,1,false); {kier}
        maskpicxms(171,199-ekr.menuwys+3,15,15,0,offsety[19]+675,scr^,1,false); {+ , sila}
           pisz(187,199-ekr.menuwys+7,l2t(grupy[ekr.opcja_menu-1].sila,3),kgrup[ekr.opcja_menu-1]);
        maskpicxms(209,199-ekr.menuwys+3,15,15,0,offsety[19]+900,scr^,1,false); {?}

        if grupy[ekr.opcja_menu-1].wolnawol then
           ebar(209,199-ekr.menuwys+3, 223,199-ekr.menuwys+17, 15);

        maskpicxms(227,199-ekr.menuwys+3,15,15,0,offsety[19]+1125,scr^,1,false); {..., czestot}
           pisz(243,199-ekr.menuwys+7,l2t(grupy[ekr.opcja_menu-1].czestot,2),kgrup[ekr.opcja_menu-1]);
        maskpicxms(258,199-ekr.menuwys+3,15,15,0,offsety[19]+1350,scr^,1,false); {%, procent}
           pisz(274,199-ekr.menuwys+7,l2t(grupy[ekr.opcja_menu-1].procent,3),kgrup[ekr.opcja_menu-1]);
        maskpicxms(296,199-ekr.menuwys+3,15,15,0,offsety[19]+1575,scr^,1,false); {wyrzuc}

        for a:=0 to 4 do begin
            maskpicxms(137+a*36,199-ekr.menuwys+22,30,17,0,
                       offsety[19]+ord(grupy[ekr.opcja_menu-1].bracia[a])*510+12000,
                       scr^,1,false);

            maskpicxms(150+a*36,199-ekr.menuwys+23,15,15,0,offsetyp[a],scr^,1,false);
            if a=ekr.opcja_menu-1 then
               ebar(137+a*36,199-ekr.menuwys+22,166+a*36,199-ekr.menuwys+38,15);
        end;

        ebar(-25+ekr.opcja_menu*26,199-ekr.menuwys+3,
             ekr.opcja_menu*26,199-ekr.menuwys+37,15);
      end;
     end;
    end;
end;
end;{proc}

{*}PROCEDURE zmiany_menu; {zmiana menu}
var zm:boolean;
begin
zm:=false;
if (kl[57]) and (not klw[57]) then begin {spacja}
   klw[57]:=true;
   if ekr.ktore_menu in [0,1] then kfg.bronmenu[ekr.ktore_menu]:=celow.bron;
   inc(ekr.ktore_menu);if ekr.ktore_menu>=6 then ekr.ktore_menu:=0;
   if (ekr.ktore_menu=2) and (il_zazn=0) then inc(ekr.ktore_menu);
   if (kfg.zapamietujmenu) and (ekr.ktore_menu in [0,1]) then celow.bron:=kfg.bronmenu[ekr.ktore_menu];
   zm:=true;
end;
if (kl[15]) and (not klw[15]) then begin {tab}
   klw[15]:=true;
   inc(ekr.jak_menu);
   if ekr.jak_menu>2 then ekr.jak_menu:=0;
end;
if (kl[41]) and (not klw[41]) then begin {` - zakladki}
   klw[41]:=true;
   kfg.zakladki:=not kfg.zakladki;
end;
for a:=2 to 7 do
    if ((kl[a]) and (not klw[a])) or
       ((ekr.jak_menu>0) and (kfg.zakladki) and ((klik[2]) or (klik[1])) and
        (mysz_w(1+(a-2)*31,199-ekr.menuwys-6, 30+(a-2)*31,199-ekr.menuwys))) then begin
       if ekr.ktore_menu in [0,1] then kfg.bronmenu[ekr.ktore_menu]:=celow.bron;
       klw[a]:=true;
       ekr.ktore_menu:=a-2;
       a:=7;
       if (kfg.zapamietujmenu) and (ekr.ktore_menu in [0,1]) then celow.bron:=kfg.bronmenu[ekr.ktore_menu];
       zm:=true;
       klik[1]:=false;
       guzik[1]:=false;
       klik[2]:=false;
       guzik[2]:=false;
    end;

if (kl[25]) and (not klw[25]) then begin {P-pauza}
   klw[25]:=true;
   pauza:=not pauza;
end;

if zm then begin {pare warunkow, jesli menu zostalo zmienione}
   if not kfg.zakladki then case ekr.ktore_menu of
      0:nowy_kom('*BRONIE*');
      1:nowy_kom('*INNE ATRAKCJE*');
      2:nowy_kom('*OPCJE POSTACI*');
      3:nowy_kom('*WARUNKI*');
      4:nowy_kom('*RYSOWANIE*');
      5:nowy_kom('*MENU GloWNE*');
   end;
   ekr.opcja_menu:=0;
   if ekr.ktore_menu=4 then celow.opcja:=6
                       else celow.opcja:=0;
end;
if not kl[57] then klw[57]:=false;
if not kl[15] then klw[15]:=false;
if not kl[25] then klw[25]:=false;
if not kl[41] then klw[41]:=false;
for a:=2 to 7 do if not kl[a] then klw[a]:=false;
end;

{*}PROCEDURE trzesienie_ziemi;
var buf:array[0..1279] of byte;
begin
ekr.skok:=50;
if zmiana[3]=0 then begin
   xms2xms(_xms[1].h,offsety[2],_xms[1].h,offsety[2]+530000,512000);
   xms2xms(_xms[1].h,offsety[2]+530000,_xms[1].h,offsety[2]+1280,510720);
   fillchar2(buf,sizeof(buf),0);
   mem2xms(buf,_xms[1].h,offsety[2],1280);
   for a:=1 to maxmin do
       if (min^[a].jest) then begin
          inc(min^[a].y,1024);
          min^[a].dy:=min^[a].dy+random(100)-50;
          min^[a].dx:=min^[a].dx+random(100)-50;
       end;
end;
for a:=1 to maxpost do
    if (post^[a].jest) then begin
       post^[a].corobi:=4;
       if random(100)=0 then post^[a].comarobic:=7;
       if abs(post^[a].dx)<0.2 then post^[a].dx:=random-0.5;
       if abs(post^[a].dy)<0.2 then post^[a].dy:=random-0.5;
    end;
end;

{*}PROCEDURE ustawienia_dla_trybu_gry;
var a:longint;
begin
if il_post<=0 then tr_gry.grupa:=random(5);{jesli nie ma postaci - wywal nowe}

for a:=0 to 4 do {przymusowe ustawienia grup}
    with grupy[a] do begin
       maxpost:=0;
       corobi:=0;
       czestot:=0;
       procent:=0;
       wylot:=false;
       wolnawol:=true;
       kierunek:=0;
       sila:=50;
    end;
grupy[tr_gry.grupa].maxpost:=20; {jednej grupy zawsze 20}

with pogoda do begin
    burza:=false;
    if agresja>10 then agresja:=10;
    dziura:=0;
    szalency:=false;
end;

if ekr.ktore_menu=2 then ekr.ktore_menu:=1;
for a:=1 to maxpost do
    if (post^[a].jest) and (post^[a].zazn) then post^[a].zazn:=false;
end;

{*}PROCEDURE gra;
var
dx,dy,pdy,c,b:integer;
_menu,bol,_pogrze:boolean;
paczbuf:array[0..10] of byte;
begin
_menu:=false;
_pogrze:=false;
kfg._co_klatke:=kfg.co_klatke;
celow.nie_lap_ludzi:=0;
dx:=0;dy:=0;pdy:=0;
xms2mem(_xms[1].h,offsety[13]+rysowanie.textura*10,wyr[0],10);
wczytaj_texture_do_rysowania(wyr+'.STX');
move3(pal_gl,pal,sizeof(pal));
cala_paleta(false);
ekr.opcja_menu:=0;
if ekr.ktore_menu=4 then celow.opcja:=6
                    else celow.opcja:=0;
if pogoda.dziura=0 then fillchar(scr2^,maxx*20,7)
                   else fillchar(scr2^,maxx*20,0);
mem2xms(scr2^,_xms[1].h,offsety[2]+512000,maxx*20);
piorun_w_wode:=0;
repeat
   fillchar(full,sizeof(full),0);
   if trybgry then ustawienia_dla_trybu_gry;
   sprawdz_mysz;
   zmiany_menu;
   pdy:=0;
   if pilatnie>0 then dec(pilatnie);
   case ekr.jak_menu of
      0:{ekr.menuwys:=0; {brak menu}
        if (ekr.menuwys>0) then begin dec(ekr.menuwys,2);pdy:=-2;end;
      1:begin {wysuwane menu}
        if (mmy>=199-ekr.menuwys) and
           (((ekr.menuwys<40) and (ekr.menuwys>0)) or
            ((ekr.menuwys=0) and ((klik[2]) or (klik[1])))) then begin
           inc(ekr.menuwys,2);
           pdy:=2;
        end;
        if (mmy<199-ekr.menuwys) and (ekr.menuwys>0) then begin dec(ekr.menuwys,2);pdy:=-2;end;
        end;
      2:if ekr.menuwys<40 then inc(ekr.menuwys,2); {zawsze menu}
   end;
   if mmy>=200-ekr.menuwys then mysz.wygl:=1 else begin
      if celow.bron=7 then mysz.wygl:=2
                      else mysz.wygl:=0;
      if celow.opcja=6 then mysz.wygl:=12;
   end;
   zmiany;
   if dx>0 then dec(dx);
   if dx<0 then inc(dx);
   if dy>0 then dec(dy);
   if dy<0 then inc(dy);
   if (mmx>=319) and (dx<kfg.szybprzesekrmysz) then inc(dx,2);
   if (mmx<=0) and (dx>-kfg.szybprzesekrmysz) then dec(dx,2);
   if (mmy>=199) and (dy<kfg.szybprzesekrmysz) then inc(dy,2);
   if (mmy<=0) and (dy>-kfg.szybprzesekrmysz) then dec(dy,2);
   if ((kl[77]) and (celow.sterowanie=0)) and (dx<kfg.szybprzesekrklaw) then inc(dx,2);
   if ((kl[75]) and (celow.sterowanie=0)) and (dx>-kfg.szybprzesekrklaw) then dec(dx,2);
   if ((kl[80]) and (celow.sterowanie=0)) and (dy<kfg.szybprzesekrklaw) then inc(dy,2);
   if ((kl[72]) and (celow.sterowanie=0)) and (dy>-kfg.szybprzesekrklaw) then dec(dy,2);
   ekr.x:=ekr.x+dx;
   ekr.wy:=ekr.wy+dy+pdy;
   if ekr.x>=maxx-321 then begin ekr.x:=maxx-321;dx:=0;end;
   if ekr.x<=0 then begin ekr.x:=0;dx:=0;end;
   if ekr.wy>=200+ekr.menuwys then begin ekr.wy:=200+ekr.menuwys;dy:=0;end;
   if ekr.wy<=0 then begin ekr.wy:=0;dy:=0;end;

   ekr.y:=ekr.wy+random(ekr.skok div 4)-ekr.skok div 8;
   if ekr.y>=200+ekr.menuwys then begin ekr.y:=200+ekr.menuwys;dy:=0;end;
   if ekr.y<=0 then begin ekr.y:=0;dy:=0;end;

   {jesli sie przesuwa ekran, to zmien wyglad kursora myszki}
   if (dx<0) and (dy=0) then mysz.wygl:=4;
   if (dx<0) and (dy<0) then mysz.wygl:=5;
   if (dx=0) and (dy<0) then mysz.wygl:=6;
   if (dx>0) and (dy<0) then mysz.wygl:=7;
   if (dx>0) and (dy=0) then mysz.wygl:=8;
   if (dx>0) and (dy>0) then mysz.wygl:=9;
   if (dx=0) and (dy>0) then mysz.wygl:=10;
   if (dx<0) and (dy>0) then mysz.wygl:=11;

   if (celow.bron=16) and (mmy<=199-ekr.menuwys) and (celow.opcja=0) then mysz.wygl:=14; {pila}
   if (celow.bron=108) and (mmy<=199-ekr.menuwys) and (celow.opcja=0) then begin {wentylator}
      ust_broni.wentyl.ani:=ust_broni.wentyl.ani+ust_broni.wentyl.sila/10;
      if ust_broni.wentyl.ani>=10 then ust_broni.wentyl.ani:=ust_broni.wentyl.ani-10;
      mysz.wygl:=16+trunc(ust_broni.wentyl.ani);
      if ust_broni.wentyl.sila>0 then dmuch(mmx+ekr.x,mmy+ekr.y);
   end;
   if (celow.opcja=7) then mysz.wygl:=13;
   if (celow.bron=109) and (mmy<=199-ekr.menuwys) and (celow.opcja=0) and
      (celow.lupa) then mysz.wygl:=26; {lupa-brak celownika}

   IF kfg._co_klatke>=kfg.co_klatke then BEGIN {rysuj tlo}
     if kfg.tlo then for a:=0 to 199-ekr.menuwys do
        xms2mem(_xms[1].h,offsety[1]+ekr.x div 3+longint(a+ekr.wy div 2)*maxx div 2,scr^[a],320)
       else fillchar2(scr^,64000,kfg.tlokolor);
   END;

   podlicz_opady;
   if (kfg.opady) and ((pogoda.il_sniegu>0) or ((pogoda.snieg) or (pogoda.deszcz) or (pogoda.deszczkrwi))) then opady(1);
      {rysuj ostatni plan sniegu}

   if kfg.paczki then begin
      if (NOT PAUZA) AND (zmiana[5]=0) and (random((31-longint(kfg.czestotpacz))*40)=0) then
         nowapaczka(-1,-1,-1);
      paczki;
   end;
   IF kfg._co_klatke>=kfg.co_klatke then BEGIN {rysuj teren}
     for a:=0 to 199-ekr.menuwys do
        xms2mem(_xms[1].h,offsety[2]+ekr.x+longint(a+ekr.y)*maxx,scr2^[a],320);
      QuickMaskPic(64000-(ekr.menuwys*320),scr2^,scr^);
   END;
   if ekr.skok>0 then dec(ekr.skok);
   sprawdz_zmiany_broni;
   celow.strzela:=false;
   if (guzik[1]) and (mmy<200-ekr.menuwys) then begin {wcisniecie guzika na planszy gry}
      if (celow.opcja=0) then begin
         if (celow.temp=0) then begin {strzelanie}
            if (not trybgry) or
               ((trybgry) and
                ((celow.bron<100) and (tr_gry.amun[typybroni1[celow.bron].rodz]>=typybroni1[celow.bron].il)) or
                ((celow.bron>=100) and
                 ((tr_gry.amun[typybroni2[celow.bron].rodz]>=typybroni2[celow.bron].il) or
                  (tr_gry.amun[typybroni2[celow.bron].rodz]=99)) and
                  (tr_gry.amun[typybroni2[celow.bron].rodz]<>255)) ) then begin
                 strzel_mysza;
               if trybgry then
                  if (celow.bron<100) then dec(tr_gry.amun[typybroni1[celow.bron].rodz],typybroni1[celow.bron].il)
                     else
                     if typybroni2[celow.bron].rodz<99 then
                        dec(tr_gry.amun[typybroni2[celow.bron].rodz],typybroni2[celow.bron].il);
            end;
         end;
         celow.strzela:=true;
      end
      else begin
         if (celow.opcja>=1) and (celow.opcja<=5) then begin {zmiana pozycji miejsca wylotu}
            grupy[celow.opcja-1].wylx:=mmx+ekr.x;
            grupy[celow.opcja-1].wyly:=mmy+ekr.y;
            celow.opcja:=0;
            celow.temp:=10;
         end;
         if (celow.opcja=6) then begin {rysowanie}
            if rysowanie.jakrys<=1 then begin {rysowanie scian}
               if rysowanie.ksztalt=0 then rysuj(mmx+ekr.x,mmy+ekr.y,1)
                                      else rysuj_kwad(mmx+ekr.x,mmy+ekr.y,1);
            end
                                   else rysujelement(mmx+ekr.x,mmy+ekr.y,0); {rys.elementow}
         end;
         if (celow.opcja=7) then begin {zmiana pozycji celu pocisku samonaprowadz.}
            celow.celx:=mmx+ekr.x;
            celow.cely:=mmy+ekr.y;
            celow.opcja:=0;
            celow.temp:=10;
            celow.ktorycel:=0;
            for a:=maxpost downto 1 do
                if (post^[a].jest) and
                   (post^[a].x>=mmx+ekr.x-5) and
                   (post^[a].x<=mmx+ekr.x+5) and
                   (post^[a].y>=mmy+ekr.y-5) and
                   (post^[a].y<=mmy+ekr.y+5) then begin
                    celow.ktorycel:=a;
                    a:=1;
                    end;
         end;
      end;
   end;
   if (guzik[2]) and (mmy<200-ekr.menuwys) and (celow.opcja=0) then begin
      if (celow.temp=0) then begin {strzelanie prawym klawiszem myszy}
         if (not trybgry) or
               ((trybgry) and (celow.bron=9) and
                (tr_gry.amun[typybroni1[celow.bron].rodz]>=typybroni1[celow.bron].il)) then begin
                 strzel_mysza2;
               if (trybgry) then dec(tr_gry.amun[typybroni1[celow.bron].rodz],typybroni1[celow.bron].il)
         end;
      end;
      celow.strzela:=true;
   end;
   if (guzik[2]) and (celow.opcja>=1) and (celow.opcja<=5) then
      celow.opcja:=0; {wylaczenie opcji stawiania miejsca wylotu prawym guzikiem}
   if (guzik[2]) and (mmy<200-ekr.menuwys) and (celow.opcja=6) then begin{mazanie scian}
      if rysowanie.jakrys<=1 then begin
         if rysowanie.ksztalt=0 then rysuj(mmx+ekr.x,mmy+ekr.y,0)
                                else rysuj_kwad(mmx+ekr.x,mmy+ekr.y,0);
      end
         else rysujelement(mmx+ekr.x,mmy+ekr.y,3);
      end;
   if (zmiana[4]<=5) and (((celow.opcja>=1) and (celow.opcja<=5)) or {pokazuj znacznik miejsca wylotu postaci}
      ((ekr.ktore_menu=5) and (ekr.opcja_menu>0) and (grupy[ekr.opcja_menu-1].wylot))) then begin
      if ((grupy[ekr.opcja_menu-1].wylx>319+ekr.x) or (grupy[ekr.opcja_menu-1].wylx<ekr.x) or
        (grupy[ekr.opcja_menu-1].wyly>199-ekr.menuwys+ekr.wy) or (grupy[ekr.opcja_menu-1].wyly<ekr.wy)) then begin
         b:=grupy[ekr.opcja_menu-1].wylx-ekr.x;
         c:=grupy[ekr.opcja_menu-1].wyly-ekr.wy;
         if b<0 then b:=0;
         if b>319 then b:=319;
         if c<0 then c:=0;
         if c>199-ekr.menuwys then c:=199-ekr.menuwys;
         maskpic3xms(b-2,c-2,5,5,0,kgrup[ekr.opcja_menu-1]+4,offsety[27]+165,scr^,true);
      end else
      maskpicxms(grupy[ekr.opcja_menu-1].wylx-ekr.x-2,
              grupy[ekr.opcja_menu-1].wyly-ekr.wy-2,5,5,0,
              offsety[27]+25*(ekr.opcja_menu-1),scr^,1,true);
   end;
   if ((guzik[1]) or (guzik[2])) and (mmy>199-ekr.menuwys) then wybor_zmenu;
   if trybgry then ustawienia_dla_trybu_gry;

   if (celow.temp>0) and (zmiana[1]=0) then dec(celow.temp);

{paczki}
   if kfg.zwierz then zwierzatka;
   postaci;
   if kfg.miecho then miesko;
   kowadla;
   pociski;
   miny;
   if rejlgan.czas>0 then rysuj_rejlgana;
   if kfg.syfki then syfki;
   if not kfg.dzieci then zasychanie_kapanie_krwi;
   if kfg.dym_wyb then begin
      dymy;
      wybuchy;
   end;

   if pogoda.dziura=2 then woda;
   if (pogoda.dziura in [2,4]) and (kfg.bomble) then begin
      bombelki;
      if (NOT PAUZA) AND (random(20)=0) then nowybom(random(maxx),maxy);
   end;
   if pogoda.dziura=4 then kwas;

   if pogoda.dziura=3 then lawa;

   if (not celow.strzela)  {skroc spowrotem dlugosc pradu jak nie strzelasz}
      then begin
      ust_broni.prad.dlug:=0;
      if ust_broni.wentyl.sila>0 then
         ust_broni.wentyl.sila:=ust_broni.wentyl.sila-0.3;
      if (ust_broni.wentyl.sila>=-0.2) and (ust_broni.wentyl.sila<=0.2) then
         ust_broni.wentyl.sila:=0;
   end;
   if (celow.strzela) and (guzik[1]) and (celow.bron=11) and ((abs(smx2-smx)>20) or (abs(smy2-smy)>20)) and
      (celow.jest_pochodnia=0) then begin
      StartSound(Sound[22],false,9,10); {dzwiek przesuwania lasera}
      celow.jest_pochodnia:=10;
   end;
   if (ciagle_dzwieki[2]=1) and ((not celow.strzela) or (celow.bron<>8)) then begin
      ciagle_dzwieki[2]:=0;stopSound(5); {wylacz dzwiek miotacza jak juz nie strzelasz}
   end;
   if (ciagle_dzwieki[4]=1) and ((not celow.strzela) or (celow.bron<>11)) then begin
      ciagle_dzwieki[4]:=0;stopSound(5); {wylacz dzwiek lasera jak juz nie strzelasz}
   end;
   if (ciagle_dzwieki[5]=1) and ((not celow.strzela) or (celow.bron<>12)) then begin
      ciagle_dzwieki[5]:=0;stopSound(5); {wylacz dzwiek pradu jak juz nie strzelasz}
   end;


   if (celow.bron=16) and (ciagle_dzwieki[6]=0) and
      (ciagle_dzwieki[7]=0) and (ciagle_dzwieki[8]=0) then startSound(sound[40],false,5,5);
   if (ciagle_dzwieki[6]=1) and ((not celow.strzela) or (celow.bron<>16)) then begin
      ciagle_dzwieki[6]:=0;stopSound(13); {wylacz dzwiek pily jak juz nie trzymasz guzika}
   end;
   if (ciagle_dzwieki[7]=1) and ((celow.strzela) or (celow.bron<>16)) then begin
      ciagle_dzwieki[7]:=0;stopSound(13); {wylacz dzwiek pily jak trzymasz guzik}
   end;
   if (ciagle_dzwieki[8]=1) and (celow.strzela) and (pilatnie=0) then begin
      ciagle_dzwieki[8]:=0;stopSound(13); {wylacz dzwiek pily tnacej kolesia}
      if startSound(sound[39],true,13,13) then ciagle_dzwieki[6]:=1; {wlacz dzwiek pily tnacej}
   end;

   if (ciagle_dzwieki[7]=0) and (not celow.strzela) and (celow.bron=16) then begin
      if startSound(sound[38],true,13,13) then ciagle_dzwieki[7]:=1; {wlacz dzwiek pily nietnacej}
   end;
   if (ciagle_dzwieki[6]=0) and (celow.strzela) and (celow.bron=16) and (pilatnie=0) then begin
      if startSound(sound[39],true,13,13) then ciagle_dzwieki[6]:=1; {wlacz dzwiek pily tnacej}
   end;
   if (ciagle_dzwieki[8]=0) and (celow.strzela) and (celow.bron=16) and (pilatnie>0) then begin
      if startSound(sound[41],true,13,13) then ciagle_dzwieki[8]:=1; {wlacz dzwiek pily tnacej kolesia!}
   end;


   {pogoda}
   if (kfg.opady) and ((pogoda.il_sniegu>0) or ((pogoda.snieg) or (pogoda.deszcz) or (pogoda.deszczkrwi))) then opady(0);
   pogoda.bylo_sniegu:=pogoda.il_sniegu;
   if (pogoda.autowiatr) and (zmiana[4]=0) and (random(3)=0) then begin
      pogoda.wiatr:=pogoda.wiatr+random(3)-1;
      if pogoda.wiatr<-30 then pogoda.wiatr:=-30;
      if pogoda.wiatr>30 then pogoda.wiatr:=30;
      if pogoda.wiatr<pogoda.wtrgrl then inc(pogoda.wiatr);
      if pogoda.wiatr>pogoda.wtrgrp then dec(pogoda.wiatr);
   end;
   if (pogoda.autoopady) and (zmiana[4]=0) and (random(3)=0) then begin
      pogoda.wielkopadow:=pogoda.wielkopadow+random(3)-1;
      if pogoda.wielkopadow<0 then pogoda.wielkopadow:=0;
      if pogoda.wielkopadow>50 then pogoda.wielkopadow:=50;
      if pogoda.wielkopadow<pogoda.wlkopgrl then inc(pogoda.wielkopadow);
      if pogoda.wielkopadow>pogoda.wlkopgrp then dec(pogoda.wielkopadow);
   end;
   if (NOT PAUZA) AND (pogoda.burza) and (random(200)=0) then piorun(random(1280),0);
   if pogoda.jest_piorun>0 then begin pokaz_piorun;IF NOT PAUZA THEN dec(pogoda.jest_piorun);end;
   if (NOT PAUZA) AND (piorun_w_wode>0) then dec(piorun_w_wode);
   if (kfg.odglosy_deszczu) and ((pogoda.deszcz) or (pogoda.deszczkrwi)) and
      (ciagle_dzwieki[3]=0) then begin
      if StartSound(Sound[17], true,14,14) then ciagle_dzwieki[3]:=1;
   end;
   if (kfg.odglosy_deszczu) and (ciagle_dzwieki[3]=1) and
      ((not pogoda.deszcz) and (not pogoda.deszczkrwi)) then begin
      ciagle_dzwieki[3]:=0;stopSound(14);
   end;
   {E pogoda}
   if (NOT PAUZA) AND (pogoda.trzesienieziemi>0) then begin
      trzesienie_ziemi;
      dec(pogoda.trzesienieziemi);
   end;

   sprawdzaj_czy_trzeba_nowych_postaci;

   if (celow.ktorycel>0) then begin {przesun celownik na postac jesli wybrana lub go usun}
      if post^[celow.ktorycel].jest then begin {ustaw}
         celow.celx:=trunc(post^[celow.ktorycel].x);
         celow.cely:=trunc(post^[celow.ktorycel].y);
      end else celow.ktorycel:=0;
   end;
   if (celow.bron=10) and (kfg._co_klatke>=kfg.co_klatke) then begin {pokaz celownik pociskow samonaprowadz.}
      if ((celow.celx>319+ekr.x) or (celow.celx<ekr.x) or
         (celow.cely>199-ekr.menuwys+ekr.wy) or (celow.cely<ekr.wy)) then begin
         b:=celow.celx-ekr.x;
         c:=celow.cely-ekr.wy;
         if b<0 then b:=0;
         if b>319 then b:=319;
         if c<0 then c:=0;
         if c>199-ekr.menuwys then c:=199-ekr.menuwys;
         maskpic3xms(b-2,c-2,5,5,0,36,offsety[27]+165,scr^,true);
      end else
         maskpicxms(celow.celx-ekr.x-10,celow.cely-ekr.wy-10,21,21,0,offsety[4]+5733,scr^,1,false);
   end;
{   pokaz_menu_na_dole;                                         }

   {zaznaczanie postaci}
   if (kl[56]) and (not celow.zaznacza) then begin {jesli wciskasz alt to zacznij zaznaczac}
      celow.x1:=mmx+ekr.x;
      celow.y1:=mmy+ekr.y;
      celow.zaznacza:=true;
   end;
   if (kl[56]) and (celow.zaznacza) then begin {trzymasz alt-pokazuj ramke}
      celow.x2:=mmx+ekr.x;
      celow.y2:=mmy+ekr.y;
      scr_y2:=199-ekr.menuwys;
      ebar(celow.x1-ekr.x,celow.y1-ekr.y,celow.x2-ekr.x,celow.y2-ekr.y,159);
      scr_y2:=199;
   end;
   if (not kl[56]) and (celow.zaznacza) then begin {puszczasz alt-zaznacz/odznacz}
      celow.zaznacza:=false;
      if celow.x1>celow.x2 then begin
         a:=celow.x1;
         celow.x1:=celow.x2;
         celow.x2:=a;
      end;
      if celow.y1>celow.y2 then begin
         a:=celow.y1;
         celow.y1:=celow.y2;
         celow.y2:=a;
      end;

      if kl[29] then b:=1 else b:=0; {jesli trzymasz ctrl to dodawaj zazn}

      for a:=1 to maxpost do
          if (post^[a].jest) and
             (post^[a].x>=celow.x1-5) and
             (post^[a].x<=celow.x2+5) and
             (post^[a].y>=celow.y1-5) and
             (post^[a].y<=celow.y2+5) then begin post^[a].zazn:=true;ekr.ktore_menu:=2;end
                                   else if b=0 then post^[a].zazn:=false;
   end;
   if (kl[78]) and (not klw[78]) then begin {zaznaczanie +}
      for a:=1 to maxpost do
          if (post^[a].jest) and
             (post^[a].x>=mmx+ekr.x-5) and
             (post^[a].x<=mmx+ekr.x+5) and
             (post^[a].y>=mmy+ekr.y-5) and
             (post^[a].y<=mmy+ekr.y+5) then begin
             if not post^[a].zazn then begin
                post^[a].zazn:=true;
                ekr.ktore_menu:=2;
                a:=maxpost;
             end;
             end;
      klw[78]:=true;
   end;
   if not kl[78] then klw[78]:=false;

   if (kl[74]) and (not klw[74]) then begin {odznaczanie -}
      for a:=1 to maxpost do
          if (post^[a].jest) and
             (post^[a].x>=mmx+ekr.x-5) and
             (post^[a].x<=mmx+ekr.x+5) and
             (post^[a].y>=mmy+ekr.y-5) and
             (post^[a].y<=mmy+ekr.y+5) then begin
             if post^[a].zazn then begin
                post^[a].zazn:=false;
                a:=maxpost;
             end;
             end;
      klw[74]:=true;
   end;
   if not kl[74] then klw[74]:=false;

   {E zaznaczanie postaci}
   {lapanie postaci kursorem}
   if ({(kl[42]) or }(kl[54])) and (celow.nie_lap_ludzi=0) then begin {trzymasz shift}
      for a:=1 to maxpost do
          if (post^[a].jest) and (not post^[a].trzymany) and
             (post^[a].x>=mmx+ekr.x-6) and
             (post^[a].x<=mmx+ekr.x+6) and
             (post^[a].y>=mmy+ekr.y-6) and
             (post^[a].y<=mmy+ekr.y+6) then post^[a].trzymany:=true;
      if zmiana[1]=0 then for a:=1 to maxpacz do
          if (pacz^[a].jest) and (not pacz^[a].trzymany) and
             (pacz^[a].y>=0) and (pacz^[a].x>=0) and
             (pacz^[a].x shr 10>=mmx+ekr.x-6) and
             (pacz^[a].x shr 10<=mmx+ekr.x+6) and
             (pacz^[a].y shr 10>=mmy+ekr.y-6) and
             (pacz^[a].y shr 10<=mmy+ekr.y+6) then begin
             bol:=false;
             for b:=0 to 9 do begin
                 xms2mem(_xms[1].h,offsety[2]+
                          (longint(pacz^[a].y shr 10)+longint(b)-5)*maxx+
                           (pacz^[a].x shr 10)-5,paczbuf,10);
                 for c:=0 to 9 do if paczbuf[c]=0 then begin c:=9;b:=9;bol:=true end;
             end;
             if bol then pacz^[a].trzymany:=true;
             end;
      celow.lapie:=true
   end else celow.lapie:=false;

   bol:=false;
   for a:=1 to maxpost do {przesuwaj postaci za kursorem}
       if (post^[a].jest) and (post^[a].trzymany) then begin
          if post^[a].palisie then bol:=true;
          post^[a].x:=mmx+ekr.x;
          post^[a].y:=mmy+ekr.y;
          if smx2-smx=0 then post^[a].dx:=post^[a].dx/3
                        else post^[a].dx:=post^[a].dx+(smx2-smx) div 40;
          if smy2-smy=0 then post^[a].dy:=post^[a].dy/3
                        else post^[a].dy:=post^[a].dy+(smy2-smy) div 40;

          if (bol) and (celow.jest_pochodnia=0) and ((smx2-smx>10) or (smx2-smx>10)) then begin
             StartSound(Sound[13],false,5,5);
             celow.jest_pochodnia:=10;
          end;
          if (post^[a].rany=0) and (random(100)=0) then
          if (pogoda.dziura>=2) and (post^[a].y>=pogoda.pozwody) then post^[a].corobi:=7
             else post^[a].corobi:=4;
       end;

   for a:=1 to maxpacz do {przesuwaj paczki za kursorem}
       if (pacz^[a].jest) and (pacz^[a].trzymany) then begin
          pacz^[a].x:=(mmx+ekr.x)*1024;
          pacz^[a].y:=(mmy+ekr.y)*1024;
          pacz^[a].dy:=0;
{          if smx2-smx=0 then pacz^[a].dx:=pacz^[a].dx/3
                        else pacz^[a].dx:=pacz^[a].dx+(smx2-smx) div 40;
          if smy2-smy=0 then pacz^[a].dy:=pacz^[a].dy/3
                        else pacz^[a].dy:=pacz^[a].dy+(smy2-smy) div 40;}
       end;

   if ({(kl[42]) or }(kl[54])) and (kl[29]) then begin {wciskasz ctrl-rzuc nimi}
      for a:=1 to maxpost do {przesuwaj postaci za kursorem}
          if (post^[a].jest) and (post^[a].trzymany) then begin
             post^[a].trzymany:=false;
             post^[a].dx:=_sin(trunc(celow.kat))*celow.sila/5-(0.2+random/2.5);
             post^[a].dy:=-_cos(trunc(celow.kat))*celow.sila/5-(0.2+random/2.5);
          end;
      celow.nie_lap_ludzi:=6;
      if (bol) and (celow.sila>=10) then begin {dzwiek pochodni przy rzucie plonacymi}
         StartSound(Sound[13],false,5,5);
         celow.jest_pochodnia:=10;
      end;
   end;

   if ((not kl[42]) and (not kl[54])) then begin{puszczasz shift-pusc ich}
      for a:=1 to maxpost do if post^[a].jest then post^[a].trzymany:=false;
      for a:=1 to maxpacz do if pacz^[a].jest then pacz^[a].trzymany:=false;
      celow.nie_lap_ludzi:=0;
   end;
   if celow.nie_lap_ludzi>0 then dec(celow.nie_lap_ludzi);
   if celow.jest_pochodnia>0 then dec(celow.jest_pochodnia);
   {E lapanie postaci kursorem}

   if (klik[2]) and (not guzik[1]) and (mmy<200-ekr.menuwys) and (celow.bron=14) then begin {usuwanie min}
      for a:=maxmin downto 1 do
          if (min^[a].jest) and
             (min^[a].x shr 10>=mmx+ekr.x-3) and
             (min^[a].x shr 10<=mmx+ekr.x+3) and
             (min^[a].y shr 10>=mmy+ekr.y-3) and
             (min^[a].y shr 10<=mmy+ekr.y+3) then begin
                min^[a].jest:=false;
                a:=1
          end;
   end;

   IF kfg._co_klatke>=kfg.co_klatke then BEGIN
      {rysowanie kursora myszy}
      if (celow.opcja=6) and (mmy<200-ekr.menuwys) then begin
         if rysowanie.jakrys<=1 then begin {rysowanie przezr.kolka do rysowania}
            if rysowanie.ksztalt=0 then T_cir(mmx,mmy)
                                   else begin
               a:=mmy+rysowanie.rozm-1;
               if a>199-ekr.menuwys then a:=199-ekr.menuwys;
               barT(mmx-rysowanie.rozm,mmy-rysowanie.rozm,
                                             mmx+rysowanie.rozm-1,a,
                                             kolter[rysowanie.kolor],scr^,chmur^);
               end
         end
                                else rysujelement(mmx,mmy,1); {rys.elementow}
      end;
   end;

   if (celow.lupa) and (kfg._co_klatke>=kfg.co_klatke) and (mmy<200-ekr.menuwys) then
      lupa_zumuj(mmx,mmy);

   pokaz_menu_na_dole;
   if (kfg.zakladki) and ((ekr.jak_menu>0) or (ekr.menuwys>0)) then for a:=0 to 5 do
       if a<>ekr.ktore_menu then
       maskpicxms(1+a*31,199-ekr.menuwys-6,30,7,0, offsety[19]+13020+a*510, scr^,1,false)
       else
       maskpicxms(1+a*31,199-ekr.menuwys-7,30,9,0, offsety[19]+13260+a*510, scr^,1,false);

   {obracanie celownika i zmiana sily}
   a:=0;
   if (guzik[2]) and (mmy<200-ekr.menuwys) and (((celow.opcja=0) and
      (not (celow.bron in [7,9,15,16,103..105,108..110]))) or (celow.lapie)) then begin {obracanie celownika i zmiana sily}
      celow.kat:=celow.kat+(smx2-smx) div 2;
      while celow.kat>=360 do dec(celow.kat,360);
      while celow.kat<0 do inc(celow.kat,360);
      celow.sila:=celow.sila-(smy2-smy) div 2;
      if celow.sila<0 then celow.sila:=0;
      if celow.sila>99 then celow.sila:=99;
      a:=1;
   end;
   if (kl[71]) then begin
      inc(celow.sila,2);
      if celow.sila>99 then celow.sila:=99;
      a:=1;
   end;
   if (kl[79]) then begin
      dec(celow.sila,2);
      if celow.sila<0 then celow.sila:=0;
      a:=1;
   end;
   if (kl[83]) then begin
      dec(celow.kat,2);
      if celow.kat<0 then inc(celow.kat,360);
      a:=1;
   end;
   if (kl[81]) then begin
      inc(celow.kat,2);
      if celow.kat>=360 then dec(celow.kat,360);
      a:=1;
   end;
   if (a=1) and (kfg.kursorwidac) then begin
      piszm(mmx-7,mmy+6,l2t(celow.kat,3)+'`',23);
      piszm(mmx-7,mmy+12,'S:'+l2t(celow.sila,2),23);
   end;
   {E obracanie celownika i zmiana sily}


   if (kfg.liczniki) and (kfg._co_klatke>=kfg.co_klatke) then begin
         if kfg.gdzielicznik=0 then a:=1+ord(trybgry)*10
                               else a:=182-ekr.menuwys;
         piszm(280,a,l2t(il_trupow-il_trup_et,10),23);
         piszm(280,a+6,l2t(il_trupow,10),23);
         piszm(280,a+12,l2t(punkty,10),23);
         for b:=0 to 2 do
             maskpicxms(272,a+b*6,7,5,0,offsety[19]+11000+b*35,scr^,1,false);
   end;

   if kfg.komentarze then begin
      komentarze; {pokaz komentarze}
      zlosliwe_komentarze;
   end;

   sprawdzaj_bonusy;

   if (trybgry) and (zmiana[3]=0) then dec(tr_gry.czas);

   IF kfg._co_klatke>=kfg.co_klatke then BEGIN
      if trybgry then begin {rysowanie amunicji itp}
         bart(0,0,319,9,2,scr^,chmur^);
         if ((tr_gry.czas<=150) and (zmiana[4]>=4)) then a:=8 else a:=0;
         fillchar(scr^[7,2],trunc((tr_gry.czas*100)/960) ,23-a);
         fillchar(scr^[8,2],trunc((tr_gry.czas*100)/960) ,18-a);
         for a:=0 to 11 do begin
             maskpicxms(a*26+7,1,7,5,0,offsety[19]+11105+a*35,scr^,1,false);
             piszm(a*26+15,1,l2t(tr_gry.amun[a],3),23);
         end;
      end;
      if kfg.tultips then tultipsy; {pokaz tultipsy}

     {ikony broni
      if celow.bron<=8 then
         maskpicxms(0,0,25,25,0,offsety[29]+longint(celow.bron)*625,scr^,1,false);
     {-}

      if trybgry then begin
         if kfg.gdzielicznik=0 then a:=1+ord(trybgry)*10
                               else a:=182-ekr.menuwys;
         piszm(9,a,l2t((il_trupow-il_trup_et),10),15);
         piszm(9,a+6,l2t(tr_gry.jeszcze,10),15);
         piszm(9,a+12,l2t(punkty-tr_gry.bylopkt,10),15);
         for b:=0 to 2 do
             maskpic3xms(1,a+b*6,7,5,0,-9,offsety[19]+11000+b*35,scr^,false);
      end;
      if pauza then pisz(143,10,'PAUZA',(zmiana[5] div 5)*8);

      IF kfg.kursorwidac THEN BEGIN{rysowanie kursora myszy}
      if (celow.opcja>=1) and (celow.opcja<=5) then begin {rysuj znaczek miejsca wylotu na kursorze przy przenoszeniu}
         maskpicxms(mmx-2,mmy-2,5,5,0,offsety[27]+25*(celow.opcja-1),scr^,1,true);
         mysz.wygl:=1;
      end;
      if ((mysz.wygl=0) and (not (celow.bron in [7,9,15,16,103..105,108..110]))) or
         (celow.lapie) then {rysuj kropki do okraglego celownika}
         for a:=0 to 4 do
         putpix(mmx+trunc(_sin(trunc(celow.kat))*(6+celow.sila/15*a)),
                mmy-trunc(_cos(trunc(celow.kat))*(6+celow.sila/15*a)),35+a);
      if not (mysz.wygl in [1,14,15,26]) then begin{rysuj krzyzyk}
         maskpicxms(mmx-10,mmy-10,21,21,0,offsety[4]+441*mysz.wygl,scr^,1,false);
         if celow.temp>0 then putpix(mmx,mmy,15);
      end;
      if mysz.wygl=1 then {rysuj mysz strzalke}
         maskpicxms(mmx,mmy,21,21,0,offsety[4]+441*mysz.wygl,scr^,1,false);
      if mysz.wygl=14 then {rysuj mysz pile}
         maskpicxms(mmx-1,mmy-1,39,31,0,offsety[4]+12000+1209*((zmiana[4] shr 1) mod 2),scr^,1,false);
      if ((mysz.wygl=0) and (not (celow.bron in [7,9,15,16,103..105,108..110]))) or
         (celow.lapie) then {rysuj okragly celownik}
         maskpicxms((mmx-10)+trunc(_sin(trunc(celow.kat))*(6+celow.sila/3)),
                 (mmy-10)-trunc(_cos(trunc(celow.kat))*(6+celow.sila/3)),
                 21,21,0,offsety[4]+441*3,scr^,1,false);
      END;{E rysowanie kursora myszy}

      move2(Scr^,mem[$A000:0000]); {rysuj na mem[$A000:0] :)}
      kfg._co_klatke:=0;
   end;
   inc(kfg._co_klatke);
   while keypressed do readkey;
   if (kl[1]) and (not klw[1]) then _menu:=true;
   if not kl[1] then klw[1]:=false;
   if (not kfg.wstrzasy_ekranu) and (ekr.skok>0) then ekr.skok:=0;

   if (kfg.fejdyekranu) and (ekr.fejd>0) then begin
      for a:=1 to 255 do begin
          pal[a,0]:=pal_gl[a,0]+ekr.fejd;if pal[a,0]>63 then pal[a,0]:=63;
          pal[a,1]:=pal_gl[a,1]+ekr.fejd;if pal[a,1]>63 then pal[a,1]:=63;
          pal[a,2]:=pal_gl[a,2]+ekr.fejd;if pal[a,2]>63 then pal[a,2]:=63;
      end;
      cala_paleta(false);
      dec(ekr.fejd);
   end;

   if (kl[87]) and (not klw[87]) then begin {mega screen shot F11}
      klw[87]:=true;
      megaskrinszot;
   end;
   if not kl[87] then klw[87]:=false;

   if (kl[88]) and (not klw[88]) then begin {screen shot F12}
      klw[88]:=true;
      shot;
   end;
   if not kl[88] then klw[88]:=false;

   if (trybgry) and (tr_gry.czas<=0) then _pogrze:=true;

   czekaj(1); {wyrownaj predkosc}
until (_wyjscie) or (_menu) or (_pogrze);
klw[1]:=true;

stopSound(5);
stopSound(11);
stopSound(12);
stopSound(13);
stopSound(14);

if _pogrze then podliczenie_po_grze;

move3(pal_gl,pal,sizeof(pal));
cala_paleta(false);
end;

{*}BEGIN
checkbreak:=false;
inicjujtimer;
pierwsze_sprawy;
if not ((paramcount>0) and (parametr(true,false,'BEZINTRO'))) then begin
   gad_intro;
   intro;
end;

wczytaj_wszystkie_postaci;
fillchar2(scr^,64000,0);
move(pal_gl,pal,sizeof(pal));
cala_paleta(false);
repeat
   _nowy:=false;
   _wyjscie:=false;
   menu;
   zapisz_kfg;
   zapisz_detale;
   if _nowy then begin nowyteren;resetuj_teren;end;
   fillchar(ciagle_dzwieki,sizeof(ciagle_dzwieki),0);
   if not _wyjscie then gra;
   fillchar(ciagle_dzwieki,sizeof(ciagle_dzwieki),0);
until _wyjscie;

ostatnie_sprawy;
zakoncztimer;
end.