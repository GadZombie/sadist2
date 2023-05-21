unit dzwieki2;

interface
uses Detect,SMix,xms;
const
   dzwiekipodstawowe=51;
   dzwiekowgrupy=13;
   NumSounds = dzwiekipodstawowe+dzwiekowgrupy*5;
var
   Sound: array[0..NumSounds-1] of PSound;

{*}PROCEDURE Init;
{*}PROCEDURE LoadSounds;
{*}PROCEDURE Shutdown;
{*}PROCEDURE FreeSounds;

implementation
uses crt;
const
   XMSRequired   = 2000;    {XMS memory required to load the sounds (KBytes) }
   SharedEMB     = true;
      {TRUE:   All sounds will be stored in a shared EMB}
      {FALSE:  Each sound will be stored in a separate EMB}
var
   BaseIO: word; IRQ, DMA, DMA16: byte;
   OldExitProc: pointer;

{*}PROCEDURE Init;
begin
if not(GetSettings(BaseIO, IRQ, DMA, DMA16)) then begin
   writeln('Blad przy inicjalizacji: bledne ustawienia BLASTER');
   Halt(1); {BLASTER environment variable invalid or non-existant}
end;

if not(InitSB(BaseIO, IRQ, DMA, DMA16)) then begin
   writeln('Blad przy inicjalizacji karty muzycznej');
   writeln('Niepoprawny adres IO, karta niezainstalowana lub uszkodzona');
   Halt(2); {Sound card could not be initialized}
end;

InitMixing;
end;

{*}PROCEDURE OurExitProc; far;
   {If the program terminates with a runtime error before the extended memory}
   {is deallocated, then the memory will still be allocated, and will be lost}
   {until the next reboot.  This exit PROCEDURE is ALWAYS called upon program}
   {termination and will deallocate extended memory if necessary.            }
var
i: byte;
begin
for i := 0 to NumSounds-1 do
    if Sound[i] <> nil then FreeSound(Sound[i]);
if SharedEMB then ShutdownSharing;
ExitProc := OldExitProc; {Chain to next exit PROCEDURE}
end;

{*}PROCEDURE Shutdown;
begin
ShutdownMixing;
ShutdownSB;
end;

{*}PROCEDURE LoadSounds;
var
i: integer;
begin
if not(InitXMS) then begin
   writeln('Blad przy rezerwacji pamieci XMS');
   writeln('HIMEM.SYS musi byc zainstalowany!');
   Halt(3); {XMS driver not installed}
