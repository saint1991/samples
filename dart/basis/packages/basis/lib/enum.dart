// 一番シンプルなenum
enum Color { red, green, blue, white }

// フィールドつきのenum
// フィールドは全てfinalである必要がある。
// コンストラクタも定義できるが、constである必要がある。
// フィールドを持てるとは行っても、全てのenumに共通のフィールドを与えるのみなので、
// 代数的データ型的な使い方をしたい場合は、sealed classの方が適切っぽい。
enum ColorCode {
  red("#FF0000"),
  green("#00FF00"),
  blue("#0000FF");

  final String code;

  const ColorCode(this.code);
}

void useEnum() {
  final c1 = Color.red;
  print("c1: $c1");

  // デフォでvaluesプロパティを持っており全enumのリストを取得できる。
  print("all colors: ${Color.values}");

  final code1 = ColorCode.green;
  print("code1: $code1, code: ${code1.code}");
  print("all color codes: ${ColorCode.values}");
}
