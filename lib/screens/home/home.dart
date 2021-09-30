import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_internship_project/models/user_data_model.dart';
import 'package:firebase_internship_project/screens/home/setting_form.dart';
import 'package:firebase_internship_project/services/database.dart';
import 'package:firebase_internship_project/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseService _databaseService = DatabaseService();

  List<UserDataModel> userData = [];

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
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.purple[400],
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
              ),
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
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<UserDataModel>>(
        initialData: [],
        stream: _databaseService.getAllUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            userData = snapshot.data;
            return ListView.builder(
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
                          backgroundImage: NetworkImage(users.imagePicked!),
                        ),
                        title: Text(users.name!),
                        subtitle: Text(userDate.toString()),
                      ),
                    ),
                  );
                });
          } else {
            return Loading();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        label: Text('Search'),
        onPressed: () async {
          final result = await showSearch<UserDataModel>(
              context: context, delegate: SearchDelegateWidget(userData));
          print(result);
        },
        icon: Icon(Icons.search),
        backgroundColor: Colors.purple[400],
        heroTag: 'searchTag',
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
      onPressed: () {
        // close(context, userList.elementAt());
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<UserDataModel> allUserName =
        userList.where((e) => e.name!.toLowerCase().contains(query)).toList();
    return ListView(
      children: allUserName
          .map<ListTile>((a) => ListTile(
                title: Text(a.name!),
                leading: Icon(Icons.person),
                onTap: () {
                  close(context, a);
                },
              ))
          .toList(),
    );

    // return ListView.builder(
    //     itemCount: allUserName.length,
    //     itemBuilder: (context, index) {
    //       return ListTile(
    //         title: Text('${allUserName[index]}'),
    //         onTap: () {
    //           //result = allUserName.elementAt(index) as String?;
    //           // close(context, result);
    //         },
    //         leading: Icon(Icons.person),
    //       );
    //     });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList =
        userList.where((e) => e.name!.toLowerCase().contains(query)).toList();

    return ListView(
      children: suggestionList
          .map<ListTile>((a) => ListTile(
                title: RichText(
                  text: TextSpan(
                      text: a.name!.substring(0, query.length),
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      children: [
                        TextSpan(
                          text: a.name!.substring(query.length),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ]),
                ),
                //leading: Icon(Icons.person),
                onTap: () {
                  query = a.name!;
                },
              ))
          .toList(),
    );
  }
}

// build suggestion code with stream builder

// return StreamBuilder<List<UserDataModel>>(
//   stream: getAllUsers(),
//   builder: (BuildContext context, AsyncSnapshot<List<UserDataModel>>snapshot) {
//       if(!snapshot.hasData) {
//         return Center(
//           child: Text('No Data'),
//         );
//       }
//       final suggestionList =
//       snapshot.data!.where((e) => e.name!.toLowerCase().startsWith(query))
//           .toList();
//
//       return ListView.builder(
//         itemCount: suggestionList.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//                     onTap: () {
//                       query = suggestionList.elementAt(index) as String;
//                     },
//                     leading: Icon(Icons.person),
//                     title: RichText(
//                       text: TextSpan(
//                           text: suggestionList[index].name!.substring(0,
//                               query.length),
//                           style: TextStyle(
//                             color: Colors.black,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: suggestionList[index].name!.substring(query.length),
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ]),
//                     ),
//                   );
//         },
//       );
//   },
// );

// build suggestion code with listview builder

// return ListView.builder(
//   itemCount: suggestionList.length,
//   itemBuilder: (context, index) {
//     return ListTile(
//       onTap: () {
//         // print(suggestionList[index]);
//         // close(context, suggestionList[index]);
//         query = suggestionList[index].name!;
//       },
//       // leading: Icon(Icons.person),
//       title: RichText(
//         text: TextSpan(
//             text: suggestionList[index].name!.substring(0, query.length),
//             style: TextStyle(
//               color: Colors.black,
//             ),
//             children: [
//               TextSpan(
//                 text: suggestionList[index].name!.substring(query.length),
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ]),
//       ),
//     );
//   },
// );
