import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  String firstName, lastName;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
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
                          hintText: firstName,
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
              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
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
                          hintText: lastName,
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: ButtonTheme(
                  minWidth: 150,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                      _auth.signOut();
                      Navigator.pop(context);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text(
                      "Log Out",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
            FlatButton(
              child: Text('click'),
              onPressed: () {
                getInfo();
              },
            )
          ],
        ),
      ),
    );
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void getInfo() async {
    _firestore.collection('users').document(loggedInUser.uid).get().then((val) {
      setState(() {
        this.firstName = val.data['firstName'];
        this.lastName = val.data['lastName'];
      });
    });
  }
}
