unit loudsejw;

interface
{$N+}
{*}PROCEDURE sprawdz_katalogi;
{*}PROCEDURE sprawdz_czy_jest_plik_tla(var nazwa);
{*}PROCEDURE wczytaj_teren(nazwa:string;var blad:byte);
{*}PROCEDURE zapisz_teren(nazwa:string;var blad:byte);
{*}PROCEDURE wczytaj_zestaw_postaci(nazwa:string; nr:byte;var blad:byte);
{*}PROCEDURE przerob_zestaw_postaci(nr:byte);
{*}PROCEDURE wczytaj_wszystkie_postaci;
{*}PROCEDURE wczytaj_texture_do_rysowania(nazwa:string);
{*}PROCEDURE wczytaj_wierzch(nazwa:string);
{*}PROCEDURE shot;
{*}PROCEDURE megaskrinszot;
{*}PROCEDURE wczytaj_detale;
{*}PROCEDURE zapisz_detale;

implementation
uses crt,vars,glowne,dos,xms,maskp,myszunit,cosin,dzwieki2,SMix,nowe,resztki,lzssunit;

{kompresja LZSS}
var InFile, OutFile : file;
{E kompresja LZSS}
var
zeg_obrot,dozeg_obr:byte;

{kompresja LZSS}
Function ReadProc(var ReadBuf; var NumRead : word) : word; far;
Begin
  BlockRead(InFile, ReadBuf, LZRWBufSize, NumRead);
{  xms2mem(_xms[1].h,offsety[11]+35200,mem[$A000:35200],5440);}
  maskpicxms(151,110,17,17,0,offsety[24]+zeg_obrot*289,mem[$A000:0],1,true);
  inc(dozeg_obr);
  if dozeg_obr>=4 then begin
     inc(zeg_obrot);if zeg_obrot>=12 then zeg_obrot:=0;
     dozeg_obr:=0;
  end;
End; { ReadProc }

Function WriteProc(var WriteBuf; Count : word; var NumWritten : word) : word;
far;Begin
  BlockWrite(OutFile, WriteBuf, Count, NumWritten);
{  xms2mem(_xms[1].h,offsety[11]+35200,mem[$A000:35200],5440);  }
  maskpicxms(151,110,17,17,0,offsety[24]+zeg_obrot*289,mem[$A000:0],1,true);
  inc(dozeg_obr);
  if dozeg_obr>=4 then begin
     inc(zeg_obrot);if zeg_obrot>=12 then zeg_obrot:=0;
     dozeg_obr:=0;
  end;
End; { WriteProc }

{E kompresja LZSS}


{*}PROCEDURE sprawdz_katalogi;
begin
{$I-}
chdir('POSTACI');
if IOResult <> 0 then mkdir('POSTACI')
                 else chdir('..');
chdir('TERENY');
if IOResult <> 0 then mkdir('TERENY')
                 else chdir('..');
chdir('ZRZUTY');
if IOResult <> 0 then mkdir('ZRZUTY')
                 else chdir('..');
chdir('TLA');
if IOResult <> 0 then mkdir('TLA')
                 else chdir('..');
chdir('TEKSTURY');
if IOResult <> 0 then mkdir('TEKSTURY')
                 else chdir('..');
{$I+}
a:=ioresult;
end;

{*}PROCEDURE sprawdz_czy_jest_plik_tla(var nazwa);
var
 DirInfo:SearchRec;
 naz:string[8];
