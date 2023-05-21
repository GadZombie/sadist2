uses crt,asmprocs,xpal;
type
  scr=array[0..199] of array [0..319] of byte;
  obr=array[1..50,1..50] of byte;
  chm=array[1..255] of array[0..255] of byte;
  neg=array[0..255] of byte;
var
  screen:scr absolute $A000:0;
  vs,vs2:^scr;
  chmur:^chm;
  negatyw:^neg;
  obrazek:^obr;
  i,j:integer;
  f:file;
  x,y:word;
  plik:file;

Procedure MaskPic(X,Y,Width,Height:integer; Maskcolor:byte; tab,Sprite,
Dest:Pointer);
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
{} ADD   BL,8
   CMP   BL,Maskcolor
   JZ    @Skipped
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

function fnear(r,g,b :byte):byte;
var
 i,found:byte;
 dist1,dist2 :word;

begin
 dist1:=65535;
 for i:=1 to 223 do
 begin
  dist2:=(abs(paleta[i].r-r)+abs(paleta[i].g-g)+abs(paleta[i].b-b));
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

begin
  randomize;
  new(vs);
  new(vs2);
  new(obrazek);
  new(chmur);
  new(negatyw);
  assign(f,'dane\paleta.pal');
  reset(f,1);
  blockread(f,paleta,sizeof(paleta));
  close(f);
  asm
    mov ax,13h
    int 10h
  end;
  setpalette(paleta);
  for i:=1 to 50 do
      for j:=1 to 50 do
          obrazek^[i][j]:=I;
  for i:=0 to 199 do
      for j:=0 to 319 do
          vs^[i][j]:=j div 4;

  for i:=1 to 255 do
  for j:=0 to 255 do
  begin
    chmur^[i][j]:=fnear(
    (paleta[i].r+paleta[j].r*2)div 3,
    (paleta[i].g+paleta[j].g*2)div 3,
    (paleta[i].b+paleta[j].b*2)div 3);
  end;

  for j:=0 to 255 do
  begin
    negatyw^[j]:=fnear(
    63-paleta[j].r,
    63-paleta[j].g,
    63-paleta[j].b);
  end;

  assign(plik,'transtab.dat');
  rewrite(plik,1);
  blockwrite(plik, chmur^,sizeof(chmur^));
  close(plik);

  assign(plik,'negtab.dat');
  rewrite(plik,1);
  blockwrite(plik, negatyw^,sizeof(negatyw^));
  close(plik);

  for i:=0 to 99 do
      for j:=0 to 319 do
          vs^[i][j]:=negatyw^[vs^[i,j]];

  repeat
    inc(x);
    move(vs^,vs2^,64000);
    maskpic(x,100,50,50,0,@chmur^,@obrazek^,@vs2^);
    synchro;
    move(vs2^,screen,64000);
    if keypressed then begin readkey; readkey; end;
  until x=270;
end.