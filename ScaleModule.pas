unit ScaleModule;

interface

uses modelFileModule;

procedure ScaleOne(var faces: PFace; factor: double; const caseVal: Char;
  var VTalia, VShoulder, VBedra, VShoul_krai: TVershinaDynamic);

procedure DeScale(var faces: PFace; factor: TArray<double>;
  var VTalia, VShoulder, VBedra, VShoul_krai: TVershinaDynamic);
procedure Scale(var faces: PFace; factor: TArray<double>;
  var VTalia, VShoulder, VBedra, VShoul_krai: TVershinaDynamic);
procedure DeScaleOne(var faces: PFace; factor: double; const caseVal: Char;
  var VTalia, VShoulder, VBedra, VShoul_krai: TVershinaDynamic);

implementation

procedure Scale(var faces: PFace; factor: TArray<double>;
  var VTalia, VShoulder, VBedra, VShoul_krai: TVershinaDynamic);
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
    temp := temp.next;
  end;

  for var i := 0 to High(VTalia) do
    for var f := 0 to High(factor) do
      VTalia[i][f] := VTalia[i][f] * factor[f];

  for var i := 0 to High(VShoulder) do
    for var f := 0 to High(factor) do
      VShoulder[i][f] := VShoulder[i][f] * factor[f];

  for var i := 0 to High(VBedra) do
    for var f := 0 to High(factor) do
      VBedra[i][f] := VBedra[i][f] * factor[f];

  for var i := 0 to High(VShoul_krai) do
    for var f := 0 to High(factor) do
      VShoul_krai[i][f] := VShoul_krai[i][f] * factor[f];
end;

procedure DeScale(var faces: PFace; factor: TArray<double>;
  var VTalia, VShoulder, VBedra, VShoul_krai: TVershinaDynamic);
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

  for var i := 0 to High(VTalia) do
    for var f := 0 to High(factor) do
      VTalia[i][f] := VTalia[i][f] / factor[f];

  for var i := 0 to High(VShoulder) do
    for var f := 0 to High(factor) do
      VShoulder[i][f] := VShoulder[i][f] / factor[f];

  for var i := 0 to High(VBedra) do
    for var f := 0 to High(factor) do
      VBedra[i][f] := VBedra[i][f] / factor[f];

  for var i := 0 to High(VShoul_krai) do
    for var f := 0 to High(factor) do
      VShoul_krai[i][f] := VShoul_krai[i][f] / factor[f];
end;

procedure DeScaleOne(var faces: PFace; factor: double; const caseVal: Char;
  var VTalia, VShoulder, VBedra, VShoul_krai: TVershinaDynamic);
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
        for var i := 0 to High(VTalia) do
          VTalia[i][0] := VTalia[i][0] - factor;
        for var i := 0 to High(VShoulder) do
          VShoulder[i][0] := VShoulder[i][0] - factor;
        for var i := 0 to High(VBedra) do
          VBedra[i][0] := VBedra[i][0] - factor;
        for var i := 0 to High(VShoul_krai) do
          VShoul_krai[i][0] := VShoul_krai[i][0] - factor;
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
        for var i := 0 to High(VTalia) do
          VTalia[i][1] := VTalia[i][1] - factor;
        for var i := 0 to High(VShoulder) do
          VShoulder[i][1] := VShoulder[i][1] - factor;
        for var i := 0 to High(VBedra) do
          VBedra[i][1] := VBedra[i][1] - factor;
        for var i := 0 to High(VShoul_krai) do
          VShoul_krai[i][1] := VShoul_krai[i][1] - factor;
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
        for var i := 0 to High(VTalia) do
          VTalia[i][2] := VTalia[i][2] - factor;
        for var i := 0 to High(VShoulder) do
          VShoulder[i][2] := VShoulder[i][2] - factor;
        for var i := 0 to High(VBedra) do
          VBedra[i][2] := VBedra[i][2] - factor;
        for var i := 0 to High(VShoul_krai) do
          VShoul_krai[i][2] := VShoul_krai[i][2] - factor;
      end;
  end;

end;

procedure ScaleOne(var faces: PFace; factor: double; const caseVal: Char;
  var VTalia, VShoulder, VBedra, VShoul_krai: TVershinaDynamic);
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
          begin
            temp^.data.Coordinates[i][0] := temp^.data.Coordinates[i]
              [0] + factor;
          end;
          temp := temp.next;
        end;
        for var i := 0 to High(VTalia) do
          VTalia[i][0] := VTalia[i][0] + factor;
        for var i := 0 to High(VShoulder) do
          VShoulder[i][0] := VShoulder[i][0] + factor;
        for var i := 0 to High(VBedra) do
          VBedra[i][0] := VBedra[i][0] + factor;
        for var i := 0 to High(VShoul_krai) do
          VShoul_krai[i][0] := VShoul_krai[i][0] + factor;
      end;
    'y':
      begin
        while temp <> nil do
        begin
          for var i := 0 to High(temp.data.Coordinates) do
          begin
            temp^.data.Coordinates[i][1] := temp^.data.Coordinates[i]
              [1] - factor;
          end;
          temp := temp.next;
        end;
        for var i := 0 to High(VTalia) do
          VTalia[i][1] := VTalia[i][1] + factor;
        for var i := 0 to High(VShoulder) do
          VShoulder[i][1] := VShoulder[i][1] + factor;
        for var i := 0 to High(VBedra) do
          VBedra[i][1] := VBedra[i][1] + factor;
        for var i := 0 to High(VShoul_krai) do
          VShoul_krai[i][1] := VShoul_krai[i][1] + factor;
      end;
    'z':
      begin
        while temp <> nil do
        begin
          for var i := 0 to High(temp.data.Coordinates) do
          begin
            temp^.data.Coordinates[i][2] := temp^.data.Coordinates[i]
              [2] + factor;
          end;
          temp := temp.next;
        end;
        for var i := 0 to High(VTalia) do
          VTalia[i][2] := VTalia[i][2] + factor;
        for var i := 0 to High(VShoulder) do
          VShoulder[i][2] := VShoulder[i][2] + factor;
        for var i := 0 to High(VBedra) do
          VBedra[i][2] := VBedra[i][2] + factor;
        for var i := 0 to High(VShoul_krai) do
          VShoul_krai[i][2] := VShoul_krai[i][2] + factor;
      end;
  end;
end;

end.