begin
{$I+}
a:=ioresult;
{$I-}
move(nazwa,naz,9);
assign(plik,'TLA\'+naz+'.S2B');
reset(plik,1);
if ioresult=0 then close(plik)
   else begin
      FindFirst('TLA\*.S2B',Anyfile,DirInfo);
      if (DosError=0) then begin
         wyr:=DirInfo.Name;
         if pos('S2B',wyr)>0 then delete(wyr,pos('S2B',wyr)-1,4);
         naz:=wyr;
      end;
   end;
move(naz,nazwa,9);
{$I+} a:=ioresult; {$I-}
end;

{*}PROCEDURE przygotuj_obrazki_klepsydry;
var a,b:longint;
begin
for a:=0 to 11 do begin
    xms2mem(_xms[1].h,offsety[11]+35200,scr^[110],5440);
    maskpicxms(151,110,17,17,0,offsety[24]+a*289,scr^,1,true);
    for b:=0 to 16 do mem2xms(scr^[110+b,151],_xms[1].h,offsety[24]+a*289+b*17,17);
end;
end;

{*}PROCEDURE wczytaj_teren;
var
b:byte;
fp,l,a:longint;
maxminn:word;
begin
{$I-}
zeg_obrot:=0;
mem2xms(scr^,_xms[1].h,offsety[11],64000);
przygotuj_obrazki_klepsydry;
if LZInit then begin
   blad:=ioresult;
   {$I-}
   assign(plik,'tereny\'+nazwa);
   reset(plik,1);
   {$I+}
   blad:=ioresult;
   {$I-}
   if blad=0 then begin
     b:=0;
     seek(plik,filesize(plik)-4);
     blockread(plik,fp,4);
     seek(plik,fp);
     blockread(plik,b,1);
     close(plik);
     if b=2 then begin {wersja 2}
      assign(inFile,'tereny\'+nazwa); {dekompresja}
      reset(inFile,1);
      assign(OutFile,'tereny\temp.tmp');
      rewrite(OutFile,1);

      LZUnSquash(ReadProc, WriteProc);

      close(inFile);
      close(OutFile);

      assign(plik,'tereny\temp.tmp');
      reset(plik,1);
      for a:=0 to 399 do begin
          blockread(plik,scr^,1280);
          mem2xms(scr^,_xms[1].h,offsety[2]+longint(a)*maxx,1280);
      end;
      close(plik);

      {odczyt min, tla itd}
      assign(inFile,'tereny\'+nazwa);
      reset(inFile,1);
      seek(infile,fp+1);
      blockread(infile, pogoda, 44);
      for a:=0 to 4 do {zapis punktow wyjscia itd}
          blockread(infile, grupy[a], 21); {ustawienia wylotu kazdej z grup}

      for a:=1 to maxmin do min^[a].jest:=false;
      blockread(infile, maxminn, sizeof(maxminn));
      if maxminn>maxmin then maxminn:=maxmin;
      blockread(infile, min^, maxminn*pam.smin);
      close(infile);

      {$I+}
      blad:=ioresult;
      {$I-}
      assign(plik,'tereny\temp.tmp');
      erase(plik);
     end else blad:=245;
   end;
   LZDone;
end; {else brak pamieci!}
xms2mem(_xms[1].h,offsety[11],scr^,64000);
{$I+} a:=ioresult; {$I-}
end;

{*}PROCEDURE zapisz_teren;
var
b:byte;
fp:longint;
begin
{$I-}
zeg_obrot:=0;
mem2xms(scr^,_xms[1].h,offsety[11],64000);
przygotuj_obrazki_klepsydry;
if LZInit then begin
   blad:=ioresult;
   {$I-}
   assign(plik,'tereny\temp.tmp');
   rewrite(plik,1);
   {$I+}
   blad:=ioresult;
   {$I-}
   if blad=0 then begin
      for a:=0 to 399 do begin {zapis temp}
          xms2mem(_xms[1].h,offsety[2]+longint(a)*maxx,scr^,1280);
          blockwrite(plik,scr^,1280);
      end;
      close(plik);

      assign(inFile,'tereny\temp.tmp'); {kompresja}
      reset(inFile,1);
      assign(OutFile,'tereny\'+nazwa);
      rewrite(OutFile, 1);

      LZSquash(ReadProc, WriteProc);

      close(inFile);

      {zapis min, tla itd}
      fp:=filepos(outfile);
      b:=2; {numer wersji}
      blockwrite(outfile, b, sizeof(b));
      blockwrite(outfile, pogoda, 44); {wszystko z pogody procz drogi pioruna}
      for a:=0 to 4 do {zapis punktow wyjscia itd}
          blockwrite(outfile, grupy[a], 21); {ustawienia wylotu kazdej z grup}

      blockwrite(outfile, maxmin,sizeof(maxmin));
      blockwrite(outfile, min^, maxmin*pam.smin);

      blockwrite(outfile, fp, sizeof(fp));

      close(OutFile);
      {$I+}
      blad:=ioresult;
      {$I-}
      assign(plik,'tereny\temp.tmp');
      erase(plik);
   end;
   LZDone;
end;  {else brak pamieci!}
xms2mem(_xms[1].h,offsety[11],scr^,64000);
{$I+} a:=ioresult; {$I-}
end;

{*}PROCEDURE wczytaj_zestaw_postaci(nazwa:string; nr:byte;var blad:byte);
var
a,a1,ll:longint;
buf:array[0..999] of byte;

dzww:array[0..12] of record
                     n:string[8];
                     os,r:longint;
                     end;
begin
{$I-}
if nr=0 then ll:=offsety[3]
        else ll:=offsetyp[nr-1]+24000;
offsetyp[nr]:=ll;
if nr=0 then ll:=offsety[3]+5*24000
        else ll:=offsetym[nr-1]+784;
offsetym[nr]:=ll;

blad:=ioresult;
{$I-}
assign(plik,'postaci\'+nazwa);reset(plik,1);
{$I+}
blad:=ioresult;
if blad=0 then begin
   {$I-}
   seek(plik,77{25+26+26});
   for a:=0 to 23 do begin
       blockread(plik,buf,1000);
       mem2xms(buf, _xms[1].h, offsetyp[nr]+a*1000, 1000);
   end;
   seek(plik,23477);
   blockread(plik,buf,784);
   mem2xms(buf, _xms[1].h, offsetym[nr], 784);

   blockread(plik,grupy[nr].kolorkrwi,sizeof(grupy[nr].kolorkrwi));
   blockread(plik,grupy[nr].ranykrew,sizeof(grupy[nr].ranykrew));
   blockread(plik,grupy[nr].szybkosc,sizeof(grupy[nr].szybkosc));
   blockread(plik,grupy[nr].waga,sizeof(grupy[nr].waga));
   blockread(plik,grupy[nr].sila_bicia,sizeof(grupy[nr].sila_bicia));
   blockread(plik,grupy[nr].sila_kop,sizeof(grupy[nr].sila_kop));
   blockread(plik,grupy[nr].bicie,sizeof(grupy[nr].bicie));
   blockread(plik,grupy[nr].ani_corobi,sizeof(grupy[nr].ani_corobi));
   for a:=0 to 3 do
       for a1:=0 to 7 do begin
           dec(grupy[nr].ranykrew[a,a1].x,7);
           dec(grupy[nr].ranykrew[a,a1].y,7);
       end;
   blockread(plik,dzww,sizeof(dzww));
   {$I+}
   blad:=ioresult;
   close(plik);

   XMSFree(handlery[2+nr]);
   XMSAllocate(handlery[2+nr], 0);
   sharedsize[2+nr]:=0;

   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+ 0],'postaci\'+nazwa,'',dzww[ 0].os,dzww[ 0].r,2+nr);
   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+ 1],'postaci\'+nazwa,'',dzww[ 1].os,dzww[ 1].r,2+nr);
   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+ 2],'postaci\'+nazwa,'',dzww[ 2].os,dzww[ 2].r,2+nr);
   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+ 3],'postaci\'+nazwa,'',dzww[ 3].os,dzww[ 3].r,2+nr);
   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+ 4],'postaci\'+nazwa,'',dzww[ 4].os,dzww[ 4].r,2+nr);
   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+ 5],'postaci\'+nazwa,'',dzww[ 5].os,dzww[ 5].r,2+nr);
   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+ 6],'postaci\'+nazwa,'',dzww[ 6].os,dzww[ 6].r,2+nr);
   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+ 7],'postaci\'+nazwa,'',dzww[ 7].os,dzww[ 7].r,2+nr);
   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+ 8],'postaci\'+nazwa,'',dzww[ 8].os,dzww[ 8].r,2+nr);
   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+ 9],'postaci\'+nazwa,'',dzww[ 9].os,dzww[ 9].r,2+nr);
   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+10],'postaci\'+nazwa,'',dzww[10].os,dzww[10].r,2+nr);
   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+11],'postaci\'+nazwa,'',dzww[11].os,dzww[11].r,2+nr);
   LoadSound(Sound[dzwiekipodstawowe+dzwiekowgrupy*nr+12],'postaci\'+nazwa,'',dzww[12].os,dzww[12].r,2+nr);
end;
{$I+} a:=ioresult; {$I-}
end;

{*}PROCEDURE przerob_zestaw_postaci(nr:byte);
var
x,k:longint;
buf:array[0..224] of byte;
begin
for k:=0 to 103 do begin
    xms2mem(_xms[1].h,offsetyp[nr]+225*k,buf,225);
    for x:=0 to 224 do
        if buf[x] in [248..255] then
           buf[x]:=buf[x] mod 8+kgrup[nr];
    mem2xms(buf,_xms[1].h,offsetyp[nr]+225*k,225);
end;
for k:=0 to 15 do begin
    xms2mem(_xms[1].h,offsetym[nr]+49*k,buf,49);
    for x:=0 to 48 do
        if buf[x] in [248..255] then
           buf[x]:=buf[x] mod 8+kgrup[nr];
    mem2xms(buf,_xms[1].h,offsetym[nr]+49*k,49);
end;
end;

{*}PROCEDURE wczytaj_wszystkie_postaci;
var
a:byte;
ww:string;
begin
xms2mem(_xms[1].h,offsety[17]+10,ww,10);

wczytaj_zestaw_postaci(ostpliki.postaci[0]+'.S2P',0,a);
if a<>0 then begin ostpliki.postaci[0]:=ww;wczytaj_zestaw_postaci(ostpliki.postaci[0]+'.S2P',0,a);end;
wczytaj_zestaw_postaci(ostpliki.postaci[1]+'.S2P',1,a);
if a<>0 then begin ostpliki.postaci[1]:=ww;wczytaj_zestaw_postaci(ostpliki.postaci[1]+'.S2P',1,a);end;
wczytaj_zestaw_postaci(ostpliki.postaci[2]+'.S2P',2,a);
if a<>0 then begin ostpliki.postaci[2]:=ww;wczytaj_zestaw_postaci(ostpliki.postaci[2]+'.S2P',2,a);end;
wczytaj_zestaw_postaci(ostpliki.postaci[3]+'.S2P',3,a);
if a<>0 then begin ostpliki.postaci[3]:=ww;wczytaj_zestaw_postaci(ostpliki.postaci[3]+'.S2P',3,a);end;
wczytaj_zestaw_postaci(ostpliki.postaci[4]+'.S2P',4,a);
if a<>0 then begin ostpliki.postaci[4]:=ww;wczytaj_zestaw_postaci(ostpliki.postaci[4]+'.S2P',4,a);end;

przerob_zestaw_postaci(0);
przerob_zestaw_postaci(1);
przerob_zestaw_postaci(2);
przerob_zestaw_postaci(3);
przerob_zestaw_postaci(4);

{$I+}
a:=ioresult;
{$I-}
end;

{*}PROCEDURE wczytaj_texture_do_rysowania(nazwa:string);
var a:longint;
begin
{$I+}
a:=ioresult;
{$I-}
assign (plik,'tekstury\'+nazwa);
reset(plik,1);
{$I+}
if ioresult=0 then begin
   {$I-}
   blockread(plik,texturar,4);
   fillchar2(scr2^,64000,0);
   for a:=0 to texturar.RY-1 do blockread(plik,scr2^[a],texturar.RX);
   close(plik);
   for a:=0 to texturar.RY-1 do mem2xms(scr2^[a],_xms[1].h,offsety[12]+a*320,320);
   texturar.nazwa:=nazwa;
end else begin
   texturar.nazwa:='BRAK';
   texturar.rx:=1;
   texturar.ry:=1;
end;
{$I+} a:=ioresult; {$I-}
end;

{*}PROCEDURE wczytaj_wierzch(nazwa:string);
var a:longint;
begin
{$I+}
a:=ioresult;
{$I-}
assign (plik,'tekstury\'+nazwa);
reset(plik,1);
blockread(plik,wierzchr,4);
for a:=0 to wierzchr.ry-1 do begin
    blockread(plik,trawabuf^,wierzchr.rx);
    mem2xms(trawabuf^,_xms[1].h,offsety[28]+a*320,wierzchr.rx);
end;
close(plik);
wierzchr.nazwa:=nazwa;
{$I+} a:=ioresult; {$I-}
end;


{*}PROCEDURE shot;
type
  pcxheader_rec = Record
    manufacturer   : Byte;
    version        : Byte;
    encoding       : Byte;
    bitsperpixel : Byte;
    xmin, ymin     : integer;
    xmax, ymax     : integer;
    hres, vres     : integer;
    paltte        : Array [0..47] of Byte;
    reserved       : Byte;
    Nplanes  : Byte;
    Bytesperline : integer;
    paletteType   : integer;
    filler         : Array [0..57] of Byte;
  end;

var
 header:pcxheader_rec;
 f:file;
 i,j,gdziebufor,numer:word;
 kolor:byte;
 ilosc:byte;
 bufor:array[0..500] of byte;
 pall:array[0..255,0..2] of byte;

procedure zapisz;
begin
 ilosc:=ilosc or (128+64);
 bufor[gdziebufor]:=ilosc;inc(gdziebufor);
 bufor[gdziebufor]:=kolor;inc(gdziebufor);
 ilosc:=1;
end;

begin
 gdziebufor:=0;fillchar(bufor,sizeof(bufor),0);
 with header do begin
   manufacturer:=10;
   version:=5;
   encoding:=1;
   bitsperpixel:=8;
   xmin:=0;
   ymin:=0;
   xmax:=319;
   ymax:=199;
   hres:=300;
   vres:=300;
   nplanes:=1;
   bytesperline:=320;
   paletteType:=0;
   fillchar(filler,sizeof(filler),0);
 end;

 numer:=0;

 repeat
 str(numer,wyr);while length(wyr)<4 do insert('0',wyr,1);
 assign(f,'zrzuty\s2ss'+wyr+'.pcx');
 {$I-}
 reset(f);
 close(f);
 {$I+}
 a:=IOResult;
 inc(numer);
 until (a<>0) or (numer>=9999);

 assign(f,'zrzuty\s2ss'+wyr+'.pcx');
 {$I-}
 rewrite(f,1);
 blockwrite(f,header,sizeof(header));
 kolor:=mem[$A000:3200];
 ilosc:=1;
 for i:=1 to 63999 do begin
     if kolor=mem[$A000:i] then begin
        inc(ilosc);
        if ilosc=63 then begin
           ilosc:=ilosc-1;
           zapisz;
        end;
     end
        else begin
        if (kolor<64) and (ilosc=1) then begin bufor[gdziebufor]:=kolor;inc(gdziebufor);end
                                    else zapisz;
        kolor:=mem[$A000:i];
        end;
     if gdziebufor>=400 then begin blockwrite(f,bufor,gdziebufor);gdziebufor:=0;end;
 end;
 zapisz;
 blockwrite(f,bufor,gdziebufor);
 kolor:=12;
 blockwrite(f,kolor,1);
 for i := 0 to 255 do begin
     pall[i,0]:=pal_gl[i,0] shl 2;
     pall[i,1]:=pal_gl[i,1] shl 2;
     pall[i,2]:=pal_gl[i,2] shl 2;
 end;
 blockwrite(f,pall,sizeof(pall));
 close(f);
 {$I+}
 if ioresult=0 then nowy_kom('S2SS'+wyr+'.PCX ZAPISANY');
end;

{*}PROCEDURE megaskrinszot;
type
BMPHeader = record
  bfType           : Word;
  bfSize,
  bfReserved,
  bfOffBits,
  biSize,
  biWidth,
  biHeight         : LongInt;
  biPlanes,
  biBitCount       : Word;
  biCompression,
  biSizeImage,
  biXPelsPerMeter,
  biYPelsPerMeter,
  biClrUsed,
  biClrImportant   : LongInt;
end;

var
Header:BMPHeader;
Palette:Array [0..255,0..3] of Byte;
numer:word;
a,b:longint;
bufscr:array[0..1279] of byte;
buftlo:array[0..640] of byte;

begin
numer:=0;
repeat
  str(numer,wyr);while length(wyr)<4 do insert('0',wyr,1);
  assign(plik,'zrzuty\s2ms'+wyr+'.bmp');
  {$I-}
  reset(plik);
  close(plik);
  {$I+}
  a:=IOResult;
  inc(numer);
until (a<>0) or (numer>=9999);

{przenies caly teren do bufora w xms}
xms2xms(_xms[1].h,offsety[2],_xms[1].h,offsety[2]+530000,512000);

assign(plik,'zrzuty\s2ms'+wyr+'.bmp');
rewrite(plik,1);
with header do begin
  bfType           :=19778;
  bfSize           :=1280*400;
  bfReserved       :=0;
  bfOffBits        :=1078;
  biSize           :=40;
  biWidth          :=1280;
  biHeight         :=400;
  biPlanes         :=1;
  biBitCount       :=8;
  biCompression    :=0;
  biSizeImage      :=1280*400;
  biXPelsPerMeter  :=2834;
  biYPelsPerMeter  :=2834;
  biClrUsed        :=0;
  biClrImportant   :=0;
end;
for a:=0 to 255 do begin
    Palette[a,3]:=0;
    Palette[a,2]:=Pal[a,0] shl 2;
    Palette[a,1]:=Pal[a,1] shl 2;
    Palette[a,0]:=Pal[a,2] shl 2;
end;
Blockwrite(plik,Header,SizeOf(Header));
Blockwrite(plik,Palette,1024);

fillchar2(buftlo,640,kfg.tlokolor);
for a:=399 downto 0 do begin
    xms2mem(_xms[1].h,offsety[2]+530000+longint(a)*maxx,bufscr,1280);

    if kfg.tlo then
       xms2mem(_xms[1].h,
               offsety[1]+
                   longint(50+a div 2)*640,
               buftlo,
               640);

    for b:=0 to 1279 do
        if bufscr[b]=0 then bufscr[b]:=buftlo[b shr 1];

    if (pogoda.dziura>=2) and (a>=pogoda.pozwody) then
       if pogoda.dziura=2 then for b:=0 to 1279 do bufscr[b]:=chmur^[bufscr[b],168]
          else
          if pogoda.dziura=3 then for b:=0 to 1279 do bufscr[b]:=chmur^[bufscr[b],15]
          else
          for b:=0 to 1279 do bufscr[b]:=chmur^[bufscr[b],20];

    blockwrite(plik,bufscr,1280);
end;
close(plik);
{$I+}
if ioresult=0 then nowy_kom('S2MS'+wyr+'.BMP ZAPISANY');
end;

{*}PROCEDURE wczytaj_detale;
begin
{$I+} a:=ioresult;

assign(plik,'dane\s2detale.cfg');
{$I-}
reset(plik,1);
{$I+}
if ioresult=0 then begin
   {$I-}
   writeln('Plik z detalami znaleziony, wczytywanie...');
   blockread(plik,maxpost,sizeof(maxpost));
   blockread(plik,maxsyf,sizeof(maxsyf));
   blockread(plik,maxpoc,sizeof(maxpoc));
   blockread(plik,maxmin,sizeof(maxmin));
   blockread(plik,maxmies,sizeof(maxmies));
   blockread(plik,maxwyb,sizeof(maxwyb));
   blockread(plik,maxdym,sizeof(maxdym));
   blockread(plik,maxopad,sizeof(maxopad));
   blockread(plik,maxkow,sizeof(maxkow));
   blockread(plik,maxbom,sizeof(maxbom));
   blockread(plik,maxzwi,sizeof(maxzwi));
   blockread(plik,maxpacz,sizeof(maxpacz));
end
   else
   writeln('Plik z detalami nie znaleziony lub uszkodzony; uzyte beda ustawienia'+#13#10+'standardowe');
close(plik);

{$I+} a:=ioresult;
end;

{*}PROCEDURE zapisz_detale;
begin
{$I+} a:=ioresult;

assign(plik,'dane\s2detale.cfg');
{$I-}
rewrite(plik,1);
{$I+}
if ioresult=0 then begin
   {$I-}
   blockwrite(plik,maxpost,sizeof(maxpost));
   blockwrite(plik,maxsyf,sizeof(maxsyf));
   blockwrite(plik,maxpoc,sizeof(maxpoc));
   blockwrite(plik,maxmin,sizeof(maxmin));
   blockwrite(plik,maxmies,sizeof(maxmies));
   blockwrite(plik,maxwyb,sizeof(maxwyb));
   blockwrite(plik,maxdym,sizeof(maxdym));
   blockwrite(plik,maxopad,sizeof(maxopad));
   blockwrite(plik,maxkow,sizeof(maxkow));
   blockwrite(plik,maxbom,sizeof(maxbom));
   blockwrite(plik,maxzwi,sizeof(maxzwi));
   blockwrite(plik,maxpacz,sizeof(maxpacz));
end;
close(plik);

{$I+} a:=ioresult;
end;


end.