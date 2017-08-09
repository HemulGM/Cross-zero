unit SetLanGame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls, Buttons, ExtCtrls;

type
  TFormSetLanGame = class(TForm)
    LabelIP: TLabel;
    EditIP: TEdit;
    ButtonCheck: TButton;
    ButtonCancel: TButton;
    ButtonStart: TButton;
    Bevel1: TBevel;
    LabelStatus: TLabel;
    TimerCheck: TTimer;
    procedure ButtonCheckClick(Sender: TObject);
    procedure TimerCheckTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSetLanGame: TFormSetLanGame;

implementation
 uses LanGame;

{$R *.dfm}

procedure TFormSetLanGame.ButtonCheckClick(Sender: TObject);
begin
 LabelStatus.Caption:='Соединение...';
 if GameLan.ConnectTo(EditIP.Text) then
  begin
   LabelStatus.Caption:='Соединение установлено, ждем ответ...';
   GameLan.Status:=tsWait;
   TimerCheck.Enabled:=True;
  end
 else LabelStatus.Caption:='Игра на удаленном компьютере не запущена.'
end;

procedure TFormSetLanGame.TimerCheckTimer(Sender: TObject);
begin
 case GameLan.Status of
  tsWait:Exit;
  tsNo:begin
        LabelStatus.Caption:='Приглашение откланено.';
        TimerCheck.Enabled:=False;
        Exit;
       end;
  tsYes:
       begin
        LabelStatus.Caption:='Приглашение принято.';
        LabelStatus.Caption:='Отправка параметров игры...';
        GameLan.Status:=tsWait;
        GameLan.SendParametrs;
       end;
  tsSC:begin
        ButtonStart.Enabled:=True;
        LabelStatus.Caption:='Соединение готово, нажмите "Начать"';
        TimerCheck.Enabled:=False;
       end;
  end;
end;

end.
