class Person {
  final String name;
  final int age;

  Person(this.name, this.age);
}

void matchCollections() {
  // リストのパターンマッチ、 ... で可変部分を吸収できる
  final [apple, ..., banana] = ["apple", "lemon", "kiwi", "banana"];
  print("$apple $banana");

  // マップのパターンマッチ
  // キーがマッチしてるものが代入されるらしい。珍しいな
  final {"apple": red, "greep": purple} = {"apple": "red", "greep": "purple"};
  print("$red $purple");

  // recordのマッチ
  // 名前付きの場合は名前も書かないといけない
  final (name: n, age: a) = (name: "saint1991", age: 22);
  print("$n is $a");

  // クラスのパターンマッチ
  // クラスに定義した各フィールドでマッチできる。
  // Dartではクラス定義がすべてScalaのcase class相当の動きっぽい
  final me = Person("saint1991", 33);

  final Person(name: myname) = me;
  print(myname);

  final fruitColors = {
    "apple": "red",
    "kiwi": "green",
    "banana": "yellow",
    "greep": "purple",
  };

  // MapのentriesもMapEntryを使って分解できる
  for (final MapEntry(key: k, value: v) in fruitColors.entries) {
    print("key: $k -> value: $v");
  }
}
