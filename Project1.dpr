﻿//----------------------------------------------------------------------------------\\
//----------------------СтартерКит для DTLoger v0.5.3 Final-------------------------\\
//---------------------Автор: vovken1997 с форума CheatON.ru------------------------\\
//------------------------------Версия: 0.5.3 Final---------------------------------\\
//----------------------------------------------------------------------------------\\
library Project1;

uses
  System.SysUtils,
  System.Classes,
  WinApi.Windows,
  advApiHook,
  D3DX9,
  Direct3D,
  Direct3D9,
  DirectDraw,
  DXTypes;


//Запись, хранящая каждое условие первого режима
type StrNumPrim=record
        Strides:integer;
        NumVertices:integer;
        PrimCount:integer;
        ZnakStr:integer;
        ZnakNum:integer;
        ZnakPrim:integer;
        ZBuf:boolean;
        Draw:boolean;
        Chams:boolean;
        Sheyder:boolean;
        condition:integer;
        Enable: boolean;
        WireFrame: integer;
     end;

      const Mode1_if=1000;    //Максимальное кол-во условий первого режима
            //Описываем цвета текстур Chams
            bPink:array[0..57] of byte = ($42, $4D, $3A, $00, $00, $00, $00, $00, $00,
                                          $00, $36, $00, $00, $00, $28, $00, $00, $00,
                                          $01, $00, $00, $00, $01, $00, $00, $00, $01,
                                          $00, $18, $00, $00, $00, $00, $00, $04, $00,
                                          $00, $00, $00, $00, $00, $00, $00, $00, $00,
                                          $00, $00, $00, $00, $00, $00, $00, $00, $00,
                                          $80, $00, $FF, $00);
            bBlue:array[0..59] of byte = ($42, $4D, $3C, $00, $00, $00, $00, $00, $00,
                                          $00, $36, $00, $00, $00, $28, $00, $00, $00,
                                          $01, $00, $00, $00, $01, $00, $00, $00, $01,
                                          $00, $20, $00, $00, $00, $00, $00, $00, $00,
                                          $00, $00, $12, $0B, $00, $00, $12, $0B, $00,
                                          $00, $00, $00, $00, $00, $00, $00, $00, $00,
                                          $FF, $00, $00, $00, $00, $00);
            bRed:array[0..59] of byte =  ($42, $4D, $3C, $00, $00, $00, $00, $00, $00,
                                          $00, $36, $00, $00, $00, $28, $00, $00, $00,
                                          $01, $00, $00, $00, $01, $00, $00, $00, $01,
                                          $00, $20, $00, $00, $00, $00, $00, $00, $00,
                                          $00, $00, $12, $0B, $00, $00, $12, $0B, $00,
                                          $00, $00, $00, $00, $00, $00, $00, $00, $00,
                                          $00, $00, $FF, $00, $00, $00);
            bGreen:array[0..59] of byte =($42, $4D, $3C, $00, $00, $00, $00, $00, $00,
                                          $00, $36, $00, $00, $00, $28, $00, $00, $00,
                                          $01, $00, $00, $00, $01, $00, $00, $00, $01,
                                          $00, $20, $00, $00, $00, $00, $00, $00, $00,
                                          $00, $00, $12, $0B, $00, $00, $12, $0B, $00,
                                          $00, $00, $00, $00, $00, $00, $00, $00, $00,
                                          $20, $A0, $00, $00, $FF, $FF);
            bYellow:array[0..59] of byte=($42, $4D, $3C, $00, $00, $00, $00, $00, $00,
                                          $00, $36, $00, $00, $00, $28, $00, $00, $00,
                                          $01, $00, $00, $00, $01, $00, $00, $00, $01,
                                          $00, $20, $00, $00, $00, $00, $00, $00, $00,
                                          $00, $00, $12, $0B, $00, $00, $12, $0B, $00,
                                          $00, $00, $00, $00, $00, $00, $00, $00, $00,
                                          $00, $FF, $FF, $00, $00, $00);
            bOrange:array[0..59] of byte=($42, $4D, $3C, $00, $00, $00, $00, $00, $00,
                                          $00, $36, $00, $00, $00, $28, $00, $00, $00,
                                          $01, $00, $00, $00, $01, $00, $00, $00, $01,
                                          $00, $20, $00, $00, $00, $00, $00, $00, $00,
                                          $00, $00, $12, $0B, $00, $00, $12, $0B, $00,
                                          $00, $00, $00, $00, $00, $00, $00, $00, $00,
                                          $10, $80, $F0, $B0, $00, $00);
            bWhite:array[0..57] of byte= ($42, $4D, $3A, $00, $00, $00, $00, $00, $00,
                                          $00, $36, $00, $00, $00, $28, $00, $00, $00,
                                          $01, $00, $00, $00, $01, $00, $00, $00, $01,
                                          $00, $18, $00, $00, $00, $00, $00, $04, $00,
                                          $00, $00, $00, $00, $00, $00, $00, $00, $00,
                                          $00, $00, $00, $00, $00, $00, $00, $00, $00,
                                          $FF, $FF, $FF, $00);


  //Объявление методов для возращения игре после выполнения наших действий
  var Direct3DCreate9Next: function (SDKVersion: LongWord): DWORD stdcall = nil;
      CreateDevice9Next: function (self: pointer; Adapter: LongWord; DeviceType: TD3DDevType; hFocusWindow: HWND; BehaviorFlags: DWord; pPresentationParameters: PD3DPresentParameters; out ppReturnedDeviceInterface: IDirect3DDevice9): HResult; stdcall = nil;
      EndScene9Next : function (self: pointer): HResult stdcall = nil;
      ResetNext: function (self: pointer; const pPresentationParameters: TD3DPresentParameters): HResult; stdcall;
      SetStreamSourceNext: function (self: pointer; StreamNumber: LongWord; pStreamData: IDirect3DVertexBuffer9; OffsetInBytes, Stride: LongWord): HResult; stdcall;
      DrawIndexedPrimitiveNext: function (DeviceInterface: IDirect3DDevice9; _Type: TD3DPrimitiveType; BaseVertexIndex: Integer; MinVertexIndex, NumVertices, startIndex, primCount: LongWord): HResult; stdcall;

      //Инициализация текста
      g_Font: ID3DXFont;
      g_Font_Cross: ID3DXFont;
      TextRect1: TRect;
      TextRect2: TRect;
      TextRect3: TRect;
      TextRect4: TRect;

      TextRectCross:TRect;


      //Переменные первого режима логера
      SNPArray:array[1..Mode1_IF] of StrNumPrim;
      SNPCount:integer=1;     //Колличество условий, которые сейчас используются
      SNPEn:integer=1;      //Выделенное условие
      k : integer;//Кол-во условий на экране
      StrOutCond:integer=1;

      //Инициализация Chams цветов
      DeviceInterface:  IDirect3DDevice9;
      Pink: IDirect3DTexture9;
      Green: IDirect3DTexture9;
      Blue: IDirect3DTexture9;
      Red: IDirect3DTexture9;
      Yellow: IDirect3DTexture9;
      Orange: IDirect3DTexture9;
      White: IDirect3DTexture9;
      r:byte=1;

      //Остальные переменные
      //CrossHair
      x,y:integer;
      CrossHeir:boolean=False;

      vid: boolean=true;//Отображать ли текст
      StridesNow:integer; //Страйдес которое сейчас выводит игра
      Cheat: boolean=False;

      //Описание шейдрных цветов
      psRed, psGreen, psBlue, psYellow, psWhite, psCyan, psBlack, psPink:IDirect3DPixelShader9;
{$R *.res}

