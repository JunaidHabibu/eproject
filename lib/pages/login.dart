//Login page
//email : cat@gmail.com
//password : 123456

//As it is there is no sign up page
//this is because realistically you have to be added by an administrator to the system

import 'package:eproject/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController(); // creating new controller for inputting the users email
  final TextEditingController _passwordController = TextEditingController(); // creating new controller for inputting the users password

  String _error = ""; // error message
  bool _isLoading = false; // is loading

  final FirebaseAuth _auth = FirebaseAuth.instance; // creating a new firebase authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // creating a new firestore instance

  void login() async { // login function
    setState(() { // setting states
      _isLoading = true;
      _error = "";
    });

    try {
      // login in with Firebase Auth
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // get user data from firestore / wont block if user(s) is missing
      Map<String, dynamic>? userData;
      try {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .get();
        if (userDoc.exists) {
          userData = userDoc.data() as Map<String, dynamic>?;
        }
      } catch (_) {
        // firestore fetch failed, continue anyway
      }

      if (!mounted) return;

      //if login was successful redirect user to the homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(userData: userData)), // redirect to the home page with user data as ann argument
      );

    } on FirebaseAuthException catch (e) { // firebase error catching
      setState(() {
        _error = switch (e.code) { // switch statement changing the error message for diffrent firebase exceptions
          'user-not-found' => 'No account found with that email.',
          'wrong-password' => 'Incorrect password.',
          'invalid-email' => 'Please enter a valid email.',
          'too-many-requests' => 'Too many attempts. Try again later.',
          _ => 'Login failed (${e.code})',  // shows any error code
        };
      });
    } catch (e) {
      // catches any other unexpected errors
      setState(() {
        _error = 'Something went wrong: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) { // building ui
    return Scaffold(
      appBar: AppBar(title: const Text("Login")), // app topbar

      body: Center( // main body
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  )
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true, //for hideing inputted password (most modern webpages do this)
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  )
                ),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _isLoading ? null : login,
                child: _isLoading
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white), // create circular progress bar when loading
                      )
                    : const Text("Login"),
              ),
              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(_error, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}