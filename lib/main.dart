import 'package:eproject/firebase_options.dart';
import 'package:eproject/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eproject/classes/AppTheme.dart';
import 'package:eproject/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp( // Firebase initalization
    options: DefaultFirebaseOptions.currentPlatform
  );

  // session tracking (check if users already logged in)
  User? user = FirebaseAuth.instance.currentUser;

  //application run
  runApp(MaterialApp(
    theme: AppTheme.dark, //setting the application theme to the custom created theme
    home: user != null ? Home(userData: null) : Login(), // check if users still part of the session and either redirects to Login or Home
  ));
}