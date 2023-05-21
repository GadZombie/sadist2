{$N+}
unit resztki;

interface

{*}FUNCTION mysz_w(x1,y1,x2,y2:integer):boolean;
{*}PROCEDURE sprawdz_mysz;
{*}PROCEDURE czekaj_az_pusci_guziki;
{*}PROCEDURE zmiany;
{*}PROCEDURE sprawdz_zmiany_broni;
{*}PROCEDURE wybuch(sx,sy,rozm:integer; dziura,dzwiek,jeden_koles,zapala,rani:boolean);
{*}PROCEDURE dmuch(sx,sy:integer);
{*}PROCEDURE osmalenie(sx,sy,rozm:integer);
{*}PROCEDURE laser(sx,sy:integer;sdx,sdy:real);
{*}PROCEDURE rysuj_rejlgana;
{*}PROCEDURE strzel_mysza;
{*}PROCEDURE strzel_mysza2;
{*}PROCEDURE plum(sx:longint;szer,ile:integer;dx,sila:real);
{*}PROCEDURE piorun(px,py:integer);
{*}PROCEDURE pokaz_piorun;

implementation
uses crt,vars,glowne,dos,xms,maskp,myszunit,cosin,dzwieki2,SMix,nowe;

{liczenie dlugosci odcinka:
  i:=(sqr(11-x)+sqr(11-y));
   i:=abs(i);
   i:=round(sqrt(i));
------
   str(sqrt(abs(sqr(160-mmx)+sqr(100-mmy))):0:10,wyr); }

{---myszka---}
{*}FUNCTION mysz_w(x1,y1,x2,y2:integer):boolean;
begin
if (mmx>=x1) and (mmx<=x2) and (mmy>=y1) and (mmy<=y2) then mysz_w:=true
                                                       else mysz_w:=false;
end;

{*}PROCEDURE sprawdz_mysz;
var
a:byte;
button:integer;
begin
Smx:=mmx*2;Smy:=mmy;
sprawdzstanmyszy(button,mmx,mmy);
Smx2:=mmx;Smy2:=mmy;
if (guzik[2]) and ((mmy<200-ekr.menuwys) or (Smy div 2<200-ekr.menuwys))
   and (((celow.opcja=0) and (not (celow.bron in [7,9,15,16,103..105,108..110]))) or (celow.lapie)) then begin
   ustawpozycjemyszy(Smx,Smy);mmx:=Smx;mmy:=Smy;end;
if button=0 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=false;guzik[2]:=false;end;
if button=1 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=true ;guzik[2]:=false;end;
if button=2 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=false;guzik[2]:=true ;end;
if button=3 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=true ;guzik[2]:=true ;end;
for a:=1 to 2 do begin
    if (not Sguzik[a]) and (guzik[a]) then begin
       klik[a]:=true;doklik[a]:=40;
       if dodwuklik[a]=0 then dodwuklik[a]:=10;
    end
        else klik[a]:=false;

    if (klik[a]) and (dodwuklik[a]>=1) and (dodwuklik[a]<=9) then begin
       dwuklik[a]:=true;
       dodwuklik[a]:=0
    end
       else dwuklik[a]:=false;
    if dodwuklik[a]>0 then dec(dodwuklik[a]);

    if not guzik[a] then begin doklik[a]:=0;juzklik[a]:=0;end;
    if doklik[a]>0 then dec(doklik[a]);
    if (doklik[1]>0) and (a=1) and (celow.bron in [14,106]) then celow.temp:=2;
    if doklik[a]=1 then begin
       klik[a]:=true;
       if juzklik[a]>=10 then doklik[a]:=3
                         else begin doklik[a]:=10;inc(juzklik[a]);end;
    end;

end;
if (klik[1]) and (celow.bron in [14,106]) then celow.temp:=0;
mmx:=mmx div 2;
mmy:=mmy;
end;

{*}PROCEDURE czekaj_az_pusci_guziki;
begin
repeat
  sprawdz_mysz;
until (not guzik[1]) and (not guzik[2]);
end;
{--E-myszka---}

{*}PROCEDURE zmiany;
begin
{zmiana[0]:=0}
inc(zmiana[1]);if zmiana[1]>=3 then zmiana[1]:=0;
inc(zmiana[2]);if zmiana[2]>=2 then zmiana[2]:=0;
inc(zmiana[3]);if zmiana[3]>=5 then zmiana[3]:=0;
inc(zmiana[4]);if zmiana[4]>=10 then zmiana[4]:=0;

if zmiana[1]=0 then begin
   inc(zmiana[5]);if zmiana[5]>=10 then zmiana[5]:=0;
end;
end;

{*}PROCEDURE sprawdz_zmiany_broni;
var a:byte;
begin
if (kl[59]) and (not klw[59]) then begin
   klw[59]:=true;
   inc(celow.bron);if celow.bron>=20 then celow.bron:=0;
end;
{if (kl[104]) and (not klw[104]) then begin
   klw[104]:=true;
   inc(celow.bron);if (celow.bron>=109) or (celow.bron<100) then celow.bron:=100;
end;}

if (kl[60]) and (not klw[60]) then begin
   klw[60]:=true;
   celow.lupa:=not celow.lupa;
end;
if (kl[61]) and (not klw[61]) then begin
   klw[61]:=true;
   kfg.kursorwidac:=not kfg.kursorwidac;
end;

for a:=59 to 61 do if not kl[a] then klw[a]:=false;
{if not kl[104] then klw[104]:=false;}
end;

{*}PROCEDURE wybuch(sx,sy,rozm:integer; dziura,dzwiek,jeden_koles,zapala,rani:boolean);
const
wwwyb:array[0..2] of byte=(0,1,3);
var
a,a2,b,x,y,d,d2,prozm,sfx,_rozm:integer;
buf,bylo:array[0..maxy-1] of byte;
k1,k2,kp:real;
gx:byte;
s1,s2:single;

   {+}PROCEDURE mnowysyf(sx,sy:integer;sdx,sdy:real;skol,skon:byte);
   begin
   IF kfg.syfki then BEGIN
      if (sx>=0) and (sx<maxx) and (sy>=0) and (sy<maxy) then begin
      if (sdx>0) and (sdx<0.5) then sdx:=0.5;
      if (sdx<0) and (sdx>-0.5) then sdx:=-0.5;
      if (sdy>0) and (sdy<0.5) then sdy:=0.5;
      if (sdy<0) and (sdy>-0.5) then sdy:=-0.5;
      nowysyf(sx,sy,sdx,sdy,skol,2,true,0,0,random(3));
   end;
   END;
   end;

begin
IF NOT PAUZA THEN BEGIN
if rozm>50 then rozm:=50;
if dzwiek then StartSound(Sound[random(3)], false,2,4);
x:=0;
prozm:=rozm div 2;
y:=rozm;
d:=3-2*rozm;
fillchar2(bylo,maxy,0);
IF dziura THEN BEGIN {DZIURA}
repeat
if (sy+y>=0) and (sy+y<maxy) and ((sx+x)-(sx-x)>=1) and (bylo[sy+y]=0) then begin
  xms2mem(_xms[1].h,offsety[2]+(longint(sy)+longint(y))*maxx+sx-x,buf,x*2+1);
  IF x mod 3=0 then begin
    sfx:=0;
    while sfx<x*2 do begin
        if not (buf[sfx] in [0,160..167]) then mnowysyf(sx-x+sfx,sy+y,(random*rozm-prozm)/7,(random*rozm-prozm)/7,buf[sfx],0);
        inc(sfx,3);
    end;
  END;
  for a2:=0 to x*2 do if (a2+sx-x>=0) and (a2+sx-x<maxx) and ((buf[a2]<160) or (buf[a2]>167)) then buf[a2]:=0;
  mem2xms(buf,_xms[1].h,offsety[2]+(longint(sy)+longint(y))*maxx+sx-x,x*2+1);
  {hline_x(sx-x,sx+x,sy+y,0);}
  bylo[sy+y]:=1;
end;

if (sy-y>=0) and (sy-y<maxy) and ((sx+x)-(sx-x)>=1) and (bylo[sy-y]=0) then begin
  xms2mem(_xms[1].h,offsety[2]+(longint(sy)-longint(y))*maxx+sx-x,buf,x*2+1);
  IF x mod 3=0 then begin
    sfx:=0;
    while sfx<x*2 do begin
        if not (buf[sfx] in [0,160..167]) then mnowysyf(sx-x+sfx,sy-y,(random*rozm-prozm)/7,(random*rozm-prozm)/7,buf[sfx],0);
        inc(sfx,3);
    end;
  END;
  for a2:=0 to x*2 do if (a2+sx-x>=0) and (a2+sx-x<maxx) and (buf[a2]<160) or (buf[a2]>167) then buf[a2]:=0;
  mem2xms(buf,_xms[1].h,offsety[2]+(longint(sy)-longint(y))*maxx+sx-x,x*2+1);
  {hline_x(sx-x,sx+x,sy-y,0);}
  bylo[sy-y]:=1;
end;

if (sy+x>=0) and (sy+x<maxy) and ((sx+y)-(sx-y)>=1) and (bylo[sy+x]=0) then begin
  xms2mem(_xms[1].h,offsety[2]+(longint(sy)+longint(x))*maxx+sx-y,buf,y*2+1);
  IF x mod 3=0 then begin
    sfx:=0;
    while sfx<y*2 do begin
        if not (buf[sfx] in [0,160..167]) then mnowysyf(sx-y+sfx,sy+x,(random*rozm-prozm)/7,(random*rozm-prozm)/7,buf[sfx],0);
        inc(sfx,3);
    end;
  END;
  for a2:=0 to y*2 do if (a2+sx-y>=0) and (a2+sx-y<maxx) and (buf[a2]<160) or (buf[a2]>167) then buf[a2]:=0;
  mem2xms(buf,_xms[1].h,offsety[2]+(longint(sy)+longint(x))*maxx+sx-y,y*2+1);
  {hline_x(sx-y,sx+y,sy+x,0);}
  bylo[sy+x]:=1;
