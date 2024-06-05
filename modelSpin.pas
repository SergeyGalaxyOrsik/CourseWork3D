unit modelSpin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, modelFileModule;

type
  TFormSpineModel = class(TForm)
    tmr1: TTimer;
    UpDown1: TUpDown;
    Button1: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    UpDownX: TUpDown;
    Label2: TLabel;
    LabelX: TLabel;
    UpDownY: TUpDown;
    LabelY: TLabel;
    UpDownZ: TUpDown;
    LabelZ: TLabel;
    ColorBox1: TColorBox;
    ClotheSize: TComboBox;
    LabelSize: TLabel;
    LabelColor: TLabel;
    ClotheModel: TComboBox;
    LabelModel: TLabel;
    ComboGender: TComboBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure Button1Click(Sender: TObject);

    procedure UpDownXClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownZClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownYClick(Sender: TObject; Button: TUDBtnType);
    procedure ColorBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClotheSizeChange(Sender: TObject);
    procedure ComboGenderChange(Sender: TObject);
    procedure ClotheModelChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    // Faces:PFace;
    FilePath: String;
    VTalia: TVershinaDynamic;
    VBedra: TVershinaDynamic;
    VShoulder: TVershinaDynamic;
    VShoul_krai: TVershinaDynamic;

    SizeCoof: Double;

    coofTalia: Double;
    coofBedra: Double;
    coofShoulder: Double;
    coofShoul_krai: Double;

    gender: Integer;

  end;

var
  FormSpineModel: TFormSpineModel;

implementation

uses MainPage, Math, System.Generics.Collections, dlc, TypInfo, ScaleModule;
{$R *.dfm}

type
  TDouble3 = array [0 .. 2] of Double;
  TChar10 = array [0 .. 9] of Char;

  // Global Variebles
var
  faces: PFace;
  endfaces: PFace;
  facesCount: Integer = 0;
  light: TDouble3 = (30, 30, -50);
  bufFactorX: Integer = 10;
  bufFactorY: Integer = 10;
  bufFactorZ: Integer = 10;
  bufFactorAll: Integer = 10;

  // Cooficiente var
  taliaCoof: Double;
  bedraCoof: Double;
  shoulderCoof: Double;
  shoul_kraiCoof: Double;

procedure AppendModelFromFile(Item: TFaceData);
var
  NewNode: PFace;
  LastID: Integer;
begin

  New(NewNode);
  NewNode^.data := Item;
  NewNode^.next := nil;

  if endfaces = nil then
  begin
    faces := NewNode;
    endfaces := faces;
  end
  else
  begin
    endfaces^.next := NewNode;
    endfaces := NewNode;
  end;

  inc(facesCount);

end;

procedure LoadPFaceFromFile(const fileName: string);
var
  fileStream: TFileStream;
  modelFile: file of TFaceData;
  temp: TFaceData;
begin
  if FileExists(fileName) then
  begin
    assign(modelFile, fileName);
    reset(modelFile);
    Read(modelFile, temp);
    while not EOF(modelFile) do
    begin
      Read(modelFile, temp);
      AppendModelFromFile(temp);
    end;
    close(modelFile);
  end
end;

procedure RotateCuboid(var faces: PFace; angleX, angleY: Double);
var
  temp: PFace;
  // X, Y, z, Xn, Yn, zn: double;
