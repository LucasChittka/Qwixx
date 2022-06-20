import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dice extends StatelessWidget {
  Dice(this.color, this.value);
  Color color = Colors.red;
  String value = "";

  Widget eye(Color _c) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(color: _c, shape: BoxShape.circle),
    );
  }

  Widget dice(Color _c, int _v) {
    Widget rightDice = Container();
    switch (value) {
      case "1":
        rightDice = Expanded(
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
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
            ),
          ),
        );
        break;
      case "2":
        rightDice = Expanded(
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
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
            ),
          ),
        );
        break;
      case "3":
        rightDice = Expanded(
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
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
            ),
          ),
        );
        break;
      case "4":
        rightDice = Expanded(
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
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
            ),
          ),
        );
        break;
      case "5":
        rightDice = Expanded(
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
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
            ),
          ),
        );
        break;
      case "6":
        rightDice = Expanded(
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
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
            ),
          ),
        );
        break;
    }
    return rightDice;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
