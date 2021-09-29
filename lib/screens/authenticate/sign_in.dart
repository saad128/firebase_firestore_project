import 'package:firebase_internship_project/screens/authenticate/register.dart';
import 'package:firebase_internship_project/services/auth_service.dart';
import 'package:firebase_internship_project/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  AuthService _auth = AuthService();

  String email = '';
  String password = '';
  //String error = '';
  bool loading = false;

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error Message'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Could not sign in with those credentials'),
                  Text('Please enter valid credentials '),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.purple[50],
            appBar: AppBar(
              backgroundColor: Colors.purple[400],
              elevation: 0.0,
              title: Text('Sign in to Firebase App'),
              automaticallyImplyLeading: false,
              actions: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Email'),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) => setState(() => email = val),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Password'),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter a password 6+ char long' : null,
                      onChanged: (val) => setState(() => password = val),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            _showMyDialog(context);
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple[400],
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    // hello world
                    // Text(
                    //   error,
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 14.0,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
  }
}
