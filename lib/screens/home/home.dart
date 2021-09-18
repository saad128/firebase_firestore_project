import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_internship_project/screens/authenticate/sign_in.dart';
import 'package:firebase_internship_project/screens/home/setting_form.dart';
import 'package:firebase_internship_project/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.3,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              child: SettingForm(),
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('Users List'),
        elevation: 0.0,
        backgroundColor: Colors.purple[400],
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignIn(),
                      )));
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: Text(
              'logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Future.delayed(Duration(seconds: 2), () {
                _showSettingsPanel();
              });
            },
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            label: Text(
              'settings ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        initialData: [],
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot _users = snapshot.data.docs[index];
                  Timestamp timestamp = _users.get('date');
                  DateTime dateTime = DateTime.parse(
                    timestamp.toDate().toString(),
                  );
                  var userDate = DateFormat.yMMMd().format(dateTime);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Card(
                      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: CircleAvatar(
                            radius: 25.0,
                            child: Image.network(_users.get('imagePicked'),fit:
                            BoxFit.cover),
                          ),
                        ),
                        title: Text(_users.get('name')),
                        subtitle: Text(userDate.toString()),
                      ),
                    ),
                  );
                });
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
