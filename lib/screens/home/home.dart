import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_internship_project/models/user_data_model.dart';
import 'package:firebase_internship_project/models/user_model.dart';
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

  bool searchName = false;


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
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('Users List'),
        elevation: 0.0,
        backgroundColor: Colors.purple[400],
        automaticallyImplyLeading: false,
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
      body: StreamBuilder<List<UserDataModel>>(
        initialData: [],
        stream: getAllUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<UserDataModel> userData = snapshot.data;
            return Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    onTap: () {
                      showSearch(
                          context: context,
                          delegate: SearchDelegateWidget(userData));
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: userData.length,
                      itemBuilder: (context, index) {
                        UserDataModel users = userData[index];
                        // userData = users;
                        Timestamp timestamp = users.date!;
                        DateTime dateTime = DateTime.parse(
                          timestamp.toDate().toString(),
                        );
                        var userDate = DateFormat.yMMMd().format(dateTime);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Card(
                            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25.0,
                                backgroundImage:
                                    NetworkImage(users.imagePicked!),
                              ),
                              title: Text(users.name!),
                              subtitle: Text(userDate.toString()),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}

class SearchDelegateWidget extends SearchDelegate<UserDataModel> {
  List<UserDataModel> userList;

  SearchDelegateWidget(this.userList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<IsUserModel> allUserName = userList
        .where((e) => e.name!.toLowerCase().contains(query.toLowerCase()))
        .cast<IsUserModel>()
        .toList();

    return ListView.builder(
        itemCount: allUserName.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${allUserName[index]}'),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList =
        userList.where((e) => e.name!.toLowerCase().startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            print(suggestionList[index]);
            close(context, suggestionList[index]);
          },
          leading: Icon(Icons.person),
          title: RichText(
            text: TextSpan(
                text: suggestionList[index].name!.substring(0, query.length),
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: suggestionList[index].name!.substring(query.length),
                    style: TextStyle(color: Colors.grey),
                  ),
                ]),
          ),
        );
      },
    );
  }
}
