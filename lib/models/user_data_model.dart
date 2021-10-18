import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  String? uid;
  String? name;
  Timestamp? date;
  String? imagePicked;

  UserDataModel({this.uid,this.name, this.date, this.imagePicked});


  UserDataModel.fromJson(Map<String, dynamic> json)
      : this(
    uid: json['userId']! as String,
      name: json['name']! as String,
      imagePicked: json['imagePicked']! as String,
      date: json['date']! as Timestamp);

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'imageName': imagePicked,
      'date': date,
    };
  }

}