begin
  var
  sinX := sin(angleX);
  var
  cosX := cos(angleX);
  var
  sinY := sin(angleY);
  var
  cosY := cos(angleY);
  temp := faces;
  while temp <> nil do
  begin
    for var i := 0 to High(temp^.data.Coordinates) do
    begin
      var
      X := temp^.data.Coordinates[i][0];
      var
      Y := temp^.data.Coordinates[i][1];
      var
      z := temp^.data.Coordinates[i][2];

      var
      Xn := temp^.data.Normal[i][0];
      var
      Yn := temp^.data.Normal[i][1];
      var
      zn := temp^.data.Normal[i][2];

      // change coordinates
      temp^.data.Coordinates[i][0] := X * cosX - z * sinX;
      temp^.data.Coordinates[i][2] := z * cosX + X * sinX;

      // change x
      z := temp^.data.Coordinates[i][2];
      zn := temp^.data.Normal[i][2];

      // change coordinates
      temp^.data.Coordinates[i][1] := Y * cosY - z * sinY;
      temp^.data.Coordinates[i][2] := z * cosY + Y * sinY;
    end;
    temp := temp^.next;

  end;

  for var i := 0 to High(FormSpineModel.VTalia) do
  begin
    var
    X := FormSpineModel.VTalia[i][0];
    var
    Y := FormSpineModel.VTalia[i][1];
    var
    z := FormSpineModel.VTalia[i][2];

    // change coordinates
    FormSpineModel.VTalia[i][0] := X * cosX - z * sinX;
    FormSpineModel.VTalia[i][2] := z * cosX + X * sinX;

    // change x
    z := FormSpineModel.VTalia[i][2];

    // change coordinates
    FormSpineModel.VTalia[i][1] := Y * cosY - z * sinY;
    FormSpineModel.VTalia[i][2] := z * cosY + Y * sinY;
  end;

  for var i := 0 to High(FormSpineModel.VBedra) do
  begin
    var
    X := FormSpineModel.VBedra[i][0];
    var
    Y := FormSpineModel.VBedra[i][1];
    var
    z := FormSpineModel.VBedra[i][2];

    // change coordinates
    FormSpineModel.VBedra[i][0] := X * cosX - z * sinX;
    FormSpineModel.VBedra[i][2] := z * cosX + X * sinX;

    // change x
    z := FormSpineModel.VBedra[i][2];

    // change coordinates
    FormSpineModel.VBedra[i][1] := Y * cosY - z * sinY;
    FormSpineModel.VBedra[i][2] := z * cosY + Y * sinY;
  end;

  for var i := 0 to High(FormSpineModel.VShoulder) do
  begin
    var
    X := FormSpineModel.VShoulder[i][0];
    var
    Y := FormSpineModel.VShoulder[i][1];
    var
    z := FormSpineModel.VShoulder[i][2];

    // change coordinates
    FormSpineModel.VShoulder[i][0] := X * cosX - z * sinX;
    FormSpineModel.VShoulder[i][2] := z * cosX + X * sinX;

    // change x
    z := FormSpineModel.VShoulder[i][2];

    // change coordinates
    FormSpineModel.VShoulder[i][1] := Y * cosY - z * sinY;
    FormSpineModel.VShoulder[i][2] := z * cosY + Y * sinY;
  end;

  for var i := 0 to High(FormSpineModel.VShoul_krai) do
  begin
    var
    X := FormSpineModel.VShoul_krai[i][0];
    var
    Y := FormSpineModel.VShoul_krai[i][1];
    var
    z := FormSpineModel.VShoul_krai[i][2];

    // change coordinates
    FormSpineModel.VShoul_krai[i][0] := X * cosX - z * sinX;
    FormSpineModel.VShoul_krai[i][2] := z * cosX + X * sinX;

    // change x
    z := FormSpineModel.VShoul_krai[i][2];

    // change coordinates
    FormSpineModel.VShoul_krai[i][1] := Y * cosY - z * sinY;
    FormSpineModel.VShoul_krai[i][2] := z * cosY + Y * sinY;
  end;
end;

type
  TDoubleArray3 = array [0 .. 2] of Double;

  TPointOwn = record
    X, Y, z: Single;
  end;

  TTriangle = array [0 .. 3] of TPointOwn;

function CompareTriangles(const Left, Right: TTriangle): Boolean;
var
  z1, z2: Single;
begin
  z1 := (Left[0].z + Left[1].z + Left[2].z) / 3.0;
  z2 := (Right[0].z + Right[1].z + Right[2].z) / 3.0;

  Result := z1 > z2;
end;

procedure QuickSort(var arr: array of TTriangle; var arrN: array of Double;
  Left, Right: Integer);