end;

if (sy-x>=0) and (sy-x<maxy) and ((sx+y)-(sx-y)>=1) and (bylo[sy-x]=0) then begin
  xms2mem(_xms[1].h,offsety[2]+(longint(sy)-longint(x))*maxx+sx-y,buf,y*2+1);
  IF x mod 3=0 then begin
    sfx:=0;
    while sfx<y*2 do begin
        if not (buf[sfx] in [0,160..167]) then mnowysyf(sx-y+sfx,sy-x,(random*rozm-prozm)/7,(random*rozm-prozm)/7,buf[sfx],0);
        inc(sfx,3);
    end;
  END;
  for a2:=0 to y*2 do if (a2+sx-y>=0) and (a2+sx-y<maxx) and (buf[a2]<160) or (buf[a2]>167) then buf[a2]:=0;
  mem2xms(buf,_xms[1].h,offsety[2]+(longint(sy)-longint(x))*maxx+sx-y,y*2+1);
  {hline_x(sx-y,sx+y,sy-x,0);}
  bylo[sy-x]:=1;
end;

inc(x);
if d>=0 then begin
   dec(y);
   d:=d+2*(2*x-2*y+1);
end else d:=d+2*(2*x+1)
until x>y;

for a:=2 downto 1 do begin
   x:=0;
   y:=rozm+a;
   d:=3-2*rozm;
   fillchar2(bylo,maxy,0);
   repeat
     if (sy+y>=0) and (sy+y<maxy) and ((sx+x)-(sx-x)>=1) and (bylo[sy+y]=0) then begin
       hline_ciem_x(sx-x,sx+x,sy+y,0);bylo[sy+y]:=1;
     end;
     if (sy-y>=0) and (sy-y<maxy) and ((sx+x)-(sx-x)>=1) and (bylo[sy-y]=0) then begin
       hline_ciem_x(sx-x,sx+x,sy-y,0);bylo[sy-y]:=1;
     end;
     if (sy+x>=0) and (sy+x<maxy) and ((sx+y)-(sx-y)>=1) and (bylo[sy+x]=0) then begin
       hline_ciem_x(sx-y,sx+y,sy+x,0);bylo[sy+x]:=1;
     end;
     if (sy-x>=0) and (sy-x<maxy) and ((sx+y)-(sx-y)>=1) and (bylo[sy-x]=0) then begin
       hline_ciem_x(sx-y,sx+y,sy-x,0);bylo[sy-x]:=1;
     end;

     inc(x);
     if d>=0 then begin
        dec(y);
        d:=d+2*(2*x-2*y+1);
     end else d:=d+2*(2*x+1)
   until x>y;
end;
END; {DZIURA}

if (zapala) or (rani) then {uszkodz postacie :)}
for a:=maxpost downto 1 do begin
    if (post^[a].jest) and
       (post^[a].x>=sx-rozm*2.5) and
       (post^[a].x<=sx+rozm*2.5) and
       (post^[a].y>=sy-rozm*2.5) and
       (post^[a].y<=sy+rozm*2.5) then begin
       wystrzelone:=0;
       while (post^[a].x=sx) and (post^[a].y=sy) do begin
          post^[a].x:=post^[a].x-0.1+random/5; {jesli postac jest dokladnie w centrum             }
          post^[a].y:=post^[a].y-0.1+random/5; {wybuchu, to przesun ja troche, zeby nie bylo RE207}
       end;
       if rani then begin
          StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*post^[a].grupa+random(3)],false,15+a mod 5,15+a mod 5);
          kp:=sqrt(abs(sqr(post^[a].x-sx)+sqr(post^[a].y-sy)));
          k1:=(post^[a].x-sx)/kp;
          k2:=(post^[a].y-sy)/kp;
          d:=trunc(rozm*2.5-sqrt(abs(sqr(sx-post^[a].x)+sqr(sy-post^[a].y))));
          if d>0 then begin
             post^[a].dx:=post^[a].dx+k1*d/7;
             post^[a].dy:=post^[a].dy+k2*d/10;
             if post^[a].dx>10 then post^[a].dx:=10;
             if post^[a].dx<-10 then post^[a].dx:=-10;
             if post^[a].dy>10 then post^[a].dy:=10;
             if post^[a].dy<-10 then post^[a].dy:=-10;
          end;
          d:=5+trunc(rozm*2.5-sqrt(abs(sqr(sx-post^[a].x)+sqr(sy-post^[a].y))));
          if (d>0) and (not kfg.dzieci) then begin
             s1:=360/d/kfg.il_krwi;
             s2:=d/30;
             for b:=0 to trunc(d*kfg.il_krwi) do
              nowysyf(trunc(post^[a].x)-2+random(5),trunc(post^[a].y)-2+random(5),
                   _sin(trunc(b*s1))*(0.4+random*s2),
                   _cos(trunc(b*s1))*(0.4+random*s2),
                   grupy[post^[a].grupa].kolorkrwi.od+random(grupy[post^[a].grupa].kolorkrwi.ile)
                   ,1,true,0,0,random(2));
          end;
          {czasem przy wiekszym wybuchu oderwie konczyny lub glowe :)}
          if (d>=25) and (post^[a].rany=0) and (random(10-rozm div 5)=0) then begin
             post^[a].rany:=random(3)+1;
             case post^[a].rany of
                1: {oderwane rece}
                  for d2:=0 to 1 do
                  nowemieso(trunc(post^[a].x)-4+random(9),trunc(post^[a].y)-4+random(9),
                            random*4-2, random*2-1,
                            post^[a].grupa*4,post^[a].palisie);
                2: {oderwana noga}
                  nowemieso(trunc(post^[a].x)-4+random(9),trunc(post^[a].y)-4+random(9),
                            random*4-2, random*2-1,
                            1+post^[a].grupa*4,post^[a].palisie);
                3: {oderwana glowa}
                  nowemieso(trunc(post^[a].x)-4+random(9),trunc(post^[a].y)-4+random(9),
                            random*4-2, -random*2,
                            2+post^[a].grupa*4,post^[a].palisie);
             end;
          end;
          post^[a].corobi:=4;
          if post^[a].comarobic=5 then post^[a].comarobic:=0;
          post^[a].cotrzyma:=0;
          dec(post^[a].sila,d-2);
          inc(punkty,d-2);
       end;

       _rozm:=rozm;
       if rozm<10 then rozm:=10;
       d:=trunc(sqrt(abs(sqr(sx-post^[a].x)+sqr(sy-post^[a].y))));
       if (zapala) and (d<=rozm div 2) then post^[a].palisie:=true;
       rozm:=_rozm;
       if post^[a].sila<-3 then post^[a].sila:=-3;
       if jeden_koles then a:=1;
    end;
end;

for a:=maxpoc downto 1 do begin {rozwal pociski w zasiegu}
    if (poc^[a].jest) and
       (((poc^[a].wygl>=1) and (poc^[a].wygl<=3)) or (poc^[a].wygl=7)) and
       (poc^[a].x shr 10>=sx-rozm*1.5) and
       (poc^[a].x shr 10<=sx+rozm*1.5) and
       (poc^[a].y shr 10>=sy-rozm*1.5) and
       (poc^[a].y shr 10<=sy+rozm*1.5) then begin
       while (poc^[a].x shr 10=sx) and (poc^[a].y shr 10=sy) do begin
          poc^[a].x:=poc^[a].x-5+random(11); {jesli pocisk jest dokladnie w centrum             }
          poc^[a].y:=poc^[a].y-5+random(11); {wybuchu, to przesun go troche, zeby nie bylo RE207}
       end;
       kp:=sqrt(abs(sqr(poc^[a].x shr 10-sx)+sqr(poc^[a].y shr 10-sy)));
       k1:=(poc^[a].x shr 10-sx)/kp;
       k2:=(poc^[a].y shr 10-sy)/kp;
       d:=trunc(rozm*1.5-sqrt(abs(sqr(sx-poc^[a].x shr 10)+sqr(sy-poc^[a].y shr 10))));
       if d>0 then begin
          poc^[a].dx:=poc^[a].dx+trunc((k1*d/7)*1024);
          poc^[a].dy:=poc^[a].dy+trunc((k2*d/10)*1024);
       end;
       d:=trunc(rozm-sqrt(abs(sqr(sx-poc^[a].x shr 10)+sqr(sy-poc^[a].y shr 10))));
       if d>0 then poc^[a].czas:=3
    end;
end;

for a:=maxmin downto 1 do begin {zaktywizuj miny w zasiegu}
    if (min^[a].jest) and
       (min^[a].x shr 10>=sx-rozm*1.5) and
       (min^[a].x shr 10<=sx+rozm*1.5) and
       (min^[a].y shr 10>=sy-rozm*1.5) and
       (min^[a].y shr 10<=sy+rozm*1.5) then begin
       while (min^[a].x shr 10=sx) and (min^[a].y shr 10=sy) do begin
          min^[a].x:=min^[a].x-5+random(11); {jesli mina jest dokladnie w centrum               }
          min^[a].y:=min^[a].y-5+random(11); {wybuchu, to przesun ja troche, zeby nie bylo RE207}
       end;
       if dziura then begin {porusz tylko jak robi dziury}
          kp:=sqrt(abs(sqr(min^[a].x shr 10-sx)+sqr(min^[a].y shr 10-sy)));
          k1:=(min^[a].x shr 10-sx)/kp;
          k2:=(min^[a].y shr 10-sy)/kp;
          d:=trunc(rozm*1.5-sqrt(abs(sqr(sx-min^[a].x shr 10)+sqr(sy-min^[a].y shr 10))));
          if d>0 then begin
             min^[a].dx:=min^[a].dx+trunc((k1*d/7)*1024);
             min^[a].dy:=min^[a].dy+trunc((k2*d/10)*1024);
          end;
       end;

       d:=trunc(rozm*1.5-sqrt(abs(sqr(sx-min^[a].x shr 10)+sqr(sy-min^[a].y shr 10))));
       if (d>0) and (min^[a].czas=0) then min^[a].czas:=60+random(20);
    end;
