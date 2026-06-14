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
   {dzwieki podst. ~1410 KB + grafika XMS 5000 KB + zapas na postaci}
   XMSRequired   = 8500;
   SharedEMB     = true;
      {TRUE:   All sounds will be stored in a shared EMB}
      {FALSE:  Each sound will be stored in a separate EMB}
var
   BaseIO: word; IRQ, DMA, DMA16: byte;
   OldExitProc: pointer;

{*}PROCEDURE LoadBaseSound(n: integer; nazwa: string);
begin
if not LoadSound(Sound[n], 'dane\s2.dat', nazwa, 0, 0, 1) then begin
   writeln('Blad wczytywania dzwieku: ', nazwa);
   Halt(5);
end;
end;

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
     writeln('brak pamieci XMS');
     Halt(4); {Insufficient XMS memory}
  end else begin
   writeln('wczytywanie dzwiekow');
   if SharedEMB then InitSharing;

   LoadBaseSound(0, 'BUM1.raw');
   LoadBaseSound(1, 'BUM2.raw');
   LoadBaseSound(2, 'BUM3.raw');
   LoadBaseSound(3, 'PILKAKOP.raw');
   LoadBaseSound(4, 'CEGLA.raw');
   LoadBaseSound(5, 'GRANATS.raw');
   LoadBaseSound(6, 'SYKBOMB.raw');
   LoadBaseSound(7, 'BAZUKA.raw');
   LoadBaseSound(8, 'STRZELBA.raw');
   LoadBaseSound(9, 'DZIALO1.raw');
   LoadBaseSound(10,'DZIALO2.raw');
   LoadBaseSound(11,'BURZA1.raw');
   LoadBaseSound(12,'INTRO.raw');
   LoadBaseSound(13,'POCHDNIA.raw');
   LoadBaseSound(14,'OGIEN.raw');
   LoadBaseSound(15,'SPALONY.raw');
   LoadBaseSound(16,'MIOTACZ.raw');
   LoadBaseSound(17,'DESZCZ.raw');
   LoadBaseSound(18,'SNAJPER.raw');
   LoadBaseSound(19,'NALOT.raw');
   LoadBaseSound(20,'KOWADLO.raw');
   LoadBaseSound(21,'LASER1.raw');
   LoadBaseSound(22,'LASER2.raw');
   LoadBaseSound(23,'PRAD.raw');
   LoadBaseSound(24,'POSTAC.raw');
   LoadBaseSound(25,'INTROW.raw');
   LoadBaseSound(26,'GRANATS.raw'); {niepotrzebne}
   LoadBaseSound(27,'PLUM.raw');
   LoadBaseSound(28,'PSSS1.raw');
   LoadBaseSound(29,'PSSS2.raw');
   LoadBaseSound(30,'SMIECH1.raw');
   LoadBaseSound(31,'SMIECH2.raw');
   LoadBaseSound(32,'SMIECH3.raw');
   LoadBaseSound(33,'SMIECH4.raw');
   LoadBaseSound(34,'SMIECH5.raw');
   LoadBaseSound(35,'SMIECH6.raw');
   LoadBaseSound(36,'SMIECH7.raw');
   LoadBaseSound(37,'KULAOG.raw');
   LoadBaseSound(38,'PILACZEK.raw');
   LoadBaseSound(39,'PILAKLIK.raw');
   LoadBaseSound(40,'PILAPOC.raw');
   LoadBaseSound(41,'PILATNIE.raw');
   LoadBaseSound(42,'MINAPIP.raw');
   LoadBaseSound(43,'PACZROZW.raw');
   LoadBaseSound(44,'PACZSPAD.raw');
   LoadBaseSound(45,'BOMBAS.raw');
   LoadBaseSound(46,'PTAK1.raw');
   LoadBaseSound(47,'NETOPER.raw');
   LoadBaseSound(48,'BOING.raw');
   LoadBaseSound(49,'REJLGAN.raw');
   LoadBaseSound(50,'BULBUL.raw');

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