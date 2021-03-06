import 'package:firebase_internship_project/services/auth_service.dart';
import 'package:firebase_internship_project/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;

  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  AuthService _auth = AuthService();

  String email = '';
  String password = '';
  bool loading = false;


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
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Register()));
                    widget.toggleView();
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
                              await _auth.signInWithEmailAndPassword(
                            email,
                            password,
                            context,
                          );
                          setState(() {
                            loading = false;
                          });
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
                  ],
                ),
              ),
            ),
          );
  }
}
