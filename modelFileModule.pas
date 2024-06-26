unit modelFileModule;

interface

uses
  SysUtils, Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls;

type
  PPoint3D = ^TPoint3D;
  TPoint3D = array [0 .. 3] of Double;
  TPoint3DArray = array [0 .. 1000000] of TPoint3D;
  TPoint3DFace = array [0 .. 3] of TPoint3D;
  TFacePoint = array [0 .. 3] of array [0 .. 3] of Integer;
  TVershinaDynamic = array of TPoint3D;

  PFaceData = ^TFaceData;

  TFaceData = record
    Nodes: TFacePoint;
    Coordinates: TPoint3DFace;
    Normal: TPoint3DFace;
  end;

  PFace = ^TFace;

  TFace = record
    Data: TFaceData;
    Next: PFace;
  end;

  PNode = ^TNode;

  TNode = record
    Data: TPoint3D;
    Next: PNode;
  end;

procedure ParseLine(const Line: string; var Vershina, Normalies: TPoint3DArray;
  var Faces, EndFaces: PFace);
procedure SavePFaceToFile(var face: PFace; const fileName: string);
procedure LoadDLCLFromFile(const fileName: string;
  var VershinaR: TVershinaDynamic);
procedure ParseTXTLine(const Line: string; var Vershina: TVershinaDynamic);
procedure SaveTXTToFile(var arrayDLCL: TVershinaDynamic;
  const fileName: string);

implementation

uses StrUtils;

procedure NewFaceFunc(var Faces, EndFaces: PFace; Data: TFaceData);
var
  NewNode: PFace;
begin
  New(NewNode);
  NewNode^.Data := Data;
  NewNode^.Next := nil;
  if Faces = nil then
  begin
    Faces := NewNode;
    EndFaces := Faces;
  end
  else
  begin
    EndFaces^.Next := NewNode;
    EndFaces := NewNode;
  end;
end;

var
  vershinaLength: Integer = 0;
  vershinaLengthDynm: Integer = 0;
  normalLength: Integer = 0;

procedure ParseLine(const Line: string; var Vershina, Normalies: TPoint3DArray;
  var Faces, EndFaces: PFace);
var
  Parts: TStringList;
  i, count: Integer;
  NewFace: PFace;
  FaceData: PFaceData;
begin
  Parts := TStringList.Create;
  try
    Parts.Delimiter := ' ';
    Parts.DelimitedText := Line;
    if Parts.count > 1 then
    begin
      if Parts[0] = 'v' then
      begin
        for i := 1 to 3 do
          Vershina[vershinaLength][i - 1] := StrToFloatDef(Parts[i], 0.0);
        inc(vershinaLength);
      end
      else if Parts[0] = 'vn' then
      begin
        for i := 1 to 3 do
          Normalies[normalLength][i - 1] := StrToFloatDef(Parts[i], 0.0);
        inc(normalLength);
      end
      else if Parts[0] = 'f' then
      begin
        New(FaceData);
        for i := 1 to Parts.count - 1 do
        begin
          try
            if ContainsText(Parts[i], '/') then
            begin
              FaceData^.Nodes[i - 1][0] :=
                StrToIntDef(Copy(Parts[i], 1, Pos('/', Parts[i]) - 1), 0);
              FaceData^.Nodes[i - 1][1] :=
                StrToIntDef(Copy(Parts[i], Pos('/', Parts[i]) + 1,
                Length(Parts[i])), 0);
            end
            else
            begin
              FaceData^.Nodes[i - 1][0] := StrToIntDef(Parts[i], 0);
            end;
          except
            raise Exception.Create('�������� ��� ��������������� �����.')
          end;

        end;
        for i := 0 to 3 do
        begin
          try
            if (FaceData.Nodes[i][0] - 1 > High(Vershina)) or
              (FaceData.Nodes[i][0] = 0) then
            begin
              FaceData.Coordinates[i][0] := 10000000000000;
              FaceData.Coordinates[i][1] := 10000000000000;
              FaceData.Coordinates[i][2] := 10000000000000;
              FaceData.Coordinates[i][3] := 10000000000000;
            end
            else
              FaceData.Coordinates[i] := Vershina[FaceData.Nodes[i][0] - 1];
          except
            continue;
          end;
        end;
        for i := 0 to 3 do
          FaceData.Nodes[i][0] := i;

        NewFaceFunc(Faces, EndFaces, FaceData^);

      end;
    end;
  finally
    Parts.Free;
  end;
end;

procedure ParseTXTLine(const Line: string; var Vershina: TVershinaDynamic);
var
  Parts: TStringList;
  i, count: Integer;
  NewFace: PFace;
  FaceData: PFaceData;
begin
  Parts := TStringList.Create;
  try
    Parts.Delimiter := ' ';
    Parts.DelimitedText := Line;
    // LabelOutput.Caption := Line;
    if Parts.count > 1 then
    begin
      if Parts[0] = 'v' then
      begin
        SetLength(Vershina, Length(Vershina)+1);
        for i := 1 to 3 do
        begin
          Vershina[High(Vershina)][i - 1] := StrToFloatDef(Parts[i], 0.0);
        end;
        inc(vershinaLengthDynm);
      end
    end;
  finally
    Parts.Free;
  end;
end;


// Save to file

procedure SavePFaceToFile(var face: PFace; const fileName: string);
var
  fileStream: TFileStream;
  modelFile: file of TFaceData;
  txtFile: File;
  temp, prev: PFace;

begin
  assign(modelFile, fileName);

  rewrite(modelFile);
  temp := face;
  while temp <> nil do
  begin
    write(modelFile, temp.Data);
    prev := temp;
    temp := temp^.Next;
    dispose(prev);
  end;
  close(modelFile);

  vershinaLength:= 0;
  vershinaLengthDynm:= 0;
  normalLength:= 0;

end;

procedure SaveTXTToFile(var arrayDLCL: TVershinaDynamic;
  const fileName: string);
var
  fileStream: TFileStream;
  modelFile: file of TPoint3D;
  txtFile: File;
  temp, prev: PFace;

begin
  assign(modelFile, fileName);

  rewrite(modelFile);
  for var i := 0 to Length(arrayDLCL) - 1 do
    write(modelFile, arrayDLCL[i]);

  close(modelFile);

end;

procedure LoadDLCLFromFile(const fileName: string;
  var VershinaR: TVershinaDynamic);
var
  fileStream: TFileStream;
  modelFile: file of TPoint3D;

begin
  if FileExists(fileName) then
  begin
    assign(modelFile, fileName);
    reset(modelFile);
    SetLength(VershinaR, FileSize(modelFile));
    for var i := 0 to FileSize(modelFile) - 1 do
    begin
      Read(modelFile, VershinaR[i]);
    end;

    // �������� �����
    CloseFile(modelFile);
  end
end;

end.
