import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_internship_project/models/user_data_model.dart';

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

  Stream<List<UserDataModel>> getAllUsers() {
    Stream<QuerySnapshot<Object?>> querySnapshot =
        FirebaseFirestore.instance.collection('users').snapshots();

    Stream<List<UserDataModel>> test = querySnapshot.map((document) {
      return document.docs.map((e) {
        return UserDataModel.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
    return test;
  }

  createChatRoom(String chatRoomId, chatMap) {
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .set(chatMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessage(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time',descending: true)
        .snapshots();
  }
}
