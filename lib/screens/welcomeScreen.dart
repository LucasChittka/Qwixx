import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qwixx_game/screens/registrationScreen.dart';
import 'package:qwixx_game/screens/gameScreen.dart';

import 'loginScreen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Qwixx Game'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 30.0),
              ),
              onPressed: () async {
                await Navigator.pushNamed(context, LoginScreen.id,
                    arguments: name);
              },
            ),
            ElevatedButton(
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 30.0),
              ),
              onPressed: () async {
                await Navigator.pushNamed(context, RegistrationScreen.id,
                    arguments: name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
