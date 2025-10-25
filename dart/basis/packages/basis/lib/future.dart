import 'dart:io';
import 'dart:async';
import 'dart:convert';

/// Futureの使用例
/// ファイルの内容を非同期に読み込み、表示する
/// ほぼJavaScriptのPromise
/// asyncキーワードをつけた関数はFutureを返す
/// async関数中ではawaitキーワードでFutureの完了を待てる
Future<String> fileContent(String filePath) async {
  File file = File(filePath);
  final Future<String> maybeContent = file.readAsString();

  return await maybeContent;
}

/// Streamの使用例
/// ファイルの内容を非同期に1行ずつ読み込み、表示する
/// transformで変換パイプラインを構築できる模様
Stream<String> fileChunks(String filePath) {
  File file = File(filePath);
  final Stream<List<int>> inputStream = file.openRead();

  final lineStream = inputStream
      .transform(utf8.decoder) // デコード
      .transform(const LineSplitter()); // 行ごとに分割

  return lineStream;
}

/// async*キーワードを使うことで、ジェネレータっぽい関数を定義できる。
/// listenされて購読された時に初めて実行される。
/// ///
Stream<String> generatorLike(String filePath) async* {
  await Future.delayed(const Duration(seconds: 1));

  //yieldで単体の値を送出
  yield "Start reading $filePath";

  // yield*で別のStreamに連結できる
  yield* fileChunks(filePath);

  throw Exception("Intentional exception");

  yield "End of $filePath";
}

class StreamControllerExample {
  // StreamControllerはSubjectに近い
  // 値はバッファリングされる
  final StreamController<String> _controller = StreamController<String>();

  Stream<String> get stream => _controller.stream;

  final List<String> _values;
  int _index;

  StreamControllerExample(List<String> values) : _values = values, _index = 0;

  void next() {
    if (_index < _values.length) {
      // addでstreamに値を流す
      _controller.add(_values[_index]);
      _index += 1;
    } else {
      _controller.close();
    }
  }
}