procedure DLLEntryPoint(dwReason:DWORD);forward;


//Шейдеры
procedure GenShader(pDevice:IDirect3DDevice9);
var
 pv1,pv2, szShader:String;
 pShaderBuf :ID3DXBuffer;
 caps:D3DCAPS9;
begin
 pDevice.GetDeviceCaps(caps);
 pv1:=(inttostr( D3DSHADER_VERSION_MAJOR(caps.PixelShaderVersion)));
 pv2:=(inttostr( D3DSHADER_VERSION_MINOR(caps.PixelShaderVersion)));
 szShader:='ps_'+pv1+'_'+pv2+#13+'def c0, 1.0 , 0.0, 0.0, 1.0'+#13+'mov oC0, c0 '+#13;
 D3DXAssembleShader(PAnsiCHAR(AnsiString(szShader)), Length(szShader), nil, nil, 0, @pShaderBuf, nil);
 pDevice.CreatePixelShader(pShaderBuf.GetBufferPointer, psRed);

 szShader:='ps_'+pv1+'_'+pv2+#13+'def c0, 0.0 , 1.0, 0.0, 1.0'+#13+'mov oC0, c0 '+#13;
 D3DXAssembleShader(PAnsiCHAR(AnsiString(szShader)), Length(szShader), nil, nil, 0, @pShaderBuf, nil);
 pDevice.CreatePixelShader(pShaderBuf.GetBufferPointer, psGreen);

 szShader:='ps_'+pv1+'_'+pv2+#13+'def c0, 0.0 , 0.0, 1.0, 1.0'+#13+'mov oC0, c0 '+#13;
 D3DXAssembleShader(PAnsiCHAR(AnsiString(szShader)), Length(szShader), nil, nil, 0, @pShaderBuf, nil);
 pDevice.CreatePixelShader(pShaderBuf.GetBufferPointer, psBlue);

 szShader:='ps_'+pv1+'_'+pv2+#13+'def c0, 1.0 , 1.0, 0.0, 1.0'+#13+'mov oC0, c0 '+#13;
 D3DXAssembleShader(PAnsiCHAR(AnsiString(szShader)), Length(szShader), nil, nil, 0, @pShaderBuf, nil);
 pDevice.CreatePixelShader(pShaderBuf.GetBufferPointer, psYellow);

 szShader:='ps_'+pv1+'_'+pv2+#13+'def c0, 1.0 , 1.0, 1.0, 1.0'+#13+'mov oC0, c0 '+#13;
 D3DXAssembleShader(PAnsiCHAR(AnsiString(szShader)), Length(szShader), nil, nil, 0, @pShaderBuf, nil);
 pDevice.CreatePixelShader(pShaderBuf.GetBufferPointer, psWhite);

 szShader:='ps_'+pv1+'_'+pv2+#13+'def c0, 0.0 , 1.0, 1.0, 1.0'+#13+'mov oC0, c0 '+#13;
 D3DXAssembleShader(PAnsiCHAR(AnsiString(szShader)), Length(szShader), nil, nil, 0, @pShaderBuf, nil);
 pDevice.CreatePixelShader(pShaderBuf.GetBufferPointer, psCyan);

 szShader:='ps_'+pv1+'_'+pv2+#13+'def c0, 0.0 , 0.0, 0.0, 1.0'+#13+'mov oC0, c0 '+#13;
 D3DXAssembleShader(PAnsiCHAR(AnsiString(szShader)), Length(szShader), nil, nil, 0, @pShaderBuf, nil);
 pDevice.CreatePixelShader(pShaderBuf.GetBufferPointer, psBlack);

 szShader:='ps_'+pv1+'_'+pv2+#13+'def c0, 1.0 , 0.0, 1.0, 1.0'+#13+'mov oC0, c0 '+#13;
 D3DXAssembleShader(PAnsiCHAR(AnsiString(szShader)), Length(szShader), nil, nil, 0, @pShaderBuf, nil);
 pDevice.CreatePixelShader(pShaderBuf.GetBufferPointer, psPink);