end;

if (kfg.zwierz) and ((zapala) or (rani)) then
for a:=maxzwi downto 1 do begin {pierdolnij ptaszki w zasiegu}
    if (zwi^[a].jest) and
       (zwi^[a].x shr 10>=sx-rozm*1.5) and
       (zwi^[a].x shr 10<=sx+rozm*1.5) and
       (zwi^[a].y shr 10>=sy-rozm*1.5) and
       (zwi^[a].y shr 10<=sy+rozm*1.5) then begin
       wystrzelone:=0;
       while (zwi^[a].x shr 10=sx) and (zwi^[a].y shr 10=sy) do begin
          zwi^[a].x:=zwi^[a].x-5+random(11); {jesli zwierz jest dokladnie w centrum             }
          zwi^[a].y:=zwi^[a].y-5+random(11); {wybuchu, to przesun go troche, zeby nie bylo RE207}
       end;
       kp:=sqrt(abs(sqr(zwi^[a].x shr 10-sx)+sqr(zwi^[a].y shr 10-sy)));
       k1:=(zwi^[a].x shr 10-sx)/kp;
       k2:=(zwi^[a].y shr 10-sy)/kp;
       d:=trunc(rozm*1.5-sqrt(abs(sqr(sx-zwi^[a].x shr 10)+sqr(sy-zwi^[a].y shr 10))));
       if d>0 then begin
          zwi^[a].dx:=zwi^[a].dx+trunc((k1*d/7)*1024);
          zwi^[a].dy:=zwi^[a].dy+trunc((k2*d/10)*1024);
       end;

       d:=5+trunc(rozm*2-sqrt(abs(sqr(sx-zwi^[a].x shr 10)+sqr(sy-zwi^[a].y shr 10))))+random(3)-1;
       if d>0 then begin
          s1:=360/(kfg.il_krwi/d)/50;
          s2:=d/40;
          if not kfg.dzieci then
          for b:=0 to trunc((kfg.il_krwi/d)*50) do
              nowysyf(zwi^[a].x shr 10,zwi^[a].y shr 10,
                   _sin(trunc(b*s1))*(0.05+random*s2),
                   _cos(trunc(b*s1))*(0.05+random*s2),
                   180+random(4),1,true,0,0,0);
          dec(zwi^[a].sila,d div 2);
          inc(punkty,d div 4);
       end;
    end;
end;

if ((zapala) or (rani)) then
for a:=maxpacz downto 1 do begin
    if (pacz^[a].jest) and
       (pacz^[a].x shr 10>=sx-rozm*1.5) and
       (pacz^[a].x shr 10<=sx+rozm*1.5) and
       (pacz^[a].y shr 10>=sy-rozm*1.5) and
       (pacz^[a].y shr 10<=sy+rozm*1.5) then begin
       d:=trunc(rozm*1.5-sqrt(abs(sqr(sx-pacz^[a].x shr 10)+sqr(sy-pacz^[a].y shr 10))));
       if (d>0) then pacz^[a].rozwalasie:=true;
    end;
end;

IF dziura THEN BEGIN
   if (rozm<10) or {pokaz wybuch}
      ((rozm>=10) and (rozm<=15) and (random(4)<=2)) or
      ((rozm>15) and (random(4)<=1)) then begin
      case rozm of
         1..6:a:=3;
         7..15:a:=0;
         16..28:a:=1;
         else a:=2;
      end;
      nowywyb(sx,sy,5,a);
      end else
      for a:=0 to 7+random((rozm-10) div 3) do
          nowywyb(sx-rozm div 2+random(rozm),
                  sy-rozm div 2+random(rozm),
                  5,wwwyb[random(3)]);
   if (dziura) and (rozm>ekr.skok) then ekr.skok:=rozm;
END;

END;
end;

{*}PROCEDURE dmuch(sx,sy:integer);
var
rozm:integer;
k1,k2,kp:real;
a,b,d,d2:integer;
begin
IF NOT PAUZA THEN BEGIN
rozm:=trunc(ust_broni.wentyl.sila/2);
for a:=maxpost downto 1 do begin
    if (post^[a].jest) and
       (post^[a].x>=sx-rozm*2.5) and
       (post^[a].x<=sx+rozm*2.5) and
       (post^[a].y>=sy-rozm*2.5) and
       (post^[a].y<=sy+rozm*2.5) then begin
       while (post^[a].x=sx) and (post^[a].y=sy) do begin
          post^[a].x:=post^[a].x-0.1+random/5; {jesli postac jest dokladnie w centrum    }
          post^[a].y:=post^[a].y-0.1+random/5; {to przesun ja troche, zeby nie bylo RE207}
       end;
       kp:=sqrt(abs(sqr(post^[a].x-sx)+sqr(post^[a].y-sy)));
       k1:=(post^[a].x-sx)/kp;
       k2:=(post^[a].y-sy)/kp;
       d:=trunc(rozm*2.5-sqrt(abs(sqr(sx-post^[a].x)+sqr(sy-post^[a].y))));
       if d>0 then begin
          post^[a].dx:=post^[a].dx+k1*d/14;
          post^[a].dy:=post^[a].dy+k2*d/20;
       end;
    end;
end;

for a:=maxpoc downto 1 do begin
    if (poc^[a].jest) and
       (poc^[a].x shr 10>=sx-rozm*2.5) and
       (poc^[a].x shr 10<=sx+rozm*2.5) and
       (poc^[a].y shr 10>=sy-rozm*2.5) and
       (poc^[a].y shr 10<=sy+rozm*2.5) then begin
       while (poc^[a].x shr 10=sx) and (poc^[a].y shr 10=sy) do begin
          poc^[a].x:=poc^[a].x-5+random(11); {jesli pocisk jest dokladnie w centrum    }
          poc^[a].y:=poc^[a].y-5+random(11); {to przesun go troche, zeby nie bylo RE207}
       end;
       kp:=sqrt(abs(sqr(poc^[a].x shr 10-sx)+sqr(poc^[a].y shr 10-sy)));
       k1:=(poc^[a].x shr 10-sx)/kp;
       k2:=(poc^[a].y shr 10-sy)/kp;
       d:=trunc(rozm*2.5-sqrt(abs(sqr(sx-poc^[a].x shr 10)+sqr(sy-poc^[a].y shr 10))));
       if d>0 then begin
          poc^[a].dx:=poc^[a].dx+trunc((k1*d/14)*1024);
          poc^[a].dy:=poc^[a].dy+trunc((k2*d/20)*1024);
       end;
    end;
end;

for a:=maxmin downto 1 do begin {zaktywizuj miny w zasiegu}
    if (min^[a].jest) and
       (min^[a].x shr 10>=sx-rozm*2.5) and
       (min^[a].x shr 10<=sx+rozm*2.5) and
       (min^[a].y shr 10>=sy-rozm*2.5) and
       (min^[a].y shr 10<=sy+rozm*2.5) then begin
       while (min^[a].x shr 10=sx) and (min^[a].y shr 10=sy) do begin
          min^[a].x:=min^[a].x-5+random(11); {jesli mina jest dokladnie w centrum      }
          min^[a].y:=min^[a].y-5+random(11); {to przesun ja troche, zeby nie bylo RE207}
       end;
       kp:=sqrt(abs(sqr(min^[a].x shr 10-sx)+sqr(min^[a].y shr 10-sy)));
       k1:=(min^[a].x shr 10-sx)/kp;
       k2:=(min^[a].y shr 10-sy)/kp;
       d:=trunc(rozm*2.5-sqrt(abs(sqr(sx-min^[a].x shr 10)+sqr(sy-min^[a].y shr 10))));
       if d>0 then begin
          min^[a].dx:=min^[a].dx+trunc((k1*d/7)*1024);
          min^[a].dy:=min^[a].dy+trunc((k2*d/10)*1024);
       end;
    end;
end;

for a:=maxmies downto 1 do begin
    if (mies^[a].jest) and
       (mies^[a].x shr 10>=sx-rozm*2.5) and
       (mies^[a].x shr 10<=sx+rozm*2.5) and
       (mies^[a].y shr 10>=sy-rozm*2.5) and
       (mies^[a].y shr 10<=sy+rozm*2.5) then begin
       while (mies^[a].x shr 10=sx) and (mies^[a].y shr 10=sy) do begin
          mies^[a].x:=mies^[a].x-5+random(11); {jesli mieso jest dokladnie w centrum     }
          mies^[a].y:=mies^[a].y-5+random(11); {to przesun go troche, zeby nie bylo RE207}
       end;
       kp:=sqrt(abs(sqr(mies^[a].x shr 10-sx)+sqr(mies^[a].y shr 10-sy)));
       k1:=(mies^[a].x shr 10-sx)/kp;
       k2:=(mies^[a].y shr 10-sy)/kp;
       d:=trunc(rozm*2.5-sqrt(abs(sqr(sx-mies^[a].x shr 10)+sqr(sy-mies^[a].y shr 10))));
       if d>0 then begin
          mies^[a].dx:=mies^[a].dx+trunc((k1*d/14)*1024);
          mies^[a].dy:=mies^[a].dy+trunc((k2*d/20)*1024);
       end;
    end;
end;

for a:=maxsyf downto 1 do begin
    if (syf^[a].jest) and
       (syf^[a].x shr 10>=sx-rozm*2.5) and
       (syf^[a].x shr 10<=sx+rozm*2.5) and
       (syf^[a].y shr 10>=sy-rozm*2.5) and
       (syf^[a].y shr 10<=sy+rozm*2.5) then begin
       while (syf^[a].x shr 10=sx) and (syf^[a].y shr 10=sy) do begin
          syf^[a].x:=syf^[a].x-5+random(11); {jesli syf jest dokladnie w centrum       }
          syf^[a].y:=syf^[a].y-5+random(11); {to przesun go troche, zeby nie bylo RE207}
       end;
       kp:=sqrt(abs(sqr(syf^[a].x shr 10-sx)+sqr(syf^[a].y shr 10-sy)));
       k1:=(syf^[a].x shr 10-sx)/kp;
       k2:=(syf^[a].y shr 10-sy)/kp;
       d:=trunc(rozm*2.5-sqrt(abs(sqr(sx-syf^[a].x shr 10)+sqr(sy-syf^[a].y shr 10))));
       if d>0 then begin
          syf^[a].dx:=syf^[a].dx+trunc((k1*d/14)*1024);
          syf^[a].dy:=syf^[a].dy+trunc((k2*d/20)*1024);
       end;
    end;
