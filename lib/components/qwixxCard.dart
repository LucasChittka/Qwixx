import 'dices.dart';

class QwixxCard {
  //Spieler zu dem die Karte gehört
  late String player;

  //Feld mit 4 Zeilen und 12 Spalten, dass eine Qwixx Karte repräsentiert
  //Der Wert in der zwölften Spalte repräsentiert das Schloss
  List<List<bool>> qwixxCard = List.generate(
      4, (i) => List.generate(12, (j) => false, growable: false),
      growable: false);

  //Zählt die Anzahl der Fehlwürfe
  List<bool> misses = [false, false, false, false];

  //Speichert ob Zeilen gesperrt sind oder nicht
  var lockedLines = [false, false, false, false];

  //Ordnet der Karte ein WÜrfelset zu
  late Dices dices;

  QwixxCard(Dices _d, String _p) {
    dices = _d;
    player = _p;
  }

  List<bool> getMisses() {
    return misses;
  }

  bool missCanBeRemoved(int _miss) {
    bool allowed = true;
    for (int i = 3; i > _miss; i--) {
      if (misses[i]) {
        allowed = false;
      }
    }
    return allowed;
  }

  bool missCanBeSet(int _miss) {
    bool allowed = true;
    for (int i = 0; i < _miss; i++) {
      if (!misses[i]) {
        allowed = false;
      }
    }
    return allowed;
  }

  //Fehlwurf ist erlaubt und wurde eingetragen
  void setMissCross(int _miss) {
    if (misses[_miss] && missCanBeRemoved(_miss)) {
      misses[_miss] = false;
    } else if (!misses[3] && missCanBeSet(_miss)) {
      misses[_miss] = true;
    }
  }

  //Der angegebene Zug ist erlaubt
  bool isAllowed(int _row, int _column) {
    //Speichert, ob ein dahinterliegendes Feld angekreuzt ist
    bool isTicked = false;
    //Wenn die Zeile noch nicht gesperrt ist
    if (lockedLines[_row] != true) {
      //Für jedes Feld nach dem, das angekreuzt werden soll
      for (int i = 11; i > _column; i--) {
        //wenn kein dahinterliegendes Feld angekreuzt war
        if (isTicked == false) {
          isTicked = qwixxCard[_row][i];
        }
      }
    }
    //Wenn ein dahinterliegendes Feld angekreuzt ist
    if (isTicked == true) {
      //Zug ist nicht erlaubt
      return false;
    } else {
      return true;
    }
  }

  //Ein Kreuz an der angegebenen Stelle setzen
  void setCross(int _row, int _column) {
    if (isAllowed(_row, _column)) {
      if (qwixxCard[_row][_column]) {
        qwixxCard[_row][_column] = false;
      } else {
        qwixxCard[_row][_column] = true;
      }
    }
  }

  //Anzahl der gesetzten Kreuze in einer Zeile
  int crossesInLine(int _row) {
    int quantity = 0;
    for (int i = 0; i < 12; i++) {
      if (qwixxCard[_row][i]) {
        quantity++;
      }
    }
    return quantity;
  }

  //Endergebnis der Karte
  int result() {
    int result = 0;
    for (int i = 0; i < 4; i++) {
      int crosses = crossesInLine(i);
      switch (crosses) {
        case 0:
          break;
        case 1:
          result = result + 1;
          break;
        case 2:
          result = result + 3;
          break;
        case 3:
          result = result + 6;
          break;
        case 4:
          result = result + 10;
          break;
        case 5:
          result = result + 15;
          break;
        case 6:
          result = result + 21;
          break;
        case 7:
          result = result + 28;
          break;
        case 8:
          result = result + 36;
          break;
        case 9:
          result = result + 45;
          break;
        case 10:
          result = result + 55;
          break;
        case 11:
          result = result + 66;
          break;
        case 12:
          result = result + 78;
          break;
      }
    }

    for (int i = 0; i < 4; i++) {
      if (misses[i]) {
        result = result - 5;
      }
    }

    return result;
  }

  //Eine bestimmte Zeile sperren
  void lockLine(int _l) {
    lockedLines[_l] = true;
  }

  List<List<bool>> getQwixxCard() {
    return qwixxCard;
  }

  //Karte zum schreiben in die Datenbank in eine Map konvertieren
  Map<String, bool> convertCardtoMap() {
    Map<String, bool> map = {};
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 12; j++) {
        String key = "Reihe" + i.toString() + "Zeile" + j.toString();
        map[key] = qwixxCard[i][j];
      }
    }
    return map;
  }
}