end;


//Опрос клавиатуры
procedure CheckPressed;
var
F:TextFile;
I: Integer;
begin
//Клавиши, работающие во всех режимах
if (GetAsyncKeyState(VK_F1) and 1)<>0 then Cheat:=not Cheat;
if (GetAsyncKeyState(VK_HOME) and 1)<>0 then vid:=not vid;
end;

//Отрисовка объектов по верх всего
procedure DrawIndexedPrimitive1(ChamsDraw,DrawD,Z_BufDraw,Sheyder:boolean;WareFrame:integer;Color:IDirect3DTexture9;DeviceInterface: IDirect3DDevice9; _Type: TD3DPrimitiveType; BaseVertexIndex: Integer; MinVertexIndex, NumVertices, startIndex, primCount: LongWord);
begin
if Z_bufDraw=true then DeviceInterface.SetRenderState(D3DRS_ZENABLE, D3DZB_FALSE);
if WareFrame=1 then DeviceInterface.SetRenderState(D3DRS_FILLMODE, D3DFILL_WIREFRAME);
if WareFrame=2 then DeviceInterface.SetRenderState(D3DRS_FILLMODE, D3DFILL_POINT);

if chamsDraw=true then DeviceInterface.SetTexture(0,Color);
if Sheyder=true then DeviceInterface.SetPixelShader(psGreen);
if DrawD=true then DrawIndexedPrimitiveNext(DeviceInterface, _Type, BaseVertexIndex, MinVertexIndex, NumVertices, startIndex, primCount);
if Sheyder=true then DeviceInterface.SetPixelShader(psGreen);
if chamsDraw=true then DeviceInterface.SetTexture(0,Color);

