// 標準ライブラリのインポート
// asエイリアスをつけないと、平の名前空間に直接取り込まれるっぽいので基本はas付きが良さそう。
import 'dart:math' as math;

// ローカルパッケージのインポート
import 'package:basis/basis.dart' as basis;
import 'package:basis/control.dart' as control;
import 'package:basis/match.dart' as match;
import 'package:basis/exception.dart' as ex;
import 'package:basis/functions.dart' as funcs;
import 'package:basis/class.dart' as cls;
import 'package:basis/enum.dart' as enums;
import 'package:basis/future.dart' as futures;

void main(List<String> arguments) {
  print("===Definitions===");
  final (a, b, c, d, msg) = basis.variables();

  print("\n\n===Types and Literals===");
  final typeLits = basis.typesAndLiterals();

  print("\n\n===List Types===");
  basis.listType();

  print("\n\n===Set Types===");
  basis.setType();

  print("\n\n===Map Types===");
  basis.mapType();

  print("\n\n===Record Types===");
  basis.recordTypes();

  print("\n\n===Generics===");
  basis.genericFunction(23.3);

  print("\n\n===Cascade===");
  print(basis.cascade());

  print("\n\n===Nullable===");
  try {
    basis.nullable();
  } catch (e) {
    print("${e.runtimeType}: $e"); // _TypeErrorとかいうやつなのね...
  }

  print("\n\n===Control===");
  control.useIfCase();
  control.useSwitch();
  control.forLoop();
  control.whileLoop();

  print("\n\n==Pattern Match==");
  match.matchCollections();

  print("\n\n===Exceptions===");
  try {
    ex.tryCatch();
  } catch (e) {
    print(e);
  }

  ex.assertion(12);
  try {
    print(math.pi);
    ex.assertion(8);
  } on AssertionError catch (ex, trace) {
    print(ex);
    print(trace);
  }

  print("\n\n===Functions===");
  print(funcs.rgba(11, 32, 55));
  print(funcs.rgba2(11, 32, 55));
  print(funcs.rgba(11, 32, 55, 0.8));

  print("\n\n===Classes===");
  final p1 = cls.Point(11, 20, 34);
  p1.x = 10;
  p1.y = 30;
  // private変数は外からはアクセスできない
  // p1._z = 50;
  print(p1);

  // 名前付きコンストラクタによるインスタンス化
  print(cls.Point.zero());
  print(cls.Point.fromRecord((30, 40, 50)));

  cls.Viechle(3).move();
  cls.Car().move();
  cls.useExtension();
  cls.useMixin();
  cls.useSealed();

  print("\n\n===Enums===");
  enums.useEnum();
}
