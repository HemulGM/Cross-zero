unit LanGame;

interface
 uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, XPMan, Buttons, Menus, NMMSG, Psock;

 type
  TStatus = (tsWait, tsYes, tsNo, tsSC);
  TLanGame = class
   public
    Address:string;
    ConnectAddress:string;
    Status:TStatus;
    ClientIsWait:Boolean;
    function ConnectTo(CAddress:string):Boolean;
    procedure SendCommandTo(Command:string);
    function SendParametrs:Boolean;
    function SendClickPos(CPos:TPoint):Boolean;
  end;
  TCheckParam = record
   Lead:Boolean;
   Size:Boolean;
  end;

 const
  SureGame:string =  '-sure';
  AnswerYes:string = '-yes';
  AnswerNo:string =  '-no';
  StartGame:string = '-play';
  YouLeadC:string =   '-leadC';
  YouLeadZ:string =   '-leadZ';
  GridSize:string =  '-size';
  StopGame:string =  '-stop';
  Winner:string =    '-winn';
  Full:string =      '-full';
  SClick:string =    '-click';
  SWait:string =     '-wait';
  SReady:string =    '-ready';

 var
  GameLan:TLanGame;
  CheckParam:TCheckParam;
  function CheckFull:Boolean;

implementation
 uses Main, SetLanGame;

function CheckFull:Boolean;
begin
 Result:=CheckParam.Lead and CheckParam.Size;
end;

function TLanGame.SendClickPos(CPos:TPoint):Boolean;
begin
 Result:=False;
 with FormMain do
  begin
   NMMSGServer.Connect;
   NMMsg.Host:=ConnectAddress;
   NMMSGServer.Host:=ConnectAddress;
   NMMsg.FromName:=NMMsg.LocalIP;
   try
    NMMsg.PostIt(SClick+'@'+IntToStr(CPos.X)+':'+IntToStr(CPos.Y));
   except
    Exit;
   end;
  end;
 Result:=True;
end;

function TLanGame.SendParametrs:Boolean;
begin
 Result:=False;
 with FormMain do
  begin
   NMMSGServer.Connect;
   NMMsg.Host:=ConnectAddress;
   NMMSGServer.Host:=ConnectAddress;
   NMMsg.FromName:=NMMsg.LocalIP;
   try
    case Game.CompLead of
     tlCross:NMMsg.PostIt(YouLeadC);
     tlZero: NMMsg.PostIt(YouLeadZ);
    end;
    NMMsg.PostIt(GridSize+'@'+IntToStr(Game.Size));
   except
    Exit;
   end; 
  end;
 Result:=True;
end;

procedure TLanGame.SendCommandTo(Command:string);
begin
 with FormMain do
  begin
   NMMSGServer.Connect;
   NMMsg.Host:=ConnectAddress;
   NMMSGServer.Host:=ConnectAddress;
   NMMsg.FromName:=NMMsg.LocalIP;
   NMMsg.PostIt(Command);
  end;
end;

function TLanGame.ConnectTo(CAddress:string):Boolean;
begin
 with FormMain do
  begin
   NMMSGServer.Connect;
   NMMsg.Host:=CAddress;
   NMMSGServer.Host:=CAddress;
   NMMsg.FromName:=NMMsg.LocalIP;
   try
    NMMsg.PostIt(SureGame);
   except
    begin
     Result:=False;
     Exit;
    end;
   end;
   ConnectAddress:=CAddress;
   Address:=CAddress;
   Result:=True;
  end;
end;

initialization
 GameLan:=TLanGame.Create;

end.
