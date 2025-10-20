class Point {
  int x;
  int y;

  // private変数は_で始める。修飾子はない
  int _z;

  // constコンストラクタではassertはコンパイルエラー
  // 通常のコンストラクタではRuntimeErrorになる。ただし、--enable-assertsオプションをつけて実行する必要あり
  Point(this.x, this.y, this._z) : assert(x >= 0), assert(y >= 0);

  // 名前付きコンストラクタ
  Point.zero() : x = 0, y = 0, _z = 0;

  @override
  String toString() => '($x, $y, $_z)';

  // いまいち存在意義がわからんfactoryコンストラクタ
  // 新しくインスタンスを作らない場合もあるとのことだが、それ普通の関数でも良くないか...
  // claudeが言うには、シングルトンとかに使うと良いらしい
  factory Point.fromRecord((int, int, int) r) {
    if (r.$1 < 0 || r.$2 < 0 || r.$3 < 0) {
      return Point.zero();
    }
    return Point(r.$1, r.$2, r.$3);
  }
}

class ConstPoint2d {
  // フィールドは全てfinalである必要がある
  final double x;
  final double y;

  // constコンストラクタ
  // こいつのインスタンスはconstにも代入できる
  const ConstPoint2d(this.x, this.y);
}

class Viechle {
  final int wheels;

  Viechle(this.wheels);

  void move() {
    print("brummmm");
  }
}

// 通常の継承
class Car extends Viechle {
  Car() : super(4);

  @override
  void move() {
    print("move by $wheels wheels");
  }
}

// extensionで既存の型にメソッドを追加する
// ScalaのEnrich my library的なやつ
extension ScalikeList<T> on List<T> {
  U foldLeft<U>(U initial, U Function(U, T) f) {
    var result = initial;
    for (var element in this) {
      result = f(result, element);
    }
    return result;
  }
}

void useExtension() {
  final list = [1, 2, 3, 4];
  final sum = list.foldLeft(0, (acc, elem) => acc + elem);
  print("sum is $sum");
}

// mixinによるメソッドの追加
// on XXXで適用可能なクラスを制限できる。
// 制限することにより、mixin内でそのクラスのメソッドやプロパティにアクセスできるようになる
mixin Runnable on Viechle {
  void run() {
    print("fire!");
    move();
  }
}

mixin Flyable {
  void fly() {
    print("fly!");
  }
}

/// mixin class
/// mixinでき、かつ単体でインスタンス化もできる
/// ただし、コンストラクタは引数なし、初期化指定子なしのものしか定義できない
mixin class SwimmableShip {
  SwimmableShip();

  void swim() {
    print("splash!");
  }
}

// mixinの適用
// withで複数mixinを適用できる
class Bike extends Viechle with Runnable, Flyable {
  Bike() : super(2);
}

void useMixin() {
  final bike = Bike();
  bike.run();
  bike.fly();

  // Scalaのようにインスタンス化する際にmixinするのは無理っぽい...
  // final car = Car() with Runnable;
}

/// abstract と base を併用する例
/// abstractは他の言語と同様に実装なしのメソッドを定義できるクラス。 コンストラクタは取れるがインスタンス化はできない
/// baseクラスはimplementsを禁止する。基本privateメソッドの実装を固定するのに使う感じっぽいがあんま使い所はなさげ。
abstract base class Completer {
  final String text;

  Completer(this.text);

  /// 抽象メソッド
  /// abstract修飾子はいらんらしい
  ({int start, int end}) positionOfKeyword();

  void _printKeyword(({int start, int end}) pos) {
    if (pos.start == -1) {
      print("");
    } else {
      print("Keyword: ${text.substring(pos.start, pos.end)}");
    }
  }

  String printAndGetKeyword() {
    final pos = positionOfKeyword();
    _printKeyword(pos);
    if (pos.start == -1) {
      return "";
    }
    return text.substring(pos.start, pos.end);
  }
}

base class BaseCompleter extends Completer {
  BaseCompleter(super.text);

  @override
  ({int start, int end}) positionOfKeyword() {
    final match = RegExp(r'\w+').firstMatch(text);
    if (match == null) {
      return (start: -1, end: -1);
    }
    return (start: match.start, end: match.end);
  }

  String getKeyword() {
    final pos = positionOfKeyword();
    if (pos.start == -1) {
      return "";
    }
    return text.substring(pos.start, pos.end);
  }
}

void useClass() {
  final c = BaseCompleter(" abstract class example");
  print(c.getKeyword());
}

/// interface class
/// こいつは継承できないクラスになる
/// つまり、implements専用クラスになる
/// TypeScriptのinterfaceっぽく使いたければ、abstract interfaceにする
abstract interface class CantExtends {
  void doSomething();
}

/// final class
/// パッケージ外で継承もimplementsもできないクラス
final class Fixed {
  final String value;

  const Fixed(this.value);
}

/// sealed class
/// 他のpackageでは継承できない定義を固定できるクラス
/// サブタイプをEnumのようにパターンマッチで使用できるので、代数的データ型的な使い方ができる
sealed class ErrorBase {
  abstract int code;
  abstract String message;
}

class RuntimeError extends ErrorBase {
  @override
  int code = 1;

  @override
  String message;

  String file;
  int line;

  RuntimeError(this.message, this.file, this.line);
}

class IOError extends ErrorBase {
  @override
  int code = 2;

  @override
  String message;

  String cause;

  IOError(this.message, this.cause);
}

void useSealed() {
  List<ErrorBase> errors = [
    RuntimeError("Null pointer", "main.dart", 42),
    IOError("File not found", "No such file or directory"),
  ];

  for (final err in errors) {
    // sealed classはパターンマッチで分岐できる
    // 以下のようにScalaのcase class的なパターンマッチが可能
    switch (err) {
      case RuntimeError(
        code: int c,
        message: String msg,
        file: String file,
        line: int line,
      ):
        print("RuntimeError($c): $msg at $file:$line");
      case IOError(code: int code, message: var msg, cause: var c):
        print("IOError($code): $msg, cause: $c");
    }
  }
}
