/// []付き引数は省略可能なのでnull許容型かデフォルト値の設定が必要
String rgba(int red, int green, int blue, [double? alpha]) {
  final code = [red, green, blue].map((int color) {
    return color.toRadixString(16).padLeft(2, '0').toUpperCase();
  }).join();
  return "#$code ${alpha != null ? "alpha: $alpha" : ""}";
}

/// デフォ値の場合はこんな感じ
String rgba2(int red, int green, int blue, [double alpha = 1.0]) {
  // 変数的に保持する場合はこういう型付になる
  String Function(int, int, int, double) f = rgba;
  return f(red, green, blue, alpha);
}
