import 'package:firebase_internship_project/models/user_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {

  final UserDataModel? userDataModel;
  UserTile({this.userDataModel});


  @override
  Widget build(BuildContext context) {
    // Timestamp timeStamp = userDataModel!.date as Timestamp;
    // DateTime dateTime = DateTime.parse(timeStamp.toDate().toString());
    // var userDoB = DateFormat.yMMMd().format(dateTime);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage('${userDataModel!.imagePicked}'),
          ),
          title: Text('${userDataModel!.name}'),
          subtitle: Text('${userDataModel!.date!.toDate().toString()}'),
        ),
      ),
    );
  }
}
