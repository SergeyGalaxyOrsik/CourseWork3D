unit modelSpin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls;

type
  TFormSpineModel = class(TForm)
    tmr1: TTimer;
    Label1: TLabel;
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

  private
    { Private declarations }
  public
    { Public declarations }
    // Faces:PFace;
    FilePath: String;

  end;

var
  FormSpineModel: TFormSpineModel;
  nodes: TArray < TArray < double >> = [[-1, -1, -0.5], [-1, -1, 0.5],
    [-1, 1, -1], [-1, 1, 1], [1, -1, -1], [1, -1, 1], [1, 1, -1], [1, 1, 1],
    [0, 0, 0]];
  // nodes: TArray<TArray<double>> = [[-1.3143, 15.0686,-1.6458], [-1.4575, 15.1137 ,-1.5916], [-1.3688, 15.2156, -1.6669],[-1.2726, 15.1795, -1.6948],[-1.3174, 15.2749, -1.7054],[-1.2444, 15.2717, -1.7287],[-1.4216, 15.2928, -1.6688],[-1.3357, 15.3383, -1.7143],[-1.4552, 15.3808, -1.6810]];
  edges: TArray < TArray < Integer >> = [[0, 1], [1, 2], [2, 0], [2, 3], [3, 4],
    [4, 2], [4, 5], [5, 6], [6, 4]];
  // nodes:TFace = Vershina;
  radius: double = 1;
  radius2: double = 1;
  angle: Integer = 10;
  circleNode: array of array of double;
  circleEdges: array of array of Integer;
  circleNodeY: array of array of double;
  circleEdgesY: array of array of Integer;
  circlePoint: Integer;
  // procedure LoadPFaceFromFile(const fileName: string);

implementation

uses Cube3d, modelFileModule, Math, System.Generics.Collections;
{$R *.dfm}

type
  TDouble3 = array [0 .. 2] of double;
  TChar10 = array [0 .. 9] of Char;

var
  faces: PFace;
  endfaces: PFace;
  facesCount: Integer = 0;
  light: TDouble3 = (30, 30, -50);
  bufFactorX: Integer = 10;
  bufFactorY: Integer = 10;
  bufFactorZ: Integer = 10;
  bufFactorAll: Integer = 10;
  viewPoint: TDouble3 = (0, 0, 0);

  DrawColor: TColor = clBlack;

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
    // listOrder.data.id := OrderData.id;
    while not EOF(modelFile) do
    begin
      Read(modelFile, temp);
      AppendModelFromFile(temp);
    end;
    close(modelFile);
  end
end;

procedure Scale(factor: TArray<double>);
var
  temp: PFace;
begin
  temp := faces;
  while temp <> nil do
  begin
    for var i := 0 to High(temp.data.Coordinates) do
      for var f := 0 to High(factor) do
        temp^.data.Coordinates[i][f] := temp^.data.Coordinates[i][f] *
          factor[f];

    // for var i := 0 to High(temp.data.Normal) do
    // for var f := 0 to High(factor) do
    // temp^.data.Normal[i][f] := temp^.data.Normal[i][f] * factor[f];
    temp := temp.next;
  end;
  viewPoint[0] := viewPoint[0] + factor[0];
  viewPoint[1] := viewPoint[1] + factor[1];
  viewPoint[2] := viewPoint[2] + factor[2];
end;

procedure DeScale(factor: TArray<double>);
var
  temp: PFace;
begin
  temp := faces;
  while temp <> nil do
  begin
    for var i := 0 to High(temp.data.Coordinates) do
      for var f := 0 to High(factor) do
        temp^.data.Coordinates[i][f] := temp^.data.Coordinates[i][f] /
          factor[f];
    temp := temp.next;
  end;
end;

procedure DeScaleOne(factor: double; const caseVal: Char);
var
  temp: PFace;
begin
  temp := faces;

  case caseVal of
    'x':
      begin
        while temp <> nil do
        begin
          for var i := 0 to High(temp.data.Coordinates) do
            temp^.data.Coordinates[i][0] := temp^.data.Coordinates[i]
              [0] - factor;
          temp := temp.next;
        end;
      end;
    'y':
      begin
        while temp <> nil do
        begin
          for var i := 0 to High(temp.data.Coordinates) do
            temp^.data.Coordinates[i][1] := temp^.data.Coordinates[i]
              [1] + factor;
          temp := temp.next;
        end;
      end;
    'z':
      begin
        while temp <> nil do
        begin
          for var i := 0 to High(temp.data.Coordinates) do
            temp^.data.Coordinates[i][2] := temp^.data.Coordinates[i]
              [2] - factor;
          temp := temp.next;
        end;
      end;
  end;

