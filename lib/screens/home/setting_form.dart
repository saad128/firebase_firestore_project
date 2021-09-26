import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_internship_project/models/user_model.dart';
import 'package:firebase_internship_project/services/database.dart';
import 'package:firebase_internship_project/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  String? _currentName;
  DateTime? _updatedDate;

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel?>(context);
    print(user!.uid);
    return StreamBuilder<DocumentSnapshot>(
      initialData: null,
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot _data = snapshot.data;

          Timestamp timestamp = _data.get('date');
          DateTime dateTime = DateTime.parse(
            timestamp.toDate().toString(),
          );
          var userDate = DateFormat.yMMMd().format(dateTime);
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update Your Profile',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 15.0),
                  CircleAvatar(
                    radius: 35.0,
                    backgroundImage: NetworkImage(_data.get('imagePicked')),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    initialValue: _data.get('name'),
                    decoration: InputDecoration(hintText: 'name'),
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() {
                      _currentName = val;
                    }),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    height: 52.0,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: Colors.black38)),
                      //borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: _updatedDate == null
                              ? dateTime
                              : _updatedDate!,
                          firstDate: DateTime(1920),
                          lastDate: DateTime.now(),

                        ).then((val) {
                          setState(() {
                            _updatedDate = val!;
                          });
                        });
                      },
                      child: Text(
                        _updatedDate == null
                            ? userDate
                            : _updatedDate!.toString().substring(0,10),
                        style: TextStyle(color: Colors.black87,fontSize:
                        15.0),
                      ),
                    ),
                  ),

                  SizedBox(height: 25.0),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink[400],
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                            _currentName ?? _data.get('name'),
                            _updatedDate ?? dateTime,
                            _data.get('imagePicked'),
                          );
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            ),
          );
        } else if (snapshot.data == null) {
          return Center(child: Text('There is no users'));
        } else {
          return Loading();
        }
      },
    );
  }
}


