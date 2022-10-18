import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/openingScreens/first_time_login.dart';
import 'package:gymchimp/openingScreens/home_page.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:gymchimp/openingScreens/sign_up_page.dart';
import '../firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPage();
}

void toHomePage(BuildContext ctx, int page) {
  Navigator.of(ctx).push(
      MaterialPageRoute(builder: (context) => HomePage(selectedIndex: page)));
}

void logOutUser(BuildContext ctx) {
  Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => FirstLogIn()));
  final auth = FirebaseAuth.instance;
  auth.signOut();
}

class _StartPage extends State<StartPage> {
  var user = FirebaseAuth.instance.currentUser;
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color.fromARGB(233, 228, 240, 255),
                Color.fromARGB(211, 204, 227, 255),
              ], // Gradient from https://learnui.design/tools/gradient-generator.html
              tileMode: TileMode.mirror,
            ),
          ),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: Material(
                      color: Colors.black.withOpacity(0),
                      child: IconButton(
                        icon: Icon(Icons.lock),
                        onPressed: () {
                          logOutUser(context);
                        },
                      )),
                ),
                Spacer(flex: 3),
                Text(
                  "Welcome, " + user!.email.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        letterSpacing: .5,
                        decoration: TextDecoration.none),
                  ),
                ),
                Spacer(flex: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Workout Button
                    ElevatedButton(
                        style: TextButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10)),
                            minimumSize: Size(150, 150),
                            backgroundColor: Colors.white),
                        onPressed: () {
                          toHomePage(context, 0);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.fitness_center_outlined,
                              size: 100,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Workout",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )
                          ],
                        )),
                    SizedBox(width: 10),
                    // Stats Button
                    ElevatedButton(
                        style: TextButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10)),
                            minimumSize: Size(150, 150),
                            backgroundColor: Colors.white),
                        onPressed: () {
                          toHomePage(context, 1);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.insights_outlined,
                              size: 100,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Stats",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )
                          ],
                        )),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Nutrition Button
                    ElevatedButton(
                        style: TextButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10)),
                            minimumSize: Size(150, 150),
                            backgroundColor: Colors.white),
                        onPressed: () {
                          toHomePage(context, 2);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.restaurant_outlined,
                              size: 100,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Nutrition",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )
                          ],
                        )),
                    SizedBox(width: 10),
                    // Plan Button
                    ElevatedButton(
                        style: TextButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10)),
                            minimumSize: Size(150, 150),
                            backgroundColor: Colors.white),
                        onPressed: () {
                          toHomePage(context, 3);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.edit,
                              size: 100,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Plan",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )
                          ],
                        )),
                  ],
                ),
                Spacer(flex: 5)
              ],
            ),
          )),
    );
  }
}
