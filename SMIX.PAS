unit SMix;
{$X+,G+,R-}
INTERFACE
const
   BlockLength   = 512;      {Size of digitized sound block               }
   LoadChunkSize = 2048;     {Chunk size used for loading sounds from disk}
   Voices        = 25;        {Number of available voices                  }
   DefSamplingRate = 22025;  {Sampling rate for output                    }
   ilehandlerow  = 6;
type
   PSound = ^TSound;
   TSound = record
            XMSHandle: word;
            StartOfs:  LongInt;
            SoundSize: LongInt;
            end;
var
   VoiceInUse: array[0..Voices-1] of boolean;
   IntCount   : LongInt;  {Number of sound interrupts that have occured   }
   DSPVersion : word;     {Contains the version of the installed DSP chip }
   AutoInit   : boolean;  {Tells Auto-initialized DMA transfers are in use}
   SixteenBit : boolean;  {Tells whether 16-bit sound output is occuring  }
   SMIXsound  : boolean;  {Tells whether SMIX is currently operating      }

   {Setup for storing all sounds in one extended memory block (Saves handles)}
   SharedSize:array[1..ilehandlerow] of LongInt;
   handlery:array[1..ilehandlerow] of word;

{*}FUNCTION InitSB(BaseIO: word; IRQ: byte; DMA, DMA16: byte): boolean;
      {Initializes control parameters, resets DSP, and installs int. handler }
      { Parameters: (Can be found using GetSettings PROCEDURE in Detect)     }
      {  BaseIO:   Sound card base IO address                                }
      {  IRQ:      Sound card IRQ setting                                    }
      {  DMA:      Sound card 8-bit DMA channel                              }
      {  DMA16:    Sound card 16-bit DMA channel (0 if not supported)        }
      { Returns:                                                             }
      {  TRUE:     Sound card successfully initialized (Maybe)               }
      {  FALSE:    Sound card could not be initialized                       }
{*}PROCEDURE ShutdownSB;
      {Removes interrupt handler and resets DSP                              }

{*}PROCEDURE SetSamplingRate(Rate: Word);
      {Overrides default sampling rate set with DefSamplingRate constant     }
      { Parameters:                                                          }
      {  Rate:     New sampling rate (will be rounded by sound card)         }
      {This FUNCTION can either be called before calling InitMixing (after   }
      {calling InitSB) to change the sampling rate before playback begins or }
      {called during playback to change the rate dynamically.  The lowest    }
      {sampling rate that will work is roughly 5000 HZ.  The highest sampling}
      {rate that will work on all sound cards is 22050 HZ.  If you only want }
      {to support the SB16, then you can use rates all the way up to 48000 HZ}

{*}PROCEDURE InitMixing;
      {Allocates internal buffers and starts digitized sound output          }
{*}PROCEDURE ShutdownMixing;
      {Deallocates internal buffers and stops digitized sound output         }

{*}FUNCTION  InitXMS: boolean;
      {Attempts to intialize extended memory                                 }
      { Returns:                                                             }
      {  TRUE:     Extended memory successfully initialized                  }
      {  FALSE:    Extended memory could not be initialized                  }

{*}PROCEDURE InitSharing;
      {Allocates an EMB that all sounds are stored in.  This preserves EMB   }
      {handles, which are a scarce resource.  Call this on initialization and}
      {all sounds will automatically be stored in one EMB.  Call LoadSound as}
      {usual to allocate a sound, but FreeSound only deallocates the sound   }
      {data structure.  Call ShutdownSharing before program termination to   }
      {free allocated extended memory.                                       }
{*}PROCEDURE ShutdownSharing;
      {Shuts down EMB sharing and frees all allocated extended memory        }

{*}FUNCTION LoadSound(var Sound: PSound; dplik,Key: string; offset,rozmiar:longint; handl:word): boolean;
      {Allocates an extended memory block and loads a sound from a file      }
      { Parameters:                                                          }
      {  Sound:    Unallocated pointer to sound data structure               }
      {  Key:      If a resource file has been opened then key is a resource }
      {            identifier.  Use the same ID as you used for SNDLIB.      }
      {            If a resource file has not been opened, then key is the   }
      {            filename to load the sound data from.                     }
      { Returns:                                                             }
      {  TRUE:     Sound loaded sucessfully                                  }
      {  FALSE:    Error loading sound                                       }
{*}PROCEDURE FreeSound(var Sound: PSound);
      {Deallocates extended memory and destroys sound data structure         }
      { Parameters:                                                          }
      {  Sound:    Unallocated pointer to sound data structure               }

