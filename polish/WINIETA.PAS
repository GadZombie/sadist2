unit winieta;

interface
{*}PROCEDURE gad_intro;

implementation
uses crt,glowne,vars,maskp,smix,dzwieki2,resztki,myszunit,xms;

{*}PROCEDURE gad_intro;
var
a,a1,kk,zm,kk2:longint;
qniec:boolean;
x,y:integer;
pczm:boolean;

 {+}PROCEDURE slad(x,y:integer);
 var b:integer;
 begin
 for b:=0 to 5 do
     putpix(x-1+random(3),y-1+random(3),163+random(2));
 end;

begin
fillchar2(scr^,64000,0);
fillchar2(scr2^,64000,0);
fillchar2(mem[$A000:0],64000,0);
wczytaj_pal('jaszczur.pal');
fadein(64,0,255);
qniec:=false;
kk:=0;
kk2:=4;
zm:=0;
StartSound(Sound[12], false,1,1);
for a:=-90 to 370 do begin
    sprawdz_mysz;
    move2(scr^,scr2^);
    maskpicxms(a,66,45,34,0,offsety[9]+kk*1530*2,scr2^,1,true);
    maskpicxms(a+45,66,45,34,0,offsety[9]+1530+kk*1530*2,scr2^,1,true);

    maskpicxms(a-50,100,45,34,0,offsety[9]+kk2*1530*2,scr2^,1,true);
    maskpicxms(a-5,100,45,34,0,offsety[9]+1530+kk2*1530*2,scr2^,1,true);

    if zm=0 then begin
       if kk=0 then slad(a+40,66+6);    {lewa tylna}
       if kk=6 then slad(a+23+45,66+7); {lewa przednia}
       if kk=8 then slad(a+39,66+27);   {prawa tylna}
       if kk=0 then slad(a+25+45,66+26); {prawa przednia}

       if kk2=0 then slad(a+40-50,100+6);    {lewa tylna}
       if kk2=6 then slad(a+23+45-50,100+7); {lewa przednia}
       if kk2=8 then slad(a+39-50,100+27);   {prawa tylna}
       if kk2=0 then slad(a+25+45-50,100+26); {prawa przednia}
    end;

    inc(zm);
    if zm>=3 then begin inc(kk);inc(kk2);zm:=0 end;
    if kk>=11 then kk:=0;
    if kk2>=11 then kk2:=0;

    if (a>=-36) and (a<=266) then for a1:=0 to 20 do {302} {9}
       if scr^[72+a1,a+45]=0 then
        xms2mem(_xms[1].h,offsety[9]+34000+a1*302+(a+36),scr^[72+a1,a+45],2);

    if (a>=80) and (a<=250) then for a1:=0 to 20 do {170} {75}
       if scr^[106+a1,a-5]=0 then
        xms2mem(_xms[1].h,offsety[9]+40342+a1*302+(a-80),scr^[106+a1,a-5],2);

    synchro;
    move2(scr2^,mem[$A000:0]);
    if (keypressed) or (klik[1]) or (klik[2]) then begin a:=370;qniec:=true end;
end;

startsound(Sound[14],true,1,1);

if not qniec then begin
   b:=200;
   for a:=0 to 15000 do begin
       repeat
          x:=random(320);
          y:=random(90)+66;
       until (scr^[y,x]>0) and (scr^[y,x]<=162) and
             ((scr^[y+1,x]<scr^[y,x]) or (scr^[y+1,x]>162));
       a1:=trunc(scr^[y,x]/1.1);
       if a1<0 then a1:=0;
       scr^[y+1,x]:=a1;

       if a mod (b div 2)=0 then begin
          pczm:=false;
          for a1:=0 to 255 do begin
            if pal[a1,1]>0 then begin
              pczm:=true;
              dec(pal[a1,1]);
              if pal[a1,0]<63 then inc(pal[a1,0]);
            end;
            if pal[a1,2]>0 then begin
              if (not pczm) and (pal[a1,0]<63) then inc(pal[a1,0]);
              pczm:=true;
              dec(pal[a1,2])
            end;
          end;
          synchro;
          if pczm then begin cala_paleta(true);pal_gl:=pal end;
          move2(scr^,mem[$A000:0]);
          if b>60 then dec(b);
       end;

       if (keypressed) or (klik[1]) or (klik[2]) then begin a:=15000;qniec:=true end;
   end;
end;

fadeout(1,0,255);
end;

end.