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

uses Cube3d, modelFileModule, Math;
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

    for var i := 0 to High(temp.data.Normal) do
      for var f := 0 to High(factor) do
        temp^.data.Normal[i][f] := temp^.data.Normal[i][f] * factor[f] / 100;
    temp := temp.next;
  end;
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

      temp^.data.Coordinates[i][0] := X * cosX - z * sinX;
      temp^.data.Coordinates[i][2] := z * cosX + X * sinX;

      z := temp^.data.Coordinates[i][2];

      temp^.data.Coordinates[i][1] := Y * cosY - z * sinY;
      temp^.data.Coordinates[i][2] := z * cosY + Y * sinY;
    end;
    temp := temp^.next;

  end;
end;

function DrawCuboid(var faces: PFace; X, Y, w, h: Integer): TBitmap;
var
  offset, offset2: TPoint;
  fangle: Integer;
  temp: PFace;
  a: Integer;
  vec: TDouble3;
  b: double;

begin
  Result := TBitmap.Create;
  Result.SetSize(w, h);
  RotateCuboid(faces, PI / 180, 0);
  offset := TPoint.Create(X, Y * 2);

  with Result.canvas do
  begin
    temp := faces;
    Brush.Color := clWhite;
    Brush.Style := bsSolid;
    Pen.Color := DrawColor;
    a := 0;

    FillRect(ClipRect);
    while temp <> nil do
    begin
      for var i := 0 to 2 do
      begin
        var
        p1 := (temp^.data.Coordinates[temp^.data.nodes[i][0]]);
        var
        p2 := (temp^.data.Coordinates[temp^.data.nodes[i + 1][0]]);
        vec[0] := p1[0];
        vec[1] := p1[1];
        vec[2] := sqrt(p1[0] * p1[0] - p1[1] * p1[1]);
        moveTo(Trunc(p1[0]) + offset.X, Trunc(p1[1]) + offset.Y);
        lineTo(Trunc(p2[0]) + offset.X, Trunc(p2[1]) + offset.Y);
      end;
      temp := temp^.next;
    end;
  end;
end;

procedure TFormSpineModel.Button1Click(Sender: TObject);
begin
  Label1.Caption := 'STOPPED';
  tmr1.Enabled := not tmr1.Enabled;
end;

procedure TFormSpineModel.ColorBox1Change(Sender: TObject);
begin
  DrawColor:=ColorBox1.Selected;
end;

procedure TFormSpineModel.FormActivate(Sender: TObject);
begin
  DoubleBuffered := true;

  LoadPFaceFromFile(FilePath);
  Scale([bufFactorX, bufFactorY, bufFactorZ]);
  RotateCuboid(faces, ArcTan(sqrt(2)), PI);
  Label2.Caption := '�������: ' + IntToStr(bufFactorAll);
  LabelX.Caption := '������� X: ' + IntToStr(bufFactorX);
  LabelY.Caption := '������� Y: ' + IntToStr(bufFactorY);
  LabelZ.Caption := '������� Z: ' + IntToStr(bufFactorZ);
end;

procedure TFormSpineModel.FormCreate(Sender: TObject);
begin

  ClientHeight := FormSpineModel.Height;
  ClientWidth := FormSpineModel.Width;

end;

procedure TFormSpineModel.tmr1Timer(Sender: TObject);
var
  buffer: TBitmap;
begin
  buffer := DrawCuboid(faces, (ClientWidth - GroupBox2.Width) div 2,
    ClientHeight div 2, ClientWidth, ClientHeight);
  canvas.Draw(FormSpineModel.GroupBox2.Width, 0, buffer);
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
