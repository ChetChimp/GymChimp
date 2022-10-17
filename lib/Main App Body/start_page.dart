import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/Main%20App%20Body/app_bar.dart';
import 'package:gymchimp/openingScreens/first_time_login.dart';
import 'package:gymchimp/Main%20App%20Body/home_page.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:gymchimp/Sign%20up/sign_up_page.dart';
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

void extraPopOut(BuildContext ctx) {
  print("entered");
  Widget build(BuildContext context) {
    return (PopupMenuButton(
      itemBuilder: (_) {
        return [
          PopupMenuItem(child: Text("Item2")),
          PopupMenuItem(child: Text("Item3"))
        ];
      },
    ));
  }
}

class _StartPage extends State<StartPage> {
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            Container(
              child: PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                itemBuilder: (
                  BuildContext context,
                ) =>
                    <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Container(
                      child: ListTile(
                        leading: Icon(Icons.person_outline),
                        title: Text('Account'),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    child: new Container(
                      color: Colors.transparent,
                      width: 1000,
                      child: ListTile(
                        onTap: () {},
                        leading: Icon(Icons.notifications_outlined),
                        title: PopupMenuButton(
                          child: Text("Notifications"),
                          itemBuilder: (_) {
                            return [
                              PopupMenuItem(
                                  child: ListTile(leading: Text("Item2"))),
                              PopupMenuItem(child: Text("Item3"))
                            ];
                          },
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                  PopupMenuItem(
                    enabled: true,
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          child: ListTile(
                            onTap: () {},
                            leading: Icon(Icons.scale_outlined),
                            title: Text(input),
                            trailing: Container(
                              child: Switch(
                                // This bool value toggles the switch.
                                value: kg,
                                activeColor: Colors.blue,
                                inactiveThumbColor: Colors.red,
                                inactiveTrackColor:
                                    Color.fromARGB(131, 255, 73, 73),
                                onChanged: (bool value) {
                                  // This is called when the user toggles the switch.
                                  setState(() {
                                    kg = value;
                                  });
                                  if (input == 'Imperial') {
                                    setState(() {
                                      input = 'Metric';
                                    });
                                  } else {
                                    setState(() {
                                      input = 'Imperial';
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: Container(
                      child: ListTile(
                        leading: Icon(Icons.lock_outline),
                        title: Text('Sign Out'),
                        onTap: () {
                          logOutUser(context);
                        },
                      ),
                    ),
                  ),
                ],
                splashRadius: 20,
                icon: Icon(color: Colors.black, Icons.settings_outlined),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          child: Column(
            children: <Widget>[
              Spacer(flex: 1),
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
        ),
      ),
    );
  }
}
