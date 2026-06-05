{       SMIX is Copyright 1995 by Ethan Brodsky.  All rights reserved.       }
unit XMS;
  interface
   {Initialization}
    function XMSInstalled: boolean;
    procedure XMSInit;

   {Informational}
    function XMSGetVersion: word;
    function XMSGetFreeMem: word;

   {Allocation and deallocation}
    function XMSAllocate(var Handle: word; Size: word): boolean;
    function XMSReallocate(Handle: word; NewSize: word): boolean;
    function XMSFree(Handle: word): boolean;

  function xms2xms(SourceHandle : Word; SHandleOffset : LongInt;
    DestHandle : Word; DHandleOffset : LongInt; DataLength : LongInt):boolean;
  function xms2mem(SourceHandle : Word; SHandleOffset : LongInt; var Buf;
    DataLength : LongInt):boolean;
  function mem2xms(var Buf; DestHandle : Word; DHandleOffset : LongInt;
    DataLength : LongInt):boolean;


   {Memory moves}
    type
      PMoveParams = ^TMoveParams;
      TMoveParams =
        record
          Length       : LongInt;  {Length must be a multiple of two}
          SourceHandle : word;
          SourceOffset : LongInt;
          DestHandle   : word;
          DestOffset   : LongInt;
        end;
    function XMSMove(Params: PMoveParams): boolean;

  implementation  {ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ}
    var
      XMSDriver: pointer;

{ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

    function XMSInstalled: boolean; assembler;
      asm
        mov    ax, 4300h
        int    2Fh
        cmp    al, 80h
        jne    @NoXMSDriver
        mov    al, TRUE
        jmp    @Done
       @NoXMSDriver:
        mov    al, FALSE
       @Done:
      end;

{ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ}

    procedure XMSInit; assembler;
      asm
        mov    ax, 4310h
        int    2Fh
        mov    word ptr [XMSDriver], bx
        mov    word ptr [XMSDriver+2], es
      end;

{ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

    function XMSGetVersion: word; assembler;
      asm
        mov    ah, 00h
        call   XMSDriver
      end;

{ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ}

    function XMSGetFreeMem: word; assembler;
      asm
        mov    ah, 08h
        call   XMSDriver
        mov    ax, dx
      end;

{ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

    function XMSAllocate(var Handle: word; Size: word): boolean; assembler;
      asm
        mov    ah, 09h
        mov    dx, Size
        call   XMSDriver
        les    di, Handle
        mov    es:[di], dx
      end;

{ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ}

    function XMSReallocate(Handle: word; NewSize: word): boolean; assembler;
      asm
        mov    ah, 0Fh
        mov    bx, NewSize
        mov    dx, Handle
        call   XMSDriver
      end;

{ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ}

    function XMSFree(Handle: word): boolean; assembler;
      asm
        mov    ah, 0Ah
        mov    dx, Handle
        call   XMSDriver
      end;

{ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
    function XMSMove(Params: PMoveParams): boolean; assembler;
      asm
        push   ds
        mov    ax, ds
        mov    es, ax
        mov    ah, 0Bh
        lds    si, Params
        call   es:XMSDriver
        pop    ds
      end;


Function xms2xms(SourceHandle : Word; SHandleOffset : LongInt;
  DestHandle : Word; DHandleOffset : LongInt; DataLength : LongInt):boolean;
var
MoveParams: TMoveParams;
begin
if datalength and 1=1 then inc(datalength);
   moveparams.Length       := datalength;
   moveparams.SourceHandle := SourceHandle;
   moveparams.SourceOffset := SHandleOffset;
   moveparams.DestHandle   := DestHandle;
   moveparams.DestOffset   := DHandleOffset;
    xms2xms:=xmsMove(@MoveParams);
end;

Function xms2mem(SourceHandle : Word; SHandleOffset : LongInt; var Buf;
  DataLength : LongInt):boolean;
var
MoveParams: TMoveParams;
begin
if datalength and 1=1 then inc(datalength);
   moveparams.Length       := datalength;
   moveparams.SourceHandle := SourceHandle;
   moveparams.SourceOffset := SHandleOffset;
   moveparams.DestHandle   := 0;
   moveparams.DestOffset   := longint(@buf);
   xms2mem:=xmsMove(@MoveParams);
{   xms2mem:=xmsMove(DataLength, SourceHandle, Pointer(SHandleOffset),
     0, @Buf)}
end;

Function mem2xms(var Buf; DestHandle : Word; DHandleOffset : LongInt;
  DataLength : LongInt):boolean;
var
MoveParams: TMoveParams;
begin
if datalength and 1=1 then inc(datalength);
   moveparams.Length       := datalength;
   moveparams.SourceHandle := 0;
   moveparams.SourceOffset := longint(@buf);
   moveparams.DestHandle   := DestHandle;
   moveparams.DestOffset   := DHandleOffset;
   mem2xms:=xmsMove(@MoveParams);
{    mem2xms:=xmsMove(DataLength, 0, @Buf, DestHandle,
      Pointer(DHandleOffset))}
end;

end.