end;

for a:=maxopad downto 1 do begin
    if (opad^[a].jest) and
       (opad^[a].plan=1) and
       (opad^[a].x shr 10>=sx-rozm*2.5) and
       (opad^[a].x shr 10<=sx+rozm*2.5) and
       (opad^[a].y>=sy-rozm*2.5) and
       (opad^[a].y<=sy+rozm*2.5) then begin
       while (opad^[a].x shr 10=sx) and (opad^[a].y=sy) do begin
          opad^[a].x:=opad^[a].x-5+random(11); {jesli opad jest dokladnie w centrum       }
          opad^[a].y:=opad^[a].y-1+random(3); {to przesun go troche, zeby nie bylo RE207}
       end;
       kp:=sqrt(abs(sqr(opad^[a].x shr 10-sx)+sqr(opad^[a].y-sy)));
       k1:=(opad^[a].x shr 10-sx)/kp;
       k2:=(opad^[a].y-sy)/kp;
       d:=trunc(rozm*2.5-sqrt(abs(sqr(sx-opad^[a].x shr 10)+sqr(sy-opad^[a].y))));
       if d>0 then begin
          opad^[a].x:=opad^[a].x+trunc((k1*d/14)*1024);
          opad^[a].y:=opad^[a].y+trunc((k2*d/20));
       end;
    end;
end;


if kfg.zwierz then
for a:=maxzwi downto 1 do begin
    if (zwi^[a].jest) and
       (zwi^[a].x shr 10>=sx-rozm*1.5) and
       (zwi^[a].x shr 10<=sx+rozm*1.5) and
       (zwi^[a].y shr 10>=sy-rozm*1.5) and
       (zwi^[a].y shr 10<=sy+rozm*1.5) then begin
       while (zwi^[a].x shr 10=sx) and (zwi^[a].y shr 10=sy) do begin
          zwi^[a].x:=zwi^[a].x-5+random(11); {jesli ziwerz jest dokladnie w centrum             }
          zwi^[a].y:=zwi^[a].y-5+random(11); {wybuchu, to przesun go troche, zeby nie bylo RE207}
       end;
       kp:=sqrt(abs(sqr(zwi^[a].x shr 10-sx)+sqr(zwi^[a].y shr 10-sy)));
       k1:=(zwi^[a].x shr 10-sx)/kp;
       k2:=(zwi^[a].y shr 10-sy)/kp;
       d:=trunc(rozm*1.5-sqrt(abs(sqr(sx-zwi^[a].x shr 10)+sqr(sy-zwi^[a].y shr 10))));
       if d>0 then begin
          zwi^[a].dx:=zwi^[a].dx+trunc((k1*d/7)*1024);
          zwi^[a].dy:=zwi^[a].dy+trunc((k2*d/10)*1024);
       end;
    end;
end;

END;
end;

{*}PROCEDURE osmalenie(sx,sy,rozm:integer);
var
b,x,y,d:integer;
bylo:array[0..maxy-1] of byte;
begin
IF NOT PAUZA THEN BEGIN
x:=0;
y:=rozm;
d:=3-2*rozm;
fillchar2(bylo,maxy,0);
x:=0;
y:=rozm;
d:=3-2*rozm;
fillchar2(bylo,maxy,0);
repeat
     if (sy+y>=0) and (sy+y<maxy) and ((sx+x)-(sx-x)>=1) and (bylo[sy+y]=0) then begin
       hline_ciem_x(sx-x,sx+x,sy+y,0);bylo[sy+y]:=1;
     end;
     if (sy-y>=0) and (sy-y<maxy) and ((sx+x)-(sx-x)>=1) and (bylo[sy-y]=0) then begin
       hline_ciem_x(sx-x,sx+x,sy-y,0);bylo[sy-y]:=1;
     end;
     if (sy+x>=0) and (sy+x<maxy) and ((sx+y)-(sx-y)>=1) and (bylo[sy+x]=0) then begin
       hline_ciem_x(sx-y,sx+y,sy+x,0);bylo[sy+x]:=1;
     end;
     if (sy-x>=0) and (sy-x<maxy) and ((sx+y)-(sx-y)>=1) and (bylo[sy-x]=0) then begin
       hline_ciem_x(sx-y,sx+y,sy-x,0);bylo[sy-x]:=1;
     end;
     inc(x);
     if d>=0 then begin
        dec(y);
        d:=d+2*(2*x-2*y+1);
     end else d:=d+2*(2*x+1)
until x>y;
END;
end;

{*}PROCEDURE laser(sx,sy:integer;sdx,sdy:real);
var
_x,_y,px,py,pdx,pdy:real;
juz:byte;
a,x,y:longint;
coile:shortint;
begin
IF NOT PAUZA THEN BEGIN
px:=sx;
py:=sy;
juz:=0;
pdx:=sdx;
pdy:=sdy;
_x:=-1;
_y:=-1;
coile:=0;
repeat
  if (_x<>px) or (_y<>py) then putpixt(trunc(px)-ekr.x,trunc(py)-ekr.y,15);
   if (zmiana[1]=0) and (random(30)=0) then
      nowysyf(trunc(px),trunc(py),random-0.5,random-0.5,108-random(3),0,false,5,0,0);

   _x:=px;
   _y:=py;
   px:=px+pdx;
   py:=py+pdy;

  if (_x<>px) or (_y<>py) then begin
   if (trunc(py)=pogoda.pozwody) then begin
      if pogoda.dziura in [2,4] then pdx:=sdx/1.8 else
      if pogoda.dziura=3 then pdx:=sdx/3;
   end;

   dec(coile);

   if (py>=0) and (getpix_x(trunc(px),trunc(py))<>0) then juz:=1;
   if (px<0) or (px>=maxx) or (py<-300) or (py>=maxy) then juz:=2;

   if coile<=0 then begin
     for a:=maxpost downto 1 do
       if (post^[a].jest) and
          (post^[a].x>=px-4) and
          (post^[a].x<=px+4) and
          (post^[a].y>=py-4) and
          (post^[a].y<=py+4) then begin
          wybuch(trunc(px),trunc(py),ust_broni.laser.sila+1,false,false,false,ust_broni.laser.podpala,true);
          juz:=1;
       end;
     for a:=maxzwi downto 1 do
       if (zwi^[a].jest) and
          (zwi^[a].x shr 10>=px-4) and
          (zwi^[a].x shr 10<=px+4) and
          (zwi^[a].y shr 10>=py-4) and
          (zwi^[a].y shr 10<=py+4) and (zwi^[a].sila>0) then begin
          dec(zwi^[a].sila,4);
          juz:=1;
       end;
     for a:=maxpacz downto 1 do
       if (pacz^[a].jest) and
          (pacz^[a].x shr 10>=px-4) and
          (pacz^[a].x shr 10<=px+4) and
          (pacz^[a].y shr 10>=py-4) and
          (pacz^[a].y shr 10<=py+4) then begin
          if (random(10)=0) then pacz^[a].rozwalasie:=true;
          juz:=1;
       end;
     coile:=5;
   end;
  end;
until juz>0;
if (juz=1) and (zmiana[1]=0) then begin
   nowydym(trunc(px),trunc(py),1+random(4),0);
   osmalenie(trunc(px),trunc(py),3);
   b:=getpix_x(trunc(px),trunc(py));
   if (not (b in [0,160..167])) or ((b in [160..167]) and (random(4)=0)) then begin
      putpix_x(trunc(px),trunc(py),0);
      for a:=0 to 3 do begin
          x:=random(3)-1;
          y:=random(3)-1;
          if not (getpix_x(trunc(px)+x,trunc(py)+y) in [0,160..167]) then putpix_x(trunc(px)+x,trunc(py)+y,0);
      end;
      nowysyf(trunc(px),trunc(py),random-0.5,random-0.5,199,0,true,50,2,0);
   end;
end;
END;
end;

