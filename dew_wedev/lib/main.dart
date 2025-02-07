import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'registerPage.dart';
import 'secondPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.green, accentColor: Colors.greenAccent),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String email, password;
  bool spinner = false;

  Animation animation;
  AnimationController animationController;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    animationController.forward();

    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.green[50],
                body: Transform(
                  transform:
                      Matrix4.translationValues(animation.value * width, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LimitedBox(
                        maxHeight: 100,
                        maxWidth: 100,
                        child: Image.asset(
                          'images/wedev.png',
                          width: 200,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 50, right: 50, top: 50),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(width: 20),
                              ),
                              hintText: "Email"),
                          onChanged: (text) {
                            email = text;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 50, right: 50, top: 20),
                        child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(width: 20),
                                ),
                                hintText: "Password"),
                            onChanged: (text1) {
                              password = text1;
                            }),
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
                                    await _auth.signInWithEmailAndPassword(
                                        email: email, password: password);
                                if (newUser != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SecondPage()));
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
                              "Login",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Register()));
                          },
                          child: Text(
                            'Create an Account',
                            textAlign: TextAlign.end,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
