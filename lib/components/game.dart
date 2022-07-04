class Game {
  bool startet = false;
  List<String> players = [];
  String currentPlayer = '';
  String gameOwner = '';
  int currentPlayerIndex = 0;

  void setGameOwner(String _o) {
    gameOwner = _o;
  }

  String getGameOwner() {
    return gameOwner;
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

  void next(String _currentPlayer) {
    int index;
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
