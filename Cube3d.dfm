object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 783
  ClientWidth = 1356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 936
    Top = 536
    Width = 34
    Height = 15
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = -8
    Top = 736
    Width = 331
    Height = 49
    Caption = #1054#1090#1082#1088#1099#1090#1100' 3D '#1084#1086#1076#1077#1083#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object OpenModel: TOpenDialog
    Left = 416
    Top = 208
  end
  object SaveModel: TSaveDialog
    Left = 1224
    Top = 448
  end
end