if WareFrame=2 then DeviceInterface.SetRenderState(D3DRS_FILLMODE, D3DFILL_SOLID);
if WareFrame=1 then DeviceInterface.SetRenderState(D3DRS_FILLMODE, D3DFILL_SOLID);
if Z_bufDraw=true then DeviceInterface.SetRenderState(D3DRS_ZENABLE, D3DZB_TRUE);
end;

//Функция вызывается при рисовании объектов игрой
function DrawIndexedPrimitiveCallback(DeviceInterface: IDirect3DDevice9; _Type: TD3DPrimitiveType; BaseVertexIndex: Integer; MinVertexIndex, NumVertices, startIndex, primCount: LongWord): HResult; stdcall;
var
Draw_out,Flag_Znak_Strides,Flag_Znak_Num,Flag_Znak_Prim,Draw_Out_Mode1,DrawOutPrimitive:boolean;
I, buf3,i1: Integer;
begin
Draw_out:=false;   //Переменная, будет установлена в True если произойдёт отрисовка в втором режиме
Draw_out_Mode1:=False; //Переменная будет в True если произойдёт отрисовка в первом режиме
//Инициализируем текстуры для Chams
if (r<=5) then
begin
    r:=r+1;
    D3DXCreateTextureFromFileInMemory(DeviceInterface,@bPink,58,Pink);
    D3DXCreateTextureFromFileInMemory(DeviceInterface,@bBlue,60,Blue);
    D3DXCreateTextureFromFileInMemory(DeviceInterface,@bRed,60,Red);
    D3DXCreateTextureFromFileInMemory(DeviceInterface,@bGreen,60,Green);
    D3DXCreateTextureFromFileInMemory(DeviceInterface,@bYellow,60,Yellow);
    D3DXCreateTextureFromFileInMemory(DeviceInterface,@bOrange,60,Orange);
    D3DXCreateTextureFromFileInMemory(DeviceInterface,@bWhite,58,White);
end;

