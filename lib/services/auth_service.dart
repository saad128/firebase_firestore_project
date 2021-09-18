import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_internship_project/models/user_model.dart';
import 'package:firebase_internship_project/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase User
  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
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

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email,password and some extra arguments

  Future registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    DateTime date,
    File imagePicked,
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
      return null;
    }
  }

}
