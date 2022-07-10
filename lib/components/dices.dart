import 'dart:math';

class Dices {
  //Werte der Würfel als String
  List<String> diceResultString = [
    1.toString(),
    1.toString(),
    1.toString(),
    1.toString(),
    1.toString(),
    1.toString()
  ];

  //Werte der Würfel als Map
  Map<String, int> diceResultMap = <String, int>{
    'white1': 1,
    'white2': 1,
    'red': 1,
    'green': 1,
    'blue': 1,
    'yellow': 1,
  };

  Dices();

  List<String> getResultString() {
    return diceResultString;
  }

  Map<String, int> getResultMap() {
    return diceResultMap;
  }

  //Neue Werte als Zufallszahl zwischen 1 und 6 generieren
  void dice() {
    for (int i = 0; i < diceResultString.length; i++) {
      int value = Random().nextInt(6) + 1;
      diceResultString[i] = value.toString();
      switch (i) {
        case 0:
          diceResultMap['white1'] = value;
          break;
        case 1:
          diceResultMap['white2'] = value;
          break;
        case 2:
          diceResultMap['red'] = value;
          break;
        case 3:
          diceResultMap['green'] = value;
          break;
        case 4:
          diceResultMap['blue'] = value;
          break;
        case 5:
          diceResultMap['yellow'] = value;
          break;
      }
    }
  }
}
