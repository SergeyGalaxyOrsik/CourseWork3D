unit modelFileModule;

interface

uses
  SysUtils, Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls;

type
  PPoint3D = ^TPoint3D;
  TPoint3D = array [0 .. 2] of Double;
  TPoint3DArray = array [0 .. 100000] of TPoint3D;
  TPoint3DFace = array [0 .. 3] of TPoint3D;
  TFacePoint = array [0 .. 3] of array [0 .. 2] of Integer;

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

procedure ParseLine(const Line: string; LabelOutput: TLabel;
  var Vershina, Normalies: TPoint3DArray; var Faces, EndFaces: PFace);
procedure SavePFaceToFile(var face: PFace; const fileName: string);
// procedure LoadPFaceFromFile(var faces, endfaces:pface;const fileName: string);

implementation

uses StrUtils;
// Global variables

// EndVershina: PNode;
// EndNomalies: PNode;


// Procedure to create a new node
// function NewNodeFunc(Data: TPoint3D);
// var
// NewNode: PNode;
// begin
//
// New(NewNode);
// NewNode^.Data := Data;
// NewNode^.Next := nil;
// Result := NewNode;
// end;

procedure NewFaceFunc(var Faces, EndFaces: PFace; Data: TFaceData);
var
  NewNode: PFace;
begin
  New(NewNode);
  NewNode^.Data := Data;
  // NewNode^.Normal := Normal;
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

// procedure AddNode(var Head, Tail: PNode; Data: TPoint3D);
// var
// NewNode: PNode;
// begin
// NewNode:=NewNodeFunc(Data);
// if Head = nil then
// begin
// Head := NewNode;
// Tail := NewNode;
// end
// else
// begin
// Tail^.Next := NewNode;
// Tail := NewNode;
// end;
// end;

var
  vershinaLength: Integer = 0;
  normalLength: Integer = 0;

procedure ParseLine(const Line: string; LabelOutput: TLabel;
  var Vershina, Normalies: TPoint3DArray; var Faces, EndFaces: PFace);
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
//    LabelOutput.Caption := Line;
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
            if ContainsText(Parts[i], '//') then
            begin
              count := Parts.count - 1;
              FaceData.Nodes[i - 1][0] :=
                StrToIntDef(Copy(Parts[i], 1, Pos('//', Parts[i]) - 1), 0);

              FaceData.Nodes[i - 1][1] :=
                StrToIntDef(Copy(Parts[i], Pos('//', Parts[i]) + 2,
                Length(Parts[i])), 0);
            end
            else if ContainsText(Parts[i], '/') then
            begin
              count := Parts.count - 1;
              LabelOutput.Caption:= Copy(Parts[i], 1, Pos('/', Parts[i]) - 1);
              FaceData.Nodes[i - 1][0] :=
                StrToIntDef(Copy(Parts[i], 1, Pos('/', Parts[i]) - 1), 0);

//               FaceData.Nodes[i - 1][1] :=
//               StrToIntDef(Copy(Parts[i], Pos('/', Parts[i]) + 1,
//               Length(Parts[i])), 0);
            end;

          except
            count := -2;
          end;

        end;
        for i := 0 to 2 do
        begin
          FaceData.Coordinates[i] := Vershina[FaceData.Nodes[i][0] - 1];
//          FaceData.Normal[i] := Normalies[FaceData.Nodes[i][1] - 1];
        end;
        for i := 0 to 2 do
          FaceData.Nodes[i][0] := i;
        FaceData.Nodes[3][0] := 0;

        NewFaceFunc(Faces, EndFaces, FaceData^);
        // Add new face to the linked list

      end;
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

end;

end.