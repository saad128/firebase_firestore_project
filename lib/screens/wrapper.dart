import 'package:firebase_internship_project/models/user_model.dart';
import 'package:firebase_internship_project/screens/authenticate/authentication.dart';
import 'package:firebase_internship_project/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if(user == null) {
      return Authentication();
    }else{
      return Home();
    }
  }
}
