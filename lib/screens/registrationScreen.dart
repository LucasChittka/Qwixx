import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qwixx_game/screens/gameScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  String name = '';
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
                keyboardType: TextInputType.emailAddress,
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
              padding: EdgeInsets.all(20.0),
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
                'Register',
                style: TextStyle(fontSize: 30.0),
              ),
              onPressed: () async {
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    Navigator.pushNamed(context, GameScreen.id);
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }
                //Get.to(const DicePage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
