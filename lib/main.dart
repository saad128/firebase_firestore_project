
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_internship_project/models/user_model.dart';
import 'package:firebase_internship_project/screens/wrapper.dart';
import 'package:firebase_internship_project/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
       debugShowCheckedModeBanner: false,
        title: 'Firebase Internship Project',
        home: Wrapper(),
      ),
    );
  }
}
