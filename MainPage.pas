unit MainPage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, JPEG,
  modelSpin, modelFileModule, Vcl.Grids;

type
  TOrderFile = file of string[100];
  TStrign = string;
  TPoint3D = array [0 .. 2] of Double;
  TFace = array of TPoint3D;

  TForm2 = class(TForm)
    Button1: TButton;
    OpenModel: TOpenDialog;
    SaveModel: TSaveDialog;
    ClothesList: TListBox;
    ButtonOpenModel: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonOpenModelClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);

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
  System.SysUtils, dlc;
{$R *.dfm}

var
  Vershina: TPoint3DArray;
  VTalia: TVershinaDynamic;
  VBedra: TVershinaDynamic;
  VShoulder: TVershinaDynamic;
  VShoul_krai: TVershinaDynamic;
  VershinaS: TVershinaDynamic;
  VershinaR: TVershinaDynamic;
  Normalies: TPoint3DArray;
  Faces: PFace;

  EndFaces: PFace;

procedure TForm2.Button2Click(Sender: TObject);
var
  TxtFile: TextFile;
  Line: string;
  SL: TStringList;
begin
  if OpenDialog1.Execute then
    if FileExists(OpenDialog1.FileName) then
    begin
      if OpenDialog1.FilterIndex = 1 then
      begin
        AssignFile(TxtFile, OpenDialog1.FileName);
        Reset(TxtFile);
        try
          while not Eof(TxtFile) do
          begin
            ReadLn(TxtFile, Line);
            ParseTXTLine(Line, VershinaS);
            Application.ProcessMessages;
          end;

        finally
          CloseFile(TxtFile);
          if SaveDialog1.Execute then
            if FileExists(SaveDialog1.FileName) then
              { If it exists, raise an exception. }
              raise Exception.Create('File already exists. Cannot overwrite.')
            else
            begin

              SaveTXTToFile(VershinaS, SaveDialog1.FileName + '.dlcl');

            end;

        end;
      end
      else
      begin
        LoadDLCLFromFile(OpenDialog1.FileName, VershinaR);

      end;
    end;
end;

procedure TForm2.ButtonOpenModelClick(Sender: TObject);
var
  FilePath, itemName, shoulderPath, taliaPath, bedraPath,
    shoul_kraiPath: string;
begin
  for var i := 0 to (ClothesList.Items.Count - 1) do
  begin
    if ClothesList.Selected[i] then
    begin
      itemName := ClothesList.Items.Strings[i];
      FilePath := ExtractFilePath(ParamStr(0)) + '\models\' + itemName + '\' +
        itemName + '.dat';
      // DLCL Files paths
      shoulderPath := ExtractFilePath(ParamStr(0)) + '\models\' + itemName +
        '\shoulder.dlcl';
      taliaPath := ExtractFilePath(ParamStr(0)) + '\models\' + itemName +
        '\talia.dlcl';
      bedraPath := ExtractFilePath(ParamStr(0)) + '\models\' + itemName +
        '\bedra.dlcl';
      shoul_kraiPath := ExtractFilePath(ParamStr(0)) + '\models\' + itemName +
        '\shoulder-krai.dlcl';

      if FileExists(FilePath) then
      begin

        Application.CreateForm(TFormSpineModel, FormSpineModel);
        FormSpineModel.FilePath := FilePath;

        if FileExists(shoulderPath) then
          LoadDLCLFromFile(shoulderPath, FormSpineModel.VShoulder);
        if FileExists(taliaPath) then
          LoadDLCLFromFile(taliaPath, FormSpineModel.VTalia);
        if FileExists(bedraPath) then
          LoadDLCLFromFile(bedraPath, FormSpineModel.VBedra);
        if FileExists(shoul_kraiPath) then
          LoadDLCLFromFile(shoul_kraiPath, FormSpineModel.VShoul_krai);

        FormSpineModel.Show;
        FormSpineModel.FilePath := FilePath;
      end;
    end;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  bm := TBitmap.Create;
  bm2 := TBitmap.Create;
  FDrawingLine := false;
  OpenModel.Filter := 'Model files (*.dat)|*.dat|Base OBJ model (*.obj)|*.obj|';
  OpenDialog1.Filter := 'Text file (*.txt)|*.txt|DLCL File (*.dlcl)|*.dlcl|';
  SaveModel.Filter := 'Model files (*.dat)|*.dat|';
  SaveDialog1.Filter := 'Model files (*.dlcl)|*.dlcl|';
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
            ParseLine(Line, Vershina, Normalies, Faces, EndFaces);
            Application.ProcessMessages;
          end;

        finally
          CloseFile(ObjFile);
          if SaveModel.Execute then
            if FileExists(SaveModel.FileName) then
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