end;

procedure ScaleOne(factor: double; const caseVal: Char);
var
  temp: PFace;
begin

  temp := faces;

  case caseVal of
    'x':
      begin
        while temp <> nil do
        begin
          for var i := 0 to High(temp.data.Coordinates) do
            temp^.data.Coordinates[i][0] := temp^.data.Coordinates[i]
              [0] + factor;
          temp := temp.next;
        end;
      end;
    'y':
      begin
        while temp <> nil do
        begin
          for var i := 0 to High(temp.data.Coordinates) do
            temp^.data.Coordinates[i][1] := temp^.data.Coordinates[i]
              [1] - factor;
          temp := temp.next;
        end;
      end;
    'z':
      begin
        while temp <> nil do
        begin
          for var i := 0 to High(temp.data.Coordinates) do
            temp^.data.Coordinates[i][2] := temp^.data.Coordinates[i]
              [2] + factor;
          temp := temp.next;
        end;
      end;
  end;
end;

procedure RotateCuboid(var faces: PFace; angleX, angleY: double);
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
      // change normal
      temp^.data.Normal[i][0] := Xn * cosX - zn * sinX;
      temp^.data.Normal[i][2] := zn * cosX + Xn * sinX;

      // change x
      z := temp^.data.Coordinates[i][2];
      zn := temp^.data.Normal[i][2];

      // change coordinates
      temp^.data.Coordinates[i][1] := Y * cosY - z * sinY;
      temp^.data.Coordinates[i][2] := z * cosY + Y * sinY;
      // change normal
      temp^.data.Normal[i][1] := Yn * cosY - zn * sinY;
      temp^.data.Normal[i][2] := zn * cosY + Yn * sinY;
      // X := temp^.data.Coordinates[i][0];
      // Y := temp^.data.Coordinates[i][1];
      // z := temp^.data.Coordinates[i][2];
      // Xn := temp^.data.Normal[i][0];
      // Yn := temp^.data.Normal[i][1];
      // zn := temp^.data.Normal[i][2];
      //
      // // change coordinates
      // temp^.data.Coordinates[i][0] := X * cosX - z * sinX;
      // temp^.data.Coordinates[i][1] := Y * cosY - (z * cosX + X * sinX) * sinY;
      // temp^.data.Coordinates[i][2] := (z * cosX + X * sinX) * cosY + Y * sinY;
      //
      // // change normal
      // temp^.data.Normal[i][0] := Xn * cosX - zn * sinX;
      // temp^.data.Normal[i][1] := Yn * cosY - (zn * cosX + Xn * sinX) * sinY;
      // temp^.data.Normal[i][2] := (zn * cosX + Xn * sinX) * cosY + Yn * sinY;
    end;
    temp := temp^.next;

  end;
end;

