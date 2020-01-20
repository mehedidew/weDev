import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'main.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  bool spinner = false;
  String email, password, firstName, lastName;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Card(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                color: Colors.purple[100],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Email :",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black)),
                        onChanged: (text) {
                          email = text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                color: Colors.purple[100],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Password :",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black)),
                        onChanged: (text) {
                          password = text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                color: Colors.purple[100],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "First Name :",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black)),
                        onChanged: (text) {
                          firstName = text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                color: Colors.purple[100],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Last Name :",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black)),
                        onChanged: (text) {
                          lastName = text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ButtonTheme(
                  minWidth: 270,
                  height: 55,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                      setState(() {
                        spinner = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        print(newUser.user.uid);
                        if (newUser != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomePage()));
                        }
                        setState(() {
                          spinner = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
