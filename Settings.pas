unit Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormSet = class(TForm)
    LabelGraphics: TLabel;
    ButtonClose: TButton;
    ListBoxGraphics: TListBox;
    CheckBoxTieUp: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure ListBoxGraphicsDblClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure CheckBoxTieUpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSet: TFormSet;
  MF:array[0..50] of String;

implementation
 uses Main;

{$R *.dfm}

procedure FillDll;
var FS:TSearchRec;
   Count:Byte;
begin
 Count:=0;
 FormSet.ListBoxGraphics.Clear;
 if FindFirst(Path+'Graphics\*.dll', faAnyFile, FS) = 0 then
  begin
   FormSet.ListBoxGraphics.Items.Add(FS.Name);
   MF[Count]:=Path+'Graphics\'+FS.Name;
   while FindNext(FS) = 0 do
    begin
     Inc(Count);
     if Count=50 then Break;
     FormSet.ListBoxGraphics.Items.Add(FS.Name);
     MF[Count]:=Path+'Graphics\'+FS.Name;
    end;
   FindClose(FS);
  end;
end;

procedure TFormSet.FormShow(Sender: TObject);
begin
 CheckBoxTieUp.Checked:=Game.EnableTieUp;
 FillDll;
end;

procedure TFormSet.ListBoxGraphicsDblClick(Sender: TObject);
begin
 LoadSkinFromDll(MF[ListBoxGraphics.ItemIndex]);
end;

procedure TFormSet.ButtonCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TFormSet.CheckBoxTieUpClick(Sender: TObject);
begin
 Game.EnableTieUp:=CheckBoxTieUp.Checked;
end;

end.
