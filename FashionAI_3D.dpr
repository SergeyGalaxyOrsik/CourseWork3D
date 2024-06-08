program FashionAI_3D;

uses
  Vcl.Forms,
  MainPage in 'MainPage.pas' {Form2},
  modelSpin in 'modelSpin.pas' {FormSpineModel},
  modelFileModule in 'modelFileModule.pas',
  dlc in 'dlc.pas',
  ScaleModule in 'ScaleModule.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