{*}PROCEDURE prad(sx,sy:integer;sdx,sdy:real);
var
_x,_y,px,py,px1,py1,px2,py2:real;
juz,b:byte;
a,l:longint;
coile:shortint;
begin
IF NOT PAUZA THEN BEGIN
px:=sx;
py:=sy;
px1:=sx;
py1:=sy;
px2:=sx;
py2:=sy;
juz:=0;
l:=0;
_x:=-1;
_y:=-1;
coile:=0;
repeat
   if random(7)=0 then begin
      px2:=px1;
      py2:=py1;
      if random(30)=0 then begin
         px1:=px+random(7)-3;
         py1:=py+random(7)-3;
      end else begin
         px1:=px+random(5)-2;
         py1:=py+random(5)-2;
      end;
   end;
   drawline(trunc(px1)-ekr.x,trunc(py1)-ekr.y,trunc(px2)-ekr.x,trunc(py2)-ekr.y,63-random(2),true);
   if (zmiana[1]=0) and (random(10)=0) then
      nowysyf(trunc(px),trunc(py),random-0.5,random-0.5,62-random(5),0,false,10,0,0);
   _x:=px;
   _y:=py;
   px:=px+sdx;
   py:=py+sdy;

  if (_x<>px) or (_y<>py) then begin
   if (py>=0) and (getpix_x(trunc(px),trunc(py))<>0) then juz:=1;
   if (px<0) or (px>=maxx) or (py<-300) or (py>=maxy) then juz:=2;
   dec(coile);

   if coile<=0 then begin
     for a:=maxpost downto 1 do
       if (post^[a].jest) and
          (post^[a].x>=px-4) and
          (post^[a].x<=px+4) and
          (post^[a].y>=py-4) and
          (post^[a].y<=py+4) then begin
          wybuch(trunc(px),trunc(py),ust_broni.prad.sila+1,false,false,false,ust_broni.prad.podpala,true);
          for b:=0 to 15 do
          nowysyf(trunc(post^[a].x-5+random(11)),trunc(post^[a].y-5+random(11)),
                  random*2-1,random*2-1,62-random(5),0,true,10+random(10),0,0);
          post^[a].blyska:=3;
          post^[a].ani:=random(8);
          juz:=1;
       end;
     for a:=maxzwi downto 1 do
       if (zwi^[a].jest) and
          (zwi^[a].x shr 10>=px-4) and
          (zwi^[a].x shr 10<=px+4) and
          (zwi^[a].y shr 10>=py-4) and
          (zwi^[a].y shr 10<=py+4) and (zwi^[a].sila>0) then begin
          dec(zwi^[a].sila,4);
          inc(punkty);
          juz:=1;
       end;
     for a:=maxpacz downto 1 do
       if (pacz^[a].jest) and
          (pacz^[a].x shr 10>=px-4) and
          (pacz^[a].x shr 10<=px+4) and
          (pacz^[a].y shr 10>=py-4) and
          (pacz^[a].y shr 10<=py+4) then begin
          if (random(30)=0) then pacz^[a].rozwalasie:=true;
          juz:=1;
       end;
     coile:=5;
   end;
  end;
   inc(l);
   if l>=ust_broni.prad.dlug then juz:=2;
   if (pogoda.dziura in [2,4]) and (py>=pogoda.pozwody) then begin
      for a:=maxpost downto 1 do
        if (post^[a].jest) and
           (post^[a].y+6>=pogoda.pozwody) {and (not post^[a].trzymany) }then begin
           post^[a].blyska:=3;
           post^[a].ani:=random(8);
           wybuch(trunc(post^[a].x)-2+random(5),trunc(post^[a].y)-2+random(5),ust_broni.prad.sila+1,
                  false,false,false,ust_broni.prad.podpala,true);
           for b:=0 to 9 do
               nowysyf(trunc(post^[a].x-5+random(11)),trunc(post^[a].y-5+random(11)),
                  random*2-1,random*2-1,62-random(5),0,true,10+random(10),0,0);

        end;
      for a:=maxzwi downto 1 do
        if (zwi^[a].jest) and
           (zwi^[a].y>=longint(pogoda.pozwody) shl 10) then begin
           zwi^[a].sila:=0;
           inc(punkty,5);
        end;

      juz:=2;
      ust_broni.prad.dlug:=l-15;
      piorun_w_wode:=4;
   end;
   if (pogoda.dziura=3) and (py>=pogoda.pozwody) then begin
      juz:=2;
      ust_broni.prad.dlug:=l-15;
   end;
   if juz>0 then begin
      px2:=px1;
      py2:=py1;
      px1:=px;
      py1:=py;
      drawline(trunc(px1)-ekr.x,trunc(py1)-ekr.y,trunc(px2)-ekr.x,trunc(py2)-ekr.y,63-random(2),true);
   end;
until juz>0;
if (juz=1) and (zmiana[1]=0) then begin
   nowydym(trunc(px),trunc(py),1+random(4),0);
   osmalenie(trunc(px),trunc(py),3);
   nowysyf(trunc(px),trunc(py),random*2-1,random*2-1,199,0,true,60,2,random(2)*3);
end;
if ust_broni.prad.dlug<2000 then inc(ust_broni.prad.dlug,15);

END;
end;

{*}PROCEDURE rejl(sx,sy:integer;sdx,sdy:real);
var
_x,_y,px,py,pdx,pdy:real;
juz:byte;
a,x,y,l,jeszczewziemie:longint;
coile:shortint;
begin
IF NOT PAUZA THEN BEGIN
px:=sx;
py:=sy;
juz:=0;
pdx:=sdx;
pdy:=sdy;
_x:=-1;
_y:=-1;
coile:=0;
l:=0;
rejlgan.x:=px;
rejlgan.y:=py;
rejlgan.dx:=pdx;
rejlgan.dy:=pdy;
rejlgan.czas:=20;
jeszczewziemie:=20;
repeat
   _x:=px;
   _y:=py;
   px:=px+pdx;
   py:=py+pdy;

  if (_x<>px) or (_y<>py) then begin
   if (trunc(py)=pogoda.pozwody) then begin
      plum(trunc(_x),5,20,pdx,1);
   end;
   dec(coile);

   b:=getpix_x(trunc(px),trunc(py));
   if (py>=0) and (b<>0) then begin
      if jeszczewziemie<=0 then juz:=1
         else begin
              if (not (b in [0,160..167])) then
               for a:=0 to 3 do begin
                  x:=random(3)-1;
                  y:=random(3)-1;
                  if not (getpix_x(trunc(px)+x,trunc(py)+y) in [0,160..167]) then
                     putpix_x(trunc(px)+x,trunc(py)+y,0);
               end;
              putpix_x(trunc(px),trunc(py),0);
              osmalenie(trunc(px),trunc(py),1+random(4));
              if ((not (b in [0,160..167])) and (random(2)=0)) then dec(jeszczewziemie)
                 else if (b in [160..167]) then dec(jeszczewziemie,random(3)+1);
              end;
   end;
   if (px<0) or (px>=maxx) or (py<-300) or (py>=maxy) then juz:=2;

   if coile<=0 then begin
     for a:=maxpost downto 1 do
       if (post^[a].jest) and
          (post^[a].x>=px-4) and
          (post^[a].x<=px+4) and
          (post^[a].y>=py-4) and
          (post^[a].y<=py+4) then begin
          for b:=0 to 5 do
          wybuch(trunc(px),trunc(py),5,false,false,false,false,true);
       end;
     for a:=maxzwi downto 1 do
       if (zwi^[a].jest) and
          (zwi^[a].x shr 10>=px-4) and
          (zwi^[a].x shr 10<=px+4) and
          (zwi^[a].y shr 10>=py-4) and
          (zwi^[a].y shr 10<=py+4) and (zwi^[a].sila>0) then begin
          zwi^[a].sila:=0;
       end;
     for a:=maxpacz downto 1 do
       if (pacz^[a].jest) and
          (pacz^[a].x shr 10>=px-4) and
          (pacz^[a].x shr 10<=px+4) and
          (pacz^[a].y shr 10>=py-4) and
          (pacz^[a].y shr 10<=py+4) then begin
          pacz^[a].rozwalasie:=true;
       end;
     coile:=5;
   end;
  end;
  inc(l);
until juz>0;
rejlgan.dl:=l;

if (juz=1) then begin
   nowydym(trunc(px),trunc(py),1+random(4),0);
   b:=getpix_x(trunc(px),trunc(py));
   if (not (b in [0,160..167])) or ((b in [160..167]) and (random(4)=0)) then begin
      putpix_x(trunc(px),trunc(py),0);
      for a:=0 to 3 do begin
          x:=random(3)-1;
          y:=random(3)-1;
          if not (getpix_x(trunc(px)+x,trunc(py)+y) in [0,160..167]) then putpix_x(trunc(px)+x,trunc(py)+y,0);
      end;
      nowysyf(trunc(px),trunc(py),random-0.5,random-0.5,199,0,true,50,2,0);
   end;
end;
END;
end;

{*}PROCEDURE rysuj_rejlgana;
var
_x,_y,px,py,pdx,pdy,r:real;
a,x,y,l:longint;
begin
_x:=-1;
_y:=-1;
l:=0;
px:=rejlgan.x;
py:=rejlgan.y;
pdx:=rejlgan.dx;
pdy:=rejlgan.dy;
repeat
   if (l>=300-rejlgan.czas*50) then
      putpixt(trunc(px-ekr.x+random*((30-rejlgan.czas)/10)),
              trunc(py-ekr.y+random*((30-rejlgan.czas)/10)),
              123+random(4));
   _x:=px;
   _y:=py;
   px:=px+pdx;
   py:=py+pdy;

  if (_x<>px) or (_y<>py) then begin
     r:=-(l-200)/300+(30-rejlgan.czas)/20;
     putpix(trunc(px+_sin(l shl 5)*(abs(pdx)+abs(pdy))*r)-ekr.x,
              trunc(py+_cos(l shl 5)*(abs(pdx)+abs(pdy))*r)-ekr.y,
              59+trunc(_sin(l shl 5)*(abs(pdx)+abs(pdy))*2));
  end;
  inc(l);
until l>=rejlgan.dl;
if not pauza then dec(rejlgan.czas);
end;