var
  i, J: Integer;
  Pivot, temp: TTriangle;
  tempN: Double;
begin
  i := Left;
  J := Right;
  Pivot := arr[(Left + Right) div 2];
  repeat
    while CompareTriangles(arr[i], Pivot) do
      i := i + 1;
    while CompareTriangles(Pivot, arr[J]) do
      J := J - 1;
    if i <= J then
    begin
      temp := arr[i];
      arr[i] := arr[J];
      arr[J] := temp;
      tempN := arrN[i];
      arrN[i] := arrN[J];
      arrN[J] := tempN;
      i := i + 1;
      J := J - 1;
    end;
  until i > J;
  if Left < J then
    QuickSort(arr, arrN, Left, J);
  if i < Right then
    QuickSort(arr, arrN, i, Right);
end;

function Clamp(Value, Min, Max: Single): Single;
begin
  if Value < Min then
    Result := Min
  else if Value > Max then
    Result := Max
  else
    Result := Value;
end;

var
  lightIntensity: Double;
  R: Byte = 128;
  G: Byte = 128;
  B: Byte = 128;

function DrawCuboid(var faces: PFace; X, Y, w, h: Integer): TBitmap;
var
  offset: TPoint;
  temp: PFace;
  line1, line2, Normal, toCamera: TDoubleArray3;
  vecTrianglesToRaster: array of TTriangle;
  l: Double;
  dotProduct: array of Double;
  points: TTriangle;

  // ��������� ������
  cameraPos: TPoint3D;
  cameraDir: TPoint3D;
  hFOV, vFOV, nearPlane, farPlane: Double;
  // ��������� ���������
  lightDirection: TDoubleArray3;
  ambientIntensity, diffuseIntensity: Double;

