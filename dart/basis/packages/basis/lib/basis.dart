// コンパイル時定数
const globalConstants = "I am a global constant";

// constのListも作れる。しかも中身も変更できる... constとは...
const List<String> globalList = ["I", "am", "a", "global", "list"];

// 変数の宣言
(int, int, int, int, String) variables() {
  // 定数 (let相当)
  final a = 1;

  final int b = 2;

  // 変数 (let mut相当)
  var c = 1;
  c = 2;

  // 遅延初期化 (scalaのlazy val相当)
  late final d = calculate();

  // 三項演算子 (if-else式)
  final e = c == 2 ? "c is two" : "c is not two";
  print(e);

  return (a, b, c, d, globalConstants);
}

bool typesAndLiterals() {
  // 整数型
  final int integer = 1;

  // 浮動小数
  final double doublePrecision = 2.0;

  // 整数/浮動小数のsupertype (num)
  final num number = 2;

  // 文字列
  final String str = 'string';

  // 複数行の文字列
  final String multiLine =
      """
I am a $str and
${number}nd line here!
$integer $doublePrecision $number
""";

  // 真偽値
  final bool tr = true;
  final bool fl = false;

  print("$multiLine $fl");

  return tr;
}

void listType() {
  // constへの追加はさすがにエラー。
  // でもコンパイルエラーではなくランタイムエラー...
  try {
    globalList[1] = "was";
    globalList.add("Unsupported operation: Cannot add to an unmodifiable list");
  } catch (e) {
    print(e.toString());
  }

  // List (配列)
  final list = <int>[1, 2, 3];

  // constでなければfinalでも普通に追加できる
  list.add(1);

  // 要素が異なる型の場合はSuperClassの型で宣言すればいける。(Objectは全ての型のsuper class)
  final List<Object> list2 = [1, "two", 3.0];

  // 不変のリストを作る際はunmodifiableを使う
  // constの場合も暗黙的にunmodifiableになるようで、挙動は同じ。
  final unmodifiableList = List<String>.unmodifiable(["I, am", "unmodifiable"]);

  try {
    unmodifiableList[2] = "error";
  } catch (e) {
    print(e);
  }

  // さすがにglobalListには追加はされていない
  print("These are printed lists: $list $globalList $list2 $unmodifiableList");

  // spread演算子で結合も可能
  final list3 = [...list, ...list2];
  print("This is a spread interpolated list: $list3");

  // 条件付き要素追加
  final num = 2;
  final list4 = [1, if (num == 2) "two", if (num != 2) "not two", 3];
  print("This is a conditionally interpolated list: $list4");

  // for内包表記
  // Pythonとかと違って先にforを書いた後、値にする式を後置する方式
  final list5 = [0, for (var i in list) 2 * (i + 1), 4];
  final list6 = [for (var i in list5) i + 1];
  print("This is a for-comprehension like interpolated list: $list5, $list6");
}

void setType() {
  // Set (集合)
  final set = <int>{1, 2, 3};

  // 要素の追加
  set.add(1); // 重複する要素は追加されない
  set.add(4);
  print("This is a set: $set");

  final Set<String> set2 = {"Apple", "Banana", "Orange", "Apple", "Greape"};
  print("This is another set: $set2");

  final set3 = [...set, ...set2];
  print("This is a spread interpolated list from set and set2: $set3");

  final set4 = {
    ...set,
    ...{1, 6, 3},
  };
  print("set4: $set4");
}

void mapType() {
  // Map (辞書)
  final map = <String, int>{"one": 1, "two": 2, "three": 3};

  // 要素の追加
  map["four"] = 4;
  print("This is a map: $map");

  // キーにはなんでも取れるが、透過性判定が基本的に参照ベースなので、以下のようにしても取り出せないMapになる。
  final Map<List<String>, String> map2 = {
    ["1"]: "Apple",
    ["1"]: "Banana",
    ["3"]: "Orange",
    ["2"]: "Greape",
  };
  print("This is another map: $map2");
  print("This is a value of map2: ${map2[["1"]]}");

  // mapもspread演算子でマージできる
  // 同じキーの場合は後勝ち
  final mergedMap = {
    ...map,
    ...{"three": 4, "five": 5},
  };
  print("This is a merged map: $mergedMap");

  // for comprehension
  final map3 = {for (final i in map.keys) i: map[i]! * 2};
  print("This is a for-comprehension like interpolated map: $map3");
}

void recordTypes() {
  // record型 (tuple相当 immutable)
  final (int, String, double) record = (1, "two", 3.0);

  // recordの各要素は$1, $2, $3でアクセスできる
  // 珍しいことに1-indexed
  print("2 is ${record.$2}");

  // 名前付きrecord
  // 名前つき部分は {} で囲んで型　フィールド名
  // 位置フィールドと混在する場合は、必ず位置フィールドが前 (リテラル側はその限りではない、型のみ)
  final (String, {String name, int age}) person = (
    name: 'saint1991',
    age: 34,
    "engineer",
  );
  print("I am $person");

  // 名前付きフィールドは名前でアクセスできる
  print("My name is ${person.name} and ocupation is ${person.$1}");
}

// ジェネリック関数
void genericFunction<T>(T value) {
  final g = GenericClass<T>(value);
  g.printValue();
}

// ジェネリッククラス
class GenericClass<T> {
  T value;

  // コンストラクタ?
  // ここにthisを使うのは結構特殊な構文やな...?
  // どうやらC++と同じく、メンバ初期化指定子方式らしく、これはそのシンタックスシュガー
  GenericClass(this.value) {
    print("GenericClass created with $value (${T.runtimeType})");
  }

  void printValue() {
    print("GenericClass value is $value");
    print("$this");
  }
}

int calculate() {
  print("calculate called");
  return 6 * 7;
}

String cascade() {
  // インスタンス化
  // newはあってもなくても良いっぽい
  final sb1 = new StringBuffer();
  sb1.write("I am"); // 普通に呼び出すとここはvoidなのでチェーンできない

  // cascade notation
  final sb2 = StringBuffer()
    ..write("I am ") // ここで..とすることで、戻り値がStringBufferになる
    ..write("a cascade ")
    ..write("example.");

  // ただしこうはできないらしい... 中途半端やな...
  // final str = StringBuffer()..write("I can't").toString();

  return sb2.toString();
}

void nullable() {
  // 型推論させると気づきづらいが、Dartのデフォの型は概ねnull非許容
  // なのでこれは無理
  // int a = null;
  String? str = null; // ?をつけるとnull許容になる

  // TypeScript同様、?でnullチェックできる。nullの場合は単にnullに評価される。
  print("length of $str is ${str?.length}");

  // これもTypeScript同様、null合体演算子
  // 左項がnullの場合、右項を評価する
  print(str ?? "str is null so this is default value");

  // !演算子でチェックすると、nullの場合、例外になる。
  print("length of $str is ${str!.length}");
}