{*}PROCEDURE strzel_mysza;
const
brtemp:array[0..19] of byte=(5,4,5,5,1,1,10,7,1,20,5,0,0,5,0,5,1,20,8,2);
intemp:array[100..110] of byte=(6,6,0,5,0,0,0,0,0,0,5);
sniegkol:array[0..3] of byte=(6,7,127,63);
bryzgmies:array[100..103] of byte=(3,105,44,107); {kolory rozwalanych rzeczy [pilek itd]}
var
a,b,c,c1,d:integer;
p1,p2:real;
s1,s2:single;
boll:boolean;
begin
czasbezstrz:=0;
inc(wystrzelone);
case celow.bron of
  0:{bazuka}
    begin
    strzal(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat))*celow.sila/10,
       -_cos(trunc(celow.kat))*celow.sila/10,
       0,ust_broni.bazuka.sila*2+6,1,0);
    inc(wystrzelone,2);
    StartSound(Sound[7],false,5,5)
    end;
  1:{granat}
    strzal(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat))*celow.sila/10+random/10-0.05,
       -_cos(trunc(celow.kat))*celow.sila/10+random/10-0.05,
       1,ust_broni.granat.sila*2+4,2,ust_broni.granat.czas*2);
  2:{bomba}
    strzal(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat))*celow.sila/10+random/10-0.05,
       -_cos(trunc(celow.kat))*celow.sila/10+random/10-0.05,
       2,ust_broni.bomba.sila*2+8,3,ust_broni.bomba.czas*2);
  3:{dynamit}
    strzal(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat))*celow.sila/10+random/10-0.05,
       -_cos(trunc(celow.kat))*celow.sila/10+random/10-0.05,
       2,ust_broni.dynamit.sila*2+8,7,ust_broni.dynamit.czas*2);
{strzal(sx,sy:integer;sdx,sdy:real;srodz,ssila,swygl,sczas:byte);}
  4:{karabin}
    begin
    p1:=_sin(trunc(celow.kat))*3;
    p2:=-_cos(trunc(celow.kat))*3;
    strzal(mmx+ekr.x,mmy+ekr.y,
       p1, p2,
       0,ust_broni.karabin.sila,4,0);
    if kfg.luski then
      nowysyf(mmx+ekr.x,mmy+ekr.y,
            -p1/3+random/4-0.125,-p2/3+random/4-0.125,
            36+random(3),2,true,0,0,1);
    StartSound(Sound[10],false,5,5)
    end;
  5:{minigan}
    begin
    strzal(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat-7+random(15)))*3,
       -_cos(trunc(celow.kat-7+random(15)))*3,
       0,ust_broni.minigan.sila,4,0);
    if kfg.luski then
      nowysyf(mmx+ekr.x,mmy+ekr.y,
            -_sin(trunc(celow.kat))+random/4-0.125,
            _cos(trunc(celow.kat))+random/4-0.125,
            125+random(3),2,true,0,0,1);
    StartSound(Sound[9],false,5,5)
    end;
  6:{strzelba}
    begin
    for b:=0 to 5 do
     strzal(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat-7+random(15)))*3,
       -_cos(trunc(celow.kat-7+random(15)))*3,
       0,ust_broni.strzelba.sila,4,0);
    if kfg.luski then
      for b:=0 to 1 do
        nowysyf(mmx+ekr.x,mmy+ekr.y,
            -_sin(trunc(celow.kat))+random/4-0.125,
            _cos(trunc(celow.kat))+random/4-0.125,
            11+random(3),2,true,0,0,1);
    inc(wystrzelone,3);
    StartSound(Sound[8],false,5,5)
    end;
  7:{snajper}
    begin
    inc(wystrzelone,4);
    for a:=maxmies downto 1 do begin
      if (mies^[a].jest) and
        (mies^[a].x shr 10>=mmx+ekr.x-4) and
        (mies^[a].x shr 10<=mmx+ekr.x+4) and
        (mies^[a].y shr 10>=mmy+ekr.y-4) and
        (mies^[a].y shr 10<=mmy+ekr.y+4) then begin
             if mies^[a].rodz<100 then begin
                b:=trunc((15+random(15))*kfg.il_krwi);
                for c:=0 to b do begin
                    c1:=random(3);
                    if c1>1 then d:=1+random(2) else d:=1;
                    nowysyf(mies^[a].x shr 10,mies^[a].y shr 10,
                            _sin(trunc(c*(360/b)))*(random*2),
                            _cos(trunc(c*(360/b)))*(random*2),
                            grupy[mies^[a].rodz div 4].kolorkrwi.od+random(grupy[mies^[a].rodz div 4].kolorkrwi.ile),
                            d,true,0,0,c1);
                end;
                mies^[a].jest:=false;
             end else begin
                b:=10+random(15);
                for c:=0 to b do begin
                    c1:=random(3);
                    if c1>1 then d:=1+random(2) else d:=1;
                    nowysyf(mies^[a].x shr 10,mies^[a].y shr 10,
                            _sin(trunc(c*(360/b)))*(random*2),
                            _cos(trunc(c*(360/b)))*(random*2),
                            bryzgmies[mies^[a].rodz]+random(4),
                            d,true,0,0,c1);
                end;
                mies^[a].jest:=false;
             end;
             wystrzelone:=0;
             a:=1;
      end;
    end;

    c1:=1;
    IF random(4)>=1 then begin {moze oderwac konczyne}
    for a:=maxpost downto 1 do
     if (post^[a].jest) and
       (post^[a].x>=(mmx+ekr.x)-7) and
       (post^[a].x<=(mmx+ekr.x)+7) and
       (post^[a].y>=(mmy+ekr.y)-7) and
       (post^[a].y<=(mmy+ekr.y)+7) then begin
       wystrzelone:=0;
       c1:=0;
       while (post^[a].x=(mmx+ekr.x)) and (post^[a].y=(mmy+ekr.y)) do begin
          post^[a].x:=post^[a].x-0.1+random/5; {jesli postac jest dokladnie w centrum             }
          post^[a].y:=post^[a].y-0.1+random/5; {wybuchu, to przesun ja troche, zeby nie bylo RE207}
       end;
       StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*post^[a].grupa+random(3)],false,15+a mod 5,15+a mod 5);
       d:=5+trunc(7-sqrt(abs(sqr((mmx+ekr.x)-post^[a].x)+sqr((mmy+ekr.y)-post^[a].y))));
       if (d>0) and (not kfg.dzieci) then begin
          s1:=360/d/kfg.il_krwi;
          s2:=d/30;
          for b:=0 to trunc(d*kfg.il_krwi) do
              nowysyf(trunc(post^[a].x)-2+random(5),trunc(post^[a].y)-2+random(5),
                   _sin(trunc(b*s1))*(0.4+random*s2),
                   _cos(trunc(b*s1))*(0.4+random*s2),
                   grupy[post^[a].grupa].kolorkrwi.od+random(grupy[post^[a].grupa].kolorkrwi.ile)
                   ,1,true,0,0,random(2));
       end;
       if (post^[a].rany=0) then begin
          if ((mmx+ekr.x)>=post^[a].x-3) and
             ((mmx+ekr.x)<=post^[a].x+3) and
             ((mmy+ekr.y)>=post^[a].y-7) and
             ((mmy+ekr.y)<=post^[a].y-2) then post^[a].rany:=3 {glowa}
             else
             if ((mmx+ekr.x)>=post^[a].x-7) and
                ((mmx+ekr.x)<=post^[a].x+7) and
                ((mmy+ekr.y)> post^[a].y-2) and
                ((mmy+ekr.y)<=post^[a].y+2) then post^[a].rany:=1 {rece}
                else
                if ((mmx+ekr.x)>=post^[a].x-5) and
                   ((mmx+ekr.x)<=post^[a].x+5) and
                   ((mmy+ekr.y)> post^[a].y+2) and
                   ((mmy+ekr.y)<=post^[a].y+7) then post^[a].rany:=2 {noga}
                   else
                   post^[a].rany:=random(3)+1; {losowo}

          case post^[a].rany of
                1: {oderwane rece}
                  for c:=0 to 1 do
                  nowemieso(trunc(post^[a].x)-4+random(9),trunc(post^[a].y)-4+random(9),
                            random*4-2, random*2-1,
                            post^[a].grupa*4,post^[a].palisie);
                2: {oderwana noga}
                  nowemieso(trunc(post^[a].x)-4+random(9),trunc(post^[a].y)-4+random(9),
                            random*4-2, random*2-1,
                            1+post^[a].grupa*4,post^[a].palisie);
                3: {oderwana glowa}
                  nowemieso(trunc(post^[a].x)-4+random(9),trunc(post^[a].y)-4+random(9),
                            random*4-2, -random*2,
                            2+post^[a].grupa*4,post^[a].palisie);
          end;
       end;
       post^[a].corobi:=4;
       if post^[a].comarobic=5 then post^[a].comarobic:=0;
       post^[a].cotrzyma:=0;
       dec(post^[a].sila,d);
       inc(punkty,d*3);

       if post^[a].sila<-3 then post^[a].sila:=-3;
       a:=1;
     end;
    END;

    if c1=1 then {zabij wybuchem - normalnie}
       for b:=0 to 5 do wybuch(mmx+ekr.x,mmy+ekr.y,5,false,false,true,false,true);

    wybuch(mmx+ekr.x,mmy+ekr.y,5,true,false,true,false,true);

    inc(stats.pociski);
    StartSound(Sound[18],false,5,5)
    end;
  8:{miotacz ognia}
    begin
    if ust_broni.miotacz.rodz=0 then {ogien}
    strzal(mmx+ekr.x,mmy+ekr.y,
       sin(trunc(celow.kat-2+random(5))*pi/180)*celow.sila/40,
       -_cos(trunc(celow.kat-2+random(5)))*celow.sila/40,
       3,1{to nie ma znaczenia},5,10+celow.sila div 7)
    else {napalm}
    strzal(mmx+ekr.x,mmy+ekr.y,
       sin(trunc(celow.kat-3+random(7))*pi/180)*celow.sila/30,
       -_cos(trunc(celow.kat-2+random(5)))*celow.sila/30,
       9,10,9,130-random(20));

    if (ciagle_dzwieki[2]=0) then begin
       if StartSound(Sound[16], true,5,5) then ciagle_dzwieki[2]:=1;
    end
    end;
  9:{nalot}
    begin
    inc(wystrzelone,4);
    for a:=0 to 7 do begin
       strzal(mmx+ekr.x-95+a*25-
              random(10)-pogoda.wiatr*10-(mmy+ekr.y) div 3,
           -a*15-random(5),
           1+random/15,2+random/15,
           5+ust_broni.nalot.rodz*5,
           13-ust_broni.nalot.rodz*9,
           1+ust_broni.nalot.rodz*7,
           ((ekr.y+mmy) div 12+3-random(3)+a)*ust_broni.nalot.rodz);
       if ust_broni.nalot.rodz=1 then inc(a);
    end;
    StartSound(Sound[19],false,1,1);
    end;
  10:{poc. samonaprowadzajacy}
    begin
    strzal(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat))*celow.sila/10,
       -_cos(trunc(celow.kat))*celow.sila/10,
       4,ust_broni.pocsam.sila*2+6,1,250);
    StartSound(Sound[7],false,5,5)
    end;
  11:{laser}
    begin
    if (random(3)<=1) and (wystrzelone>0) then dec(wystrzelone);
    laser(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat)),
       -_cos(trunc(celow.kat)));
    if (ciagle_dzwieki[4]=0) then begin
       if StartSound(Sound[21], true,5,5) then ciagle_dzwieki[4]:=1;
    end
    end;
  12:{prad}
    begin
    if (random(3)<=1) and (wystrzelone>0) then dec(wystrzelone);
    prad(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat)),
       -_cos(trunc(celow.kat)));
    if (ciagle_dzwieki[5]=0) then begin
       if StartSound(Sound[23], true,5,5) then ciagle_dzwieki[5]:=1;
    end
    end;
  13:{kula ognista}
    begin
    inc(wystrzelone,2);
    strzal(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat))*celow.sila/10,
       -_cos(trunc(celow.kat))*celow.sila/10,
       6,ust_broni.kulaog.sila*2+6,6,0);
    StartSound(Sound[37],false,5,5)
    end;
  14:{miny}
    begin
    IF klik[1] then begin
       wystrzelone:=0;
       case ust_broni.miny.zepsute of
          0:boll:=false;
          1:boll:=true;
          2:if random(2)=0 then boll:=true else boll:=false;
       end;
       nowamina(mmx+ekr.x,mmy+ekr.y,
                _sin(trunc(celow.kat))*celow.sila/10+random/10-0.05,
                -_cos(trunc(celow.kat))*celow.sila/10+random/10-0.05,boll);
    END;
    end;
  15:begin{kowadlo}
    nowekowadlo(mmx+ekr.x,mmy+ekr.y);
    inc(wystrzelone);
    end;
  16:{pila}
    begin
    wystrzelone:=0;
    mmx:=mmx+random(3)-1;
    mmy:=mmy+random(3)-1;
    for a:=maxpost downto 1 do begin
        c1:=0;
        if (post^[a].jest) and
           (post^[a].x>=mmx+ekr.x-7) and
           (post^[a].x<=mmx+ekr.x+7) and
           (post^[a].y>=mmy+ekr.y-7) and
           (post^[a].y<=mmy+ekr.y+7) then c1:=1;

        if (c1=0) and (post^[a].jest) and
           (post^[a].x>=mmx+9+ekr.x-7) and
           (post^[a].x<=mmx+9+ekr.x+7) and
           (post^[a].y>=mmy+9+ekr.y-7) and
           (post^[a].y<=mmy+9+ekr.y+7) then c1:=2;

        if c1>0 then begin
            pilatnie:=3;
            b:=random(5)+1;
            if post^[a].sila>0 then begin
               dec(post^[a].sila,b);
               inc(punkty,b);
            end;

            if bonusy.spokojni=0 then post^[a].comarobic:=7;
            if c1=1 then begin
               post^[a].x:=mmx+ekr.x;
               mmx:=mmx+random(3)-1;
               mmy:=mmy+random(3)-1;
               post^[a].y:=mmy+ekr.y;
            end;
            if c1=2 then begin
               post^[a].x:=post^[a].x+random(2)*2-1;
               post^[a].y:=post^[a].y+random(2)*2-1;
            end;
            if not kfg.dzieci then begin
              s1:=36/kfg.il_krwi;
              for b:=0 to trunc(9*kfg.il_krwi) do
               nowysyf(trunc(post^[a].x)-2+random(5),trunc(post^[a].y)-2+random(5),
                 _sin(trunc(b*36))*(0.4+random*1.2),
                 _cos(trunc(b*36))*(0.4+random*1.2),
                 grupy[post^[a].grupa].kolorkrwi.od+random(grupy[post^[a].grupa].kolorkrwi.ile)
                 ,1,true,0,0,random(2));
              if random(30)=0 then
               nowysyf(trunc(post^[a].x)-2+random(5),trunc(post^[a].y)-2+random(5),
                 _sin(trunc(b*36))*(0.4+random*1.2),
                 _cos(trunc(b*36))*(0.4+random*1.2),
                 grupy[post^[a].grupa].kolorkrwi.od+random(grupy[post^[a].grupa].kolorkrwi.ile)
                 ,1,true,0,0,3);
            end;
            if random(3)=0 then
               StartSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*post^[a].grupa+random(3)],false,15+a mod 5,15+a mod 5);
            if (post^[a].rany=0) and (random(30)=0) then begin
               post^[a].rany:=random(3)+1;
               case post^[a].rany of
                  1: {oderwane rece}
                    for b:=0 to 1 do
                    nowemieso(trunc(post^[a].x)+czescipoz[b].x,trunc(post^[a].y)+czescipoz[b].y,
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
            end;
        end;
    end;

    for a:=maxpacz downto 1 do begin
       c1:=0;
       if (pacz^[a].jest) and
          (pacz^[a].x shr 10>=mmx+ekr.x-7) and
          (pacz^[a].x shr 10<=mmx+ekr.x+7) and
          (pacz^[a].y shr 10>=mmy+ekr.y-7) and
          (pacz^[a].y shr 10<=mmy+ekr.y+7) then c1:=1;
       if (pacz^[a].jest) and
          (pacz^[a].x shr 10>=mmx+9+ekr.x-7) and
          (pacz^[a].x shr 10<=mmx+9+ekr.x+7) and
          (pacz^[a].y shr 10>=mmy+9+ekr.y-7) and
          (pacz^[a].y shr 10<=mmy+9+ekr.y+7) then c1:=1;
       if c1>0 then begin
          pilatnie:=3;
          if (random(10)=0) then pacz^[a].rozwalasie:=true;
          for b:=0 to 4 do
             nowysyf(pacz^[a].x shr 10-1+random(3),pacz^[a].y shr 10-1+random(3),
                     random*2-1,random*2-1,
                     random(3)+41,2,true,0,0,random(3));
       end;
    end;

    end;
  17:{rejlgan}
    begin
    rejl(mmx+ekr.x,mmy+ekr.y,
         _sin(trunc(celow.kat)),
         -_cos(trunc(celow.kat)));
    inc(stats.rejlpoc);
    inc(wystrzelone,2);
    StartSound(Sound[49], false,5,5);
    end;
  18:{napalm}
    begin
    inc(wystrzelone,3);
    strzal(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat))*celow.sila/10,
       -_cos(trunc(celow.kat))*celow.sila/10,
       8,ust_broni.napalm.sila*2+6,8,0);
    StartSound(Sound[7],false,5,5)
    end;
  19:{miotacz odlamkow}
    begin
    strzal(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat-7+random(15)))*celow.sila/20,
       -_cos(trunc(celow.kat-7+random(15)))*celow.sila/20,
       0,10,0,0);
    StartSound(Sound[9],false,5,5)
    end;
  100:begin{smieci}
    nowemieso(mmx+ekr.x,mmy+ekr.y,
       _sin(trunc(celow.kat))*celow.sila/10+random/10-0.05,
       -_cos(trunc(celow.kat))*celow.sila/10+random/10-0.05,
       100+ust_broni.smieci.co,false);
     wystrzelone:=0;
     end;
  101:begin{miesko}
     wystrzelone:=0;
         if ust_broni.miesko.co<=3 then a:=ust_broni.miesko.co
            else if ust_broni.miesko.co=4 then a:=random(4);
         if ust_broni.miesko.grupa<=4 then b:=ust_broni.miesko.grupa
            else if ust_broni.miesko.grupa=5 then b:=random(5);
      if ust_broni.miesko.co<=4 then begin {mieso}
         nowemieso(mmx+ekr.x,mmy+ekr.y,
                   _sin(trunc(celow.kat))*celow.sila/10+random/10-0.05,
                   -_cos(trunc(celow.kat))*celow.sila/10+random/10-0.05,
                   b*4+a,false);
      end
       else {zwloki}
         for a:=0 to 5 do
             nowemieso(mmx+ekr.x+czescipoz[a].x,mmy+ekr.y+czescipoz[a].y,
                       _sin(trunc(celow.kat))*celow.sila/10+random/10-0.05,
                       -_cos(trunc(celow.kat))*celow.sila/10+random/10-0.05,
                       czesci[a]+b*4,false);
      end;
  102:begin{krew}
      wystrzelone:=0;
      for b:=0 to 1 do
      nowysyf(mmx+ekr.x,mmy+ekr.y,
         _sin(trunc(celow.kat-4+random(9)))*celow.sila/10+random/10-0.05,
         -_cos(trunc(celow.kat-4+random(9)))*celow.sila/10+random/10-0.05,
         random(4)+180,1,true,0,0,0);
      end;
  103:begin{piorun}
    piorun(mmx+ekr.x,mmy+ekr.y);
     inc(wystrzelone);
     end;
  104,105:begin {snieg,deszcz}
    wystrzelone:=0;
    for c:=0 to 3 do begin
     b:=-1;
     for a:=1 to maxopad do if not opad^[a].jest then begin b:=a;a:=maxopad;end;
     if b>=1 then with opad^[b] do begin
          plan:=1;
          x:=longint(mmx-7+random(15)+ekr.x) shl 10;
          y:=mmy+random(3)+ekr.y;
          rodz:=celow.bron-104;
          if rodz=0 then kol:=sniegkol[random(4)]
                    else kol:=125+random(3);
          jest:=true;
     end;
    end;
     end;
  106:{ludzie}
    begin
    wystrzelone:=0;
    IF (klik[1]) and (not trybgry) then begin
    b:=-1;
    for c:=1 to maxpost do if not post^[c].jest then begin b:=c;c:=maxpost;end;
    if b>=1 then with post^[b] do begin
       grupy[ust_broni.ludzie.grupa].kiedynast:=0;
       jest:=true;
       x:=mmx+ekr.x;
       y:=mmy+ekr.y;
       dx:=_sin(trunc(celow.kat-3+random(7)))*celow.sila/5;
       dy:=-_cos(trunc(celow.kat-3+random(7)))*celow.sila/5;
       ani:=random(4);
       ogienani:=random(6);
       doani:=random(3);
       if grupy[ust_broni.ludzie.grupa].corobi<5 then comarobic:=corobitab[grupy[ust_broni.ludzie.grupa].corobi]
          else comarobic:=corobitab[random(5)];
       corobi:=4;
       if grupy[ust_broni.ludzie.grupa].kierunek=0 then kier:=random(2)*2-1
                                                   else kier:=grupy[ust_broni.ludzie.grupa].kierunek;
       sila:=grupy[ust_broni.ludzie.grupa].sila;
       rany:=0;
       zazn:=false;
       grupa:=ust_broni.ludzie.grupa;
       trzymany:=false;
       palisie:=false;
       dusisie:=0;
       blyska:=0;
       niesmiertelny:=-1;
       wolnawola:=grupy[ust_broni.ludzie.grupa].wolnawol;
       inc(grupy[ust_broni.ludzie.grupa].jestpost);
       inc(stats.postaci);
       StartSound(Sound[24],false,5,5)
    end;
    END;
    end;
  107:begin {zwierzatka}
    wystrzelone:=0;
    IF klik[1] then
       nowezwi(mmx+ekr.x,mmy+ekr.y,
             _sin(trunc(celow.kat-3+random(7)))*celow.sila/10,
             -_cos(trunc(celow.kat-3+random(7)))*celow.sila/10,
             ust_broni.zwierz.rodzaj);
    end;
  108:{wentylator}
    begin
    wystrzelone:=0;
    if ust_broni.wentyl.sila<40 then
       ust_broni.wentyl.sila:=ust_broni.wentyl.sila+0.5;
    end;
  {109: lupa}
  110:begin {paczki}
    wystrzelone:=0;
    nowapaczka(mmx+ekr.x,mmy+ekr.y,ust_broni.paczki.rzut);
    end;
