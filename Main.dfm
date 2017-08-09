object FormMain: TFormMain
  Left = 361
  Top = 186
  AlphaBlend = True
  AlphaBlendValue = 250
  BorderStyle = bsNone
  Caption = #1050#1088#1077#1089#1090#1080#1082#1080' vs '#1053#1086#1083#1080#1082#1080
  ClientHeight = 321
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  ScreenSnap = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ImageBG: TImage
    Left = 0
    Top = 0
    Width = 321
    Height = 321
    Align = alClient
  end
  object LabelScoreZero: TLabel
    Left = 192
    Top = 284
    Width = 60
    Height = 33
    Alignment = taRightJustify
    AutoSize = False
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelScoreCross: TLabel
    Left = 72
    Top = 284
    Width = 60
    Height = 33
    AutoSize = False
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ImageZeroX: TImage
    Left = 258
    Top = 288
    Width = 32
    Height = 32
    Center = True
    Stretch = True
  end
  object ImageCrossX: TImage
    Left = 34
    Top = 288
    Width = 32
    Height = 32
    Center = True
    Stretch = True
  end
  object ButtonOption: TPNGButton
    Left = 34
    Top = 0
    Width = 23
    Height = 33
    Hint = #1054#1087#1094#1080#1080
    ButtonLayout = pbsImageLeft
    ButtonStyle = pbsNoFrame
    OnClick = ButtonOptionClick
    OnMouseEnter = ImageBGMouseEnter
    OnMouseExit = ImageBGMouseLeave
  end
  object ButtonNew: TPNGButton
    Left = 2
    Top = 0
    Width = 23
    Height = 33
    Hint = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
    ButtonLayout = pbsImageLeft
    ButtonStyle = pbsNoFrame
    OnClick = ButtonNewClick
    OnMouseEnter = ImageBGMouseEnter
    OnMouseExit = ImageBGMouseLeave
  end
  object ButtonHide: TPNGButton
    Left = 266
    Top = 0
    Width = 23
    Height = 33
    Hint = #1057#1074#1077#1088#1085#1091#1090#1100
    ButtonLayout = pbsImageLeft
    ButtonStyle = pbsNoFrame
    OnClick = ButtonHideClick
    OnMouseEnter = ImageBGMouseEnter
    OnMouseExit = ImageBGMouseLeave
  end
  object ButtonHelp: TPNGButton
    Left = 66
    Top = 0
    Width = 24
    Height = 33
    Hint = #1055#1086#1084#1086#1095#1100
    ButtonLayout = pbsImageLeft
    ButtonStyle = pbsNoFrame
    OnClick = ButtonHelpClick
    OnMouseEnter = ImageBGMouseEnter
    OnMouseExit = ImageBGMouseLeave
  end
  object ButtonClose: TPNGButton
    Left = 296
    Top = 0
    Width = 23
    Height = 33
    Hint = #1047#1072#1082#1088#1099#1090#1100
    ButtonLayout = pbsImageLeft
    ButtonStyle = pbsNoFrame
    OnClick = ButtonCloseClick
    OnMouseEnter = ImageBGMouseEnter
    OnMouseExit = ImageBGMouseLeave
  end
  object ButtonAbout: TPNGButton
    Left = 234
    Top = 0
    Width = 23
    Height = 33
    Hint = #1057#1087#1088#1072#1074#1082#1072
    ButtonLayout = pbsImageLeft
    ButtonStyle = pbsNoFrame
    OnClick = ButtonAboutClick
    OnMouseEnter = ImageBGMouseEnter
    OnMouseExit = ImageBGMouseLeave
  end
  object DrawGridMain: TDrawGrid
    Left = 36
    Top = 36
    Width = 249
    Height = 249
    Cursor = crHandPoint
    Align = alCustom
    BorderStyle = bsNone
    ColCount = 3
    DefaultColWidth = 82
    DefaultRowHeight = 82
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 3
    FixedRows = 0
    Options = [goVertLine, goHorzLine]
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = DrawGridMainDrawCell
    OnMouseDown = DrawGridMainMouseDown
    OnMouseWheelDown = DrawGridMainMouseWheelDown
    OnMouseWheelUp = DrawGridMainMouseWheelUp
  end
  object XPManifest: TXPManifest
    Left = 128
    Top = 80
  end
  object TimerAutoGame: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerAutoGameTimer
    Left = 144
    Top = 144
  end
  object TimerStep: TTimer
    Enabled = False
    OnTimer = TimerStepTimer
    Left = 64
    Top = 144
  end
  object NMMsg: TNMMsg
    Port = 6712
    TimeOut = 3000
    ReportLevel = 0
    Left = 192
    Top = 56
  end
  object NMMSGServer: TNMMSGServ
    Port = 6712
    TimeOut = 3000
    ReportLevel = 0
    OnMSG = NMMSGServerMSG
    Left = 256
    Top = 56
  end
end