begin
  Result := TBitmap.Create;
  Result.SetSize(w, h);
  RotateCuboid(faces, PI / 180, 0);
  offset := TPoint.Create(X, Y * 2);

  // �������������� ��������� ������
  cameraPos[0] := 0;
  cameraPos[1] := 0;
  cameraPos[2] := -100;
  // ������ ����������� ����� ������� �� ���������� 100 ������

  cameraDir[0] := 0;
  cameraDir[1] := 0;
  cameraDir[2] := 1; // ������ ������� ����� ��� Z

  hFOV := 90;
  vFOV := 90;
  nearPlane := 1;
  farPlane := 2000;

  lightDirection[0] := 0;
  lightDirection[1] := -1;
  lightDirection[2] := -1;
  ambientIntensity := 0.3;
  diffuseIntensity := 0.6;

  with Result.Canvas do
  begin
    Brush.Color := clWhite;
    Pen.Color := Transparent;

    FillRect(ClipRect);
    temp := faces;
    while temp <> nil do
    begin
      line1[0] := temp^.data.Coordinates[temp^.data.nodes[1][0]][0] -
        temp^.data.Coordinates[temp^.data.nodes[0][0]][0];
      line1[1] := temp^.data.Coordinates[temp^.data.nodes[1][0]][1] -
        temp^.data.Coordinates[temp^.data.nodes[0][0]][1];
      line1[2] := temp^.data.Coordinates[temp^.data.nodes[1][0]][2] -
        temp^.data.Coordinates[temp^.data.nodes[0][0]][2];

      line2[0] := temp^.data.Coordinates[temp^.data.nodes[2][0]][0] -
        temp^.data.Coordinates[temp^.data.nodes[0][0]][0];
      line2[1] := temp^.data.Coordinates[temp^.data.nodes[2][0]][1] -
        temp^.data.Coordinates[temp^.data.nodes[0][0]][1];
      line2[2] := temp^.data.Coordinates[temp^.data.nodes[2][0]][2] -
        temp^.data.Coordinates[temp^.data.nodes[0][0]][2];

      Normal[0] := line1[1] * line2[2] - line1[2] * line2[1];
      Normal[1] := line1[2] * line2[0] - line1[0] * line2[2];
      Normal[2] := line1[0] * line2[1] - line1[1] * line2[0];

      l := Sqrt(Normal[0] * Normal[0] + Normal[1] * Normal[1] + Normal[2] *
        Normal[2]);

      Normal[0] := Normal[0] / l;
      Normal[1] := Normal[1] / l;
      Normal[2] := Normal[2] / l;

      toCamera[0] := temp^.data.Coordinates[temp^.data.nodes[0][0]][0] -
        cameraPos[0];
      toCamera[1] := temp^.data.Coordinates[temp^.data.nodes[0][0]][1] -
        cameraPos[1];
      toCamera[2] := temp^.data.Coordinates[temp^.data.nodes[0][0]][2] -
        cameraPos[2];

      // ��������� ��������� ������ ����� �������
      if (Normal[2] < 0) then
      begin
        SetLength(dotProduct, Length(dotProduct) + 1);
        dotProduct[Length(dotProduct) - 1] := Normal[0] * lightDirection[0] +
          Normal[1] * lightDirection[1] + Normal[2] * lightDirection[2];

        for var i := 0 to 3 do
        begin
          try
            if temp^.data.Coordinates[temp^.data.nodes[i][0]][0] < 10000000000000
            then
            begin
              points[i].X := Round(temp^.data.Coordinates[temp^.data.nodes[i][0]
                ][0]) + offset.X;
              points[i].Y := Round(temp^.data.Coordinates[temp^.data.nodes[i][0]
                ][1]) + offset.Y;
              points[i].z :=
                Round(temp^.data.Coordinates[temp^.data.nodes[i][0]][2]);
            end
            else
            begin
              points[i].X := -10000000000000;
              points[i].Y := -10000000000000;
              points[i].z := -10000000000000;
            end;
          except
            continue;
          end;
        end;

        // ��������� ��� ������������ ��� ������� ����������������
        SetLength(vecTrianglesToRaster, Length(vecTrianglesToRaster) + 1);
        vecTrianglesToRaster[High(vecTrianglesToRaster)][0] := points[0];
        vecTrianglesToRaster[High(vecTrianglesToRaster)][1] := points[1];
        vecTrianglesToRaster[High(vecTrianglesToRaster)][2] := points[2];
        vecTrianglesToRaster[High(vecTrianglesToRaster)][3] := points[3];
      end;

      temp := temp^.next;
    end;

    // ��������� ������������ �� ������� ������� (z-����������)
    QuickSort(vecTrianglesToRaster, dotProduct, 0, High(vecTrianglesToRaster));

    for var i := 0 to High(vecTrianglesToRaster) do
    begin
      var
        x1, x2, x3, x4: Integer;
      var
        y1, y2, y3, y4: Integer;

      x1 := -1;
      x2 := -1;
      x3 := -1;
      x4 := -1;
      y1 := -1;
      y2 := -1;
      y3 := -1;
      y4 := -1;

      x1 := Round(vecTrianglesToRaster[i][0].X);
      x2 := Round(vecTrianglesToRaster[i][1].X);
      x3 := Round(vecTrianglesToRaster[i][2].X);

      y1 := Round(vecTrianglesToRaster[i][0].Y);
      y2 := Round(vecTrianglesToRaster[i][1].Y);
      y3 := Round(vecTrianglesToRaster[i][2].Y);

      // �������� �� �������������� ����������
      if (vecTrianglesToRaster[i][3].X > 0) and
        (vecTrianglesToRaster[i][3].X < 1920) then
      begin
        x4 := Round(vecTrianglesToRaster[i][3].X);
        y4 := Round(vecTrianglesToRaster[i][3].Y);
      end;

      lightIntensity := Clamp(ambientIntensity + diffuseIntensity *
        Max(dotProduct[i], 0), 0, 1);

      Pen.Color := RGB(Round(R * lightIntensity), Round(G * lightIntensity),
        Round(B * lightIntensity));

      Brush.Color := RGB(Round(R * lightIntensity), Round(G * lightIntensity),
        Round(B * lightIntensity));

      if (x4 = -1) and (y4 = -1) then
        Polygon([Point(x1, y1), Point(x2, y2), Point(x3, y3)])
      else
        Polygon([Point(x1, y1), Point(x2, y2), Point(x3, y3), Point(x4, y4)]);
    end;
    // SetLength(dotProduct, 0);
  end;