//Проверяем, Выполняются ли условия, и записываем, какие именно выполняются
if Cheat=True then
begin
  for I := 1 to SNPCount do
  begin
    if SNPArray[i].Enable=true then
    begin
      case SNPArray[i].ZnakStr of
        1: if StridesNow=SNPArray[i].Strides then Flag_znak_Strides:=True else Flag_Znak_Strides:=False;
        2: if StridesNow<>SNPArray[i].Strides then Flag_Znak_Strides:=True else Flag_Znak_Strides:=False;
        3: if StridesNow<SNPArray[i].Strides then Flag_Znak_Strides:=True else Flag_Znak_Strides:=False;
        4: if StridesNow>SNPArray[i].Strides then Flag_Znak_Strides:=True else Flag_Znak_Strides:=False;
      end;


      case SNPArray[i].ZnakNum of
        1: if NumVertices=SNPArray[i].NumVertices then Flag_Znak_Num:=True else Flag_Znak_Num:=False;
        2: if NumVertices<>SNPArray[i].NumVertices then Flag_Znak_Num:=True else Flag_Znak_Num:=False;
        3: if NumVertices<SNPArray[i].NumVertices then Flag_Znak_Num:=True else Flag_Znak_Num:=False;
        4: if NumVertices>SNPArray[i].NumVertices then Flag_Znak_Num:=True else Flag_Znak_Num:=False;
      end;

      case SNPArray[i].ZnakPrim of
        1: if PrimCount=SNPArray[i].PrimCount then Flag_Znak_Prim:=True else Flag_Znak_Prim:=False;
        2: if PrimCount<>SNPArray[i].PrimCount then Flag_Znak_Prim:=True else Flag_Znak_Prim:=False;
        3: if PrimCount<SNPArray[i].PrimCount then Flag_Znak_Prim:=True else Flag_Znak_Prim:=False;
        4: if PrimCount>SNPArray[i].PrimCount then Flag_Znak_Prim:=True else Flag_Znak_Prim:=False;
      end;

      if SNPArray[i].condition=0 then
      begin
        if (Flag_Znak_Strides=true) and (Flag_Znak_Num=True) and (Flag_Znak_Prim=True) then
        begin
            DrawIndexedPrimitive1(SNPArray[i].Chams,SNPArray[i].Draw,SNPArray[i].ZBuf,SNPArray[i].Sheyder,SNPArray[i].WireFrame,Red,DeviceInterface, _Type, BaseVertexIndex, MinVertexIndex, NumVertices, startIndex, primCount);
            Draw_Out_Mode1:=True;
            Break;
        end;

        if (Flag_Znak_Strides=True) and (Flag_Znak_Num=True) then
        begin
            DrawIndexedPrimitive1(SNPArray[i].Chams,SNPArray[i].Draw,SNPArray[i].ZBuf,SNPArray[i].Sheyder,SNPArray[i].WireFrame,Pink,DeviceInterface, _Type, BaseVertexIndex, MinVertexIndex, NumVertices, startIndex, primCount);
            Draw_Out_Mode1:=True;
            Break;
        end;

        if (Flag_Znak_Strides=True) and (Flag_Znak_Prim=True) then
        begin
            DrawIndexedPrimitive1(SNPArray[i].Chams,SNPArray[i].Draw,SNPArray[i].ZBuf,SNPArray[i].Sheyder,SNPArray[i].WireFrame,Blue,DeviceInterface, _Type, BaseVertexIndex, MinVertexIndex, NumVertices, startIndex, primCount);
            Draw_out_Mode1:=True;
            Break;
        end;

        if (Flag_Znak_Num=True) and (Flag_Znak_Prim=true) then
        begin
            DrawIndexedPrimitive1(SNPArray[i].Chams,SNPArray[i].Draw,SNPArray[i].ZBuf,SNPArray[i].Sheyder,SNPArray[i].WireFrame,Green,DeviceInterface, _Type, BaseVertexIndex, MinVertexIndex, NumVertices, startIndex, primCount);
            Draw_out_Mode1:=True;
            Break;
        end;
      end;

      if SNPArray[i].condition=1 then
      begin
        if (Flag_Znak_Strides=true) and (Flag_Znak_Num=True) and (Flag_Znak_Prim=True) then
        begin
            DrawIndexedPrimitive1(SNPArray[i].Chams,SNPArray[i].Draw,SNPArray[i].ZBuf,SNPArray[i].Sheyder,SNPArray[i].WireFrame,Red,DeviceInterface, _Type, BaseVertexIndex, MinVertexIndex, NumVertices, startIndex, primCount);
            Draw_out_Mode1:=True;
            Break;
        end;
      end;

      if SNPArray[i].condition=2 then
      begin
        if (Flag_Znak_Strides=true) then
        begin
            DrawIndexedPrimitive1(SNPArray[i].Chams,SNPArray[i].Draw,SNPArray[i].ZBuf,SNPArray[i].Sheyder,SNPArray[i].WireFrame,Yellow,DeviceInterface, _Type, BaseVertexIndex, MinVertexIndex, NumVertices, startIndex, primCount);
            Draw_out_Mode1:=True;
            Break;
        end;
        if (Flag_Znak_Num=True) then
        begin
            DrawIndexedPrimitive1(SNPArray[i].Chams,SNPArray[i].Draw,SNPArray[i].ZBuf,SNPArray[i].Sheyder,SNPArray[i].WireFrame,Orange,DeviceInterface, _Type, BaseVertexIndex, MinVertexIndex, NumVertices, startIndex, primCount);
            Draw_out_Mode1:=True;
            Break;
        end;
        if (Flag_Znak_Prim=True) then
        begin
            DrawIndexedPrimitive1(SNPArray[i].Chams,SNPArray[i].Draw,SNPArray[i].ZBuf,SNPArray[i].Sheyder,SNPArray[i].WireFrame,White,DeviceInterface, _Type, BaseVertexIndex, MinVertexIndex, NumVertices, startIndex, primCount);
            Draw_out_Mode1:=True;
            Break;
        end;
      end;

    end;
 end;
