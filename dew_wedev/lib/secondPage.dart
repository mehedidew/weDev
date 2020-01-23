import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  bool enable = false;
  bool visible = true;
  FirebaseUser loggedInUser;
  String firstName, lastName;
  bool spinner = true;
  var doc;
  bool update = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Update Info'),
            backgroundColor: Colors.green,
            leading: Container(),
          ),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 5),
                      color: Colors.green[100],
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
                            flex: 2,
                            child: TextField(
                              enabled: enable,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: firstName,
                                  hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.black)),
                              onChanged: (text) {
                                firstName = text;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 5),
                      color: Colors.green[100],
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
                            flex: 2,
                            child: TextField(
                              enabled: enable,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: lastName,
                                  hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.black)),
                              onChanged: (text) {
                                lastName = text;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Visibility(
                        visible: visible,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (enable == false) {
                                  enable = true;
                                } else {
                                  enable = false;
                                }
                                if (visible == true) {
                                  visible = false;
                                } else {
                                  visible = true;
                                }
                              });
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              shadowColor: Colors.greenAccent,
                              color: Colors.lightBlue,
                              elevation: 7,
                              child: Center(
                                  child: Image.asset(
                                'images/pencil-edit-button.png',
                                color: Colors.white,
                                width: 20,
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Visibility(
                        visible: !visible,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          width: 100,
                          height: 40,
                          child: GestureDetector(
                            onTap: () async {
                              _firestore
                                  .collection('users')
                                  .document(loggedInUser.uid)
                                  .updateData({
                                'firstName': firstName,
                                'lastName': lastName
                              }).then((_) {
                                setState(() {
                                  update = true;
                                });
                                showToastForUser();
                              }).catchError((_) {
                                setState(() {
                                  update = false;
                                });
                                showToastForUser();
                              });

                              setState(() {
                                if (enable == false) {
                                  enable = true;
                                } else {
                                  enable = false;
                                }
                                if (visible == true) {
                                  visible = false;
                                } else {
                                  visible = true;
                                }
                              });
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              shadowColor: Colors.greenAccent,
                              color: Colors.lightBlue,
                              elevation: 7,
                              child: Center(
                                  child: Text(
                                'Save',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned.directional(
                  textDirection: TextDirection.ltr,
                  bottom: 20,
                  end: 20,
                  start: 20,
                  child: Center(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        getInfo();
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  showToastForUser() async {
    if (update == true) {
      Fluttertoast.showToast(
        msg: "Updated Info",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        gravity: ToastGravity.CENTER,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Coudn't Update Info",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<bool> _onBackPressed() {
    return null;
  }

  void getInfo() async {
    _firestore.collection('users').document(loggedInUser.uid).get().then((val) {
      setState(() {
        this.firstName = val.data['firstName'];
        this.lastName = val.data['lastName'];
        spinner = false;
      });
    });
  }
}
