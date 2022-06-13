import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qwixx_game/screens/welcomeScreen.dart';

import '../components/dices.dart';
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

  @override
  void initState() {
    super.initState();
    dices = Dices();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    getCurrentUser();
    card = QwixxCard(dices, loggedInUser.email.toString());
  }

  @override
  //Build Method = Das was dargestelt wird
  Widget build(BuildContext context) {
    _firestore.collection('qwixxCards').doc(loggedInUser.email).set({
      'player': loggedInUser.email.toString(),
      'score': card.convertCardtoMap(),
      'misses': card.getMisses()
    });
    List<String> diceResultString = dices.getResultString();
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
            Expanded(
              //Gesture Detector
              //Reagiert auf User Interaction bezüglich des Widgets
              child: TextButton(
                onPressed: () {
                  setState(() {
                    dices.dice();

                    //Collection 'diceResults' erstellen
                    _firestore.collection('diceResults').doc('1').set({
                      'result': diceResultMap,
                      'player': loggedInUser.email
                    });
                    //showValue();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                          color: Colors.grey,
                          child: Image.asset(
                              'images/dice' + diceResultString[0] + '.png')),
                    ),
                    Expanded(
                      child: Container(
                          color: Colors.grey,
                          child: Image.asset(
                              'images/dice' + diceResultString[1] + '.png')),
                    ),
                    Expanded(
                      child: Container(
                          color: Colors.red,
                          child: Image.asset(
                              'images/dice' + diceResultString[2] + '.png')),
                    ),
                    Expanded(
                      child: Container(
                          color: Colors.green,
                          child: Image.asset(
                              'images/dice' + diceResultString[3] + '.png')),
                    ),
                    Expanded(
                      child: Container(
                          color: Colors.blue,
                          child: Image.asset(
                              'images/dice' + diceResultString[4] + '.png')),
                    ),
                    Expanded(
                      child: Container(
                          color: Colors.yellow,
                          child: Image.asset(
                              'images/dice' + diceResultString[5] + '.png')),
                    ),
                  ],
                ),
              ),
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
                          title: Text('Spieler \'' +
                              data['player'] +
                              '\' hat gewürfelt: '),
                          subtitle: Row(
                            children: [
                              Text('Weiß: ' + result['white1'].toString()),
                              Text(', Weiß: ' + result['white2'].toString()),
                              Text(', Rot: ' + result['red'].toString()),
                              Text(', Grün: ' + result['green'].toString()),
                              Text(', Blau: ' + result['blue'].toString()),
                              Text(', Gelb: ' + result['yellow'].toString()),
                            ],
                          ));
                    }).toList(),
                  );
                }),

            // Column(children: [
            //   Row(children: fillRow(false, Colors.red, 0)),
            //   Row(children: fillRow(false, Colors.green, 1)),
            //   Row(children: fillRow(true, Colors.blue, 2)),
            //   Row(children: fillRow(true, Colors.yellow, 3)),
            //   Row(
            //     children: [
            //       scoreInfo('Kreuze', 'Punkte'),
            //       scoreInfo('1x', '1'),
            //       scoreInfo('2x', '3'),
            //       scoreInfo('3x', '6'),
            //       scoreInfo('4x', '10'),
            //       scoreInfo('5x', '15'),
            //       scoreInfo('6x', '21'),
            //       scoreInfo('7x', '28'),
            //       scoreInfo('8x', '36'),
            //       scoreInfo('9x', '45'),
            //       scoreInfo('10x', '55'),
            //       scoreInfo('11x', '66'),
            //       scoreInfo('12x', '78'),
            //       scoreInfo('Fehlwürfe je -5', 'o o o o')
            //     ],
            //   )
            // ]),
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
                    child: ListView(
                      controller: ScrollController(),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        Map<String, dynamic> score =
                            data['score'] as Map<String, dynamic>;
                        List<dynamic> misses = data['misses'] as List<dynamic>;
                        return ListTile(
                          title: Text(data['player']),
                          subtitle: Column(
                            children: [
                              buildQwixxCard(score, misses),
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

// class QwixxCard1 extends StatelessWidget {
//   QwixxCard1({Key? key}) : super(key: key);
//
//   List<Widget> fillRow(bool reverse, Color color) {
//     List<Widget> row = [];
//     if (reverse) {
//
//       for (int i = 12; i >= 2; i--) {
//         row.add(QwixxField(color, FieldContent(i.toString()),));
//       }
//     } else {
//       for (int i = 2; i <= 12; i++) {
//         row.add(QwixxField(color, FieldContent(i.toString())));
//       }
//     }
//     row.add(
//       QwixxField(
//         color,
//         Icon(Icons.lock),
//       ),
//     );
//     return row;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       Row(children: fillRow(false, Colors.red)),
//       Row(children: fillRow(false, Colors.green)),
//       Row(children: fillRow(true, Colors.blue)),
//       Row(children: fillRow(true, Colors.yellow)),
//       Row(
//         children: [
//           ScoreInfo('Kreuze', 'Punkte'),
//           ScoreInfo('1x', '1'),
//           ScoreInfo('2x', '3'),
//           ScoreInfo('3x', '6'),
//           ScoreInfo('4x', '10'),
//           ScoreInfo('5x', '15'),
//           ScoreInfo('6x', '21'),
//           ScoreInfo('7x', '28'),
//           ScoreInfo('8x', '36'),
//           ScoreInfo('9x', '45'),
//           ScoreInfo('10x', '55'),
//           ScoreInfo('11x', '66'),
//           ScoreInfo('12x', '78'),
//           ScoreInfo('Fehlwürfe je -5', 'o o o o')
//         ],
//       )
//     ]);
//   }
// }

// class Methods {
//   Widget scoreInfo(String crosses, String points) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
//         child: Column(
//           children: [Text(crosses), Text('-------'), Text(points)],
//         ),
//       ),
//     );
//   }
//
//   Widget fieldContent(String value) {
//     return Text(
//       value,
//       style: const TextStyle(fontSize: 20.0),
//     );
//   }
//
//   List<Widget> fillRow(bool reverse, Color color) {
//     List<Widget> row = [];
//     if (reverse) {
//       for (int i = 12; i >= 2; i--) {
//         row.add(QwixxField(color, FieldContent(i.toString())));
//       }
//     } else {
//       for (int i = 2; i <= 12; i++) {
//         row.add(QwixxField(color, FieldContent(i.toString())));
//       }
//     }
//     row.add(
//       QwixxField(
//         color,
//         Icon(Icons.lock),
//       ),
//     );
//     return row;
//   }
// }
//
// class ScoreInfo extends StatelessWidget {
//   String crosses;
//   String points;
//   ScoreInfo(this.crosses, this.points);
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
//         child: Column(
//           children: [Text(crosses), Text('-------'), Text(points)],
//         ),
//       ),
//     );
//   }
// }
//
// class FieldContent extends StatelessWidget {
//   String value;
//   FieldContent(this.value, {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       value,
//       style: const TextStyle(fontSize: 20.0),
//     );
//   }
// }

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
        onPressed: () {
          setState(() {
            widget.qwixxCard.setCross(widget.row, widget.column);
            widget._firestore
                .collection('qwixxCards')
                .doc(widget.loggedInUser.email)
                .set({
              'player': widget.loggedInUser.email.toString(),
              'score': widget.qwixxCard.convertCardtoMap(),
              'misses': widget.qwixxCard.getMisses()
            });

            if (widget.ticked) {
              widget.ticked = false;
            } else if (widget.qwixxCard.isAllowed(widget.row, widget.column)) {
              widget.ticked = true;
            }
          });
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
        onPressed: () {
          setState(() {
            widget.qwixxCard.setMissCross(widget.column);
            widget._firestore
                .collection('qwixxCards')
                .doc(widget.loggedInUser.email)
                .set({
              'player': widget.loggedInUser.email.toString(),
              'score': widget.qwixxCard.convertCardtoMap(),
              'misses': widget.qwixxCard.getMisses()
            });

            if (widget.ticked &&
                widget.qwixxCard.missCanBeRemoved(widget.column)) {
              widget.ticked = false;
            } else if (widget.qwixxCard.missCanBeSet(widget.column)) {
              widget.ticked = true;
            }
          });
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
