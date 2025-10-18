import 'package:basis/class.dart' as cls;
import 'package:basis/future.dart' as futures;

base class ThreeCharsCompleter extends cls.Completer {
  ThreeCharsCompleter(super.text);

  @override
  ({int start, int end}) positionOfKeyword() {
    return (start: 0, end: text.length >= 3 ? 3 : text.length);
  }
}

void main(List<String> arguments) async {
  final completer = ThreeCharsCompleter("This is a sample text.");
  print("Keyword: ${completer.printAndGetKeyword()}");

  print("\n\n===Futures===");

  /// JavaScriptのPromiseのようにthenで成功時のコールバックを書ける
  /// catchErrorで失敗時のエラーハンドリングを書く
  /// デフォ値を返したいときはonErrorではなく、thenのonErrorパラメータを使う
  futures
      .fileContent("unknown-file")
      .then(
        (content) {
          print(content);
        },
        onError: (err) {
          return "DEFAULT CONTENT";
        },
      )
      .catchError((Object err) {
        print("ERR $err");
      });

  // streamの場合はawait forで各要素を同期っぽく処理できる
  await for (final line in futures.fileChunks("./README.md")) {
    print("async for LINE: $line");
  }

  // Streamは基本的にlistenで購読する。
  // これはObservableのsubscribeに近い。
  // subscription.cancel()がunsubscribeに相当する。
  final subscription = futures.fileChunks("./README.md").listen((line) {
    print("LINE: $line");
  });
}