end;

procedure TFormSpineModel.Button1Click(Sender: TObject);
begin
  tmr1.Enabled := not tmr1.Enabled;

end;

procedure TFormSpineModel.ClotheModelChange(Sender: TObject);
var
  coof: TModelCof;
begin
  tmr1.Enabled := false;
  coof := Model2Coof(TModels(ClotheModel.ItemIndex));
  ChangeModel(faces, coofTalia, coofBedra, coofShoulder, coofShoul_krai,
    coof.Talia, coof.Bedra, coof.Shoulder, coof.Shoul_krai);
  coofTalia:=coof.Talia;
  coofBedra:=coof.Bedra;
  coofShoulder:=coof.Shoulder;
  coofShoul_krai:=coof.Shoul_krai;
  tmr1.Enabled := true;
end;

procedure TFormSpineModel.ClotheSizeChange(Sender: TObject);
var
  Sizes: TSizes;
  coof: Double;
begin
  if gender = 0 then
  begin
    tmr1.Enabled := false;
    coof := Size2CoofMan(TSizes(ClotheSize.ItemIndex));

    ChangeSize(faces, coof, SizeCoof);
    SizeCoof := coof;

    tmr1.Enabled := true;
  end
  else if gender = 1 then
  begin
    tmr1.Enabled := false;
    coof := Size2CoofFemale(TSizes(ClotheSize.ItemIndex));

    ChangeSize(faces, coof, SizeCoof);
    SizeCoof := coof;

    tmr1.Enabled := true;
  end;
end;

procedure TFormSpineModel.ColorBox1Change(Sender: TObject);
begin
  tmr1.Enabled := false;
  R := GetRValue(ColorBox1.Selected);
  G := GetGValue(ColorBox1.Selected);
  B := GetBValue(ColorBox1.Selected);
  tmr1.Enabled := true;
end;

procedure TFormSpineModel.ComboGenderChange(Sender: TObject);
var
  coof: Double;
begin
  gender := ComboGender.ItemIndex;
  if ClotheSize.ItemIndex <> -1 then
  begin
    if gender = 0 then
    begin
      tmr1.Enabled := false;
      coof := Size2CoofMan(TSizes(ClotheSize.ItemIndex));

      ChangeSize(faces, coof, SizeCoof);
      SizeCoof := coof;

      tmr1.Enabled := true;
    end
    else if gender = 1 then
    begin
      tmr1.Enabled := false;
      coof := Size2CoofFemale(TSizes(ClotheSize.ItemIndex));

      ChangeSize(faces, coof, SizeCoof);
      SizeCoof := coof;

      tmr1.Enabled := true;
    end;
  end;

end;

procedure TFormSpineModel.FormActivate(Sender: TObject);
begin
  DoubleBuffered := true;

  LoadPFaceFromFile(FilePath);
  Scale(faces, [bufFactorX, bufFactorY, bufFactorZ], VTalia, VShoulder, VBedra,
    VShoul_krai);
  RotateCuboid(faces, ArcTan(Sqrt(2)), PI);
  Label2.Caption := '�������: ' + IntToStr(bufFactorAll);
  LabelX.Caption := '������� X: ' + IntToStr(bufFactorX);
  LabelY.Caption := '������� Y: ' + IntToStr(bufFactorY);
  LabelZ.Caption := '������� Z: ' + IntToStr(bufFactorZ);
end;

procedure TFormSpineModel.FormClose(Sender: TObject; var Action: TCloseAction);
var
  temp, temp2, endfacesTemp, endfacesTemp2: PFace;