end;
if celow.bron<100 then celow.temp:=brtemp[celow.bron]
                  else celow.temp:=intemp[celow.bron];
end;

{*}PROCEDURE strzel_mysza2; {prawy klawisz myszy}
const
brtemp:array[0..15] of byte=(5,4,5,5,1,1,10,7,1,20,5,0,0,5,0,6);
intemp:array[100..106] of byte=(6,6,0,5,0,0,0);
sniegkol:array[0..3] of byte=(6,7,127,63);
var
a,b,c:integer;
pl:text;
begin
case celow.bron of
  9:{nalot}
    begin
    inc(wystrzelone,5);
    for a:=0 to 7 do begin
       strzal(mmx+ekr.x+95-a*25-
             random(10)-pogoda.wiatr*10+(mmy+ekr.y) div 3,
           -a*15-random(5),
           -1-random/15,2+random/15,
           5+ust_broni.nalot.rodz*5,
           13-ust_broni.nalot.rodz*9,
           1+ust_broni.nalot.rodz*7,
           ((ekr.y+mmy) div 12+3-random(3)+a)*ust_broni.nalot.rodz);
       if ust_broni.nalot.rodz=1 then inc(a);
    end;
    StartSound(Sound[19],false,1,1);
    if celow.bron<100 then celow.temp:=brtemp[celow.bron]
                      else celow.temp:=intemp[celow.bron];
    end;