{*FUNCTION StartSound(Sound: PSound; Index: byte; Loop: boolean): boolean;
{*}FUNCTION StartSound(Sound: PSound; Loop: boolean; chan1,chan2:byte): boolean;
      {Starts playing a sound                                                }
      { Parameters:                                                          }
      {  Sound:    Pointer to sound data structure                           }
      {  Index:    A number to keep track of the sound with (Used to stop it)}
      {  Loop:     Indicates whether the sound should be continuously looped }
      { Returns:                                                             }
      {  TRUE:     Sound was played                                          }
      {  FALSE:    There were no free channels and the sound was not played  }
{*}PROCEDURE StopSound(Index: byte);
      {Stops playing sound                                                   }
      { Parameters:                                                          }
      {  Index:    Index of sound to stop (All with given index are stopped) }
{*}FUNCTION SoundPlaying(Index: byte): boolean;
      {Checks if a sound is still playing                                    }
      { Parameters:                                                          }
      {  Index:    Index used when the sound was started                     }
      { Returns:                                                             }
      {  TRUE      At least oen sound with the specified index is playing    }
      {  FALSE     No sounds with the specified index are playing            }



IMPLEMENTATION
uses CRT, DOS, XMS,vars,dat_file;

type
   PVoice = ^TVoice;
   TVoice = record
            Sound:     PSound;
            Index:     byte;
            CurPos:    LongInt;
            Loop:      boolean;
            end;
   PMixingBlock = ^TMixingBlock;
   TMixingBlock = array[1..BlockLength] of integer;
   {8-bit}
   POut8Block   = ^TOut8Block;
   TOut8Block   = array[1..BlockLength] of byte;
   POut8Buffer  = ^TOut8Buffer;
   TOut8Buffer  = array[1..2] of TOut8Block;
   {16-bit}
   POut16Block  = ^TOut16Block;
   TOut16Block  = array[1..BlockLength] of integer;
   POut16Buffer = ^TOut16Buffer;
   TOut16Buffer = array[1..2] of TOut16Block;

   TKey = array[1..8] of char;

const
   BufferLength = BlockLength * 2;
var
   ResetPort,
   ReadPort,
   WritePort,
   PollPort,
   AckPort : word;

   PICRotatePort,
   PICMaskPort : word;

   DMAMaskPort,
   DMAClrPtrPort,
   DMAModePort,
   DMABaseAddrPort,
   DMACountPort,
   DMAPagePort : word;

   IRQStartMask,
   IRQStopMask,
   IRQIntVector : byte;

   DMAStartMask,
   DMAStopMask,
   DMAMode : byte;
   DMALength : word;

   SMIXinitialized : boolean;

   OldIntVector,
   OldExitProc : pointer;

   HandlerInstalled : boolean;

   SamplingRate : word;

{   VoiceInUse: array[0..Voices-1] of boolean;}
   Voice:      array[0..Voices-1] of TVoice;
   CurBlock:   byte;
   {Sound buffer}
   SoundBlock: array[1..BlockLength+1] of ShortInt;
        {The length of XMS copies under HIMEM.SYS must be a mutiple  }
        {of two.  If the sound data ends in mid-block, it may not be }
        {possible to round up without corrupting memory.  Therefore, }
        {the copy buffer has been extended by one byte to eliminate  }
        {this problem.                                               }

   {Mixing buffers}
   MixingBlock  : TMixingBlock;

   {Output buffers}
   OutMemArea  : pointer;
   Out8Buffer  : POut8Buffer;
   Out16Buffer : POut16Buffer;
   BlockPtr    : array[1..2] of pointer;
   CurBlockPtr : pointer;
   {For auto-initialized transfers (Whole buffer)}
   BufferAddr : LongInt;
   BufferPage : byte;
   BufferOfs  : word;
   {For single-cycle transfers (One block at a time)}
   BlockAddr  : array[1..2] of LongInt;
   BlockPage  : array[1..2] of byte;
   BlockOfs   : array[1..2] of word;
   {Clipping for 8-bit output}
   Clip8 : array[-128*Voices..128*Voices] of byte;

   {Setup for sound resource files}

   SoundFile : file;
   SoundSize : LongInt;


{*}PROCEDURE WriteDSP(Value: byte);
begin
repeat until (Port[WritePort] and $80) = 0;
Port[WritePort] := Value;
end;

{*}FUNCTION ReadDSP: byte;
begin
repeat until (Port[PollPort] and $80) <> 0;
ReadDSP := Port[ReadPort];
end;

{*}FUNCTION ResetDSP: boolean;
var
i: byte;
begin
Port[ResetPort] := 1;
Delay(1);                              {One millisecond}
Port[ResetPort] := 0;
i := 100;
while (ReadDSP <> $AA) and (i > 0) do Dec(i);
if i > 0 then ResetDSP := true
         else ResetDSP := false;
end;

{*}PROCEDURE InstallHandler; forward;
{*}PROCEDURE UninstallHandler; forward;
{*}PROCEDURE MixExitProc; far; forward;

{*}FUNCTION InitSB(BaseIO: word; IRQ: byte; DMA, DMA16: byte): boolean;
begin
{Sound card IO ports}
ResetPort  := BaseIO + $6;
ReadPort   := BaseIO + $A;
WritePort  := BaseIO + $C;
PollPort   := BaseIO + $E;

{Reset DSP, get version, and pick output mode}
if not(ResetDSP) then begin
   InitSB := false;
   Exit;
end;

WriteDSP($E1);  {Get DSP version number}
DSPVersion := ReadDSP shl 8;  DSPVersion := DSPVersion + ReadDSP;
AutoInit   := DSPVersion >= $0200;
SixteenBit := (DSPVersion >= $0400) and (DMA16 <> $FF) and (DMA16 > 3);

{Compute interrupt ports and parameters}
if IRQ <= 7 then begin
   IRQIntVector  := $08+IRQ;
   PICMaskPort   := $21;
end else begin
    IRQIntVector  := $70+IRQ-8;
    PICMaskPort   := $A1;
    end;
IRQStopMask  := 1 shl (IRQ mod 8);
IRQStartMask := not(IRQStopMask);

{Compute DMA ports and parameters}
if SixteenBit then begin {Sixteen bit}
   DMAMaskPort     := $D4;
   DMAClrPtrPort   := $D8;
   DMAModePort     := $D6;
   DMABaseAddrPort := $C0 + 4*(DMA16-4);
   DMACountPort    := $C2 + 4*(DMA16-4);
   case DMA16 of
      5:  DMAPagePort := $8B;
      6:  DMAPagePort := $89;
      7:  DMAPagePort := $8A;
   end;
   DMAStopMask  := DMA16-4 + $04;   {000001xx}
   DMAStartMask := DMA16-4 + $00;   {000000xx}
   DMAMode      := DMA16-4 + $58;   {010110xx}
   AckPort := BaseIO + $F;
end else begin{Eight bit}
   DMAMaskPort     := $0A;
   DMAClrPtrPort   := $0C;
   DMAModePort     := $0B;
   DMABaseAddrPort := $00 + 2*DMA;
   DMACountPort    := $01 + 2*DMA;
   case DMA of
      0:  DMAPagePort := $87;
      1:  DMAPagePort := $83;
      2:  DMAPagePort := $81;
      3:  DMAPagePort := $82;
   end;
   DMAStopMask  := DMA + $04;       {000001xx}
   DMAStartMask := DMA + $00;       {000000xx}
   if AutoInit then DMAMode := DMA + $58      {010110xx}
               else DMAMode := DMA + $48;     {010010xx}
   AckPort := BaseIO + $E;
end;
if AutoInit then DMALength := BufferLength
            else DMALength := BlockLength;
InstallHandler;

SMIXinitialized := true;
SMIXsound       := false;
SamplingRate    := DefSamplingRate;

InitSB := true;
end;

{*}PROCEDURE ShutdownSB;
begin
if HandlerInstalled then UninstallHandler;
ResetDSP;
end;

{*}FUNCTION InitXMS: boolean;
begin
InitXMS := true;
if not(XMSInstalled) then InitXMS := false
                     else XMSInit;
end;


{*}FUNCTION TimeConstant(Rate: word): byte;
begin
TimeConstant := 256 - (1000000 div Rate);
end;

{*}PROCEDURE InitSamplingRate(Rate: word);
begin
if SixteenBit then begin
   WriteDSP($41);      {Set digitized sound output sampling rate}
   WriteDSP(Hi(Rate));
   WriteDSP(Lo(Rate));
end else begin
    WriteDSP($40);      {Set digitized sound time constant       }
    WriteDSP(TimeConstant(Rate));
end;
end;

{*}PROCEDURE SetSamplingRate(Rate: word);
begin
SamplingRate := Rate;
if (SMIXsound) then begin
   if SixteenBit then begin
      InitSamplingRate(SamplingRate);
      WriteDSP($D6); {Continue 16-bit DMA mode digitized sound }
   end else begin
      WriteDSP($D0); {Pause 8-bit DMA mode digitized sound     }
      InitSamplingRate(SamplingRate);
      WriteDSP($D4); {Continue 8-bit DMA mode digitized sound  }
   end;
end;
end;

{*}PROCEDURE StartDAC;
begin
Port[DMAMaskPort]     := DMAStopMask;
Port[DMAClrPtrPort]   := $00;
Port[DMAModePort]     := DMAMode;
Port[DMABaseAddrPort] := Lo(BufferOfs);
Port[DMABaseAddrPort] := Hi(BufferOfs);
Port[DMACountPort]    := Lo(DMALength-1);
Port[DMACountPort]    := Hi(DMALength-1);
Port[DMAPagePort]     := BufferPage;
Port[DMAMaskPort]     := DMAStartMask;

InitSamplingRate(SamplingRate);

if SixteenBit then begin {Sixteen bit: SB16 and up (DSP 4.xx)}
   WriteDSP($B6);        {16-bit DMA command: D/A, Auto-Init, FIFO}
   WriteDSP($10);        {16-bit DMA mode:    Signed Mono         }
   WriteDSP(Lo(BlockLength - 1));
   WriteDSP(Hi(BlockLength - 1));
end else begin{Eight bit}
   WriteDSP($D1);        {Turn on speaker                         }
   if AutoInit then begin{Eight bit auto-initialized: SBPro and up (DSP 2.00+)}
      WriteDSP($48);  {Set DSP block transfer size             }
      WriteDSP(Lo(BlockLength - 1));
      WriteDSP(Hi(BlockLength - 1));
      WriteDSP($1C);  {8-bit auto-init DMA mono sound output   }
   end else begin{Eight bit single-cycle: Sound Blaster (DSP 1.xx+)}
      WriteDSP($14);  {8-bit single-cycle DMA sound output     }
      WriteDSP(Lo(BlockLength - 1));
      WriteDSP(Hi(BlockLength - 1));
   end;
end;
SMIXsound := true;
end;

{*}PROCEDURE StopDAC;
begin
SMIXsound := false;
if SixteenBit then begin{Sixteen bit}
   WriteDSP($D5);        {Pause 16-bit DMA sound I/O              }
end else begin{Eight bit}
   WriteDSP($D0);        {Pause 8-bit DMA mode sound I/O          }
   WriteDSP($D3);        {Turn off speaker                        }
end;
Port[DMAMaskPort] := DMAStopMask;
end;


{*}PROCEDURE InitSharing;
var a:byte;
begin
for a:=1 to ilehandlerow do begin
    SharedSize[a] := 0;
    XMSAllocate(handlery[a], SharedSize[a]);
end;
end;

{*}PROCEDURE ShutdownSharing;
var a:byte;
begin
for a:=1 to ilehandlerow do
    XMSFree(handlery[a]);
end;


{*}FUNCTION Min(a, b: LongInt): LongInt;
begin
if a < b then Min := a
         else Min := b;
end;

{Loading and freeing sounds}
{*}FUNCTION LoadSound(var Sound: PSound; dplik,Key: string; offset,rozmiar:longint; handl:word): boolean;
var
Size: LongInt;
InBuffer: array[1..LoadChunkSize] of byte;
Remaining: LongInt;
MoveParams: TMoveParams;
begin
LoadSound := false;
if not jestkartamuzyczna then begin
   LoadSound := true;
   exit;
end;

if key<>'' then begin {z dat pliku}
   DATassign(SoundFile, dplik,key,0);
   SoundSize:=datplik.rozmiar;
end else begin {z innego pliku}
   Assign(SoundFile, dplik);
   Reset(SoundFile, 1);
   seek(soundfile,offset);
   SoundSize:=rozmiar;
end;

New(Sound);
Sound^.SoundSize := SoundSize;
Sound^.StartOfs := SharedSize[handl];
Sound^.XMSHandle := handlery[handl];
SharedSize[handl] := SharedSize[handl] + SoundSize;
if not(XMSReallocate(handlery[handl], (SharedSize[handl] + 1023) div 1024)) then exit;

MoveParams.SourceHandle := 0;
MoveParams.SourceOffset := LongInt(Addr(InBuffer));
MoveParams.DestHandle   := Sound^.XMSHandle;
MoveParams.DestOffset   := Sound^.StartOfs;

Remaining := Sound^.SoundSize;

repeat
   MoveParams.Length := Min(Remaining, LoadChunkSize);
   BlockRead(SoundFile, InBuffer, MoveParams.Length);
   MoveParams.Length := ((MoveParams.Length+1) div 2) * 2;
   XMSMove(@MoveParams); {XMS copy lengths must be a multiple of two}
   Inc(MoveParams.DestOffset, MoveParams.Length);
   Dec(Remaining, MoveParams.Length);
until not(Remaining > 0);

Close(SoundFile);
LoadSound := true;
end;

{*}PROCEDURE FreeSound(var Sound: PSound);
begin
Dispose(Sound);
Sound := nil;
end;

{*}PROCEDURE DeallocateVoice(VoiceNum: byte);
begin
VoiceInUse[VoiceNum] := false;
with Voice[VoiceNum] do begin
     Sound    := nil;
     Index    := 0;
     CurPos   := 0;
     Loop     := false;
end;
end;

(*{*}FUNCTION StartSound(Sound: PSound; Index: byte; Loop: boolean): boolean;
var
i,Slot:byte;
begin
if not kfg.dzwiek then begin
   startsound:=true;
   exit;
end;
StartSound:=false; {assume that we cannot play the sound}
Slot:=$FF;
i:=0;
repeat
   if not(VoiceInUse[i]) then Slot := i;
   Inc(i);
until ((Slot <> $FF) or (i=Voices));

if Slot <> $FF then begin
   Voice[Slot].Sound :=Sound;
   Voice[Slot].Index :=Index;
   Voice[Slot].CurPos:=0;
   Voice[Slot].Loop  :=Loop;

   VoiceInUse[Slot]:=true;

   StartSound:=true; {success}
end;
end;
*)
{*}FUNCTION StartSound(Sound: PSound; Loop: boolean; chan1,chan2:byte): boolean;
var
i,Slot:byte;
begin
if (not kfg.dzwiek) or (not jestkartamuzyczna) then begin
   startsound:=true;
   exit;
end;
StartSound:=false; {assume that we cannot play the sound}
Slot:=$FF;
i:=chan1;
repeat
   if not(VoiceInUse[i]) then Slot := i;
   Inc(i);
until ((Slot <> $FF) or (i=Voices) or (i>=chan2+1));

if slot=$FF then begin
   slot:=chan1+random(chan2-chan1+1);
   stopsound(slot);
end;

if Slot <> $FF then begin
   Voice[Slot].Sound :=Sound;
   Voice[Slot].Index :=slot;
   Voice[Slot].CurPos:=0;
   Voice[Slot].Loop  :=Loop;

   VoiceInUse[Slot]:=true;

   StartSound:=true; {success}
end;
end;

{*}PROCEDURE StopSound(Index: byte);
var
i: byte;
begin
if jestkartamuzyczna then
  for i := 0 to Voices-1 do
    if (Voice[i].Sound <> nil) and (Voice[i].Index = Index) then begin
       DeallocateVoice(i);
    end;
end;

{*}FUNCTION SoundPlaying(Index: byte): boolean;
var
i: byte;
begin
SoundPlaying := False;
for i := 0 to Voices-1 do
    if (Voice[i].Sound <> nil) and (Voice[i].Index = Index) then
       SoundPlaying := True;
end;

{*}PROCEDURE UpdateVoices;
var
VoiceNum: byte;
begin
for VoiceNum := 0 to Voices-1 do begin
    if VoiceInUse[VoiceNum] then
       if Voice[VoiceNum].CurPos >= Voice[VoiceNum].Sound^.SoundSize then begin
          DeallocateVoice(VoiceNum);
       end;
    end;
end;

{Utility functions}
{*}PROCEDURE SetCurBlock(BlockNum: byte);
begin
CurBlock := BlockNum;
CurBlockPtr := pointer(BlockPtr[BlockNum]);
end;

{*}PROCEDURE ToggleBlock;
begin
if CurBlock = 1 then SetCurBlock(2)
                else SetCurBlock(1);
end;

{*}PROCEDURE SilenceBlock;
begin
FillChar(MixingBlock, BlockLength*2, 0);  {FillChar uses REP STOSW}
end;

{*}FUNCTION GetLinearAddr(Ptr: pointer): LongInt;
begin
GetLinearAddr := LongInt(Seg(Ptr^))*16 + LongInt(Ofs(Ptr^));
end;

{*}FUNCTION NormalizePtr(p: pointer): pointer;
var
LinearAddr: LongInt;
begin
LinearAddr := GetLinearAddr(p);
NormalizePtr := Ptr(LinearAddr div 16, LinearAddr mod 16);
end;

{*}PROCEDURE InitClip8;
var
i, Value: integer;
begin
for i := -128*Voices to 128*Voices do begin
    Value := i;
    if (Value < -128) then Value := -128;
    if (Value > +127) then Value := +127;
    Clip8[i] := Value + 128;
    end;
end;

{*}PROCEDURE InitMixing;
var
i: integer;
begin
for i := 0 to Voices-1 do DeallocateVoice(i);
if SixteenBit then begin
   {Find a block of memory that does not cross a page boundary}
   GetMem(OutMemArea, 4*BufferLength);
   if ((GetLinearAddr(OutMemArea) div 2) mod 65536)+BufferLength < 65536 then
      Out16Buffer := OutMemArea
      else
      Out16Buffer := NormalizePtr(Ptr(Seg(OutMemArea^), Ofs(OutMemArea^)+2*BufferLength));
   for i := 1 to 2 do BlockPtr[i] := NormalizePtr(Addr(Out16Buffer^[i]));
   {DMA parameters}
   BufferAddr := GetLinearAddr(pointer(Out16Buffer));
   BufferPage := BufferAddr div 65536;
   BufferOfs  := (BufferAddr div 2) mod 65536;
   for i := 1 to 2 do BlockAddr[i] := GetLinearAddr(pointer(BlockPtr[i]));
   for i := 1 to 2 do BlockPage[i] := BlockAddr[i] div 65536;
   for i := 1 to 2 do BlockOfs[i]  := (BlockAddr[i] div 2) mod 65536;
   FillChar(Out16Buffer^, BufferLength*2, $00);   {Signed   16-bit}
end else begin
   {Find a block of memory that does not cross a page boundary}
   GetMem(OutMemArea, 2*BufferLength);
   if (GetLinearAddr(OutMemArea) mod 65536)+BufferLength < 65536 then
      Out8Buffer := OutMemArea
      else
      Out8Buffer := NormalizePtr(Ptr(Seg(OutMemArea^), Ofs(OutMemArea^)+BufferLength));
   for i := 1 to 2 do BlockPtr[i] := NormalizePtr(Addr(Out8Buffer^[i]));
   {DMA parameters}
   BufferAddr := GetLinearAddr(pointer(Out8Buffer));
   BufferPage := BufferAddr div 65536;
   BufferOfs  := BufferAddr mod 65536;
   for i := 1 to 2 do BlockAddr[i] := GetLinearAddr(pointer(BlockPtr[i]));
   for i := 1 to 2 do BlockPage[i] := BlockAddr[i] div 65536;
   for i := 1 to 2 do BlockOfs[i]  := BlockAddr[i] mod 65536;
   FillChar(Out8Buffer^, BufferLength, $80);      {Unsigned  8-bit}
   InitClip8;
end;
FillChar(MixingBlock, BlockLength*2, $00);
SetCurBlock(1);
IntCount := 0;
StartDAC;
end;

{*}PROCEDURE ShutdownMixing;
begin
StopDAC;
if SixteenBit then FreeMem(OutMemArea, 4*BufferLength)
              else FreeMem(OutMemArea, 2*BufferLength);
end;

{*}PROCEDURE CopySound(Sound: PSound; var CurPos: LongInt; CopyLength: word; Loop: boolean);
var
SoundSize: LongInt;
DestPtr: pointer;
MoveParams: TMoveParams;
begin
SoundSize := Sound^.SoundSize;
DestPtr := pointer(@SoundBlock);
MoveParams.SourceHandle := Sound^.XMSHandle;
MoveParams.DestHandle   := 0;
while CopyLength > 0 do begin
   {Compute max transfer size}
   if CopyLength < SoundSize-CurPos then MoveParams.Length := CopyLength
                                    else MoveParams.Length := SoundSize-CurPos;
   {Compute starting dest. offset and update offset for next block}
   MoveParams.SourceOffset := Sound^.StartOfs + CurPos;
   CurPos := CurPos + MoveParams.Length;
   if Loop then CurPos := CurPos mod SoundSize;

   {Compute starting source offset and update offset for next block}
   MoveParams.DestOffset := LongInt(DestPtr);
   DestPtr := NormalizePtr(Ptr(Seg(DestPtr^), Ofs(DestPtr^)+MoveParams.Length));

   {Update remaining count for next iteration}
   CopyLength := CopyLength - MoveParams.Length;

   {Move block}
   MoveParams.Length := ((MoveParams.Length+1) div 2) * 2;
   {XMS copy lengths must be a multiple of two}
   XMSMove(@MoveParams);  {Luckily, the XMS driver is re-entrant}
   end;
end;

{*}PROCEDURE MixVoice(VoiceNum: byte);
var
MixLength: word;
begin
with Voice[VoiceNum] do
     if Loop then MixLength := BlockLength
        else
        if BlockLength < Sound^.SoundSize-CurPos then MixLength := BlockLength
           else MixLength := Sound^.SoundSize-CurPos;
CopySound(Voice[VoiceNum].Sound, Voice[VoiceNum].CurPos, MixLength, Voice[VoiceNum].Loop);
asm
   lea  si, SoundBlock         {DS:SI -> Sound data (Source)          }
   mov  ax, ds                 {ES:DI -> Mixing block (Destination)   }
   mov  es, ax
   lea  di, MixingBlock
   mov  cx, MixLength          {CX = Number of samples to copy        }

  @MixSample:
   mov  al, [si]               {Load a sample from the sound block    }
   inc  si                     { increment pointer                    }
   cbw                         {Convert it to a 16-bit signed sample  }
   add  es:[di], ax            {Add it into the mixing buffer         }
   add  di, 2                  {Next word in mixing buffer            }
   dec  cx                     {Loop for next sample                  }
   jnz  @MixSample
end;
end;

{*}PROCEDURE MixVoices;
var
i: word;
begin
SilenceBlock;
for i := 0 to Voices-1 do if VoiceInUse[i] then MixVoice(i);
end;

{*}PROCEDURE CopyData16; assembler;
asm
   lea   si, MixingBlock         {DS:SI -> 16-bit input block           }
   les   di, [CurBlockPtr]       {ES:DI -> 16-bit output block          }
   mov   cx, BlockLength         {CX = Number of samples to copy        }

  @CopySample:
   mov   ax, [si]                {Load a sample from the mixing block   }
   add   di, 2                   {Increment destination pointer         }
   sal   ax, 5                   {Shift sample left to fill 16-bit range}
   add   si, 2                   {Increment source pointer              }
   mov   es:[di-2], ax           {Store sample in output block          }
   dec   cx                      {Process the next sample               }
   jnz   @CopySample
end;

{*}PROCEDURE CopyData8; assembler;
asm
   push  bp
   mov   dx, ss                  {Preserve SS in DX                     }
   pushf
   cli                           {Disable interrupts                    }
   mov   ax, ds                  {Using SS for data                     }
   mov   ss, ax

   lea   si, Clip8               {DS:SI -> 8-bit clipping buffer        }
   add   si, 128*Voices          {DS:SI -> Center of clipping buffer    }

   lea   bp, MixingBlock         {SS:BP -> 16-bit input block           }
   les   di, [CurBlockPtr]       {ES:DI -> 8-bit output block           }
   mov   cx, BlockLength         {CX = Number of samples to copy        }

  @CopySample:
   mov   bx, [bp]                {BX = Sample from mixing block         }
   inc   di                      {Increment destination pointer (DI)    }
   add   bp, 2                   {Increment source pointer (BP)         }
   mov   al, [si+bx]             {AL = Clipped sample                   }
   mov   es:[di-1], al           {Store sample in output block          }
   dec   cx                      {Process the next sample               }
   jnz   @CopySample

   mov   ss, dx                  {Restore SS                            }
   popf                          {Restore flags                         }
   pop   bp
end;

{*}PROCEDURE CopyData;
begin
if SixteenBit then CopyData16
              else CopyData8;
end;

{*}PROCEDURE StartBlock_SC; {Starts a single-cycle DMA transfer}
begin
Port[DMAMaskPort]     := DMAStopMask;
Port[DMAClrPtrPort]   := $00;
Port[DMAModePort]     := DMAMode;
Port[DMABaseAddrPort] := Lo(BlockOfs[CurBlock]);
Port[DMABaseAddrPort] := Hi(BlockOfs[CurBlock]);
Port[DMACountPort]    := Lo(DMALength-1);
Port[DMACountPort]    := Hi(DMALength-1);
Port[DMAPagePort]     := BlockPage[CurBlock];
Port[DMAMaskPort]     := DMAStartMask;
WriteDSP($14);                {8-bit single-cycle DMA sound output   }
WriteDSP(Lo(BlockLength - 1));
WriteDSP(Hi(BlockLength - 1));
end;

{$IFNDEF VER60}
   var Save_Test8086: byte; {CPU type flag}
{$ENDIF}

{*}PROCEDURE IntHandler; interrupt;
var
Temp: byte;
begin
{On a 386 or higher, Turbo Pascal 7 uses 32-bit registers for LongInt
 math.  Unfortunately, it doesn't preserve these registers when
 generating code to handle interrupts, so they are occasionally
 corrupted.  This can cause a problem with LongInt math in your
 program or in TSRs. The below code disables 32-bit instructions for
 the interrupt to prevent 32-bit register corruption.                 }
{$IFNDEF VER60}
   Save_Test8086 := Test8086;
   Test8086 := 0;
{$ENDIF}

Inc(IntCount);

if not(AutoInit) then begin{Start next block first if not using auto-init DMA}
   StartBlock_SC;
   CopyData;
   ToggleBlock;
end;

UpdateVoices;
MixVoices;

if (AutoInit) then begin
   CopyData;
   ToggleBlock;
end;

{$IFNDEF VER60}
   Test8086 := Save_Test8086;
{$ENDIF}

   Temp := Port[AckPort];
   Port[$A0] := $20;
   Port[$20] := $20;
end;

{*}PROCEDURE EnableInterrupts;  InLine($FB); {STI}
{*}PROCEDURE DisableInterrupts; InLine($FA); {CLI}

{*}PROCEDURE InstallHandler;
begin
DisableInterrupts;
Port[PICMaskPort] := Port[PICMaskPort] or IRQStopMask;
GetIntVec(IRQIntVector, OldIntVector);
SetIntVec(IRQIntVector, @IntHandler);
Port[PICMaskPort] := Port[PICMaskPort] and IRQStartMask;
EnableInterrupts;
HandlerInstalled := true;
end;

{*}PROCEDURE UninstallHandler;
begin
DisableInterrupts;
Port[PICMaskPort] := Port[PICMaskPort] or IRQStopMask;
SetIntVec(IRQIntVector, OldIntVector);
EnableInterrupts;
HandlerInstalled := false;
end;

{*}PROCEDURE MixExitProc;       {Called automatically on program termination}
begin
ExitProc := OldExitProc;
if (SMIXinitialized) then begin
   StopDAC;
   ShutdownSB;
end;
end;

{*}BEGIN
SMIXinitialized      := false;
HandlerInstalled     := false;
OldExitProc := ExitProc;
ExitProc    := @MixExitProc;
end.