begin
  // ��������������� ��������� �� ���������
  tmr1.Enabled := false;
  temp2 := faces;
  while temp2 <> nil do
  begin
    temp := temp2;
    temp2 := temp2^.next;
    Dispose(temp);
  end;

  FilePath := '';
  SetLength(VTalia, 0);
  SetLength(VBedra, 0);
  SetLength(VShoulder, 0);
  SetLength(VShoul_krai, 0);

  facesCount := 0;
  light[0] := 30;
  light[1] := 30;
  light[2] := -50;
  bufFactorX := 10;
  bufFactorY := 10;
  bufFactorZ := 10;
  bufFactorAll := 10;
  SizeCoof := 1;
  coofTalia := 1;
  coofBedra := 1;
  coofShoulder := 1;
  coofShoul_krai := 1;
  gender := 0;

end;

procedure TFormSpineModel.FormCreate(Sender: TObject);
var
  Sizes: TSizes;
  Models: TModels;
begin
  // ������������� ������� ��� ���� ���������
  ClientHeight := FormSpineModel.Height;
  ClientWidth := FormSpineModel.Width;

  // �������� ������
  endfaces := nil;
  faces := nil;

  // ������������� ����������� ��������
  SizeCoof := 1;
  coofTalia := 1;
  coofBedra := 1;
  coofShoulder := 1;
  coofShoul_krai := 1;
  gender := 0;

  for Sizes := Low(TSizes) to High(TSizes) do
    ClotheSize.Items.Add(GetEnumName(TypeInfo(TSizes), Ord(Sizes)));
  for Models := Low(TModels) to High(TModels) do
    ClotheModel.Items.Add(GetEnumName(TypeInfo(TModels), Ord(Models)));
end;

procedure TFormSpineModel.tmr1Timer(Sender: TObject);
var
  buffer: TBitmap;
begin
  buffer := DrawCuboid(faces, (ClientWidth - GroupBox2.Width) div 2,
    ClientHeight div 2, ClientWidth, ClientHeight);
  Canvas.Draw(FormSpineModel.GroupBox2.Width, 0, buffer);
  buffer.Free;
end;

procedure TFormSpineModel.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  DeScale(faces, [bufFactorAll, bufFactorAll, bufFactorAll], VTalia, VShoulder,
    VBedra, VShoul_krai);
  Scale(faces, [UpDown1.Position, UpDown1.Position, UpDown1.Position], VTalia,
    VShoulder, VBedra, VShoul_krai);
  bufFactorAll := UpDown1.Position;
  Label2.Caption := '�������: ' + IntToStr(UpDown1.Position);
end;

procedure TFormSpineModel.UpDownXClick(Sender: TObject; Button: TUDBtnType);
begin
  DeScaleOne(faces, bufFactorX, 'x', VTalia, VShoulder, VBedra, VShoul_krai);
  ScaleOne(faces, UpDownX.Position, 'x', VTalia, VShoulder, VBedra,
    VShoul_krai);
  bufFactorX := UpDownX.Position;
  LabelX.Caption := '�������� X: ' + IntToStr(UpDownX.Position);
end;

procedure TFormSpineModel.UpDownZClick(Sender: TObject; Button: TUDBtnType);
begin
  DeScaleOne(faces, bufFactorZ, 'z', VTalia, VShoulder, VBedra, VShoul_krai);
  ScaleOne(faces, UpDownZ.Position, 'z', VTalia, VShoulder, VBedra,
    VShoul_krai);
  bufFactorZ := UpDownZ.Position;
  LabelZ.Caption := '�������� Z: ' + IntToStr(UpDownZ.Position);
end;

procedure TFormSpineModel.UpDownYClick(Sender: TObject; Button: TUDBtnType);
begin
  DeScaleOne(faces, bufFactorY, 'y', VTalia, VShoulder, VBedra, VShoul_krai);
  ScaleOne(faces, UpDownY.Position, 'y', VTalia, VShoulder, VBedra,
    VShoul_krai);
  bufFactorY := UpDownY.Position;
  LabelY.Caption := '�������� Y: ' + IntToStr(UpDownY.Position);
end;

end.