// function DrawCuboid(var faces: PFace; X, Y, w, h: Integer): TBitmap;
// var
// offset, offset2: TPoint;
// fangle: Integer;
// temp: PFace;
// a: Integer;
// vec: TDouble3;
// b: double;
// Normal: array [0 .. 2] of double;
// l: double;
// line1: array [0 .. 2] of double;
// line2: array [0 .. 2] of double;
// dotProduct: double;
//
// begin
// Result := TBitmap.Create;
// Result.SetSize(w, h);
// RotateCuboid(faces, PI / 180, 0);
// offset := TPoint.Create(X, Y * 2);
//
// with Result.canvas do
// begin
// temp := faces;
// Brush.Color := clWhite;
// Brush.Style := bsSolid;
// Pen.Color := DrawColor;
// a := 0;
//
// FillRect(ClipRect);
// while temp <> nil do
// begin
//
// line1[0] := temp^.data.Coordinates[temp^.data.nodes[1][0]][0] -
// temp^.data.Coordinates[temp^.data.nodes[0][0]][0];
// line1[1] := temp^.data.Coordinates[temp^.data.nodes[1][0]][1] -
// temp^.data.Coordinates[temp^.data.nodes[0][0]][1];
// line1[2] := temp^.data.Coordinates[temp^.data.nodes[1][0]][2] -
// temp^.data.Coordinates[temp^.data.nodes[0][0]][2];
//
// line2[0] := temp^.data.Coordinates[temp^.data.nodes[2][0]][0] -
// temp^.data.Coordinates[temp^.data.nodes[0][0]][0];
// line2[1] := temp^.data.Coordinates[temp^.data.nodes[2][0]][1] -
// temp^.data.Coordinates[temp^.data.nodes[0][0]][1];
// line2[2] := temp^.data.Coordinates[temp^.data.nodes[2][0]][2] -
// temp^.data.Coordinates[temp^.data.nodes[0][0]][2];
//
// Normal[0] := line1[1] * line2[2] - line1[2] * line2[1];
// Normal[1] := line1[2] * line2[0] - line1[0] * line2[2];
// Normal[2] := line1[0] * line2[1] - line1[1] * line2[0];
//
// l := sqrt(Normal[0] * Normal[0] + Normal[1] * Normal[1] + Normal[2] *
// Normal[2]);
//
// Normal[0] := Normal[0] / l;
// Normal[1] := Normal[1] / l;
// Normal[2] := Normal[2] / l;
//
// dotProduct := Normal[0] * (temp^.data.Coordinates[temp^.data.nodes[0][0]]
// [0] ) + Normal[1] * (temp^.data.Coordinates[temp^.data.nodes[0][0]]
// [1] ) + Normal[2] *
// (temp^.data.Coordinates[temp^.data.nodes[0][0]][2] );
//
// if Normal[2] < 0 then
// begin
// for var i := 0 to 2 do
// begin
//
// var
// p1 := (temp^.data.Coordinates[temp^.data.nodes[i][0]]);
// var
// p2 := (temp^.data.Coordinates[temp^.data.nodes[i + 1][0]]);
// moveTo(Trunc(p1[0]) + offset.X, Trunc(p1[1]) + offset.Y);
// lineTo(Trunc(p2[0]) + offset.X, Trunc(p2[1]) + offset.Y);
// end;
// end;
//
// temp := temp^.next;
//
// end;
// end;
// end;

type
  TDoubleArray3 = array [0 .. 2] of double;

  TPointOwn = record
    X, Y, z: Single;
  end;

  TTriangle = array [0 .. 3] of TPointOwn;

  // function IsInViewFrustum(const p, cameraPos, cameraDir: TPoint3D; hFOV, vFOV, nearPlane, farPlane: Double): Boolean;
  // var
  // toPoint: TDoubleArray3;
  // distance: Double;
  // begin
  // // ��������� ������ �� ������ �� �����
  // toPoint[0] := p[0] - cameraPos[0];
  // toPoint[1] := p[1] - cameraPos[1];
  // toPoint[2] := p[2] - cameraPos[2];
  //
  // // ��������� ���������� �� �����
  // distance := sqrt(toPoint[0] * toPoint[0] + toPoint[1] * toPoint[1] + toPoint[2] * toPoint[2]);
  //
  // // ���������, ��������� �� ����� � �������� ��������� ������
  // Result := (distance >= nearPlane) and (distance <= farPlane);
  // end;

function CompareTriangles(const Left, Right: TTriangle): Boolean;
var
  z1, z2: Single;
begin
  z1 := (Left[0].z + Left[1].z + Left[2].z) / 3.0;
  z2 := (Right[0].z + Right[1].z + Right[2].z) / 3.0;

  Result := z1 > z2; // Reversed the comparison to sort in descending order
end;

procedure QuickSort(var arr: array of TTriangle; var arrN: array of Double; Left, Right: Integer);
var
  i, J: Integer;
  Pivot, temp: TTriangle;
  tempN:Double;
begin
  i := Left;
  J := Right;
  Pivot := arr[(Left + Right) div 2];
  repeat
    while CompareTriangles(arr[i], Pivot) do
      // Reversed the comparison to sort in descending order
      i := i + 1;
    while CompareTriangles(Pivot, arr[J]) do
      // Reversed the comparison to sort in descending order
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

function IsInViewFrustum(const p, cameraPos, cameraDir: TPoint3D;
  hFOV, vFOV, nearPlane, farPlane: double): Boolean;
var
  toPoint: TDoubleArray3;
  distance: double;
