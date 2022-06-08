//Alle Widgets wie Buttons, AppBars etc.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qwixx_game/screens/loginScreen.dart';
import 'package:qwixx_game/screens/gameScreen.dart';
import 'package:qwixx_game/screens/registrationScreen.dart';
import 'package:qwixx_game/screens/welcomeScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(MaterialApp(
    //Flutter Themes
    theme: ThemeData(),
    routes: {
      WelcomeScreen.id: (context) => const WelcomeScreen(),
      LoginScreen.id: (context) => const LoginScreen(),
      RegistrationScreen.id: (context) => const RegistrationScreen(),
      GameScreen.id: (context) => const GameScreen(),
    },
    home: WelcomeScreen(),
  ));
}
