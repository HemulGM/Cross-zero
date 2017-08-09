unit ResWin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormWin = class(TForm)
    ImageWin: TImage;
    Bevel1: TBevel;
    ButtonOK: TButton;
    ButtonClose: TButton;
    LabelResult: TLabel;
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormWin: TFormWin;

implementation

 uses
    Main;
{$R *.dfm}

procedure TFormWin.ButtonCloseClick(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TFormWin.ButtonOKClick(Sender: TObject);
begin
 Close;
end;

procedure TFormWin.FormShow(Sender: TObject);
begin
 case Game.LastWin of
  twCross:ImageWin.Picture.Graphic:=Bitmaps.WinC;
  twZero:ImageWin.Picture.Graphic:=Bitmaps.WinZ;
  twNothing:ImageWin.Picture.Graphic:=Bitmaps.WinCZ;
 else
  ImageWin.Picture.Graphic:=Bitmaps.WinCZ;
 end;
 LabelResult.Caption:=Game.Score.Text+#13#10+'Партий сыграно: '+IntToStr(Game.Score.Games);
end;

end.
