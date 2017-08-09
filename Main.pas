unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, XPMan, Buttons, Menus, pngextra,
  NMMSG, Psock;

type
  TFormMain = class(TForm)
    XPManifest: TXPManifest;
    ImageBG: TImage;
    DrawGridMain: TDrawGrid;
    LabelScoreZero: TLabel;
    LabelScoreCross: TLabel;
    ImageZeroX: TImage;
    ImageCrossX: TImage;
    ButtonOption: TPNGButton;
    ButtonNew: TPNGButton;
    ButtonHide: TPNGButton;
    ButtonHelp: TPNGButton;
    ButtonClose: TPNGButton;
    ButtonAbout: TPNGButton;
    TimerAutoGame: TTimer;
    TimerStep: TTimer;
    NMMsg: TNMMsg;
    NMMSGServer: TNMMSGServ;
    procedure FormCreate(Sender: TObject);
    procedure DrawGridMainDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGridMainMouseWheelDown(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure DrawGridMainMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ImageBGMouseLeave(Sender: TObject);
    procedure ImageBGMouseEnter(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonHideClick(Sender: TObject);
    procedure ButtonNewClick(Sender: TObject);
    procedure DrawGridMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure ButtonOptionClick(Sender: TObject);
    procedure ButtonAboutClick(Sender: TObject);
    procedure TimerAutoGameTimer(Sender: TObject);
    procedure TimerStepTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NMMSGServerMSG(Sender: TComponent; const sFrom,
      sMsg: String);
  private
   procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
  public
    { Public declarations }
  end;
 TGrid = array[0..15,0..15] of Byte;
 TLead = (tlCross, tlZero);
 TLeadWin = (twCross, twZero, twNothing);
 TGameType = (gtLarge, gtSmall);
 TScore = record
  Cross:Word;
  Zero:Word;
  Games:Word;
  Text:string;
 end;
 TGameMode = (gmPVP, gmPVB, gmPVPLan);                                          //(Игрок против игрока, мигрок против компьютера, игрок против игрока по сети)
 TGame = class
  private
   Lead:TLead;                                                                  //Текущий ход
   FSize:Byte;
   procedure SetSize(Value:Byte);
   function GetSize:Byte;
   function CheckPos(const Str, GTypeC, GTypeZ:string; var Initial,Final:byte;  //Проверка на выигрышную комбинацию (расширенная)
    var Winner:TLead):byte;
   function GetHorizontaly(Row:byte; Grid:TGrid):string;                                    //Получить строку по горизонтали
   function GetVerticaly(Row:byte; Grid:TGrid):string;                                      //Получить строку по вертикали
   procedure GetDiagonalRight(List:TStrings; Grid:TGrid);                                   //Получить список диагоналей
   procedure GetDiagonalLeft(List:TStrings; Grid:TGrid);                                    //Получить список диагоналей
  public
   GameType:TGameType;                                                          //Размер комбинации
   GameMode:TGameMode;
   Score:TScore;                                                                //Счет
   FirstLead:TLead;                                                             //Первый ход
   CompLead:TLead;
   LastWin:TLeadWin;                                                            //Последний выигравший
   SetofCoord:array[1..5] of TPoint;                                            //Множество координат ячеек комбинации
   IsEnd:Boolean;                                                               //Конец игры (для отрисовки доп. ячеек)
   FTU:Boolean;
   EnableTieUp:Boolean;
   procedure Clear;                                                             //Очистка поля
   procedure New;                                                               //Новая игра
   function Check(var Winner:TLead; var Initial, Final:Byte; Grid:TGrid):Boolean;           //Проверка на выигрышную комбинацию (расширенная)
   function TieUp:Boolean;                                                      //Ничья
   procedure SetScore;                                                          //Показать счет
   procedure UpCross;                                                           //Очки крестиков + 1
   procedure UpZero;                                                            //Очки ноликов + 1
  published
   property Size:byte read GetSize write SetSize;                               //Установка размера поля
  end;
  TBitmaps = class                                                              //Текстуры
   public
    Cross:TPNGObject;                                                           //Изображение крестика (зависти от размера поля)
    Zero:TPNGObject;                                                            //Изображение нолика (зависти от размера поля)
    CrossLead:TPNGObject;                                                       //Подсвеченный крестик
    ZeroLead:TPNGObject;                                                        //Подсвеченный нолик
    CrossShow:TPNGObject;                                                       //Крестик для показа
    ZeroShow:TPNGObject;                                                        //Нолик для показа
    Empty:TPNGObject;                                                           //Пустая клетка
    BackGround:TBitmap;                                                         //Фон
    WinC:TPNGObject;                                                            //Выиграли крестики
    WinZ:TPNGObject;                                                            //Выиграли нолики
    WinCZ:TPNGObject;                                                           //Ничья
    New:TPNGObject;                                                             //Пустая клета для выигрышной комбинации
    EmptyWin:TPNGObject;
    DrawBMP:TBitmap;
    constructor Create;
  end;

const
  Cross = 22;                                                                   //Крестик
  Zero = 24;                                                                    //Нолик
  FCrossSmall:string  = '111';                                                  //Строка крестиков 3 на 3
  FZeroSmall: string  = '000';                                                  //Строка ноликов 3 на 3
  FCrossLarge:string  = '11111';                                                //Строка крестиков 5/10 на 5/10
  FZeroLarge: string  = '00000';                                                //Строка ноликов 5/10 на 5/10

var
  FormMain: TFormMain;
  Grid:TGrid;                                                                   //Массив - поле
  Game:TGame;                                                                   //Игра
  Bitmaps:TBitmaps;                                                             //Текстуры
  Need:Boolean;                                                                 //Перетаскивание возможно
  Path:String;                                                                  //Рабочий каталог
  ThemeName:string='default.dll';                                               //Стандартная схема
  Client:Boolean;

  function LoadSkinFromDll(DllName:string):Boolean;                             //загрузка схемы
  procedure RandomStep;
  procedure ClickToGrid(CPos:TPoint);
  function Busy(CPos:TPoint):Boolean;



implementation
 uses New, ResWin, Settings, About, LanGame, SetLanGame;

{$R *.dfm}

constructor TBitmaps.Create;
begin
 Cross:=TPNGObject.Create;
 Zero:=TPNGObject.Create;
 CrossLead:=TPNGObject.Create;
 ZeroLead:=TPNGObject.Create;
 CrossShow:=TPNGObject.Create;
 ZeroShow:=TPNGObject.Create;
 Empty:=TPNGObject.Create;
 EmptyWin:=TPNGObject.Create;
 BackGround:=TBitmap.Create;
 WinC:=TPNGObject.Create;
 WinZ:=TPNGObject.Create;
 WinCZ:=TPNGObject.Create;
 New:=TPNGObject.Create;
 DrawBMP:=TBitmap.Create;
 inherited;
end;

procedure TGame.New;
begin
 case FormNewGame.ShowModal of
  mrOk:
   begin
    Score.Cross:=0;
    Score.Zero:=0;
    Score.Games:=0;
    GameMode:=gmPVB;
    SetScore;
    Clear;
   end;
  mrYes:
   begin
    Score.Cross:=0;
    Score.Zero:=0;
    Score.Games:=0;
    GameMode:=gmPVPLan;
    SetScore;
    Clear;
    case FormSetLanGame.ShowModal of
     mrCancel:New;
     mrOk:Exit;
    end;
   end;
 else
  if not Client then Application.Terminate
  else
   begin
    Score.Cross:=0;
    Score.Zero:=0;
    Score.Games:=0;
    GameMode:=gmPVPLan;
    SetScore;
    Clear;
   end;
 end;
end;

function LoadSkinFromDll(DllName:string):Boolean;
var DLL:Cardinal;
 S: array [0..255] of Char;
 Clr:string;
 Color:TColor;
 //PNG:TPNGObject;
begin
 Dll:=LoadLibrary(PChar(Dllname));
 if DLL=0 then
  begin
   Result:=False;
   Exit;
  end;
 ThemeName:=ExtractFileName(DllName); 
 LoadString(DLL, 60000, S, 255);
 Clr:=StrPas(S);
 try
  Color:=StringToColor(Clr);
 except
  Color:=clWhite;
 end;
 FormMain.LabelScoreZero.Font.Color:=Color;
 FormMain.LabelScoreCross.Font.Color:=Color;
 with Bitmaps do
  try
   CrossLead.LoadFromResourceName(DLL, 'crossc');
   ZeroLead.LoadFromResourceName(DLL, 'zeroc');
   CrossShow.LoadFromResourceName(DLL, 'crosss');
   ZeroShow.LoadFromResourceName(DLL, 'zeros');
   Empty.LoadFromResourceName(DLL, 'Empty');
   EmptyWin.LoadFromResourceName(DLL, 'EmptyWin');
   BackGround.LoadFromResourceName(DLL, 'bg');
   WinC.LoadFromResourceName(DLL, 'c');
   Winz.LoadFromResourceName(DLL, 'z');
   WinCZ.LoadFromResourceName(DLL, 'cz');
   New.LoadFromResourceName(DLL, 'main');
   with FormMain do
    begin
     ImageBG.Picture.Bitmap:=Bitmaps.BackGround;
     ButtonClose.ImageNormal.LoadFromResourceName(DLL, 'close');
     ButtonHide.ImageNormal.LoadFromResourceName(DLL, 'hide');
     ButtonNew.ImageNormal.LoadFromResourceName(DLL, 'new');
     ButtonHelp.ImageNormal.LoadFromResourceName(DLL, 'help');
     ButtonAbout.ImageNormal.LoadFromResourceName(DLL, 'about');
     ButtonOption.ImageNormal.LoadFromResourceName(DLL, 'set');
     DrawGridMain.Repaint;
    end;
   FreeLibrary(DLL);
  except
   begin
    FreeLibrary(Dll);
    MessageBox(FormMain.Handle, 'Отсутствуют необходимые текстуры!'+#13+#10+'Попытка загрузки сдандартной схемы.', '', MB_ICONSTOP or MB_OK);
    if not LoadSkinFromDll(Path+'Graphics\default.dll') then
     begin
      MessageBox(FormMain.Handle, 'Отсутствует стандартная схема "Graphics\default.dll"'+#13+#10+'Программа будет закрыта.', '', MB_ICONSTOP or MB_OK);
      Application.Terminate;
     end;
   end;
  end;
 Result:=True;
end;

procedure LoadSize(Value:Byte; DllName:string);
var DLL:Cardinal;
begin
 Dll:=LoadLibrary(PChar(Dllname));
 if DLL=0 then Exit;
 case Value of
  3:
  with Bitmaps do
   try
    Cross.LoadFromResourceName(DLL, 'cross_3');
    Zero.LoadFromResourceName(DLL, 'zero_3');
   except
   end;
  5:
  with Bitmaps do
   try
    Cross.LoadFromResourceName(DLL, 'cross_5');
    Zero.LoadFromResourceName(DLL, 'zero_5');
   except
   end;
  10:
  with Bitmaps do
   try
    Cross.LoadFromResourceName(DLL, 'cross_10');
    Zero.LoadFromResourceName(DLL, 'zero_10');
   except
   end;
 else
  with Bitmaps do
   try
    Cross.LoadFromResourceName(DLL, 'cross_3');
    Zero.LoadFromResourceName(DLL, 'zero_3');
    CrossLead.LoadFromResourceName(DLL, 'crossc_3');
    ZeroLead.LoadFromResourceName(DLL, 'zeroc_3');
   except
   end;
 end;
end;

procedure TFormMain.WMNCHitTest(var M:TWMNCHitTest);
begin
 inherited;
 if (M.Result = htClient) and Need then M.Result := htCaption;
end;

procedure TGame.UpCross;
begin
 Score.Cross:=Score.Cross+1;
 SetScore;
end;

procedure TGame.UpZero;
begin
 Score.Zero:=Score.Zero+1;
 SetScore;
end;

procedure TGame.SetScore;
begin
 with FormMain do
  begin
   LabelScoreCross.Caption:=IntToStr(Score.Cross);
   LabelScoreZero.Caption:=IntToStr(Score.Zero);
  end;
end;

function TGame.CheckPos(const Str, GTypeC, GTypeZ:string; var Initial,Final:byte; var Winner:TLead):byte;
var CPos:Byte;
begin
 Result:=0;
 CPos:=Pos(GTypeC, Str);
 if CPos<>0 then
  begin
   Initial:=CPos;
   Final:=CPos+Length(GTypeC)-1;
   Result:=CPos;
   Winner:=tlCross;
   Exit;
  end;
 //--
 //--Zero
 CPos:=Pos(GTypeZ, Str);
 if CPos<>0 then
  begin
   Initial:=CPos;
   Final:=CPos+Length(GTypeZ)-1;
   Winner:=tlZero;
   Result:=CPos;
   Exit;
  end;
  //--
end;

function TGame.GetVerticaly(Row:byte; Grid:TGrid):string;
var i:Byte;
begin
 Result:='';
 for i:=0 to FSize-1 do
  case Grid[Row,i] of
   Cross:Result:=Result+'1';
   Zero:Result:=Result+'0';
  else
   Result:=Result+'2';
  end;
end;

function TGame.GetHorizontaly(Row:byte; Grid:TGrid):string;
var i:Byte;
begin
 Result:='';
 for i:=0 to FSize-1 do
  case Grid[i,Row] of
   Cross:Result:=Result+'1';
   Zero:Result:=Result+'0';
  else
   Result:=Result+'2';
  end;
end;

procedure TGame.GetDiagonalRight(List:TStrings; Grid:TGrid);
var p,i,b:byte;
 Str:string;
 Max:byte;
begin
 Max:=FSize;
 p:=0;
 List.Clear;
 for b:=(Max-1) downto 0 do
  begin
   for i:=Max-b downto 1 do
    begin
     Inc(p);
     case Grid[i-1,p-1] of
      Cross:Str:=Str+'1';
      Zero:Str:=Str+'0';
     else
      Str:=Str+'2';
     end;
    end;
   List.Add(Str);
   Str:='';
   p:=0;
  end;
 for b:=0 to (Max-1) do
  begin
   p:=1+b;
   for i:=Max downto 2+b do
    begin
     Inc(p);
     case Grid[i-1,p-1] of
      Cross:Str:=Str+'1';
      Zero:Str:=Str+'0';
     else
      Str:=Str+'2';
     end;
    end;
   List.Add(Str);
   Str:='';
  end;
end;

procedure TGame.GetDiagonalLeft(List:TStrings; Grid:TGrid);
var b,i, Max:byte;
 Str:string;
begin
 Max:=FSize;
 List.Clear;
 for b:=(Max-1) downto 1 do
  begin
   for i:=1 to Max-b do
    case Grid[i-1,i+b-1] of
     Cross:Str:=Str+'1';
     Zero:Str:=Str+'0';
    else
     Str:=Str+'2';
    end;
   List.Add(Str);
   Str:='';
  end;
  //--
 for b:=0 to (Max-1) do
  begin
   for i:=1 to Max-b do
    case Grid[i+b-1,i-1] of
     Cross:Str:=Str+'1';
     Zero:Str:=Str+'0';
    else
     Str:=Str+'2';
    end;
   List.Add(Str);
   Str:='';
  end;
end;

function TGame.TieUp:Boolean;
var i,j:byte;
begin
 Result:=False;
 for i:=0 to FSize-1 do
  for j:=0 to FSize-1 do
   if (Grid[i,j]<>Cross) and (Grid[i,j]<>Zero) then Exit;
 Result:=True;
end;

function TieUpFast:Boolean;
var i,j:byte;
  TempGrid:TGrid;
  Winner:TLead;
  Init, Fin:Byte;
  XCross, XZero:Boolean;
begin
 TempGrid:=Grid;
 for i:=0 to Game.FSize-1 do
  for j:=0 to Game.FSize-1 do
   if TempGrid[i,j]=0 then TempGrid[i,j]:=Cross;
 XCross:=not Game.Check(Winner, Init, Fin, TempGrid);
 TempGrid:=Grid;
 for i:=0 to Game.FSize-1 do
  for j:=0 to Game.FSize-1 do
   if TempGrid[i,j]=0 then TempGrid[i,j]:=Zero;
 XZero:=not Game.Check(Winner, Init, Fin, TempGrid);
 Result:=XCross and XZero;
end;

function TGame.Check(var Winner:TLead; var Initial, Final:Byte; Grid:TGrid):Boolean;
var i,j, k:Byte;
 Col, GTypeC, GTypeZ:string;
 List:TStrings;
begin
 Result:=True;
 Col:='';
 GTypeC:='';
 GTypeZ:='';
 case GameType of
  gtLarge:
   begin
    GTypeC:=FCrossLarge;       //11111
    GTypeZ:=FZeroLarge;        //00000
   end;
  gtSmall:
   begin
    GTypeC:=FCrossSmall;       //111
    GTypeZ:=FZeroSmall;        //000
   end;
 end;
 //--Горизонталь
 for i:=0 to FSize-1 do
  begin
   Col:='';
   Col:=GetHorizontaly(i, Grid);
   if CheckPos(Col, GTypeC, GTypeZ, Initial, Final, Winner)<>0 then
    begin
     SetofCoord[1]:=Point(Initial-1, i);
     for j:=2 to 5 do SetofCoord[j]:=Point(SetofCoord[1].X+(j-1), SetofCoord[1].Y);
     Exit;
    end;
  end;
 //--
 //--Вертикаль
 for i:=0 to FSize-1 do
  begin
   Col:='';
   Col:=GetVerticaly(i, Grid);
   if CheckPos(Col, GTypeC, GTypeZ, Initial, Final, Winner)<>0 then
    begin
     SetofCoord[1]:=Point(i, Initial-1);
     for j:=2 to 5 do SetofCoord[j]:=Point(SetofCoord[1].X, SetofCoord[1].Y+(j-1));
     Exit;
    end;
  end;
 List:=TStringList.Create;
 //--
 //--Диагональ справа налево  (сверху вниз)
 GetDiagonalRight(List, Grid);
 for i:=0 to List.Count-1 do
  begin
   Col:='';
   Col:=List.Strings[i];
   if CheckPos(Col, GTypeC, GTypeZ, Initial, Final, Winner)<>0 then
    begin
     if i<=9 then SetofCoord[1]:=Point((i+1)-(Initial-1)-1, Initial-1)
     else         SetofCoord[1]:=Point(FSize-(Initial), ((i-FSize)+1)+(Initial-1));
     k:=0;
     for j:=2 to 5 do
      begin
       Inc(k);
       SetofCoord[j]:=Point(SetofCoord[1].X-k, SetofCoord[1].Y+k);
      end;
     Exit;
    end;
  end;
 //--
 //--Диагональ слева направо  (сверху вниз)
 GetDiagonalLeft(List, Grid);
 for i:=0 to List.Count-1 do
  begin
   Col:='';
   Col:=List.Strings[i];
   if CheckPos(Col, GTypeC, GTypeZ, Initial, Final, Winner)<>0 then
    begin
     if i<=9 then SetofCoord[1]:=Point(Initial-1, (FSize-(i+1))+(Initial-1))
     else         SetofCoord[1]:=Point(((i+1)-FSize)+(Initial-1), (Initial-1));
     for j:=2 to 5 do SetofCoord[j]:=Point(SetofCoord[1].X+(j-1), SetofCoord[1].Y+(j-1));
     Exit;
    end;
  end;
 //--
 Result:=False;
end;

function Place(Line:string; Who:string; XPos:Byte):Boolean;//Возвращяет True, если есть возможность выиграть вставляя в указанную строку хода
var i, CPos, SPos, FPos:Byte;
begin
 if Length(Line)<Length(Who) then
  begin
   Result:=False;
   Exit;
  end;
 for i:=XPos downto 1 do if (Line[i]<>'2') and (Line[i]<>Who[1]) then Break;
 SPos:=i;
 for i:=XPos to Length(Line) do if (Line[i]<>'2') and (Line[i]<>Who[1]) then Break;
 FPos:=i;
 if ((FPos-SPos)+1)<Length(Who) then
  begin
   Result:=False;
   Exit;
  end;

 for i:=SPos to FPos do if Line[i]='2' then Line[i]:=Who[1];
 //for i:=1 to Length(Line) do if Line[i]='2' then Line[i]:=Who[1];
 CPos:=Pos(Who, Line);
 Result:=CPos<>0;
end;

procedure ThinkStep;
var i, CPos, Method:Byte;
  ListV, ListH, ListD1, ListD2:TStrings;
  DPoint, RND:TPoint;
  USE:set of Byte;
  EXT:Boolean;
  P2, P3, P4:string;
  I1, I2, I3, I4:string;
  GTypeI, GTypeP:string;

procedure DestrotAll;
begin
 ListV.Free;
 ListH.Free;
 ListD1.Free;
 ListD2.Free;
end;

function Insert(IH, GTI:string):Boolean;
var i:Byte;
begin
 Result:=False;
 //-вставка 4 начало
 for i:=0 to ListH.Count-1 do                 //Горизонталь
  begin
   CPos:=Pos(IH, ListH[i]);
   if (CPos<>0) and (Place(ListH[i], GTI, CPos)) then
    begin
     if not Busy(Point(CPos-2, i)) then
      begin
       ClickToGrid(Point(CPos-2, i));
       DestrotAll;
       Result:=True;
       Exit;
      end;
     if not Busy(Point(Cpos+(Length(IH)-1), i)) then
      begin
       ClickToGrid(Point(Cpos+(Length(IH)-1), i));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 for i:=0 to ListV.Count-1 do               //Вертикаль
  begin
   CPos:=Pos(IH, ListV[i]);
   if (CPos<>0) and (Place(ListV[i], GTI, CPos)) then
    begin
     if not Busy(Point(i, CPos-2)) then
      begin
       ClickToGrid(Point(i, CPos-2));
       DestrotAll;
       Result:=True;
       Exit;
      end;
     if not Busy(Point(i, Cpos+(Length(IH)-1))) then
      begin
       ClickToGrid(Point(i, Cpos+(Length(IH)-1)));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 for i:=2 to ListD1.Count-3 do               //Диагональ 1
  begin
   CPos:=Pos(IH, ListD1[i]);
   if (CPos<>0) and (Place(ListD1[i], GTI, CPos)) then
    begin
     if i<=9 then DPoint:=Point((i+1)-(CPos-1)-1, CPos-1)
     else         DPoint:=Point(Game.FSize-(CPos), ((i-Game.FSize)+1)+(CPos-1));
     if not Busy(Point(DPoint.X+1, DPoint.Y-1)) then
      begin
       ClickToGrid(Point(DPoint.X+1, DPoint.Y-1));
       DestrotAll;
       Result:=True;
       Exit;
      end;
     if not Busy(Point((DPoint.X-(Length(IH))), (DPoint.Y+(Length(IH))))) then
      begin
       ClickToGrid(Point((DPoint.X-(Length(IH))), (DPoint.Y+(Length(IH)))));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 for i:=2 to ListD2.Count-3 do               //Диагональ 2
  begin
   CPos:=Pos(IH, ListD2[i]);
   if (CPos<>0) and (Place(ListD2[i], GTI, CPos)) then
    begin
     if i<=9 then DPoint:=Point(CPos-1, (Game.FSize-(i+1))+(CPos-1))
     else         DPoint:=Point(((i+1)-Game.FSize)+(CPos-1), (CPos-1));
     if not Busy(Point(DPoint.X-1, DPoint.Y-1)) then
      begin
       ClickToGrid(Point(DPoint.X-1, DPoint.Y-1));
       DestrotAll;
       Result:=True;
       Exit;
      end;
     if not Busy(Point((DPoint.X+(Length(IH))), (DPoint.Y+(Length(IH))))) then
      begin
       ClickToGrid(Point((DPoint.X+(Length(IH))), (DPoint.Y+(Length(IH)))));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
  //--вставка 4 закончена
end;

function CloseStep(PH, GTP:string):Boolean;
var I:Byte;
begin
 Result:=False;
 //--перекрытие 4 начало
 for i:=0 to ListH.Count-1 do                 //Горизонталь
  begin
   CPos:=Pos(PH, ListH[i]);
   if (CPos<>0) and (Place(ListH[i], GTP, CPos)) then
    begin
     if not Busy(Point(CPos-2, i)) then
      begin
       ClickToGrid(Point(CPos-2, i));
       DestrotAll; 
       Result:=True;
       Exit;
      end;
     if not Busy(Point(Cpos+(Length(PH)-1), i)) then
      begin
       ClickToGrid(Point(Cpos+(Length(PH)-1), i));
       DestrotAll; 
       Result:=True;
       Exit;
      end;
    end;
  end;
 for i:=0 to ListV.Count-1 do               //Вертикаль
  begin
   CPos:=Pos(PH, ListV[i]);
   if (CPos<>0) and (Place(ListV[i], GTP, CPos)) then
    begin
     if not Busy(Point(i, CPos-2)) then
      begin
       ClickToGrid(Point(i, CPos-2));
       DestrotAll; 
       Result:=True;
       Exit;
      end;
     if not Busy(Point(i, Cpos+(Length(PH)-1))) then
      begin
       ClickToGrid(Point(i, Cpos+(Length(PH)-1)));
       DestrotAll; 
       Result:=True;
       Exit;
      end;
    end;
  end;
 for i:=2 to ListD1.Count-3 do               //Диагональ 1
  begin
   CPos:=Pos(PH, ListD1[i]);
   if (CPos<>0) and (Place(ListD1[i], GTP, CPos)) then
    begin
     if i<=9 then DPoint:=Point((i+1)-(CPos-1)-1, CPos-1)
     else         DPoint:=Point(Game.FSize-(CPos), ((i-Game.FSize)+1)+(CPos-1));
     if not Busy(Point(DPoint.X+1, DPoint.Y-1)) then
      begin
       ClickToGrid(Point(DPoint.X+1, DPoint.Y-1));
       DestrotAll; 
       Result:=True;
       Exit;
      end;
     if not Busy(Point((DPoint.X-(Length(PH))), (DPoint.Y+(Length(PH))))) then
      begin
       ClickToGrid(Point((DPoint.X-(Length(PH))), (DPoint.Y+(Length(PH)))));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 for i:=2 to ListD2.Count-3 do               //Диагональ 2
  begin
   CPos:=Pos(PH, ListD2[i]);
   if (CPos<>0) and (Place(ListD2[i], GTP, CPos)) then
    begin
     if i<=9 then DPoint:=Point(CPos-1, (Game.FSize-(i+1))+(CPos-1))
     else         DPoint:=Point(((i+1)-Game.FSize)+(CPos-1), (CPos-1));
     if not Busy(Point(DPoint.X-1, DPoint.Y-1)) then
      begin
       ClickToGrid(Point(DPoint.X-1, DPoint.Y-1));
       DestrotAll;
       Result:=True;
       Exit;
      end;
     if not Busy(Point((DPoint.X+(Length(PH))), (DPoint.Y+(Length(PH))))) then
      begin
       ClickToGrid(Point((DPoint.X+(Length(PH))), (DPoint.Y+(Length(PH)))));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 //--перекрытие 4 конец
end;

function InsertInCombination(IXH, GTI:string):Boolean;
var i, XPos:Byte;
begin
 Result:=False;
 //--вставка 010 начало
 for i:=0 to ListH.Count-1 do
  begin
   CPos:=Pos(IXH, ListH[i]);
   if (CPos<>0) and (Place(ListH[i], GTI, CPos)) then
    begin
     XPos:=Pos('2', IXH);
     if not Busy(Point((CPos-1)+XPos, i)) then
      begin
       ClickToGrid(Point((CPos-1)+XPos, i));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 for i:=0 to ListV.Count-1 do
  begin
   CPos:=Pos(IXH, ListV[i]);
   if (CPos<>0) and (Place(ListV[i], GTI, CPos)) then
    begin
     XPos:=Pos('2', IXH);
     if not Busy(Point(i, (CPos-1)+XPos)) then
      begin
       ClickToGrid(Point(i, (CPos-1)+XPos));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 for i:=2 to ListD1.Count-3 do               //Диагональ 1
  begin
   CPos:=Pos(IXH, ListD1[i]);
   if (CPos<>0) and (Place(ListD1[i], GTI, CPos)) then
    begin
     if i<=9 then DPoint:=Point((i+1)-(CPos-1)-1, CPos-1)
     else         DPoint:=Point(Game.FSize-(CPos), ((i-Game.FSize)+1)+(CPos-1));
      XPos:=Pos('2', IXH);
     if not Busy(Point(DPoint.X+(XPos-1), DPoint.Y-(XPos-1))) then
      begin
       ClickToGrid(Point(DPoint.X+(XPos-1), DPoint.Y-(XPos-1)));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 for i:=2 to ListD2.Count-3 do               //Диагональ 2
  begin
   CPos:=Pos(IXH, ListD2[i]);
   if (CPos<>0) and (Place(ListD2[i], GTI, CPos)) then
    begin
     if i<=9 then DPoint:=Point(CPos-1, (Game.FSize-(i+1))+(CPos-1))
     else         DPoint:=Point(((i+1)-Game.FSize)+(CPos-1), (CPos-1));
      XPos:=Pos('2', IXH);
     if not Busy(Point(DPoint.X-(XPos-1), DPoint.Y-(XPos-1))) then
      begin
       ClickToGrid(Point(DPoint.X-(XPos-1), DPoint.Y-(XPos-1)));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 //--вставка 010 конец
end;

function CloseFromCombination(PXH, GTP:string):Boolean;
var i, XPos:Byte;
begin
 Result:=False;
 //--перекрытие 010 начало
 for i:=0 to ListH.Count-1 do
  begin
   CPos:=Pos(PXH, ListH[i]);
   if (CPos<>0) and (Place(ListH[i], GTP, CPos)) then
    begin
     XPos:=Pos('2', PXH);
     if not Busy(Point((CPos-1)+(XPos-1), i)) then                 //+(Length(PX3)-1)
      begin
       ClickToGrid(Point((CPos-1)+(XPos-1), i));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 for i:=0 to ListV.Count-1 do
  begin
   CPos:=Pos(PXH, ListV[i]);
   if (CPos<>0) and (Place(ListV[i], GTP, CPos)) then
    begin
     XPos:=Pos('2', PXH);
     if not Busy(Point(i, (CPos-1)+(XPos-1))) then
      begin
       ClickToGrid(Point(i, (CPos-1)+(XPos-1)));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 for i:=2 to ListD1.Count-3 do               //Диагональ 1
  begin
   CPos:=Pos(PXH, ListD1[i]);
   if (CPos<>0) and (Place(ListD1[i], GTP, CPos)) then
    begin
     if i<=9 then DPoint:=Point((i+1)-(CPos-1)-1, CPos-1)
     else         DPoint:=Point(Game.FSize-(CPos), ((i-Game.FSize)+1)+(CPos-1));
     XPos:=Pos('2', PXH);
     if not Busy(Point(DPoint.X-(XPos-1), DPoint.Y+(XPos-1))) then
      begin
       ClickToGrid(Point(DPoint.X-(XPos-1), DPoint.Y+(XPos-1)));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 for i:=2 to ListD2.Count-3 do               //Диагональ 2
  begin
   CPos:=Pos(PXH, ListD2[i]);
   if (CPos<>0) and (Place(ListD2[i], GTP, CPos)) then
    begin
     if i<=9 then DPoint:=Point(CPos-1, (Game.FSize-(i+1))+(CPos-1))
     else         DPoint:=Point(((i+1)-Game.FSize)+(CPos-1), (CPos-1));
     XPos:=Pos('2', PXH);
     if not Busy(Point((DPoint.X+(XPos-1)), (DPoint.Y+(XPos-1)))) then
      begin
       ClickToGrid(Point((DPoint.X+(XPos-1)), (DPoint.Y+(XPos-1))));
       DestrotAll;
       Result:=True;
       Exit;
      end;
    end;
  end;
 //--перекрытие 010 конец
end;

function X21(Combination:string):string;
var i:Byte;
begin
 Result:='';
 for i:=1 to Length(Combination) do
  begin
   case Combination[i] of
    'X', 'x':Result:=Result+'1';
    'E', 'e':Result:=Result+'2';
   end;
  end;
end;

function X20(Combination:string):string;
var i:Byte;
begin
 Result:='';
 for i:=1 to Length(Combination) do
  begin
   case Combination[i] of
    'X', 'x':Result:=Result+'0';
    'E', 'e':Result:=Result+'2';
   end;
  end;
end;

function X2XP(Combination:string):string;
begin
 case Game.Lead of
  tlZero:Result:=X21(Combination);
  tlCross:Result:=X20(Combination);
 end;
end;

function X2XI(Combination:string):string;
begin
 case Game.Lead of
  tlZero:Result:=X20(Combination);
  tlCross:Result:=X21(Combination);
 end;
end;

begin
 if Game.IsEnd then Exit;
 case Game.Lead of
  tlZero:
   begin
    I1:='0';
    I2:='00';
    I3:='000';
    I4:='0000';
    P2:='11';
    P3:='111';
    P4:='1111';
    case Game.GameType of
     gtLarge:
      begin
       GTypeI:=FZeroLarge;
       GTypeP:=FCrossLarge;
      end;
     gtSmall:
      begin
       GTypeI:=FZeroSmall;
       GTypeP:=FCrossSmall;
      end;
    end;
   end;
  tlCross:
   begin
    P2:='00';
    P3:='000';
    P4:='0000';
    I1:='1';
    I2:='11';
    I3:='111';
    I4:='1111';
    case Game.GameType of
     gtLarge:
      begin
       GTypeI:=FCrossLarge;
       GTypeP:=FZeroLarge;
      end;
     gtSmall:
      begin
       GTypeI:=FCrossSmall;
       GTypeP:=FZeroSmall;
      end;
    end;
   end;
 end;
 ListV:=TStringList.Create;
 ListH:=TStringList.Create;
 ListD1:=TStringList.Create;
 ListD2:=TStringList.Create;
 for i:=0 to Game.FSize-1 do
  begin
   ListV.Add(Game.GetVerticaly(i, Grid));             //Получены списки по вертикали
   ListH.Add(Game.GetHorizontaly(i, Grid));           //Списки по горизонтали
  end;
 Game.GetDiagonalRight(ListD1, Grid);                 //Диагонали 1  сверху вниз справа налево
 Game.GetDiagonalLeft(ListD2, Grid);                  //Диагонали 2  сверху вниз слева направо

 if Insert(I4, GTypeI)    then Exit;
 if CloseStep(P4, GTypeP) then Exit;

 if InsertInCombination(X2XI('EXXXE'), GTypeI)  then Exit;
 if CloseFromCombination(X2XP('EXXXE'), GTypeP) then Exit;
 if InsertInCombination(X2XI('EXXEXE'),   GTypeI) then Exit;
 if CloseFromCombination(X2XP('EXXEXE'),  GTypeP) then Exit;
 if InsertInCombination(X2XI('EXEXXE'),   GTypeI) then Exit;
 if CloseFromCombination(X2XP('EXEXXE'),  GTypeP) then Exit;

 if CloseStep(P3, GTypeP) then Exit;
 if Insert(I3, GTypeI)    then Exit;

 if Insert(I2, GTypeI)    then Exit;
 if CloseStep(P2, GTypeP) then Exit;

 if InsertInCombination(X2XI('XXXEX'),  GTypeI) then Exit;
 if CloseFromCombination(X2XP('XXXEX'), GTypeP) then Exit;

 if InsertInCombination(X2XI('XXEXX'),  GTypeI) then Exit;
 if CloseFromCombination(X2XP('XXEXX'), GTypeP) then Exit;

 if InsertInCombination(X2XI('XEXXX'),  GTypeI) then Exit;
 if CloseFromCombination(X2XP('XEXXX'), GTypeP) then Exit;

 if InsertInCombination(X2XI('XEEXX'),  GTypeI) then Exit;
 if CloseFromCombination(X2XP('XEEXX'), GTypeP) then Exit;

 if InsertInCombination(X2XI('XXEEX'),  GTypeI) then Exit;
 if CloseFromCombination(X2XP('XXEEX'), GTypeP) then Exit;

 if InsertInCombination(X2XI('XXEX'),   GTypeI) then Exit;
 if CloseFromCombination(X2XP('XXEX'),  GTypeP) then Exit;

 if InsertInCombination(X2XI('XEXX'),   GTypeI) then Exit;
 if CloseFromCombination(X2XP('XEXX'),  GTypeP) then Exit;

 if InsertInCombination(X2XI('XEX'),    GTypeI) then Exit;
 if CloseFromCombination(X2XP('XEX'),   GTypeP) then Exit;

 Randomize;
 //--вставка 1 начало
 for i:=0 to ListH.Count-1 do
  begin
   CPos:=Pos(I1, ListH[i]);
   if (CPos<>0) and (Place(ListH[i], GTypeI, CPos)) then
    begin
     EXT:=False;
     repeat
      repeat
       Method:=Random(16)+1;
       if USE=[1..16] then EXT:=True;
      until (not (Method in USE)) or (EXT);
      Include(USE, Method);
      DPoint:=Point(CPos-1, i);
      case Method of
       1:RND:=Point(DPoint.X-1, DPoint.Y-1);
       2:RND:=Point(DPoint.X  , DPoint.Y-1);
       3:RND:=Point(DPoint.X+1, DPoint.Y-1);
       4:RND:=Point(DPoint.X+1, DPoint.Y  );
       5:RND:=Point(DPoint.X+1, DPoint.Y+1);
       6:RND:=Point(DPoint.X,   DPoint.Y+1);
       7:RND:=Point(DPoint.X-1, DPoint.Y+1);
       8:RND:=Point(DPoint.X-1, DPoint.Y  );

       9 :RND:=Point(DPoint.X-2, DPoint.Y-2);
       10:RND:=Point(DPoint.X  , DPoint.Y-2);
       11:RND:=Point(DPoint.X+2, DPoint.Y-2);
       12:RND:=Point(DPoint.X+2, DPoint.Y  );
       13:RND:=Point(DPoint.X+2, DPoint.Y+2);
       14:RND:=Point(DPoint.X,   DPoint.Y+2);
       15:RND:=Point(DPoint.X-2, DPoint.Y+2);
       16:RND:=Point(DPoint.X-2, DPoint.Y  );
      else
       Break;
      end;
     until (not Busy(RND)) or EXT;
     if not EXT then
      begin
       ClickToGrid(RND);
       DestrotAll;
       Exit;
      end;
    end;
  end;
 //--вставка 1 конец
 DestrotAll;
 RandomStep;
end;

procedure TGame.SetSize(Value:Byte);
var NullGrid:TGridRect;
begin
 FSize:=Value;
 if FSize<=4 then GameType:=gtSmall;
 if FSize>4 then GameType:=gtLarge;
 with NullGrid do
  begin
   Left:=0;
   Top:=0;
  end;
 case Value of
  3:begin
     FormMain.DrawGridMain.Selection:=NullGrid;
     FormMain.DrawGridMain.DefaultColWidth:=82;
     FormMain.DrawGridMain.DefaultRowHeight:=82;
     FormMain.DrawGridMain.ColCount:=3;
     FormMain.DrawGridMain.RowCount:=3;
    end;
  5:begin
     FormMain.DrawGridMain.Selection:=NullGrid;
     FormMain.DrawGridMain.DefaultColWidth:=49;
     FormMain.DrawGridMain.DefaultRowHeight:=49;
     FormMain.DrawGridMain.ColCount:=5;
     FormMain.DrawGridMain.RowCount:=5;
    end;
  10:begin
      FormMain.DrawGridMain.Selection:=NullGrid;
      FormMain.DrawGridMain.DefaultColWidth:=24;
      FormMain.DrawGridMain.DefaultRowHeight:=24;
      FormMain.DrawGridMain.ColCount:=10;
      FormMain.DrawGridMain.RowCount:=10;
     end;
 end;
 LoadSize(Value, Path+'Graphics\'+ThemeName);
end;

function TGame.GetSize:Byte;
begin
 Result:=FSize;
end;

procedure TGame.Clear;
var i,j:Byte;
begin
 for i:=0 to 15 do for j:=0 to 15 do Grid[i,j]:=48;
 for i:=0 to Game.Size-1 do for j:=0 to Game.Size-1 do Grid[i,j]:=0;
 FormMain.DrawGridMain.Refresh;
 Game.Lead:=tlCross;;
 case Game.Lead of
  tlCross:
   begin
    FormMain.ImageCrossX.Picture.Graphic:=Bitmaps.CrossLead;
    FormMain.ImageZeroX.Picture.Graphic:=Bitmaps.ZeroShow;
   end;
  tlZero:
   begin
    FormMain.ImageCrossX.Picture.Graphic:=Bitmaps.CrossShow;
    FormMain.ImageZeroX.Picture.Graphic:=Bitmaps.ZeroLead;
   end;
 end;
 for i:=1 to 5 do SetofCoord[i]:=Point(25,25);
 Inc(Score.Games);
 IsEnd:=False;
 FTU:=False;
 FormMain.DrawGridMain.Repaint;
 if (CompLead=tlCross) and (GameMode=gmPVB) then ThinkStep;
end;

function Busy(CPos:TPoint):Boolean;
begin
 Result:=(Grid[CPos.X, CPos.Y]<>0) or (CPos.X<0) or (CPos.Y<0) or (CPos.X>Game.FSize-1) or (CPos.Y>Game.FSize-1);
end;

procedure ClickToGrid(CPos:TPoint);
var
 Winner:TLead;
 I,F:Byte;
 Str:string;
begin
 if Busy(CPos) then Exit;
 if Client then GameLan.SendCommandTo(SWait);
 case Game.Lead of
  tlCross:
   begin
    Grid[CPos.X, CPos.Y]:=Cross;
    Game.Lead:=tlZero;
    FormMain.ImageCrossX.Picture.Graphic:=Bitmaps.CrossShow;
    FormMain.ImageZeroX.Picture.Graphic:=Bitmaps.ZeroLead;
   end;
  tlZero:
   begin
    Grid[CPos.X, CPos.Y]:=Zero;
    Game.Lead:=tlCross;
    FormMain.ImageCrossX.Picture.Graphic:=Bitmaps.CrossLead;
    FormMain.ImageZeroX.Picture.Graphic:=Bitmaps.ZeroShow;
   end;
 end;
 FormMain.DrawGridMain.Refresh;
 if Game.Check(Winner, I, F, Grid) then
  begin
   Game.IsEnd:=True;
   FormMain.DrawGridMain.Refresh;
   case Winner of
    tlCross:
     begin
      Game.UpCross;
      Game.LastWin:=twCross;
     end;
    tlZero:
     begin
      Game.UpZero;
      Game.LastWin:=twZero;
     end;
   end;
   if Game.Score.Cross>Game.Score.Zero then Str:=' в пользу крестиков';
   if Game.Score.Cross<Game.Score.Zero then Str:=' в пользу ноликов';
   if Game.Score.Cross=Game.Score.Zero then Str:='';
   Game.Score.Text:='Счет '+IntToStr(Game.Score.Cross)+':'+IntToStr(Game.Score.Zero)+Str;
   if (Game.GameMode=gmPVPLan) then GameLan.SendClickPos(CPos);
   FormWin.ShowModal;
   Game.Clear;
   if Client then GameLan.SendCommandTo(SReady);
   Exit;
  end;
 if Game.TieUp then
  begin
   Game.IsEnd:=True;
   FormMain.DrawGridMain.Refresh;
   if Game.Score.Cross>Game.Score.Zero then Str:=' в пользу крестиков';
   if Game.Score.Cross<Game.Score.Zero then Str:=' в пользу ноликов';
   if Game.Score.Cross=Game.Score.Zero then Str:='';
   Game.Score.Text:='Счет '+IntToStr(Game.Score.Cross)+':'+IntToStr(Game.Score.Zero)+Str;
   if (Game.GameMode=gmPVPLan) then GameLan.SendClickPos(CPos);
   Game.LastWin:=twNothing;
   FormWin.ShowModal;
   Game.Clear;
   if Client then GameLan.SendCommandTo(SReady);
   Exit;
  end;
 if (not Game.FTU) and (Game.EnableTieUp) and (Game.GameMode<>gmPVPLan) then if TieUpFast then
  begin
   case MessageBox(FormMain.Handle, '"Досрочная" ничья. Продолжить игру?', '', MB_ICONINFORMATION or MB_YESNO) of
    ID_YES:Game.FTU:=True;
    ID_NO:
     begin
      Game.Clear;
      Exit;
     end;
   end;
  end;
 if (Game.Lead=Game.CompLead) and (not Game.IsEnd) and (Game.GameMode=gmPVB) then FormMain.TimerStep.Enabled:=True;
 if (Game.GameMode=gmPVPLan) then GameLan.SendClickPos(CPos);
 if Client then GameLan.SendCommandTo(SReady);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
 Bitmaps:=TBitmaps.Create;
 if not LoadSkinFromDll(Path+'Graphics\'+ThemeName) then
  begin
   MessageBox(FormMain.Handle, 'Отсутствует стандартная схема "Graphics\default.dll"'+#13+#10+'Программа будет закрыта.', '', MB_ICONSTOP or MB_OK);
   Application.Terminate;
  end;
 Game:=TGame.Create;
 Game.Score.Cross:=0;
 Game.Score.Zero:=0;
 Game.Size:=3;
 Game.EnableTieUp:=True;
 Game.SetScore;
 Need:=True;
end;

function Check(ACol, ARow:Byte):Boolean;
var i:Byte;
begin
 Result:=True;
 for i:=1 to 5 do
  if (Game.SetofCoord[i].X = ACol) and (Game.SetofCoord[i].Y = ARow) then Exit;
 Result:=False;
end;

procedure TFormMain.DrawGridMainDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
 if Game.IsEnd then
  begin
   if Check(ACol, ARow) then DrawGridMain.Canvas.StretchDraw(Rect, Bitmaps.EmptyWin)
   else DrawGridMain.Canvas.StretchDraw(Rect, Bitmaps.Empty);
  end
 else DrawGridMain.Canvas.StretchDraw(Rect, Bitmaps.Empty);
 case Grid[ACol, ARow] of
  Cross: DrawGridMain.Canvas.StretchDraw(Rect, Bitmaps.Cross);
  Zero:  DrawGridMain.Canvas.StretchDraw(Rect, Bitmaps.Zero);
 end;
end;

procedure TFormMain.DrawGridMainMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
 Handled:=True;
end;

procedure TFormMain.DrawGridMainMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
 Handled:=True;
end;

procedure TFormMain.ButtonCloseClick(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TFormMain.ImageBGMouseEnter(Sender: TObject);
begin
 Need:=false;
end;

procedure TFormMain.ImageBGMouseLeave(Sender: TObject);
begin
 Need:=True;
end;

procedure RandomStep;
var CPos:TPoint;
   Excpt:Cardinal;
begin
 Randomize;
 Excpt:=0;
 repeat
  Inc(Excpt);
  CPos.X:=Random(Game.Size);
  CPos.Y:=Random(Game.Size);
 until (not Busy(CPos)) or (Excpt=2000000);
 ClickToGrid(CPos);
end;

procedure TFormMain.ButtonHelpClick(Sender: TObject);
begin
 //ThinkStep;
 TimerAutoGame.Enabled:=not TimerAutoGame.Enabled;
end;

procedure TFormMain.ButtonHideClick(Sender: TObject);
begin
 Application.Minimize;
end;

procedure TFormMain.ButtonNewClick(Sender: TObject);
begin
 if MessageBox(Handle, 'Закончить текущую игру и начать новую?', '', MB_ICONWARNING or MB_YESNO)=ID_YES
 then Game.New;
end;

procedure TFormMain.DrawGridMainMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
 var CPos:TPoint;
begin
 case Button of
  mbLeft:
   begin
    if Game.Lead=Game.CompLead then Exit;
    if (not Client) and GameLan.ClientIsWait then
     begin
      MessageBox(Handle, 'Соперник не готов!', '', MB_ICONWARNING or MB_OK);
      Exit;
     end;
    DrawGridMain.MouseToCell(X, Y, CPos.X, Cpos.Y);
    ClickToGrid(CPos);
   end;
 end;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
 Game.New;
end;

procedure TFormMain.ButtonOptionClick(Sender: TObject);
begin
 FormSet.Show;
end;

procedure TFormMain.ButtonAboutClick(Sender: TObject);
begin
 FormHelp.ShowModal;
end;

procedure TFormMain.TimerAutoGameTimer(Sender: TObject);
begin
 if Game.IsEnd then TimerAutoGame.Enabled:=False;;
 ThinkStep;
end;

procedure TFormMain.TimerStepTimer(Sender: TObject);
begin
 TimerStep.Interval:=Random(1000)+1;
 TimerStep.Enabled:=False;
 ThinkStep;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
 Game.Destroy;
end;

procedure TFormMain.NMMSGServerMSG(Sender: TComponent; const sFrom, sMsg: String);
var DPos:Word;
 tmp:string;
 CPos:TPoint;
begin
 //ShowMessage(sMsg);
 if sMsg = SureGame then
  case MessageBox(Handle, PChar('Вас приглашает играть '+SFrom+#13+#10+'Вы согласны?'), '', MB_ICONWARNING or MB_YESNO) of
    idYes:
     begin
      GameLan.ConnectAddress:=sFrom;
      GameLan.SendCommandTo(AnswerYes);
      Client:=True;
      FormNewGame.Close;
     end;
    idNo:
     begin
      GameLan.ConnectAddress:=sFrom;
      GameLan.SendCommandTo(AnswerNo);
     end; 
  end;
 if sMsg = AnswerYes then GameLan.Status:=tsYes;
 if sMsg = AnswerNo  then GameLan.Status:=tsNo;
 if sMsg = YouLeadC then
  begin
   Game.CompLead:=tlZero;
   CheckParam.Lead:=True;
   if CheckFull then GameLan.SendCommandTo(Full);
  end;
 if sMsg = YouLeadZ then
  begin
   Game.CompLead:=tlCross;
   CheckParam.Lead:=True;
   if CheckFull then GameLan.SendCommandTo(Full);
  end;
 if Pos(GridSize, sMsg) <> 0 then
  begin
   DPos:=Pos('@', sMsg);
   Game.Size:=StrToInt(Copy(sMsg, DPos+1, Length(sMsg)-DPos));
   CheckParam.Size:=True;
   if CheckFull then GameLan.SendCommandTo(Full);
  end;
 if sMsg = Full then GameLan.Status:=tsSC;
 if Pos(SClick, sMsg) <> 0 then
  begin
   DPos:=Pos('@', sMsg);
   tmp:=Copy(sMsg, DPos+1, Length(sMsg)-DPos);
   CPos.X:=StrToInt(tmp[1]);
   CPos.Y:=StrToInt(tmp[3]);
   ClickToGrid(CPos);
  end;
 if sMsg = SWait then GameLan.ClientIsWait:=True;
 if sMsg = SReady then GameLan.ClientIsWait:=False;
end;

end.
