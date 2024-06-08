unit dlc;

interface

uses modelFileModule, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls;

type
  TClothing = (
    // ������� ������
    TShirt,
    // Shirt,
    // TankTop,
    PoloShirt,
//    Sweatshirt,
    // Hoodie,
    Jacket,
    // Blazer,
    // Vest,
    // Cardigan,
    // Turtleneck,
    // Coat,
    // Parka,
    // Windbreaker,
    // PeaCoat,
    // Poncho,
    // Cape,
    // Tuxedo,
    // Suit,
    // Overall,

    // ������ ������
    // Jeans,
    Pants,
    // Joggers,
    // Shorts,
    Skirt
    // Leggings,
    // Capris,
    // Culottes,
    // Jumpsuit,
    // Tights,
    // CargoPants,
    // Chinos,
    // TrackPants,
    // Bermuda,
    // FlarePants,
    // Palazzo,
    // Gauchos,
    // Sarong,
    // Salwar,
    // HaremPants
    );

  TColor = (Red, Blue, Green, Yellow, Orange, Purple, Pink, Brown, Black, White,
    Gray, Cyan, Magenta, Turqun, Indigo, Teal, Goloise, Lavender,
    Marood, Silver);

  TSizes = (XXS, XS, S, M, L, XL, XXL);
  TModels = (Oversize, SlimFit, Regular, Athletic, Tall, Patite, PlusSize,
    Curvy, Hourglass, Pear);

  TModelCof = record
    Talia: double;
    Shoulder: double;
    Bedra: double;
    Shoul_krai: double;
  end;

  TEqual = record
    taliaIndex: Integer;
    bedraIndex: Integer;
    shoulderIndex: Integer;
    shoul_kraiIndex: Integer;
  end;

function ClothTostr(name: TClothing): string;
function Model2Coof(const model: TModels): TModelCof;
function Size2CoofMan(const size: TSizes): double;
function Size2CoofFemale(const size: TSizes): double;
procedure ChangeSize(var faces: PFace; const coof, prevCoof: double);
procedure ChangeModel(var faces: PFace; const previndexTalia, previndexBedra,
  previndexShoulder, previndexShoul_krai: double; const indexTalia, indexBedra,
  indexShoulder, indexShoul_krai: double);

implementation

function ClothTostr(name: TClothing): string;
begin
  case Name of
    TShirt:
      Result := 'T-Shirt';
//    Shirt:
//      Result := 'Shirt';
//    TankTop:
//      Result := 'Tank Top';
    PoloShirt:
      Result := 'Polo Shirt';
//    Sweatshirt:
//      Result := 'Sweatshirt';
//    Hoodie:
//      Result := 'Hoodie';
    Jacket:
      Result := 'Jacket';
//    Blazer:
//      Result := 'Blazer';
//    Vest:
//      Result := 'Vest';
//    Cardigan:
//      Result := 'Cardigan';
//    Turtleneck:
//      Result := 'Turtleneck';
//    Coat:
//      Result := 'Coat';
//    Parka:
//      Result := 'Parka';
//    Windbreaker:
//      Result := 'Windbreaker';
//    PeaCoat:
//      Result := 'Pea Coat';
//    Poncho:
//      Result := 'Poncho';
//    Cape:
//      Result := 'Cape';
//    Tuxedo:
//      Result := 'Tuxedo';
//    Suit:
//      Result := 'Suit';
//    Overall:
//      Result := 'Overall';
//    Jeans:
//      Result := 'Jeans';
    Pants:
      Result := 'Pants';
//    Joggers:
//      Result := 'Joggers';
//    Shorts:
//      Result := 'Shorts';
    Skirt:
      Result := 'Skirt';
//    Leggings:
//      Result := 'Leggings';
//    Capris:
//      Result := 'Capris';
//    Culottes:
//      Result := 'Culottes';
//    Jumpsuit:
//      Result := 'Jumpsuit';
//    Tights:
//      Result := 'Tights';
//    CargoPants:
//      Result := 'Cargo Pants';
//    Chinos:
//      Result := 'Chinos';
//    TrackPants:
//      Result := 'Track Pants';
//    Bermuda:
//      Result := 'Bermuda';
//    FlarePants:
//      Result := 'Flare Pants';
//    Palazzo:
//      Result := 'Palazzo';
//    Gauchos:
//      Result := 'Gauchos';
//    Sarong:
//      Result := 'Sarong';
//    Salwar:
//      Result := 'Salwar';
//    HaremPants:
//      Result := 'Harem Pants';

  end;
end;

function Model2Coof(const model: TModels): TModelCof;
begin

  case model of
    Oversize:
      begin
        Result.Talia := 1;
        Result.Shoulder := 1.2;
        Result.Bedra := 1.2;
        Result.Shoul_krai := 0.968;
      end;
    SlimFit:
      begin
        Result.Talia := 0.9;
        Result.Shoulder := 1;
        Result.Bedra := 0.9;
        Result.Shoul_krai := 1;
      end;
    Regular:
      begin
        Result.Talia := 1;
        Result.Shoulder := 1;
        Result.Bedra := 1;
        Result.Shoul_krai := 1;
      end;
    Athletic:
      begin
        Result.Talia := 0.9;
        Result.Shoulder := 0.9;
        Result.Bedra := 0.9;
        Result.Shoul_krai := 1;
      end;
    Tall:
      begin
        Result.Talia := 1.3;
        Result.Shoulder := 1.3;
        Result.Bedra := 1.3;
        Result.Shoul_krai := 1.3;
      end;
    Patite:
      begin
        Result.Talia := 0.7;
        Result.Shoulder := 0.7;
        Result.Bedra := 0.7;
        Result.Shoul_krai := 0.7;
      end;
    PlusSize:
      begin
        Result.Talia := 2.2;
        Result.Shoulder := 2.2;
        Result.Bedra := 2.2;
        Result.Shoul_krai := 2.2;
      end;
    Curvy:
      begin
        Result.Talia := 2;
        Result.Shoulder := 2;
        Result.Bedra := 2;
        Result.Shoul_krai := 2;
      end;
    Hourglass:
      begin
        Result.Talia := 1;
        Result.Shoulder := 1.15;
        Result.Bedra := 1.2;
        Result.Shoul_krai := 1;
      end;
    Pear:
      begin
        Result.Talia := 1.2;
        Result.Shoulder := 1;
        Result.Bedra := 1.2;
        Result.Shoul_krai := 1;
      end;
  end;

