void tryCatch() {
  try {
    // 普通に投げるときはthrow
    throw Exception("intensional exception");

    // キャッチする種別を絞るのであれば on ExceptionTypeで絞る。その後にcatch節続く
  } on Exception catch (ex) {
    // キャッチしたものを投げ直すときは専用のrethrowを使わないといけない...
    rethrow;

    // finallyは他の言語とおなじ
  } finally {
    print("finally called");
  }
}

// Pythonっぽいassertionもある
// ただし、Flutterではdebugビルド時のみ評価されるっぽい
void assertion(int x) {
  assert(x > 10, "x should be more than 10");
}

/// コードコメントのサンプル。[]で囲むとリンクになる。
/// call [assertion] with a value less than 10 to see the effect
void commentSample() {
  final a = 11;
  assertion(a);
}