end;
end;

{*}PROCEDURE plum(sx:longint;szer,ile:integer;dx,sila:real);
var a:word;
begin
if sila>=0.05 then begin
   if pogoda.dziura=2 then {plusk wody}
     for a:=1 to ile do
       nowysyf(sx-szer div 2+random(szer),pogoda.pozwody,
               random*sila-sila/2+dx,-random*sila,168+random(8),0,true,0,0,0);
   if pogoda.dziura=4 then {plusk kwasu}
     for a:=1 to ile do
       nowysyf(sx-szer div 2+random(szer),pogoda.pozwody,
               random*sila-sila/2+dx,-random*sila,200+random(7),0,true,0,0,0);
   if (pogoda.dziura in [2,4]) and (random(3)=0) and (sila>=0.15) then begin
      if sila>0.3 then {StartSound(Sound[26], false,7,8)}
                  StartSound(Sound[27], false,7,8);
   end;
   if (pogoda.dziura in [3,4]) and (random(3)=0) and (sila>=0.15) then begin
      if sila<=0.4 then StartSound(Sound[28], false,7,8)
                   else StartSound(Sound[29], false,7,8);
   end;
end;
end;

{*}PROCEDURE piorun(px,py:integer);
var
sx,sy,x,y,rozx,rozy:word;
b,c,d,e,ilroz,k1,k2,k3:byte;
roz,bedzie_widac:boolean;
a,krok:integer;
begin
x:=px;
y:=py;
ilroz:=0;
krok:=1;
bedzie_widac:=true;
pogoda.droga_p.x[0]:=x;
pogoda.droga_p.y[0]:=y;
for a:=0 to 2 do pogoda.droga_p.roz[a]:=-1;
pogoda.jest_piorun:=12;
if (pogoda.dziura>=2) and (py>=pogoda.pozwody) then begin
   bedzie_widac:=false;
   pogoda.jest_piorun:=0;
end;
repeat
 roz:=false;
 pogoda.droga_p.roz[ilroz]:=krok;
 repeat
   sx:=x;sy:=y;
   if (random(20)=0) and (ilroz<2) then begin
      rozx:=x;
      rozy:=y;
      roz:=true;
      inc(ilroz);
   end;
   pogoda.droga_p.x[krok]:=x;
   pogoda.droga_p.y[krok]:=y;
   inc(y,5+random(5));
   x:=x+random(11)-5;
   c:=getpix_x(x,y);
   if (y>=400) then begin
      if pogoda.dziura=0 then y:=399;
      c:=1;
   end;
   if (pogoda.dziura in [2,4]) and (y>=pogoda.pozwody) then begin
      c:=1;
      y:=pogoda.pozwody+1;
      piorun_w_wode:=4;
      if bedzie_widac then plum(x,7,50,0,1.5+random/2);
      for a:=maxpost downto 1 do
        if (post^[a].jest) and
           (post^[a].y+6>=pogoda.pozwody) and (not post^[a].trzymany) then begin
           post^[a].blyska:=3;
           post^[a].ani:=random(8);
           wybuch(trunc(post^[a].x)-2+random(5),trunc(post^[a].y)-2+random(5),10+random(10),false,false,false,true,true);
           for b:=0 to 15 do
               nowysyf(trunc(post^[a].x-5+random(11)),trunc(post^[a].y-5+random(11)),
                  random*2-1,random*2-1,62-random(5),0,true,10+random(10),0,0);

        end;
      for a:=maxzwi downto 1 do
        if (zwi^[a].jest) and
           (zwi^[a].y>=longint(pogoda.pozwody) shl 10) then begin
           zwi^[a].sila:=0;
           inc(punkty,5);
        end;
   end;
   if (pogoda.dziura=3) and (y>=pogoda.pozwody) then begin
      c:=1;
   end;
   for a:=maxpost downto 1 do
       if (post^[a].jest) and
          (post^[a].x>=x-5) and
          (post^[a].x<=x+5) and
          (post^[a].y>=y-5) and
          (post^[a].y<=y+5) then begin
          post^[a].blyska:=3;
          post^[a].ani:=random(8);
          c:=1;
       end;
   if c>0 then begin
      if (pogoda.dziura in [0,3]) or ((pogoda.dziura=1) and (y<=399)) or
         ((pogoda.dziura in [2,4]) and (y<pogoda.pozwody)) then begin
         wybuch(x,y,10+random(10),true,false,false,true,true);
         e:=random(20)+20;
         for d:=1 to e do
             nowysyf(trunc(x+sin(random(100))*random(20)),
                  trunc(y+cos(random(100))*random(20)),
                  _sin(trunc(d*(360/e)))*(0.6+random*2),
                  _cos(trunc(d*(360/e)))*(0.6+random*2),
                  199,0,true,50-random(10),random(4),0);
      end;
      if krok<499 then inc(krok);
      pogoda.droga_p.x[krok]:=x;
      pogoda.droga_p.y[krok]:=y;
      y:=400;
   end;
   if krok<499 then inc(krok);
 until (y>=400) or (x<0) or (x>1279);
 x:=rozx;
 y:=rozy;
until not roz;
pogoda.droga_p.ilekrok:=krok;
if kfg.fejdyekranu then ekr.fejd:=10;
StartSound(Sound[11], false,6,6);
end;

{*}PROCEDURE pokaz_piorun;
var
krok:integer;
przez:boolean;
begin
krok:=0;
if pogoda.jest_piorun>=9 then przez:=false else przez:=true;
repeat
  if (krok+1<>pogoda.droga_p.roz[0]) and
     (krok+1<>pogoda.droga_p.roz[1]) and
     (krok+1<>pogoda.droga_p.roz[2]) then begin
   drawline(pogoda.droga_p.x[krok]-1-ekr.x,pogoda.droga_p.y[krok]-ekr.wy,
            pogoda.droga_p.x[krok+1]-1-ekr.x,pogoda.droga_p.y[krok+1]-ekr.wy-1,59+pogoda.jest_piorun div 4,przez);
   drawline(pogoda.droga_p.x[krok]+1-ekr.x,pogoda.droga_p.y[krok]-ekr.wy,
            pogoda.droga_p.x[krok+1]+1-ekr.x,pogoda.droga_p.y[krok+1]-ekr.wy-1,59+pogoda.jest_piorun div 4,przez);
   drawline(pogoda.droga_p.x[krok]-ekr.x  ,pogoda.droga_p.y[krok]-ekr.wy,
            pogoda.droga_p.x[krok+1]-ekr.x  ,pogoda.droga_p.y[krok+1]-ekr.wy-1,4+pogoda.jest_piorun div 4,przez);
  end;
  inc(krok);
until krok+1>=pogoda.droga_p.ilekrok;
end;

end.