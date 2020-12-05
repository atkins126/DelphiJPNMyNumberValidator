unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.StrUtils, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
//    function CalcMyNumberCheckDigit(MyNumber: string): Integer;
//    function IsValudMyNumber(MyNumber: string): boolean;
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function CalcMyNumberCheckDigit(MyNumber: string): Integer;
var
  MyNumberUnique: String;
  CheckDigitCalc, Pn, N: Integer;
  MyNumber_num: UInt64;
begin
  // チェックデジット計算前のマイナンバーは11桁なので11桁以外の場合は -1 を返す。
  if Length(MyNumber) <> 11 then
  begin
    Result := -1; Exit;
  end;

  // 入力文字列が数字かどうかを検証し、数字ではない場合は -1 を返す。
  MyNumber_num := StrToUInt64Def(MyNumber,0);
  if MyNumber_num = 0 then
  begin
    Result := -1; Exit;
  end;

  // https://www.j-lis.go.jp/data/open/cnt/3/1282/1/H2707_qa.pdf
  // ①11桁の番号の末尾から１桁ずつ順に重みを２、３、４、５、６、７、２、３、４、５、６と乗じて総和を求める。
  // ②総和を11で割りその余りを求める。
  // ③11より余りを引いた値がチェックデジットとなる。
  //
  // ＜例＞
  // 11桁 の 番 号 がabcdefghijkの場合（a～kは任意の１桁の数字、X～Zは計算により求められた数字を表す）
  // ①（ｋ×２）＋（ｊ×３）＋（ｉ×４）＋（ｈ×５）＋（ｇ×６）＋（ｆ×７）＋（ｅ×２）＋（ｄ×３）＋（ｃ×４）＋（ｂ×５）＋（ａ×６）＝Ｘ
  // ②Ｘ÷11＝Ｙ余りＺ
  // ③11－Ｚがチェックデジット
  // ※Ｚ（余り）が０または１の場合はチェックデジットを「０」とする。


  // 文字列処理の都合上、反転した文字列を扱う
  MyNumberUnique := ReverseString(MyNumber);

  CheckDigitCalc := 0;
  for N := 1 to 11 do
  begin
    Pn := StrToInt(MyNumberUnique[N]);

    // 1～6文字目までと 7～11文字目向けの演算を行う。
    if N < 7 then
      CheckDigitCalc := CheckDigitCalc + Pn * (N + 1)
    else
      CheckDigitCalc := CheckDigitCalc + Pn * (N - 5);
  end;
  CheckDigitCalc := CheckDigitCalc mod 11;

  // 11 から、計算された数値を引いた値がチェックデジット。
  // ただし 0 または 1 の場合は常に 0 とする。
  if CheckDigitCalc <= 1 then
    CheckDigitCalc := 0
  else
    CheckDigitCalc := 11 - CheckDigitCalc;

  Result := CheckDigitCalc;
end;


function IsValudMyNumber(MyNumber: string): boolean;
var
  CheckDigit: String;
  CheckDigitCalc: Integer;
  MyNumber_num: UInt64;
begin
  // マイナンバーは12桁なので12桁以外の場合は False を返す。
  if Length(MyNumber) <> 12 then
  begin
    Result := False; Exit;
  end;

  // 入力文字列が数字かどうかを検証し、数字ではない場合は False を返す。
  MyNumber_num := StrToUInt64Def(MyNumber,0);
  if MyNumber_num = 0 then
  begin
    Result := False; Exit;
  end;

  // 番号 123456789018 は、末尾の 8 がチェックデジット、12345678901 が番号部分。
  CheckDigit := Copy(MyNumber, 12, 1);

  // 先頭1文字目から11文字からチェックデジットを計算する
  CheckDigitCalc := CalcMyNumberCheckDigit(Copy(MyNumber, 1, 11));

  if CheckDigitCalc.ToString = CheckDigit then
    Result := true
  else
    Result := false;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  IsMyNumber: Boolean;
begin
  IsMyNumber := IsValudMyNumber( Edit1.Text );

  if IsMyNumber then
    Memo1.Lines.Add( Edit1.Text + ' is valid MyNumber' )
  else
    Memo1.Lines.Add( Edit1.Text + ' is invalid' );
end;

end.
