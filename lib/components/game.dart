class Game {
  //speichert ob Spiel gestartet
  bool startet = false;
  //Liste mit an Spiel teilnehmenden Spielern
  List<String> players = [];
  //Spieler der aktuell am Zug ist
  String currentPlayer = '';
  //Spieler, der das SPiel gestartet hat
  String gameOwner = '';

  void setGameOwner(String _o) {
    gameOwner = _o;
  }

  String getGameOwner() {
    return gameOwner;
  }

  void setPlayers(List<String> _l) {
    players = _l;
  }

  List<String> getPlayers() {
    return players;
  }

  String getCurrentPlayer() {
    return currentPlayer;
  }

  void setCurrentPlayer(String _p) {
    currentPlayer = _p;
  }

  bool isStartet() {
    return startet;
  }

  //Spiel starten
  void start() {
    startet = true;
    currentPlayer = players.first;
  }

  void addPlayer(String _p) {
    players.add(_p);
    currentPlayer = players.first;
  }

  void deleteAll() {
    players = [];
  }

  void deletePlayer(_currentPlayer) {
    players.remove(_currentPlayer);
  }

  bool userNotInGame(String _currentPlayer) {
    for (int i = 0; i < players.length; i++) {
      if (_currentPlayer == players[i]) {
        return false;
      }
    }
    return true;
  }

  //Current Player auf den nöchsten Spieler, der am Zug ist setzen
  void next(String _currentPlayer) {
    int index = 0;
    for (int i = 0; i < players.length; i++) {
      if (_currentPlayer == players[i]) {
        index = i;
        if (i + 1 < players.length) {
          currentPlayer = players[i + 1];
        } else {
          currentPlayer = players[0];
        }
      }
    }
  }
}
