object FormSpineModel: TFormSpineModel
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsSingle
  Caption = 'FormSpineModel'
  ClientHeight = 1080
  ClientWidth = 1920
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  Position = poDesktopCenter
  PrintScale = poPrintToFit
  OnActivate = FormActivate
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 1136
    Top = 524
    Width = 69
    Height = 32
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 111
    Width = 377
    Height = 970
    Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
    TabOrder = 1
    object LabelX: TLabel
      Left = 80
      Top = 40
      Width = 58
      Height = 34
      Caption = #1052#1072#1089#1096#1090#1072#1073': '
    end
    object LabelY: TLabel
      Left = 80
      Top = 128
      Width = 58
      Height = 34
      Caption = #1052#1072#1089#1096#1090#1072#1073': '
    end
    object LabelZ: TLabel
      Left = 80
      Top = 216
      Width = 58
      Height = 34
      Caption = #1052#1072#1089#1096#1090#1072#1073': '
    end
    object UpDownX: TUpDown
      Left = 23
      Top = 23
      Width = 34
      Height = 51
      Min = -100
      Max = 5000
      Increment = 10
      ParentShowHint = False
      Position = 10
      ShowHint = True
      TabOrder = 0
      OnClick = UpDownXClick
    end
    object Button1: TButton
      Left = 280
      Top = 23
      Width = 81
      Height = 41
      Caption = #1055#1072#1091#1079#1072
      TabOrder = 1
      OnClick = Button1Click
    end
    object UpDownY: TUpDown
      Left = 23
      Top = 111
      Width = 34
      Height = 51
      Min = -100
      Max = 5000
      Increment = 10
      ParentShowHint = False
      Position = 10
      ShowHint = True
      TabOrder = 2
      OnClick = UpDownYClick
    end
    object UpDownZ: TUpDown
      Left = 23
      Top = 199
      Width = 34
      Height = 51
      Min = -100
      Max = 5000
      Increment = 10
      ParentShowHint = False
      Position = 10
      ShowHint = True
      TabOrder = 3
      OnClick = UpDownZClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 377
    Height = 105
    Caption = #1052#1072#1089#1096#1090#1072#1073#1080#1088#1086#1074#1072#1085#1080#1077
    TabOrder = 0
    object Label2: TLabel
      Left = 104
      Top = 48
      Width = 257
      Height = 32
      Caption = #1052#1072#1089#1096#1090#1072#1073': '
    end
    object UpDown1: TUpDown
      Left = 23
      Top = 29
      Width = 34
      Height = 51
      Min = 10
      Max = 5000
      Increment = 10
      Position = 10
      TabOrder = 0
      OnClick = UpDown1Click
    end
  end
  object ColorBox1: TColorBox
    Left = 23
    Top = 392
    Width = 145
    Height = 22
    TabOrder = 2
    OnChange = ColorBox1Change
  end
  object tmr1: TTimer
    Interval = 13
    OnTimer = tmr1Timer
    Left = 1288
    Top = 24
  end
end
