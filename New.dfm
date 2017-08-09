object FormNewGame: TFormNewGame
  Left = 258
  Top = 170
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
  ClientHeight = 329
  ClientWidth = 201
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelPSize: TLabel
    Left = 24
    Top = 112
    Width = 67
    Height = 13
    Caption = #1056#1072#1079#1084#1077#1088' '#1087#1086#1083#1103
  end
  object ImageNewGame: TImage
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
  object ComboBoxSize: TComboBox
    Left = 24
    Top = 128
    Width = 153
    Height = 21
    Style = csDropDownList
    ImeName = 'Russian'
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = #1057#1090#1072#1085#1076#1072#1088#1090#1085#1086#1077' '#1087#1086#1083#1077' - 3x3'
    Items.Strings = (
      #1057#1090#1072#1085#1076#1072#1088#1090#1085#1086#1077' '#1087#1086#1083#1077' - 3x3'
      #1056#1072#1089#1096#1080#1088#1077#1085#1085#1086#1077' '#1087#1086#1083#1077' - 5x5'
      #1054#1075#1088#1086#1084#1085#1086#1077' '#1087#1086#1083#1077' - 10x10')
  end
  object ButtonClose: TButton
    Left = 8
    Top = 296
    Width = 185
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    ModalResult = 2
    TabOrder = 1
  end
  object ButtonOk: TButton
    Left = 8
    Top = 232
    Width = 185
    Height = 25
    Caption = #1058#1099' vs '#1050#1086#1084#1087#1100#1102#1090#1077#1088
    ModalResult = 1
    TabOrder = 2
    OnClick = ButtonOkClick
  end
  object RadioGroupCompLead: TRadioGroup
    Left = 24
    Top = 160
    Width = 153
    Height = 65
    Caption = #1050#1077#1084' '#1074#1099' '#1073#1091#1076#1077#1090#1077' '#1080#1075#1088#1072#1090#1100'?'
    ItemIndex = 1
    Items.Strings = (
      #1053#1086#1083#1080#1082
      #1050#1088#1077#1089#1090#1080#1082)
    TabOrder = 3
  end
  object ButtonLanGame: TButton
    Left = 8
    Top = 264
    Width = 185
    Height = 25
    Caption = #1057#1077#1090#1077#1074#1072#1103' '#1080#1075#1088#1072
    ModalResult = 6
    TabOrder = 4
    OnClick = ButtonOkClick
  end
end
