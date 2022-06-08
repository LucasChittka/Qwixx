import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qwixx_game/screens/gameScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Qwixx'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                onChanged: (input) {
                  email = input;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                onChanged: (input) {
                  password = input;
                },
              ),
            ),
            ElevatedButton(
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 30.0),
              ),
              onPressed: () async {
                try {
                  await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  Navigator.pushNamed(context, GameScreen.id);
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
