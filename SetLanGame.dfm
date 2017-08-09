object FormSetLanGame: TFormSetLanGame
  Left = 253
  Top = 169
  BorderStyle = bsDialog
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1089#1077#1090#1077#1074#1086#1081' '#1080#1075#1088#1099
  ClientHeight = 97
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LabelIP: TLabel
    Left = 8
    Top = 8
    Width = 138
    Height = 13
    Caption = 'IP '#1072#1076#1088#1077#1089'/'#1048#1084#1103' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1072
  end
  object Bevel1: TBevel
    Left = 0
    Top = 56
    Width = 465
    Height = 9
    Shape = bsTopLine
  end
  object LabelStatus: TLabel
    Left = 8
    Top = 72
    Width = 3
    Height = 13
  end
  object EditIP: TEdit
    Left = 8
    Top = 24
    Width = 137
    Height = 21
    TabOrder = 0
  end
  object ButtonCheck: TButton
    Left = 152
    Top = 24
    Width = 75
    Height = 25
    Caption = #1054#1087#1088#1086#1089#1080#1090#1100
    TabOrder = 1
    OnClick = ButtonCheckClick
  end
  object ButtonCancel: TButton
    Left = 384
    Top = 64
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object ButtonStart: TButton
    Left = 304
    Top = 64
    Width = 75
    Height = 25
    Caption = #1053#1072#1095#1072#1090#1100
    Enabled = False
    ModalResult = 1
    TabOrder = 3
  end
  object TimerCheck: TTimer
    OnTimer = TimerCheckTimer
    Left = 272
    Top = 8
  end
end
