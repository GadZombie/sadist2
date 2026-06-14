{$A+,B-,D+,E-,F+,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
unit maskp;

interface
uses xms,vars;
type
  chm=array[1..255] of array[0..255] of byte;
  neg=array[0..255] of byte;
var
  chmur:^chm;
  negatyw:^neg;
  y,z:word;

{rysuje zwyczajnie rysunek z kolorem przezroczystym Maskcolor}
PROCEDURE MaskPic(X,Y,Width,Height:integer; Maskcolor:byte; var Sprite, Dest);
{rysuje rysunek z kolorem przezroczystym Maskcolor i zamienia wszystko na color}
PROCEDURE MaskPic2(X,Y,Width,Height:integer; Maskcolor,color:byte; var Sprite,Dest);
{rysuje rysunek z kolorem przezroczystym Maskcolor i dodaje do kolorow wartosc color}
PROCEDURE MaskPic3(X,Y,Width,Height:integer; Maskcolor:byte;color:shortint; var Sprite,Dest);
{rysuje rysunek z kolorem przezroczystym Maskcolor przezroczyste}
PROCEDURE MaskPict(X,Y,Width,Height:integer; Maskcolor:byte; var tab,Sprite, Dest);
{rysuje odbity w poziomie rysunek z kolorem przezroczystym 0}
PROCEDURE MaskPicRev(X,Y,Width,Height:integer; var sprite,dest);
{rysuje odbity w poziomie rysunek z kolorem przezroczystym 0 i zamienia wszystko na color}
PROCEDURE MaskPic2Rev(X,Y,Width,Height:integer; color:byte; var sprite,dest);
{rysuje rysunek z kolorem przezroczystym 0, bez obciniania, na dowolnej tablicy}
PROCEDURE QuickMaskPic(ildanych:word; var Sprite,Dest);
{rysuje rysunek z kolorem przezroczystym Maskcolor z XMSu odbite lub nie}
PROCEDURE MaskPicXMS(X,Y,Width,Height:integer; Maskcolor:byte; offset:longint ;var Dest;odwroc:shortint;zawsze:boolean);
{rysuje rysunek z kolorem przezroczystym Maskcolor z XMSu odbite lub nie i zamienia wszystko na color}
PROCEDURE MaskPic2XMS(X,Y,Width,Height:integer; Maskcolor,color:byte; offset:longint ;var Dest;odwroc:shortint;zawsze:boolean);
{rysuje rysunek z kolorem przezroczystym Maskcolor z XMSu dodaje do kolorow wartosc color}
PROCEDURE MaskPic3XMS(X,Y,Width,Height:integer; Maskcolor:byte;color:shortint; offset:longint ;var Dest;zawsze:boolean);
{rysuje prostokat wypelniony przezroczysty}
PROCEDURE barT(x1,y1,x2,y2:integer; kolor:byte; var gdzie,tab);
{rysuje prostokat wypelniony przezroczysty z pobieraniem przesunietym w poziomie o 'przes'}
PROCEDURE barTp(x1,y1,x2,y2,przes:word; kolor:byte; var gdzie,tab);
{rysuje rysunek z kolorem przezroczystym Maskcolor z XMSu odbite lub nie przezroczyste}
PROCEDURE MaskPictXMS(X,Y,Width,Height:integer; Maskcolor:byte; offset:longint ;var Dest);

implementation

{*}PROCEDURE MaskPic(X,Y,Width,Height:integer; Maskcolor:byte; var Sprite, Dest);
 Begin
  If (x <= -width) or (x >= 320) or (y <= -height) or (y >= 200) then exit;
 Asm
   PUSH  DS
   LDS   SI,Sprite
   LES   DI,DEST
   MOV   AX,WIDTH
   MOV   DX,AX
   PUSH  DX
   ADD   AX,X
   PUSH  Width
   CMP   AX,320
   JG    @RightCut
   SUB   AX,X
   JC    @LeftCut
   JMP   @CheckBottom
 @RightCut:
   SUB   AX,Width
   SUB   AX,320
   NEG   AX
   MOV   Width,AX
   JMP   @CheckBottom
 @LeftCut:
   ADD   AX,X
   MOV   Width,AX
   SUB   DX,AX
   ADD   SI,DX
   XOR   BX,BX
   MOV   X,BX
 @CheckBottom:
   MOV   AX,Height
   ADD   AX,Y
   CMP   AX,200
   JG    @BottomCut
   SUB   AX,Y
   JC    @TopCut
   POP   BX
   JMP   @Display
 @BottomCut:
   POP   BX
   SUB   AX,Height
   SUB   AX,200
   NEG   AX
   MOV   Height,AX
   JMP   @Display
 @TopCut:
  ADD   AX,Y
  POP   BX
  PUSH  AX
  MOV   AX,Y
  NEG   AX
  IMUL  BX
  ADD   SI,AX
  POP   AX
  MOV   Height,AX
  MOV   BX,0
  MOV   Y,BX
 @Display:
   MOV   AX,320
   IMUL  [Y]
   MOV   DI,AX
   ADD   DI,X
{ ADD   DI,8}
   POP   DX
   MOV   BX,Width
   MOV   CX,Height
  @HeightLoop:
   PUSH  SI
   PUSH  DI
   PUSH  CX
   MOV   CX,BX
  @WidthLoop:
   MOV   AL,Byte Ptr [DS:SI]
   CMP   AL,Maskcolor
   JZ    @Skipped
   MOV   Byte Ptr [ES:DI],AL
  @Skipped:
   INC   SI
   INC   DI
   DEC   CX
   JNZ  @WidthLoop
   POP   CX
   POP   DI
   POP   SI
   ADD   DI,320
   ADD   SI,DX
   DEC   CX
   JNZ  @HeightLoop
   POP   DS
 End;
End;

{*}PROCEDURE MaskPic2;
 Begin
  If (x <= -width) or (x >= 320) or (y <= -height) or (y >= 200) then exit;
 Asm
   PUSH  DS
   LDS   SI,Sprite
   LES   DI,DEST
   MOV   AX,WIDTH
   MOV   DX,AX
   PUSH  DX
   ADD   AX,X
   PUSH  Width
   CMP   AX,320
   JG    @RightCut
   SUB   AX,X
   JC    @LeftCut
   JMP   @CheckBottom
 @RightCut:
   SUB   AX,Width
   SUB   AX,320
   NEG   AX
   MOV   Width,AX
   JMP   @CheckBottom
 @LeftCut:
   ADD   AX,X
   MOV   Width,AX
   SUB   DX,AX
   ADD   SI,DX
   XOR   BX,BX
   MOV   X,BX
 @CheckBottom:
   MOV   AX,Height
   ADD   AX,Y
   CMP   AX,200
   JG    @BottomCut
   SUB   AX,Y
   JC    @TopCut
   POP   BX
   JMP   @Display
 @BottomCut:
   POP   BX
   SUB   AX,Height
   SUB   AX,200
   NEG   AX
   MOV   Height,AX
   JMP   @Display
 @TopCut:
  ADD   AX,Y
  POP   BX
  PUSH  AX
  MOV   AX,Y
  NEG   AX
  IMUL  BX
  ADD   SI,AX
  POP   AX
  MOV   Height,AX
  MOV   BX,0
  MOV   Y,BX
 @Display:
   MOV   AX,320
   IMUL  [Y]
   MOV   DI,AX
   ADD   DI,X
{ ADD   DI,8}
   POP   DX
   MOV   BX,Width
   MOV   CX,Height
  @HeightLoop:
   PUSH  SI
   PUSH  DI
   PUSH  CX
   MOV   CX,BX
  @WidthLoop:
   MOV   AL,Byte Ptr [DS:SI]
   CMP   AL,Maskcolor
   JZ    @Skipped
   MOV	 AL,color
   MOV   Byte Ptr [ES:DI],AL
  @Skipped:
   INC   SI
   INC   DI
   DEC   CX
   JNZ  @WidthLoop
   POP   CX
   POP   DI
   POP   SI
   ADD   DI,320
   ADD   SI,DX
   DEC   CX
   JNZ  @HeightLoop
   POP   DS
 End;
End;

{*}PROCEDURE MaskPic3;
 Begin
  If (x <= -width) or (x >= 320) or (y <= -height) or (y >= 200) then exit;
 Asm
   PUSH  DS
   LDS   SI,Sprite
   LES   DI,DEST
   MOV   AX,WIDTH
   MOV   DX,AX
   PUSH  DX
   ADD   AX,X
   PUSH  Width
   CMP   AX,320
   JG    @RightCut
   SUB   AX,X
   JC    @LeftCut
   JMP   @CheckBottom
 @RightCut:
   SUB   AX,Width
   SUB   AX,320
   NEG   AX
   MOV   Width,AX
   JMP   @CheckBottom
 @LeftCut:
   ADD   AX,X
   MOV   Width,AX
   SUB   DX,AX
   ADD   SI,DX
   XOR   BX,BX
   MOV   X,BX
 @CheckBottom:
   MOV   AX,Height
   ADD   AX,Y
   CMP   AX,200
   JG    @BottomCut
   SUB   AX,Y
   JC    @TopCut
   POP   BX
   JMP   @Display
 @BottomCut:
   POP   BX
   SUB   AX,Height
   SUB   AX,200
   NEG   AX
   MOV   Height,AX
   JMP   @Display
 @TopCut:
  ADD   AX,Y
  POP   BX
  PUSH  AX
  MOV   AX,Y
  NEG   AX
  IMUL  BX
  ADD   SI,AX
  POP   AX
  MOV   Height,AX
  MOV   BX,0
  MOV   Y,BX
 @Display:
   MOV   AX,320
   IMUL  [Y]
   MOV   DI,AX
   ADD   DI,X
{ ADD   DI,8}
   POP   DX
   MOV   BX,Width
   MOV   CX,Height
  @HeightLoop:
   PUSH  SI
   PUSH  DI
   PUSH  CX
   MOV   CX,BX
  @WidthLoop:
   MOV   AL,Byte Ptr [DS:SI]
   CMP   AL,Maskcolor
   JZ    @Skipped
   ADD   AL,color
   MOV   Byte Ptr [ES:DI],AL
  @Skipped:
   INC   SI
   INC   DI
   DEC   CX
   JNZ  @WidthLoop
   POP   CX
   POP   DI
   POP   SI
   ADD   DI,320
   ADD   SI,DX
   DEC   CX
   JNZ  @HeightLoop
   POP   DS
 End;
End;


{*}Procedure MaskPicT;
 Begin
  If (x <= -width) or (x >= 320) or (y <= -height) or (y >= 200) then exit;
 Asm
   PUSH  DS
   LDS   SI,Sprite
   MOV   AX,WIDTH
   MOV   DX,AX
   PUSH  DX
   ADD   AX,X
   PUSH  Width
   CMP   AX,320
   JG    @RightCut
   SUB   AX,X
   JC    @LeftCut
   JMP   @CheckBottom
 @RightCut:
   SUB   AX,Width
   SUB   AX,320
   NEG   AX
   MOV   Width,AX
   JMP   @CheckBottom
 @LeftCut:
   ADD   AX,X
   MOV   Width,AX
   SUB   DX,AX
   ADD   SI,DX
   XOR   BX,BX
   MOV   X,BX
 @CheckBottom:
   MOV   AX,Height
   ADD   AX,Y
   CMP   AX,200
   JG    @BottomCut
   SUB   AX,Y
   JC    @TopCut
   POP   BX
   JMP   @Display
 @BottomCut:
   POP   BX
   SUB   AX,Height
   SUB   AX,200
   NEG   AX
   MOV   Height,AX
   JMP   @Display
 @TopCut:
  ADD   AX,Y
  POP   BX
  PUSH  AX
  MOV   AX,Y
  NEG   AX
  IMUL  BX
  ADD   SI,AX
  POP   AX
  MOV   Height,AX
  MOV   BX,0
  MOV   Y,BX
 @Display:
   MOV   AX,320
   IMUL  [Y]
   MOV   DI,AX
   ADD   DI,X
{ ADD   DI,8}
   POP   DX
   MOV   BX,Width
   MOV   CX,Height
  @HeightLoop:
   PUSH  SI
   PUSH  DI
   PUSH  CX
   MOV   CX,BX
  @WidthLoop:
   PUSH  BX
   MOV   BL,Byte Ptr DS:[SI]
   CMP   BL,Maskcolor
   JZ    @Skipped
{ ADD   Bl,8}
   MOV   BH,Byte Ptr Es:[DI]
   DEC   BH {GAD}
   PUSH  ES
   PUSH  DI
   LES   DI,TAB
   MOV   AL,Byte Ptr ES:[BX]
   POP   DI
   POP   ES
   MOV   Byte Ptr ES:[DI],AL
  @Skipped:
   POP   BX
   INC   SI
   INC   DI
   DEC   CX
   JNZ  @WidthLoop
   POP   CX
   POP   DI
   POP   SI
   ADD   DI,320
   ADD   SI,DX
   DEC   CX
   JNZ  @HeightLoop
   POP   DS
 End;
End;

{*}PROCEDURE MaskPicRev(X,Y,Width,Height:integer; var sprite,dest);
var
 xp,yp,nx,ny,poz:integer;
begin
  If (x <= -width) or (x >= 320) or (y <= -height) or (y >= 200) then exit;
  asm
    push ds
    lds si,sprite
    les di,dest

    mov bx,width
    mov poz,bx


    mov ax,x
    mov nx,ax
    cmp ax,0
    jge @lewo_ok
    mov nx,0
    add si,ax
    add ax,width
    mov poz,ax
    @lewo_ok:


    mov cx,height

    mov ax,y
    mov ny,ax
    cmp ax,0
    jge @gora_ok
    mov ny,0
    add cx,ax
    mul [width]
    sub si,ax
    jmp @dol_ok
    @gora_ok:



    mov ax,y
    add ax,height
    cmp ax,200
    jl @dol_ok
    mov cx,200
    sub cx,y
    @dol_ok:

    mov ax,320
    mul [ny]
    add ax,nx
    mov di,ax

    mov ax,x
    add ax,width
    cmp ax,320
    jl @prawo_ok
    mov ax,320
    sub ax,x
    mov poz,ax
    @prawo_ok:

    add si,width
    dec si
{  add di,8}

    @wys:
    xor bx,bx
    @szer:
    neg bx
    mov dl,byte ptr ds:[si+bx];
    neg bx
    cmp dl,0
    je @olej
    mov byte ptr es:[di+bx],dl
    @olej:
    inc bx
    cmp bx,poz
    jne @szer
    add di,320
    add si,width
    dec cx
    jnz @wys

    pop ds
  end;
end;

{*}PROCEDURE MaskPic2Rev;
var
 xp,yp,nx,ny,poz:integer;
begin
  If (x <= -width) or (x >= 320) or (y <= -height) or (y >= 200) then exit;
  asm
    push ds
    lds si,sprite
    les di,dest

    mov bx,width
    mov poz,bx


    mov ax,x
    mov nx,ax
    cmp ax,0
    jge @lewo_ok
    mov nx,0
    add si,ax
    add ax,width
    mov poz,ax
    @lewo_ok:


    mov cx,height

    mov ax,y
    mov ny,ax
    cmp ax,0
    jge @gora_ok
    mov ny,0
    add cx,ax
    mul [width]
    sub si,ax
    jmp @dol_ok
    @gora_ok:



    mov ax,y
    add ax,height
    cmp ax,200
    jl @dol_ok
    mov cx,200
    sub cx,y
    @dol_ok:

    mov ax,320
    mul [ny]
    add ax,nx
    mov di,ax

    mov ax,x
    add ax,width
    cmp ax,320
    jl @prawo_ok
    mov ax,320
    sub ax,x
    mov poz,ax
    @prawo_ok:

    add si,width
    dec si
{  add di,8}

    @wys:
    xor bx,bx
    @szer:
    neg bx
    mov dl,byte ptr ds:[si+bx];
    neg bx
    cmp dl,0
    je @olej
    mov dl,color
    mov byte ptr es:[di+bx],dl
    @olej:
    inc bx
    cmp bx,poz
    jne @szer
    add di,320
    add si,width
    dec cx
    jnz @wys

    pop ds
  end;
end;

{*}PROCEDURE QuickMaskPic(ildanych:word; var Sprite,Dest); assembler;
Asm
   PUSH  DS
   LDS   SI,sprite
   LES   DI,Dest
   mov   cx,ildanych
  @petla:
   mov al,byte ptr ds:[si]
   cmp al,0
  je @olej
   mov byte ptr es:[di],al
  @olej:
  inc si
  inc di
  dec   cx
  jnz @petla
  POP   DS
End;

{*}PROCEDURE MaskPicXMS;
var
sprite:pointer;
buf:array[0..3599] of byte;
begin
IF (zawsze) or ((kfg._co_klatke>=kfg.co_klatke) and (not zawsze)) then BEGIN
   XMS2Mem(_xms[1].h,offset,buf,width*height);
   if odwroc=1 then MaskPic(X,Y,Width,Height, maskcolor, buf, Dest)
               else MaskPicrev(X,Y,Width,Height, buf, Dest);
END;
end;

{*}PROCEDURE MaskPic2XMS;
var
sprite:pointer;
buf:array[0..3599] of byte;
begin
IF (zawsze) or ((kfg._co_klatke>=kfg.co_klatke) and (not zawsze)) then BEGIN
   XMS2Mem(_xms[1].h,offset,buf,width*height);
   if odwroc=1 then MaskPic2(X,Y,Width,Height, maskcolor, color, buf, Dest)
               else MaskPic2rev(X,Y,Width,Height, color, buf, Dest);
END;
end;

{*}PROCEDURE MaskPic3XMS;
var
sprite:pointer;
buf:array[0..3599] of byte;
begin
IF (zawsze) or ((kfg._co_klatke>=kfg.co_klatke) and (not zawsze)) then BEGIN
   XMS2Mem(_xms[1].h,offset,buf,width*height);
   MaskPic3(X,Y,Width,Height, maskcolor, color, buf, Dest);
END;
end;

{*}PROCEDURE barT(x1,y1,x2,y2:integer; kolor:byte; var gdzie,tab);
begin
if x1<0 then x1:=0;
if x2>319 then x2:=319;
if y1<0 then y1:=0;
if y2>199 then y2:=199;
if (y1>199) or (x1>319) or (y2<0) or (x2<0) then exit;
asm
{  add   x1,8
  add   x2,8}
  les   di,gdzie
  mov   ax,y1
  mov   bx,320
  mul   bx
  add   ax,x1
  mov   di,ax
  mov   ax,y2
  sub   ax,y1
  inc   ax
 @wys:
  mov   cx,x2
  sub   cx,x1
  inc   cx
  push  di
 @szer:
  mov   bh,byte ptr es:[di]
  mov   bl,kolor
{add   bl,8}
{}{sub   bl,8}
  dec   bh
  push  es
  push  di
  les   di,tab
  mov   dl,byte ptr es:[bx]
  pop   di
  pop   es
  mov   byte ptr es:[di],dl
  inc   di
 loop   @szer
  pop   di
  add   di,320
  dec   ax
  jnz @wys;
end;
end;

{*}PROCEDURE barTp(x1,y1,x2,y2,przes:word; kolor:byte; var gdzie,tab);
begin
if x1<0 then x1:=0;
if x2>319 then x2:=319;
if y1<0 then y1:=0;
if y2>199 then y2:=199;
if (y1>199) or (x1>319) or (y2<0) or (x2<0) then exit;
asm
{  add   x1,8
  add   x2,8}
  les   di,gdzie
  mov   ax,y1
  mov   bx,320
  mul   bx
  add   ax,x1
  mov   di,ax
  mov   ax,y2
  sub   ax,y1
  inc   ax
 @wys:
  mov   cx,x2
  sub   cx,x1
  inc   cx
  push  di
 @szer:
  add   di,przes
  mov   bh,byte ptr es:[di]
  sub   di,przes
  mov   bl,kolor
{add   bl,8}
  dec   bh
  push  es
  push  di
  les   di,tab
  mov   dl,byte ptr es:[bx]
  pop   di
  pop   es
  mov   byte ptr es:[di],dl
  inc   di
 loop   @szer
  pop   di
  add   di,320
  dec   ax
  jnz @wys;
end;
end;

{*}PROCEDURE MaskPictXMS;
var
sprite:pointer;
buf:array[0..3599] of byte;
begin
XMS2Mem(_xms[1].h,offset,buf,width*height);
MaskPict(X,Y,Width,Height, maskcolor, chmur^,buf, Dest)
end;

end.