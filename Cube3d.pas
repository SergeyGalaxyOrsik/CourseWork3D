unit Cube3d;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, JPEG,
  modelSpin, modelFileModule;

type
  TOrderFile = file of string[100];
  TStrign = string;
  TPoint3D = array [0 .. 2] of Double;
  TFace = array of TPoint3D;

  TForm2 = class(TForm)
    Button1: TButton;
    OpenModel: TOpenDialog;
    SaveModel: TSaveDialog;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
    Drawing: Boolean;
    PrevX, PrevY: Integer;
    FStartPoint, FEndPoint: TPoint;
    FDrawingLine: Boolean;
    bm: TBitmap;
    bm2: TBitmap;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
  System.SysUtils;
{$R *.dfm}

var
  Vershina: TPoint3DArray;
  Normalies: TPoint3DArray;
  Faces: PFace;

  EndFaces: PFace;

procedure TForm2.FormCreate(Sender: TObject);
begin
  bm := TBitmap.Create;
  bm2 := TBitmap.Create;
  FDrawingLine := false;
  OpenModel.Filter := 'Model files (*.dat)|*.dat|Base OBJ model (*.obj)|*.obj|';
  SaveModel.Filter := 'Model files (*.dat)|*.dat|';
end;

procedure TForm2.Button1Click(Sender: TObject);

var
  ObjFile: TextFile;
  Line: string;
  SL: TStringList;
begin
  if OpenModel.Execute then
    if FileExists(OpenModel.FileName) then
    begin
      if OpenModel.FilterIndex = 1 then
      begin
        Application.CreateForm(TFormSpineModel, FormSpineModel);
        FormSpineModel.FilePath := OpenModel.FileName;
        FormSpineModel.Show;
        FormSpineModel.FilePath := OpenModel.FileName;
      end
      else if OpenModel.FilterIndex = 2 then
      begin
        AssignFile(ObjFile, OpenModel.FileName);
        Reset(ObjFile);
        try
          while not Eof(ObjFile) do
          begin
            ReadLn(ObjFile, Line);
            ParseLine(Line, Label1, Vershina, Normalies, Faces, EndFaces);
            Application.ProcessMessages;
          end;

        finally
          CloseFile(ObjFile);
          if SaveModel.Execute then
            if FileExists(SaveModel.FileName) then
              { If it exists, raise an exception. }
              raise Exception.Create('File already exists. Cannot overwrite.')
            else
            begin
              try
                SavePFaceToFile(Faces, SaveModel.FileName + '.dat');
              finally
                Application.CreateForm(TFormSpineModel, FormSpineModel);
                FormSpineModel.FilePath := SaveModel.FileName + '.dat';
                FormSpineModel.Show;
                FormSpineModel.FilePath := SaveModel.FileName + '.dat';
              end;
            end;
        end;
      end;
    end;
end;
end.