begin
  // ��������� ������ �� ������ �� �����
  toPoint[0] := p[0] - cameraPos[0];
  toPoint[1] := p[1] - cameraPos[1];
  toPoint[2] := p[2] - cameraPos[2];

  // ��������� ���������� �� �����
  distance := Sqrt(toPoint[0] * toPoint[0] + toPoint[1] * toPoint[1] +
    toPoint[2] * toPoint[2]);

  // ���������, ��������� �� ����� � �������� ��������� ������
  Result := (distance >= nearPlane) and (distance <= farPlane);
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

function DrawCuboid(var faces: PFace; X, Y, w, h: Integer): TBitmap;
var
  offset: TPoint;
  temp: PFace;
  line1, line2, Normal, toCamera: TDoubleArray3;
  vecTrianglesToRaster: array of TTriangle;
  l: double;
  dotProduct: array of Double;
  points: TTriangle;

  // ��������� ������
  cameraPos: TPoint3D;
  cameraDir: TPoint3D;
  hFOV, vFOV, nearPlane, farPlane: double;
  // ��������� ���������
  lightDirection: TDoubleArray3;
  ambientIntensity, diffuseIntensity: double;

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
//    Brush.Style := bsSolid;
    Pen.Color := Transparent; // ��� ����� ������ ���� ��� ��������� ������

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

      // dotProduct := Normal[0] * toCamera[0] + Normal[1] * toCamera[1] + Normal[2] * toCamera[2];

      // ��������� ��������� ������ ����� �������
      if (Normal[2] < 0) then
      begin
        SetLength(dotProduct, Length(dotProduct)+1);
        dotProduct[Length(dotProduct)-1] := Normal[0] * lightDirection[0] + Normal[1] * lightDirection
          [1] + Normal[2] * lightDirection[2];

        for var i := 0 to 3 do
        begin
        try
          points[i].X := Round(temp^.data.Coordinates[temp^.data.nodes[i][0]][0]
            ) + offset.X;
          points[i].Y := Round(temp^.data.Coordinates[temp^.data.nodes[i][0]][1]
            ) + offset.Y;
          points[i].z :=
            Round(temp^.data.Coordinates[temp^.data.nodes[i][0]][2]);
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

      x1 := Round(vecTrianglesToRaster[i][0].X);
      x2 := Round(vecTrianglesToRaster[i][1].X);
      x3 := Round(vecTrianglesToRaster[i][2].X);
      x4 := Round(vecTrianglesToRaster[i][3].X);

      y1 := Round(vecTrianglesToRaster[i][0].Y);
      y2 := Round(vecTrianglesToRaster[i][1].Y);
      y3 := Round(vecTrianglesToRaster[i][2].Y);
      y4 := Round(vecTrianglesToRaster[i][3].Y);

//      line1[0] := (vecTrianglesToRaster[i][1].X - offset.X) -
//        (vecTrianglesToRaster[i][0].X - offset.X);
//      line1[1] := (vecTrianglesToRaster[i][1].Y - offset.Y) -
//        (vecTrianglesToRaster[i][0].Y - offset.Y);
//      line1[2] := (vecTrianglesToRaster[i][1].z) -
//        (vecTrianglesToRaster[i][0].z);
//
//      line2[0] := (vecTrianglesToRaster[i][2].X - offset.X) -
//        (vecTrianglesToRaster[i][0].X - offset.X);
//      line2[1] := (vecTrianglesToRaster[i][2].Y - offset.Y) -
//        (vecTrianglesToRaster[i][0].Y - offset.Y);
//      line2[2] := (vecTrianglesToRaster[i][2].z) -
//        (vecTrianglesToRaster[i][0].z);
//
//      Normal[0] := line1[1] * line2[2] - line1[2] * line2[1];
//      Normal[1] := line1[2] * line2[0] - line1[0] * line2[2];
//      Normal[2] := line1[0] * line2[1] - line1[1] * line2[0];
//
//      l := Sqrt(Normal[0] * Normal[0] + Normal[1] * Normal[1] + Normal[2] *
//        Normal[2]);
//
//      Normal[0] := Normal[0] / l;
//      Normal[1] := Normal[1] / l;
//      Normal[2] := Normal[2] / l;
//
//      dotProduct := Normal[0] * lightDirection[0] + Normal[1] * lightDirection
//        [1] + Normal[2] * lightDirection[2];
      var
      lightIntensity := Clamp(ambientIntensity + diffuseIntensity *
        Max(dotProduct[i], 0), 0, 1);

      // ��������� ���� ����� � ����������� �� ������������� ���������
      // Brush.Color := DrawColor;
      Pen.Color :=RGB(Round(100 * lightIntensity),
        Round(255 * lightIntensity), Round(255 * lightIntensity));
      Brush.Color := RGB(Round(100 * lightIntensity),
        Round(255 * lightIntensity), Round(255 * lightIntensity));
      Polygon([Point(x1, y1), Point(x2, y2), Point(x3, y3), Point(x4, y4)]);
    end;
