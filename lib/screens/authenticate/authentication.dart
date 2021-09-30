import 'package:firebase_internship_project/screens/authenticate/register.dart';
import 'package:firebase_internship_project/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
class Authentication extends StatefulWidget {

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? SignIn(toggleView: toggleView)
        : Register(toggleView: toggleView);
  }
}
