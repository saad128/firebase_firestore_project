import 'package:firebase_internship_project/models/user_data_model.dart';
import 'package:firebase_internship_project/screens/home/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final usersList = Provider.of<List<UserDataModel>>(context);
    return ListView.builder(
        itemCount: usersList.length,
        itemBuilder: (context, index) {
          return UserTile(
            userDataModel: usersList[index],
          );
        });
  }
}
