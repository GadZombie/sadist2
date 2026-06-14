unit robteren;

interface
{$N+}
{*}PROCEDURE texturuj_teren;
{*}PROCEDURE wczytaj_tlo(nazwa:string;var blad:byte);
{*}PROCEDURE nowyteren;
{*}PROCEDURE resetuj_teren;

implementation
uses crt,vars,glowne,dos,xms,maskp,cosin,dzwieki2,SMix,nowe,resztki,loudsejw;

{*}PROCEDURE texturuj_teren;
var
a,
px,py, {ekran aktualnie przerabiany}
sx,sy, {pozycja danego pixla aktualnie przerabianego}
tx,ty, {pozycja "na texturze" aktualnie wklejanej}
otx,oty {zapamietany offset textury od ostatniej}
:longint;
trx,try:integer;
begin
xms2mem(_xms[1].h,offsety[13]+nowy_param.textura*10,wyr[0],10);
assign (plik,'tekstury\'+wyr+'.stx');
reset(plik,1);
blockread(plik,trx,2); blockread(plik,try,2);

fillchar2(scr2^,64000,0);
for a:=0 to tRY-1 do blockread(plik,scr2^[a],tRX);
close(plik);

otx:=0;oty:=0;
for py:=0 to 1 do begin {2 ekrany w pionie}
    for px:=0 to 3 do begin {4 ekrany w poziomie}
        for a:=0 to 199 do {przenies fragment na wirt. ekran scr^}
            xms2mem(_xms[1].h,offsety[2]+(px*320)+(a+py*200)*maxx,scr^[a],320);

        ty:=0;
        for sy:=0 to 199 do begin
            tx:=0;
            for sx:=0 to 319 do begin
                if scr^[sy,sx]=255 then
                   scr^[sy,sx]:=scr2^[(oty+ty) mod tRY,(otx+tx) mod tRX];
                inc(tx);
            end;
            inc(ty);
        end;
        inc(otx,tx);

        for a:=0 to 199 do {przenies fragment spowrotem do xms}
            mem2xms(scr^[a],_xms[1].h,offsety[2]+(px*320)+(a+py*200)*maxx,320);
    end;
    inc(oty,ty);
    otx:=0;
end;

{$I+}
a:=ioresult;
{$I-}
end;

{*}FUNCTION fnear(r,g,b :byte):byte;
var
 i,found:byte;
 dist1,dist2 :word;

begin
 dist1:=65535;
 for i:=1 to 223 do
 begin
  dist2:=(abs(pal_gl[i,0]-r)+abs(pal_gl[i,1]-g)+abs(pal_gl[i,2]-b));
  if dist2<=3 then
  begin
    fnear:=i;
    exit
  end;
  if dist2<dist1 then
  begin
    found:=i;
    dist1:=dist2
  end;
 end;
 fnear:=found;
end;

{*}PROCEDURE wczytaj_tlo(nazwa:string;var blad:byte);
var
plik:File;
a,e:longint;
begin
mem2xms(scr^,_xms[1].h,offsety[11],64000);
blad:=ioresult;
{$I-}
fillchar2(scr^,64000,1);
for a:=0 to 2 do begin
    mem2xms(scr^,_xms[1].h,offsety[1]+a*64000,64000)
end;
Assign (plik,'tla\'+nazwa);
filemode:=0;
Reset (plik, 1);
for a:=0 to 2 do begin
    BlockRead (plik,scr^,64000);
    mem2xms(scr^,_xms[1].h,offsety[1]+a*64000,64000)
end;
blockread(plik,chmur^[208],12288);
blockread(plik,pal_gl[208],144);
close(plik);
{$I+}
blad:=ioresult;

for a:=208 to 255 do negatyw^[a]:=fnear(63-pal_gl[a,0], 63-pal_gl[a,1], 63-pal_gl[a,2]);
xms2mem(_xms[1].h,offsety[11],scr^,64000);
end;

{*}PROCEDURE nowyteren;
var
e,wsumie:longint;
w,dw:single;
wi:integer;
tx:longint;
begin
new(trawabuf);
fillchar2(trawabuf^,sizeof(trawabuf^),0);
fillchar2(scr^,64000,0);
move(palczekaj,pal,sizeof(pal));
cala_paleta(false);
for a:=0 to 153 do
    xms2mem(_xms[1].h,offsety[7]+76800+a*184,scr^[23+a,68],184);
move2(scr^,mem[$A000:0]);

{$I+}
a:=ioresult;
{$I-}

xms2mem(_xms[1].h,offsety[14]+nowy_param.wierzch*10,wyr,10);
wczytaj_wierzch(wyr+'.STW');
fillchar2(scr^,64000,0);
fillchar2(scr2^,64000,0);
tx:=0; {x textury trawy}
w:=random(nowy_param.grdol-nowy_param.grgora)+nowy_param.grgora;
wi:=0;
for e:=0 to maxx-1 do begin
(*  if e mod 10=0 then begin {20,114,124}
     mem[$A000:47360+96+e div 10]:=114;
     mem[$A000:47040+96+e div 10]:=20;
     mem[$A000:47680+96+e div 10]:=124;
  end;*)
  if e mod 7=0 then
    xms2mem(_xms[1].h,offsety[7]+105136+trunc((1280-e)/8.4)*184,mem[$A000:(23+trunc((1280-e)/8.4))*320+68],184);

  dec(wi);
  if wi<=0 then begin
     dw:=dw+random-0.5;
     if dw<-1.5 then dw:=-1.5;
     if dw>1.5 then dw:=1.5;
     wi:=random(10)+1;
  end;
  w:=w+dw;
  if w<nowy_param.grgora then begin dw:=0;wi:=0;w:=nowy_param.grgora;end;
  if w>nowy_param.grdol then begin dw:=0;wi:=0;w:=nowy_param.grdol;end;

  if nowy_param.czyscstare then
     for a:=0 to 199 do begin
         scr^[a,e mod 320]:=0;
         scr2^[a,e mod 320]:=0;
     end
   else
     if (e mod 320=0) then
        for a:=0 to 199 do begin
            xms2mem(_xms[1].h,offsety[2]+e-1+longint(a)*maxx,scr^[a],320);
            xms2mem(_xms[1].h,offsety[2]+e-1+longint(a+200)*maxx,scr2^[a],320);
        end;

  for a:=399 downto trunc(w) do begin
      if nowy_param.textura=0 then begin {bez textury}
         if a<=199 then scr^[a,e mod 320]:=kolter[nowy_param.rodzteren]+(trunc(w)-a) div 200+random(3)
                   else scr2^[a-200,e mod 320]:=kolter[nowy_param.rodzteren]+(trunc(w)-a) div 200+random(3);
      end else begin   {z textura}
         if a<=199 then scr^[a,e mod 320]:=255
                   else scr2^[a-200,e mod 320]:=255;
      end;
      if (nowy_param.wierzch>0) and (a<=trunc(w)+(wierzchr.ry-1)) then begin
         xms2mem(_xms[1].h,offsety[28]+(a-trunc(w))*320+tx,trawabuf^,1);
         if (trawabuf^[0]>0) then begin
            if a<=199 then scr^[a,e mod 320]:=trawabuf^[0]
                      else scr2^[a-200,e mod 320]:=trawabuf^[0];
         end;
      end;
  end;

  inc(tx);if tx>=wierzchr.rx then tx:=0;
  if (e mod 320=319) then
     for a:=0 to 199 do begin
       mem2xms(scr^[a],_xms[1].h,offsety[2]+e-320+longint(a)*maxx,320);
       mem2xms(scr2^[a],_xms[1].h,offsety[2]+e-320+longint(a+200)*maxx,320);
     end;
end;

if nowy_param.textura>0 then texturuj_teren;

fillchar(min^,pam.smin*maxmin,0);
wczytaj_tlo(ostpliki.tlo+'.S2B',b);
move(pal_gl,pal,sizeof(pal));
dispose(trawabuf);

if trybgry then begin
   tr_gry.czas:=3000;
   tr_gry.jeszcze:=150+random(250);
   tr_gry.bylopkt:=punkty;
   tr_gry.grupa:=0;
   wsumie:=2000+tr_gry.jeszcze*3;
   for a:=0 to 11 do tr_gry.amun[a]:=0;
   while wsumie>0 do begin
      a:=random(12);
      case a of
         0,1,2,3,7,8,9,10,11:e:=1+random(10);
         4:e:=5+random(30);
         5,6:e:=30+random(50);
      end;
      inc(tr_gry.amun[a],e);
      if tr_gry.amun[a]>999 then tr_gry.amun[a]:=999;
      dec(wsumie,e);
   end;
end;
end;

{*}PROCEDURE resetuj_teren;
begin
fillchar(scr^,maxx*20,7); {domalowanie niewidocznego podloza pod ekranem}
mem2xms(scr^,_xms[1].h,offsety[2]+512000,maxx*20);

fillchar(post^,pam.spost*maxpost,0);
fillchar(syf^,pam.ssyf*maxsyf,0);
fillchar(poc^,pam.spoc*maxpoc,0);
fillchar(mies^,pam.smies*maxmies,0);
fillchar(wyb^,pam.swyb*maxwyb,0);
fillchar(dym^,pam.sdym*maxdym,0);
fillchar(opad^,pam.sopad*maxopad,0);
fillchar(kow^,pam.skow*maxkow,0);
fillchar(bom^,pam.sbom*maxbom,0);
fillchar(zwi^,pam.szwi*maxzwi,0);
fillchar(pacz^,pam.spacz*maxpacz,0);
for a:=0 to 4 do koment.tx[a]:='';
koment.cz:=100;
koment.m:=300;
czasbezstrz:=0;
wystrzelone:=0;
fillchar(bonusy,sizeof(bonusy),0);
ekr.fejd:=0;
with pogoda do begin
   il_sniegu:=0;
   bylo_sniegu:=0;
   jest_piorun:=0;
   trzesienieziemi:=0;
end;
celow.sterowanie:=0;
fillchar(rejlgan,sizeof(rejlgan),0);
pauza:=false;
ost_combo:=0;
il_trup_et:=il_trupow;
zmiana[1]:=0;
ekr.ktore_menu:=5;
tultip.cz:=0;
fillchar2(mem[$A000:0],64000,0);
fillchar2(scr^,64000,0);
assign(plik,'dane\paleta.pal');reset(plik,1);
blockread(plik,pal_gl,624);
close(plik);
fadein(64,0,255);
end;

end.