//    SetLength(dotProduct, 0);
  end;
end;

procedure TFormSpineModel.Button1Click(Sender: TObject);
begin
  Label1.Caption := 'STOPPED';
  tmr1.Enabled := not tmr1.Enabled;
end;

procedure TFormSpineModel.ColorBox1Change(Sender: TObject);
begin
  DrawColor := ColorBox1.Selected;
end;

procedure TFormSpineModel.FormActivate(Sender: TObject);
begin
  DoubleBuffered := True;

  LoadPFaceFromFile(FilePath);
  Scale([bufFactorX, bufFactorY, bufFactorZ]);
  RotateCuboid(faces, ArcTan(Sqrt(2)), PI);
  Label2.Caption := '�������: ' + IntToStr(bufFactorAll);
  LabelX.Caption := '������� X: ' + IntToStr(bufFactorX);
  LabelY.Caption := '������� Y: ' + IntToStr(bufFactorY);
  LabelZ.Caption := '������� Z: ' + IntToStr(bufFactorZ);
end;

procedure TFormSpineModel.FormClose(Sender: TObject; var Action: TCloseAction);
var temp, temp2, endfacesTemp, endfacesTemp2: PFace;
begin
  tmr1.Enabled :=false;
  temp2:=faces;
  while temp2<>nil do
  begin
    temp:=temp2;
    temp2:=temp2^.Next;
    Dispose(temp);
  end;

//  endfacesTemp2:=endfaces;
//  while endfacesTemp2<>nil do
//  begin
//    endfacesTemp:=endfacesTemp2;
//    endfacesTemp2:=endfacesTemp2^.Next;
//    Dispose(endfacesTemp);
//  end;

end;

procedure TFormSpineModel.FormCreate(Sender: TObject);
begin

  ClientHeight := FormSpineModel.Height;
  ClientWidth := FormSpineModel.Width;
  endfaces:=nil;
  faces:=nil;

end;

procedure TFormSpineModel.tmr1Timer(Sender: TObject);
var
  buffer: TBitmap;
begin

  buffer := DrawCuboid(faces, (ClientWidth - GroupBox2.Width) div 2,
    ClientHeight div 2, ClientWidth, ClientHeight);
  Canvas.Draw(FormSpineModel.GroupBox2.Width, 0, buffer);
  // canvas.Polygon();
  // canvas.Free;
  buffer.Free;
end;

procedure TFormSpineModel.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  DeScale([bufFactorAll, bufFactorAll, bufFactorAll]);
  Scale([UpDown1.Position, UpDown1.Position, UpDown1.Position]);
  bufFactorAll := UpDown1.Position;
  // Label1.Caption := IntToStr(UpDown1.Position);
  Label2.Caption := '�������: ' + IntToStr(UpDown1.Position);
end;

procedure TFormSpineModel.UpDownXClick(Sender: TObject; Button: TUDBtnType);
begin
  DeScaleOne(bufFactorX, 'x');
  ScaleOne(UpDownX.Position, 'x');
  bufFactorX := UpDownX.Position;
  LabelX.Caption := '������� X: ' + IntToStr(UpDownX.Position);
end;

procedure TFormSpineModel.UpDownZClick(Sender: TObject; Button: TUDBtnType);
begin
  DeScaleOne(bufFactorZ, 'z');
  ScaleOne(UpDownZ.Position, 'z');
  bufFactorZ := UpDownZ.Position;
  LabelZ.Caption := '������� Z: ' + IntToStr(UpDownZ.Position);
end;

procedure TFormSpineModel.UpDownYClick(Sender: TObject; Button: TUDBtnType);
begin
  DeScaleOne(bufFactorY, 'y');
  ScaleOne(UpDownY.Position, 'y');
  bufFactorY := UpDownY.Position;
  LabelY.Caption := '������� Y: ' + IntToStr(UpDownY.Position);
end;

end.