end;

function Size2CoofMan(const size: TSizes): double;
begin

  case size of
    XXS:
      Result := 1;
    XS:
      Result := 1.05;
    S:
      Result := 1.1;
    M:
      Result := 1.15;
    L:
      Result := 1.21;
    XL:
      Result := 1.26;
    XXL:
      Result := 1.315;
  end;

end;

function Size2CoofFemale(const size: TSizes): double;
begin

  case size of
    XXS:
      Result := 0.84;
    XS:
      Result := 0.89;
    S:
      Result := 0.94;
    M:
      Result := 1;
    L:
      Result := 1.05;
    XL:
      Result := 1.1;
    XXL:
      Result := 1.157;
  end;

end;

procedure ChangeSize(var faces: PFace; const coof, prevCoof: double);
var
  temp: PFace;
  indexTalia, indexBedra, indexShoulder, indexShoul_krai: Integer;
begin
  temp := faces;
  while temp <> nil do
  begin
    for var i := 0 to 3 do
    begin
      temp^.Data.Coordinates[i][0] := temp^.Data.Coordinates[i][0] / prevCoof;
      temp^.Data.Coordinates[i][2] := temp^.Data.Coordinates[i][2] / prevCoof;
      temp^.Data.Coordinates[i][0] := temp^.Data.Coordinates[i][0] * coof;
      temp^.Data.Coordinates[i][2] := temp^.Data.Coordinates[i][2] * coof;
    end;
    temp := temp^.next;
  end;
end;

procedure ChangeModel(var faces: PFace; const previndexTalia, previndexBedra,
  previndexShoulder, previndexShoul_krai: double; const indexTalia, indexBedra,
  indexShoulder, indexShoul_krai: double);
var
  temp: PFace;
  meanCoof, meanCoofPrev: double;
begin
  temp := faces;
  if (indexTalia = indexBedra) and (indexTalia = indexShoulder) and
    (indexTalia = indexShoul_krai) then
  begin
    while temp <> nil do
    begin
      for var i := 0 to 3 do
      begin
        temp^.Data.Coordinates[i][0] := temp^.Data.Coordinates[i][0] /
          previndexTalia;
        temp^.Data.Coordinates[i][1] := temp^.Data.Coordinates[i][1] /
          previndexTalia;
        temp^.Data.Coordinates[i][2] := temp^.Data.Coordinates[i][2] /
          previndexTalia;
        temp^.Data.Coordinates[i][0] := temp^.Data.Coordinates[i][0] *
          indexTalia;
        temp^.Data.Coordinates[i][1] := temp^.Data.Coordinates[i][1] *
          indexTalia;
        temp^.Data.Coordinates[i][2] := temp^.Data.Coordinates[i][2] *
          indexTalia;
      end;
      temp := temp^.next;
    end;
  end
  else if (indexShoulder = indexTalia) then
  begin
    while temp <> nil do
    begin
      for var i := 0 to 3 do
      begin
        temp^.Data.Coordinates[i][0] := temp^.Data.Coordinates[i][0] /
          previndexTalia;
        temp^.Data.Coordinates[i][1] := temp^.Data.Coordinates[i][1] /
          previndexShoul_krai;
        temp^.Data.Coordinates[i][2] := temp^.Data.Coordinates[i][2] /
          previndexTalia;
        temp^.Data.Coordinates[i][0] := temp^.Data.Coordinates[i][0] *
          indexTalia;

        temp^.Data.Coordinates[i][2] := temp^.Data.Coordinates[i][2] *
          indexTalia;
      end;
      temp := temp^.next;
    end;
  end
  else
  begin
    meanCoofPrev := (previndexTalia + previndexBedra + previndexShoulder +
      previndexShoul_krai) / 4;
    meanCoof := (indexTalia + indexBedra + indexShoulder + indexShoul_krai) / 4;
    while temp <> nil do
    begin
      for var i := 0 to 3 do
      begin
        temp^.Data.Coordinates[i][0] := temp^.Data.Coordinates[i][0] /
          meanCoofPrev;
        temp^.Data.Coordinates[i][1] := temp^.Data.Coordinates[i][1] /
          previndexShoul_krai;
        temp^.Data.Coordinates[i][2] := temp^.Data.Coordinates[i][2] /
          meanCoofPrev;
        temp^.Data.Coordinates[i][0] := temp^.Data.Coordinates[i][0] * meanCoof;
        temp^.Data.Coordinates[i][1] := temp^.Data.Coordinates[i][1] * meanCoof;
        temp^.Data.Coordinates[i][2] := temp^.Data.Coordinates[i][2] * meanCoof;
      end;
      temp := temp^.next;
    end;
  end;
end;

end.
