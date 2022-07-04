import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qwixx_game/screens/welcomeScreen.dart';

import '../components/dices.dart';
import '../components/game.dart';
import '../components/qwixxCard.dart';

class GameScreen extends StatefulWidget {
  static String id = 'play';

  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  //Würfel
  late Dices dices;

  //
  late QwixxCard card;

  //Firebase Authentification Instanz
  var _auth;
  //Firebase Database Instanz
  var _firestore;
  //Speichert den angemeldeten User
  late User loggedInUser;
  late Game game;

  Widget eye(Color _c) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(color: _c, shape: BoxShape.circle),
    );
  }

  Widget dice(Color _c, String _v) {
    Widget rightDice = Container();
    switch (_v) {
      case "1":
        rightDice = Container(
          width: 100.00,
          height: 100.00,
          decoration: BoxDecoration(color: _c),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(_c), eye(_c)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(Colors.white)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(_c), eye(_c)],
              ),
            ],
          ),
        );
        break;
      case "2":
        rightDice = Container(
          width: 100.00,
          height: 100.00,
          decoration: BoxDecoration(color: _c),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(_c), eye(Colors.white)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(_c), eye(_c)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(Colors.white), eye(_c)],
              ),
            ],
          ),
        );
        break;
      case "3":
        rightDice = Container(
          width: 100.00,
          height: 100.00,
          decoration: BoxDecoration(color: _c),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(_c), eye(Colors.white)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(Colors.white)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(Colors.white), eye(_c)],
              ),
            ],
          ),
        );
        break;
      case "4":
        rightDice = Container(
          width: 100.00,
          height: 100.00,
          decoration: BoxDecoration(color: _c),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(Colors.white), eye(Colors.white)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(_c)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(Colors.white), eye(Colors.white)],
              ),
            ],
          ),
        );
        break;
      case "5":
        rightDice = Container(
          width: 100.00,
          height: 100.00,
          decoration: BoxDecoration(color: _c),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(Colors.white), eye(Colors.white)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(Colors.white)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(Colors.white), eye(Colors.white)],
              ),
            ],
          ),
        );
        break;
      case "6":
        rightDice = Container(
          width: 100.00,
          height: 100.00,
          decoration: BoxDecoration(color: _c),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(Colors.white), eye(Colors.white)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(Colors.white), eye(Colors.white)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [eye(Colors.white), eye(Colors.white)],
              ),
            ],
          ),
        );
        break;
    }
    return rightDice;
  }

  List<bool> getValues(Map<String, dynamic> _map, int _row) {
    List<bool> values = List.filled(12, false);
    for (int j = 0; j < 12; j++) {
      String key = "Reihe" + _row.toString() + "Zeile" + j.toString();
      dynamic value = _map[key];
      values[j] = value;
    }
    return values;
  }

  //Baut aus der aus der Datenbank ausgelesenen
  Widget buildQwixxCard(Map<String, dynamic> _map, List<dynamic> _misses) {
    List<bool> values = getValues(_map, 0);
    List<bool> values1 = getValues(_map, 1);
    List<bool> values2 = getValues(_map, 2);
    List<bool> values3 = getValues(_map, 3);

    return Column(children: [
      Row(children: fillRow(false, Colors.red, 0, values)),
      Row(children: fillRow(false, Colors.green, 1, values1)),
      Row(children: fillRow(true, Colors.blue, 2, values2)),
      Row(children: fillRow(true, Colors.yellow, 3, values3)),
      Row(
        children: [
          QwixxMissField(Colors.grey, Text('Miss 1'), 0, card, _firestore,
              loggedInUser, _misses[0]),
          QwixxMissField(Colors.grey, Text('Miss 2'), 1, card, _firestore,
              loggedInUser, _misses[1]),
          QwixxMissField(Colors.grey, Text('Miss 3'), 2, card, _firestore,
              loggedInUser, _misses[2]),
          QwixxMissField(Colors.grey, Text('Miss 4'), 3, card, _firestore,
              loggedInUser, _misses[3]),
        ],
      )
    ]);
  }

  Widget scoreInfo(String crosses, String points) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: Column(
          children: [Text(crosses), Text('-------'), Text(points)],
        ),
      ),
    );
  }

  Widget fieldContent(String value) {
    return Text(
      value,
      style: const TextStyle(fontSize: 20.0),
    );
  }

  List<Widget> fillRow(bool reverse, Color color, int _row, List<bool> values) {
    List<Widget> row = [];
    int rowNumber = _row;
    if (reverse) {
      int columnNumber = 0;
      for (int i = 12; i >= 2; i--) {
        row.add(QwixxField(
            color,
            fieldContent(i.toString()),
            rowNumber,
            columnNumber,
            card,
            _firestore,
            loggedInUser,
            values[columnNumber]));
        columnNumber++;
      }
    } else {
      int columnNumber = 0;
      for (int i = 2; i <= 12; i++) {
        row.add(QwixxField(
            color,
            fieldContent(i.toString()),
            rowNumber,
            columnNumber,
            card,
            _firestore,
            loggedInUser,
            values[columnNumber]));
        columnNumber++;
      }
    }
    row.add(
      QwixxField(color, Icon(Icons.lock), rowNumber, 11, card, _firestore,
          loggedInUser, values[11]),
    );
    return row;
  }

  getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Widget getButtonText(String _p) {
    if (loggedInUser.email.toString() == _p) {
      return Text('Weitergeben an nächsten Spieler');
    }
    return Text(
        'Warte ab bis du am Zug bist und verfolge die Züge deiner Mitspieler');
  }

  @override
  void initState() {
    super.initState();
    dices = Dices();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    getCurrentUser();

    card = QwixxCard(dices, loggedInUser.email.toString());
    game = Game();
  }

  @override
  //Build Method = Das was dargestelt wird
  Widget build(BuildContext context) {
    _firestore.collection('qwixxCards').doc(loggedInUser.email).set({
      'player': loggedInUser.email.toString(),
      'score': card.convertCardtoMap(),
      'misses': card.getMisses(),
      'result': card.result()
    });

    Map<String, int> diceResultMap = dices.getResultMap();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Hello Player ' + loggedInUser.email.toString()),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10.00,
            ),
            ElevatedButton(
              onPressed: () async {
                var docRef = await _firestore.collection("qwixxGame").doc("1");
                docRef.get().then((doc) => {
                      setState(() {
                        if (!doc.exists) {
                          game.start();
                          game.setGameOwner(loggedInUser.email.toString());
                          _firestore.collection('qwixxGame').doc('1').set({
                            'players': game.getPlayers(),
                            'gameOwner': game.getGameOwner(),
                            'currentPlayer': game.getCurrentPlayer(),
                            'startet': true,
                          });
                        } else {
                          _firestore.collection('qwixxGame').doc('1').delete();
                          game.deleteAll();
                        }
                      }),
                    });
              },
              child: Text('Spiel starten oder laufendes Spiel beenden'),
            ),
            SizedBox(
              height: 10.00,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('qwixxGame').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                        child: Column(
                            children: [const Text("Loading Qwixx Game")]));
                  }
                  return Expanded(
                    child: ListView(
                      controller: ScrollController(),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        List<dynamic> players = data['players'];
                        dynamic currentPlayer = data['currentPlayer'];
                        dynamic startet = data['startet'];
                        dynamic gameOwner = data['gameOwner'];
                        return ListTile(
                          title: Center(
                            child: Text(currentPlayer + ' ist am Zug'),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        if (loggedInUser.email ==
                                            currentPlayer) {
                                          setState(() {
                                            game.next(currentPlayer);
                                            _firestore
                                                .collection('qwixxGame')
                                                .doc('1')
                                                .set({
                                              'players': game.getPlayers(),
                                              'gameOwner': game.getGameOwner(),
                                              'currentPlayer':
                                                  game.getCurrentPlayer(),
                                              'startet': true,
                                            });
                                          });
                                        }
                                      },
                                      child: getButtonText(currentPlayer)),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
            ElevatedButton(
              onPressed: () async {
                final docRef =
                    await _firestore.collection('qwixxGame').doc('1');
                docRef.get().then(
                  (DocumentSnapshot doc) async {
                    final data = await doc.data() as Map<String, dynamic>;
                    dynamic currentUser = data['currentPlayer'];
                    if (loggedInUser.email.toString() ==
                        currentUser.toString()) {
                      setState(() {
                        dices.dice();
                        //Collection 'diceResults' erstellen
                        _firestore.collection('diceResults').doc('1').set({
                          'result': diceResultMap,
                          'player': loggedInUser.email
                        });
                        //showValue();
                      });
                    }
                  },
                  onError: (e) => print("Error getting document: $e"),
                );
              },
              child: Text('Roll the Dices'),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('diceResults').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                        child:
                            Column(children: [const Text("Loading Result")]));
                  }
                  return ListView(
                    shrinkWrap: true,
                    controller: ScrollController(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      Map<String, dynamic> result =
                          data['result'] as Map<String, dynamic>;
                      return ListTile(
                          title: Center(
                            child: Text('Spieler ' +
                                data['player'] +
                                ' hat zuletzt gewürfelt: '),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  child: dice(Colors.grey,
                                      result['white1'].toString())),
                              SizedBox(width: 5.00),
                              Container(
                                  child: dice(Colors.grey,
                                      result['white2'].toString())),
                              SizedBox(width: 5.00),
                              Container(
                                  child: dice(
                                      Colors.red, result['red'].toString())),
                              SizedBox(width: 5.00),
                              Container(
                                  child: dice(Colors.green,
                                      result['green'].toString())),
                              SizedBox(width: 5.00),
                              Container(
                                  child: dice(
                                      Colors.blue, result['blue'].toString())),
                              SizedBox(width: 5.00),
                              Container(
                                  child: dice(Colors.yellow,
                                      result['yellow'].toString())),
                            ],
                          ));
                    }).toList(),
                  );
                }),
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('qwixxCards').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                        child: Column(
                            children: [const Text("Loading Qwixx Cards")]));
                  }
                  return Expanded(
                    flex: 3,
                    child: ListView(
                      controller: ScrollController(),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        Map<String, dynamic> score =
                            data['score'] as Map<String, dynamic>;
                        List<dynamic> misses = data['misses'] as List<dynamic>;
                        dynamic result = data['result'];
                        if (game.userNotInGame(data['player'])) {
                          game.addPlayer(data['player']);
                        }
                        return ListTile(
                          title: Text(data['player']),
                          subtitle: Column(
                            children: [
                              buildQwixxCard(score, misses),
                              Text(
                                'Die aktuelle Punktzahl ist ' +
                                    result.toString(),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              ElevatedButton(
                                child: Text(
                                  'Spieler ' + data['player'] + ' entfernen',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                onPressed: () async {
                                  _firestore
                                      .collection('qwixxGame')
                                      .doc('1')
                                      .delete();
                                  game.deleteAll();

                                  await _firestore
                                      .collection('qwixxCards')
                                      .doc(data['player'])
                                      .delete();
                                  if (data['player'].toString() ==
                                      loggedInUser.email.toString()) {
                                    _auth.signOut();
                                    Navigator.popAndPushNamed(
                                        context, WelcomeScreen.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
            Row(
              children: [
                scoreInfo('Kreuze', 'Punkte'),
                scoreInfo('1x', '1'),
                scoreInfo('2x', '3'),
                scoreInfo('3x', '6'),
                scoreInfo('4x', '10'),
                scoreInfo('5x', '15'),
                scoreInfo('6x', '21'),
                scoreInfo('7x', '28'),
                scoreInfo('8x', '36'),
                scoreInfo('9x', '45'),
                scoreInfo('10x', '55'),
                scoreInfo('11x', '66'),
                scoreInfo('12x', '78'),
                scoreInfo('Fehlwürfe je -5', 'o o o o')
              ],
            ),
            ElevatedButton(
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 30.0),
              ),
              onPressed: () async {
                await _firestore
                    .collection('qwixxCards')
                    .doc(loggedInUser.email.toString())
                    .delete();
                _auth.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
                //Get.to(const DicePage());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QwixxField extends StatefulWidget {
  Color color;
  Widget content;
  int row;
  int column;
  late QwixxCard qwixxCard;
  //Firebase Database Instanz
  var _firestore;
  //Speichert den angemeldeten User
  late User loggedInUser;

  bool ticked;

  QwixxField(this.color, this.content, this.row, this.column, this.qwixxCard,
      this._firestore, this.loggedInUser, this.ticked,
      {Key? key})
      : super(key: key);

  @override
  State<QwixxField> createState() => _QwixxFieldState();
}

class _QwixxFieldState extends State<QwixxField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            // If the button is pressed, return green, otherwise blue
            if (states.contains(MaterialState.pressed)) {
              return widget.color;
            }
            return widget.color;
          }),
        ),
        onPressed: () async {
          final docRef =
              await widget._firestore.collection('qwixxGame').doc('1');
          docRef.get().then(
            (DocumentSnapshot doc) async {
              final data = await doc.data() as Map<String, dynamic>;
              dynamic currentUser = data['currentPlayer'];
              if (widget.loggedInUser.email.toString() ==
                  currentUser.toString()) {
                setState(() {
                  widget.qwixxCard.setCross(widget.row, widget.column);
                  widget._firestore
                      .collection('qwixxCards')
                      .doc(widget.loggedInUser.email)
                      .set({
                    'player': widget.loggedInUser.email.toString(),
                    'score': widget.qwixxCard.convertCardtoMap(),
                    'misses': widget.qwixxCard.getMisses(),
                    'result': widget.qwixxCard.result()
                  });

                  if (widget.ticked) {
                    widget.ticked = false;
                  } else if (widget.qwixxCard
                      .isAllowed(widget.row, widget.column)) {
                    widget.ticked = true;
                  }
                });
              }
            },
            onError: (e) => print("Error getting document: $e"),
          );
        },
        child: Stack(
          children: [
            widget.content,
            if (widget.ticked)
              const Icon(
                Icons.check_box_outlined,
                //Null Aware Operator
                size: 20.0,
              )
          ],
        ),
      ),
    );
  }
}

class QwixxMissField extends StatefulWidget {
  Color color;
  Widget content;
  int column;
  late QwixxCard qwixxCard;
  //Firebase Database Instanz
  var _firestore;
  //Speichert den angemeldeten User
  late User loggedInUser;

  bool ticked;

  QwixxMissField(this.color, this.content, this.column, this.qwixxCard,
      this._firestore, this.loggedInUser, this.ticked,
      {Key? key})
      : super(key: key);

  @override
  State<QwixxMissField> createState() => _QwixxMissFieldState();
}

class _QwixxMissFieldState extends State<QwixxMissField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            // If the button is pressed, return green, otherwise blue
            if (states.contains(MaterialState.pressed)) {
              return widget.color;
            }
            return widget.color;
          }),
        ),
        onPressed: () async {
          final docRef =
              await widget._firestore.collection('qwixxGame').doc('1');
          docRef.get().then(
            (DocumentSnapshot doc) async {
              final data = await doc.data() as Map<String, dynamic>;

              dynamic currentUser = data['currentPlayer'];
              if (widget.loggedInUser.email.toString() ==
                  currentUser.toString()) {
                setState(() {
                  widget.qwixxCard.setMissCross(widget.column);
                  widget._firestore
                      .collection('qwixxCards')
                      .doc(widget.loggedInUser.email)
                      .set({
                    'player': widget.loggedInUser.email.toString(),
                    'score': widget.qwixxCard.convertCardtoMap(),
                    'misses': widget.qwixxCard.getMisses(),
                    'result': widget.qwixxCard.result()
                  });

                  if (widget.ticked &&
                      widget.qwixxCard.missCanBeRemoved(widget.column)) {
                    widget.ticked = false;
                  } else if (widget.qwixxCard.missCanBeSet(widget.column)) {
                    widget.ticked = true;
                  }
                });
              }
            },
            onError: (e) => print("Error getting document: $e"),
          );
        },
        child: Stack(
          children: [
            widget.content,
            if (widget.ticked)
              const Icon(
                Icons.check_box_outlined,
                //Null Aware Operator
                size: 20.0,
              )
          ],
        ),
      ),
    );
  }
}
