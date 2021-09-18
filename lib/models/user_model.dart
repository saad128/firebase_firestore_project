
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  UserModel({this.uid});
}


class IsUserModel {
  String? uid;
  String? name;
  Timestamp? date;
  String? imagePicked;

  IsUserModel({this.uid, this.name ,this.date,this.imagePicked});
}