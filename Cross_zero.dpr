program Cross_zero;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  New in 'New.pas' {FormNewGame},
  ResWin in 'ResWin.pas' {FormWin},
  Settings in 'Settings.pas' {FormSet},
  About in 'About.pas' {FormHelp},
  LanGame in 'LanGame.pas',
  SetLanGame in 'SetLanGame.pas' {FormSetLanGame};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Крестики vs Нолики';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormNewGame, FormNewGame);
  Application.CreateForm(TFormWin, FormWin);
  Application.CreateForm(TFormSet, FormSet);
  Application.CreateForm(TFormHelp, FormHelp);
  Application.CreateForm(TFormSetLanGame, FormSetLanGame);
  Application.Run;
end.
