object FormSet: TFormSet
  Left = 475
  Top = 189
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1054#1087#1094#1080#1080
  ClientHeight = 191
  ClientWidth = 296
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
  object LabelGraphics: TLabel
    Left = 8
    Top = 32
    Width = 128
    Height = 13
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1092#1086#1088#1084#1083#1077#1085#1080#1077':'
  end
  object ButtonClose: TButton
    Left = 192
    Top = 160
    Width = 99
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 0
    OnClick = ButtonCloseClick
  end
  object ListBoxGraphics: TListBox
    Left = 8
    Top = 48
    Width = 281
    Height = 105
    ItemHeight = 13
    TabOrder = 1
    OnDblClick = ListBoxGraphicsDblClick
  end
  object CheckBoxTieUp: TCheckBox
    Left = 8
    Top = 8
    Width = 129
    Height = 17
    Caption = '"'#1044#1086#1089#1088#1086#1095#1085#1072#1103'" '#1085#1080#1095#1100#1103
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = CheckBoxTieUpClick
  end
end
