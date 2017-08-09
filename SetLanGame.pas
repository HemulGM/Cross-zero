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
 LabelStatus.Caption:='����������...';
 if GameLan.ConnectTo(EditIP.Text) then
  begin
   LabelStatus.Caption:='���������� �����������, ���� �����...';
   GameLan.Status:=tsWait;
   TimerCheck.Enabled:=True;
  end
 else LabelStatus.Caption:='���� �� ��������� ���������� �� ��������.'
end;

procedure TFormSetLanGame.TimerCheckTimer(Sender: TObject);
begin
 case GameLan.Status of
  tsWait:Exit;
  tsNo:begin
        LabelStatus.Caption:='����������� ���������.';
        TimerCheck.Enabled:=False;
        Exit;
       end;
  tsYes:
       begin
        LabelStatus.Caption:='����������� �������.';
        LabelStatus.Caption:='�������� ���������� ����...';
        GameLan.Status:=tsWait;
        GameLan.SendParametrs;
       end;
  tsSC:begin
        ButtonStart.Enabled:=True;
        LabelStatus.Caption:='���������� ������, ������� "������"';
        TimerCheck.Enabled:=False;
       end;
  end;
end;

end.
