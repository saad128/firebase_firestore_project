import 'dart:io';
import 'package:firebase_internship_project/services/auth_service.dart';
import 'package:firebase_internship_project/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {

  final Function toggleView;

  Register({required this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String name = '';
  DateTime? _dateTime;
  String? imageError;

  File? pickedImage;

  Color? color;

  final _picker = ImagePicker();

  _pickImgFromCamera() async {
    var image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  _pickImgFromGallery() async {
    var image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    _pickImgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _pickImgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // show the Dialog Box in case of error


  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text('Sign up to Firebase App'),
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: Text(
              'Sign In',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                CircleAvatar(
                  radius: 45.0,
                  backgroundColor: Colors.purple[400],
                  foregroundImage: pickedImage != null
                      ? FileImage(pickedImage!)
                      : null,
                  child: IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _showPicker(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Name'),
                  validator: (val) =>
                  val!.isEmpty ? 'Enter a name' : null,
                  onChanged: (val) => setState(() => name = val),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (val) =>
                  val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Password'),
                  validator: (val) =>
                  val!.length < 6
                      ? 'Enter a password 6+ '
                      'chars long'
                      : null,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  obscureText: true,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.infinity,
                  height: 52.0,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1.0, color: Colors.black38)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: _dateTime == null
                            ? DateTime.now()
                            : _dateTime!,
                        firstDate: DateTime(1920),
                        lastDate: DateTime.now(),
                      ).then((val) {
                        setState(() {
                          _dateTime = val!;
                        });
                      });
                    },
                    child: Text(
                      _dateTime == null
                          ? 'Picked Date of Birth'
                          : _dateTime!.toString().substring(0, 10),
                      style: TextStyle(
                          color: Colors.black87, fontSize: 15.0),
                    ),
                  ),
                ),

                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _dateTime
                        != null && pickedImage != null) {


                      setState(() {
                        loading = true;
                      });
                      await _auth.registerWithEmailAndPassword(
                        email,
                        password,
                        name,
                        _dateTime!,
                        pickedImage!,
                        context,
                      );
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple[400],
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
