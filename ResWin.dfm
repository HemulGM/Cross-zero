object FormWin: TFormWin
  Left = 782
  Top = 142
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
  ClientHeight = 192
  ClientWidth = 201
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ImageWin: TImage
    Left = 0
    Top = 0
    Width = 200
    Height = 100
  end
  object Bevel1: TBevel
    Left = 0
    Top = 104
    Width = 201
    Height = 9
    Shape = bsTopLine
  end
  object LabelResult: TLabel
    Left = 8
    Top = 112
    Width = 185
    Height = 41
    AutoSize = False
  end
  object ButtonOK: TButton
    Left = 8
    Top = 160
    Width = 89
    Height = 25
    Caption = #1054#1050
    TabOrder = 0
    OnClick = ButtonOKClick
  end
  object ButtonClose: TButton
    Left = 104
    Top = 160
    Width = 91
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 1
    OnClick = ButtonCloseClick
  end
end