end else begin
  writeln('Pamiec XMS dziala poprawnie');
  write('Wolnej pamieci XMS: ', xmsGetFreemem, 'k - ');
  if xmsGetFreemem<XMSRequired then begin
     writeln('wrak pamieci XMS');
     Halt(4); {Insufficient XMS memory}
  end else begin
   writeln('wczytywanie dzwiekow');
   if SharedEMB then InitSharing;

   LoadSound(Sound[0], 'dane\s2.dat','BUM1.raw',0,0,1);
   LoadSound(Sound[1], 'dane\s2.dat','BUM2.raw',0,0,1);
   LoadSound(Sound[2], 'dane\s2.dat','BUM3.raw',0,0,1);
   LoadSound(Sound[3], 'dane\s2.dat','PILKAKOP.raw',0,0,1);
   LoadSound(Sound[4], 'dane\s2.dat','CEGLA.raw',0,0,1);
   LoadSound(Sound[5], 'dane\s2.dat','GRANATS.raw',0,0,1);
   LoadSound(Sound[6], 'dane\s2.dat','SYKBOMB.raw',0,0,1);
   LoadSound(Sound[7], 'dane\s2.dat','BAZUKA.raw',0,0,1);
   LoadSound(Sound[8], 'dane\s2.dat','STRZELBA.raw',0,0,1);
   LoadSound(Sound[9], 'dane\s2.dat','DZIALO1.raw',0,0,1);
   LoadSound(Sound[10],'dane\s2.dat','DZIALO2.raw',0,0,1);
   LoadSound(Sound[11],'dane\s2.dat','BURZA1.raw',0,0,1);
   LoadSound(Sound[12],'dane\s2.dat','INTRO.raw',0,0,1);
   LoadSound(Sound[13],'dane\s2.dat','POCHDNIA.raw',0,0,1);
   LoadSound(Sound[14],'dane\s2.dat','OGIEN.raw',0,0,1);
   LoadSound(Sound[15],'dane\s2.dat','SPALONY.raw',0,0,1);
   LoadSound(Sound[16],'dane\s2.dat','MIOTACZ.raw',0,0,1);
   LoadSound(Sound[17],'dane\s2.dat','DESZCZ.raw',0,0,1);
   LoadSound(Sound[18],'dane\s2.dat','SNAJPER.raw',0,0,1);
   LoadSound(Sound[19],'dane\s2.dat','NALOT.raw',0,0,1);
   LoadSound(Sound[20],'dane\s2.dat','KOWADLO.raw',0,0,1);
   LoadSound(Sound[21],'dane\s2.dat','LASER1.raw',0,0,1);
   LoadSound(Sound[22],'dane\s2.dat','LASER2.raw',0,0,1);
   LoadSound(Sound[23],'dane\s2.dat','PRAD.raw',0,0,1);
   LoadSound(Sound[24],'dane\s2.dat','POSTAC.raw',0,0,1);
   LoadSound(Sound[25],'dane\s2.dat','INTROW.raw',0,0,1);
   LoadSound(Sound[26],'dane\s2.dat','GRANATS.raw',0,0,1); {niepotrzebne}
   LoadSound(Sound[27],'dane\s2.dat','PLUM.raw',0,0,1);
   LoadSound(Sound[28],'dane\s2.dat','PSSS1.raw',0,0,1);
   LoadSound(Sound[29],'dane\s2.dat','PSSS2.raw',0,0,1);
   LoadSound(Sound[30],'dane\s2.dat','SMIECH1.raw',0,0,1);
   LoadSound(Sound[31],'dane\s2.dat','SMIECH2.raw',0,0,1);
   LoadSound(Sound[32],'dane\s2.dat','SMIECH3.raw',0,0,1);
   LoadSound(Sound[33],'dane\s2.dat','SMIECH4.raw',0,0,1);
   LoadSound(Sound[34],'dane\s2.dat','SMIECH5.raw',0,0,1);
   LoadSound(Sound[35],'dane\s2.dat','SMIECH6.raw',0,0,1);
   LoadSound(Sound[36],'dane\s2.dat','SMIECH7.raw',0,0,1);
   LoadSound(Sound[37],'dane\s2.dat','KULAOG.raw',0,0,1);
   LoadSound(Sound[38],'dane\s2.dat','PILACZEK.raw',0,0,1);
   LoadSound(Sound[39],'dane\s2.dat','PILAKLIK.raw',0,0,1);
   LoadSound(Sound[40],'dane\s2.dat','PILAPOC.raw',0,0,1);
   LoadSound(Sound[41],'dane\s2.dat','PILATNIE.raw',0,0,1);
   LoadSound(Sound[42],'dane\s2.dat','MINAPIP.raw',0,0,1);
   LoadSound(Sound[43],'dane\s2.dat','PACZROZW.raw',0,0,1);
   LoadSound(Sound[44],'dane\s2.dat','PACZSPAD.raw',0,0,1);
   LoadSound(Sound[45],'dane\s2.dat','BOMBAS.raw',0,0,1);
   LoadSound(Sound[46],'dane\s2.dat','PTAK1.raw',0,0,1);
   LoadSound(Sound[47],'dane\s2.dat','NETOPER.raw',0,0,1);
   LoadSound(Sound[48],'dane\s2.dat','BOING.raw',0,0,1);
   LoadSound(Sound[49],'dane\s2.dat','REJLGAN.raw',0,0,1);
   LoadSound(Sound[50],'dane\s2.dat','BULBUL.raw',0,0,1);

   OldExitProc := ExitProc;
   ExitProc := @OurExitProc;
   end
end;
end;

{*}PROCEDURE FreeSounds;
var
i: integer;
begin
for i := 0 to NumSounds-1 do FreeSound(Sound[i]);
if SharedEMB then ShutdownSharing;
end;

end.