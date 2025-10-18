// if-case文 Scalaのcase分解 Rustのif letにちょい似てる
void ifCase(({String fruit, int price}) marchant) {
  // 名前付きrecordの場合は以下のように名前まで指定しないといけない
  if (marchant case (fruit: String f, price: int p) when p >= 300) {
    print("This $f is $p yen");
  }
}

void useIfCase() {
  final marchant2 = (fruit: 'Grape', price: 200);
  final marchant3 = (fruit: 'Banana', price: 500);
  ifCase(marchant2);
  ifCase(marchant3);
}

// switch文
void switchStatement(String fruit) {
  // breakをいちいち書かなくてもマッチしたらswitchを抜ける方式
  switch (fruit) {
    // 複数条件書く場合はこういう風に重ねてcaseを書く。
    case 'Banana':
    case 'Lemon':
      print("YELLOW");
      continue all; // continueを書かない場合は基本フォールスルーはない。
    case 'Apple':
      print("RED"); // このケースはここで終了
    all:
    case 'all': // ラベル付き (continueでここに飛ばしている)
      print(" fruit");
    default:
      print("Unknown");
  }
}

// switch式
String switchExpression((String, int) marchant) {
  // case
  return switch (marchant) {
    ("Apple", int price) when price >= 300 => "delicious apple",
    ("Apple", int price) when price < 300 => "normal apple",
    ("Banana", 200) => "Golden Banana",
    _ => "Unknown",
  };
}

String switchExpressionCollection(List<String> fruits) {
  return switch (fruits) {
    // List等コレクションをマッチさせるときはなぜかconstが必要
    const ["pen", "pineapple", "apple", "pen"] => "PPAP",
    _ => "oh",
  };
}

void useSwitch() {
  switchStatement('Apple');
  switchStatement('Banana');
  print(switchExpression(("Apple", 400)));
  print(switchExpression(("Banana", 200)));
  print(switchExpression(("Lemon", 100)));

  print(switchExpressionCollection(["apple", "banana"]));

  // 呼び出し側もconstで渡さないとマッチしないらしい...
  print(switchExpressionCollection(const ["pen", "pineapple", "apple", "pen"]));
}

// forループ
void forLoop() {
  // 一般的なforループ
  // そらそうだがiはfinalにはできない。
  for (int i = 0; i <= 5; i++) {
    print(i);
  }

  // iterableな場合はfor inで書ける
  // この場合はfinalで良いのが謎
  final List<String> fruits = List.unmodifiable(["apple", "banana", "lemon"]);
  for (final fruit in fruits) {
    print(fruit);
  }

  // forEach
  fruits.reversed.forEach(print);
}

void whileLoop() {
  // 普通のwhile
  int i = 0;
  while (true) {
    print(i);
    i++;
    if (i > 3) {
      break;
    }
  }

  // do whileもある
  i = 0;
  do {
    print(i);
  } while (i < 0);
}
