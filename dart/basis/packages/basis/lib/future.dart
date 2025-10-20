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
/// Streamが
Stream<String> generatorLike() async* {}
