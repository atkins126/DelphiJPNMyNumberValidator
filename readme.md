# Delphi JPN MyNumber Validator
Japanese Individual Number Validator sample by Delphi
マイナンバーの番号検証処理の Delphi によるサンプル実装

扶養家族のマイナンバーは手元にメモしてあるのですが、そのメモが正しいかどうかを確認するためのコードを Delphi で書いてみました。

# Features

## function IsValudMyNumber(MyNumber: string): boolean;
If 12 digits string has passed to this function, it returns valid or not.
渡された文字列が12桁の数値の場合はマイナンバーとして正しいかどうかを返します。

## function CalcMyNumberCheckDigit(MyNumber: string): Integer;
If 11 degits strings has passed to this function, it returns check digit for Individual Number logic.
11桁の数値が渡された場合はマイナンバーのチェックデジットの方法で計算した値を返します。

# Requirement
Developped as VCL application by Delphi 10.3.3 Community Edition.

# Author
Kazuhiro Inoue.

# License
MIT License.
