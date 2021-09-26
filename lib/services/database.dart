
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_internship_project/models/user_data_model.dart';
import 'package:firebase_internship_project/models/user_model.dart';

class DatabaseService {

  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, DateTime date, String imagePicked) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'date': date,
      'imagePicked': imagePicked,
    });
  }

  List<UserDataModel> _userListFromSnapshot(QuerySnapshot snapshot) {

    return snapshot.docs.map((doc) {
      return UserDataModel(
        name: doc['name'] ?? '',
        date: doc['date'] ?? '',
        imagePicked: doc['imagePicked'] ?? '',
      );
    }).toList();

  }
  Stream<List<UserDataModel>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  IsUserModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return IsUserModel(
      uid: uid,
      name: snapshot['name'],
      date: snapshot['date'],
      imagePicked: snapshot['imagePicked'],
    );
  }

  Stream<IsUserModel> get userResponse {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
