import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_internship_project/models/user_model.dart';
import 'package:firebase_internship_project/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase User
  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // code of show dialog box

  Future<void> _showMyDialog(BuildContext context, String error) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error Message'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(error),
                  //Text(error),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  // upload the image
  Future<String> uploadFile(File image) async {
    String downloadURL;
    String postId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('profiles')
        .child('post_$postId.png');
    await ref.putFile(image);
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  // sign in with email & password

  Future signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return _showMyDialog(context, e.toString().substring(30));
    }
  }

  // register with email,password and some extra arguments

  Future registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    DateTime date,
    File imagePicked,
    BuildContext context,
  ) async {
    try {
      String image = await uploadFile(imagePicked);
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user!;
      await DatabaseService(uid: user.uid).updateUserData(name, date, image);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return _showMyDialog(context, e.toString().substring(37));
    }
  }
}
