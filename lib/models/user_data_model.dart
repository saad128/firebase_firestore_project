import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  String? name;
  Timestamp? date;
  String? image;

  UserDataModel({this.name ,this.date,this.image});

  UserDataModel.fromJson(Map<String,dynamic> parsedJSON)
      : name = parsedJSON['name'],
        date = parsedJSON['date'],
        image = parsedJSON['image'];
}