end;
  //Если объект ни подошёл ни к одному условию, то просто выведем его
  if Draw_Out_Mode1=False then result:=DrawIndexedPrimitiveNext(DeviceInterface, _Type, BaseVertexIndex, MinVertexIndex, NumVertices, startIndex, primCount);
end;


//Функция вызываемая при завершении вывода объектов. Здесь выводим информацию пользователю
function EndScene9Callback(self: pointer): HResult; stdcall;
var
bStr:string;
begin
CheckPressed;
if vid=true then
begin
    if Cheat=true then bStr:='Yes' else bStr:='No';
    g_Font.DrawTextW(nil,PWideChar('Cheat: '+bStr),-1,@TextRect1,DT_LEFT or DT_NOCLIP,D3DCOLOR_ARGB(255,255,255,0));
end;

if CrossHeir=true then g_Font_Cross.DrawTextW(nil,PWideChar('+          '),-1,@TextRectCross,DT_LEFT or DT_NOCLIP,D3DCOLOR_ARGB(255,0,255,0));

Result:=EndScene9Next(self);
end;

//Сохраняем зачение страйдс при вырисовке
function SetStreamSourceCallback(self: pointer; StreamNumber: LongWord; pStreamData: IDirect3DVertexBuffer9; OffsetInBytes, Stride: LongWord): HResult; stdcall;
begin
StridesNow := Stride;
result  := SetStreamSourceNext(self,StreamNumber,pStreamData,OffsetInBytes, StridesNow);
end;

//Функция для перезагруски ресурсов, чтоб при сворачивании игра нормально разворачивалась
procedure All_OnLostDevice;
begin
g_Font.OnLostDevice;
g_Font_Cross.OnLostDevice;
end;

procedure All_OnResetDevice;
begin
g_Font.OnResetDevice;
g_Font_Cross.OnResetDevice;
end;

