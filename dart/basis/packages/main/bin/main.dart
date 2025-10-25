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
          return content;
        },
        onError: (err, trace) {
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

  // onDoneはcompleteに近い。streamが終了した際に成否に関わらず呼ばれる
  // onErrorはStreamで例外が発生した際に呼ばれるコールバック。ない場合は例外がスローされる。
  // 例外がスローされた際に以降のstream購読を行うかは、cancelOnErrorによる
  final generatorSubscription = futures
      .generatorLike("./README.md")
      .listen(
        (line) {
          print(line);
        },
        onDone: () {
          print("DONE!!");
        },
        onError: (Object exc, StackTrace st) {
          print(exc);
        },
        cancelOnError: false,
      );

  final st = futures.StreamControllerExample([
    "pen",
    "pineapple",
    "apple",
    "pen",
  ]);

  // 基本的に購読は1Stream1つまでだがasBroadcastStreamで複数にできる。
  // shareReplyに近いが購読開始時点の値以降がとられる点がやや違う。
  st.stream.asBroadcastStream().listen(
    (value) {
      print("$value from controller");
    },
    onDone: () {
      print("controller closed");
    },
  );
}
