unit New;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFormNewGame = class(TForm)
    ComboBoxSize: TComboBox;
    ButtonClose: TButton;
    ButtonOk: TButton;
    RadioGroupCompLead: TRadioGroup;
    LabelPSize: TLabel;
    ImageNewGame: TImage;
    Bevel1: TBevel;
    ButtonLanGame: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormNewGame: TFormNewGame;

implementation
 uses pngimage, Main, SetLanGame;

{$R *.dfm}

procedure TFormNewGame.FormCreate(Sender: TObject);
begin
 ImageNewGame.Picture.Graphic:=Bitmaps.New;
end;

procedure TFormNewGame.ButtonOkClick(Sender: TObject);
begin
 case ComboBoxSize.ItemIndex of
  0:Game.Size:=3;
  1:Game.Size:=5;
  2:Game.Size:=10;
 else
  Game.Size:=3;
 end;
 Game.CompLead:=TLead(RadioGroupCompLead.ItemIndex);
end;

end.
