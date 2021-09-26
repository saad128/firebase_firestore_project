import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  String? name;
  Timestamp? date;
  String? imagePicked;

  UserDataModel({this.name, this.date, this.imagePicked});


  UserDataModel.fromJson(Map<String, dynamic> json)
      : this(
      name: json['name']! as String,
      imagePicked: json['imagePicked']! as String,
      date: json['date']! as Timestamp);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageName': imagePicked,
      'date': date,
    };
  }

}