function ResetCallback(self: pointer; const pPresentationParameters: TD3DPresentParameters): HResult; stdcall;
begin
All_OnLostDevice;

result:= ResetNext(self,pPresentationParameters);

if( SUCCEEDED(result) ) then
begin
  All_OnResetDevice;
end;

end;

//Инициализация устройства, прописываем так же настройки шрифта и положение строк
function CreateDevice9Callback(self: pointer; Adapter: LongWord; DeviceType: TD3DDevType; hFocusWindow: HWND; BehaviorFlags: DWord; pPresentationParameters: PD3DPresentParameters; out ppReturnedDeviceInterface: IDirect3DDevice9): HResult; stdcall;
var
i, y_pos: integer;
F:TextFile;
begin
Result :=CreateDevice9Next(self,Adapter,DeviceType, hFocusWindow,BehaviorFlags,pPresentationParameters,ppReturnedDeviceInterface);
if (result = 0) then
begin
  GenShader(ppReturnedDeviceInterface);

  x:=Round(GetSystemMetrics(0)/2);
  y:=Round(GetSystemMetrics(1)/2);
  TextRectCross:=Rect(x-6,y-13,x,y);
  TextRect1:=Rect(10,10,10,10);
  TextRect2:=Rect(10,30,10,10);
  TextRect3:=Rect(10,50,10,10);
  TextRect4:=Rect(10,70,10,10);

  D3DXCreateFont(ppReturnedDeviceInterface,20,0,FW_NORMAL,1,false,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,6,DEFAULT_PITCH or FF_DONTCARE,PChar('Arial'),g_Font);
  D3DXCreateFont(ppReturnedDeviceInterface,30,10,FW_NORMAL,1,false,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,1,DEFAULT_PITCH or FF_DONTCARE,PChar('Arial'),g_Font_Cross);
  HookCode(GetInterfaceMethod(ppReturnedDeviceInterface, 42), @EndScene9Callback, @EndScene9Next);
  HookCode(GetInterfaceMethod(ppReturnedDeviceInterface, 16), @ResetCallback, @ResetNext);
  HookCode(GetInterfaceMethod(ppReturnedDeviceInterface, 100),@SetStreamSourceCallback, @SetStreamSourceNext);
  HookCode(GetInterfaceMethod(ppReturnedDeviceInterface, 82), @DrawIndexedPrimitiveCallback, @DrawIndexedPrimitiveNext);
end;

//УКАЖИТЕ ЗДЕСЬ УСЛОВИЯ
  SNPCount:=10;//Кол-во условий, которые хотим использовать


end;

//Основные функции перехвата, старта DLL и т.д. О них читайте на CheatON.ru
function Direct3DCreate9Callback(SDKVersion: LongWord): DWORD; stdcall;
begin
  Result:=Direct3DCreate9Next(SDKVersion);
  if (Result <> 0) then
  begin
    if (@CreateDevice9Next <> nil) then UnhookCode(@CreateDevice9Next);
    HookCode(GetInterfaceMethod(result, 16), @CreateDevice9Callback, @CreateDevice9Next);
  end;
end;

procedure DLLEntryPoint(dwReason:DWORD);
begin
  case dwReason of
      DLL_PROCESS_ATTACH:
          begin
               HookProc('d3d9.dll', 'Direct3DCreate9', @Direct3DCreate9Callback, @Direct3DCreate9Next);
          end;
      DLL_PROCESS_DETACH:
          begin
               UnhookCode(@EndScene9Next);
               UnhookCode(@ResetNext);
               UnhookCode(@SetStreamSourceNext);
               UnhookCode(@DrawIndexedPrimitiveNext);
               UnhookCode(@CreateDevice9Next);
               UnhookCode(@Direct3DCreate9Next);
          end;
  end;
end;

begin
    DLLProc:=@DLLEntryPoint;
    DLLEntryPoint(DLL_PROCESS_ATTACH);
end.

