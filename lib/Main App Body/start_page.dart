import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/Main%20App%20Body/account_settings.dart';
import 'package:gymchimp/Main%20App%20Body/app_bar.dart';
import 'package:gymchimp/openingScreens/first_time_login.dart';
import 'package:gymchimp/Main%20App%20Body/home_page.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:gymchimp/Sign%20up/sign_up_page.dart';
import '../firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

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
  @override
  void initState() {
    fetchInfo('unit').then((String result) {
      if (mounted) {
        setState(() {
          weightUnit = result;
          if (weightUnit == 'inches/Lbs') {
            imperialSystem = true;
          } else {
            imperialSystem = false;
          }
        });
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    fetchInfo('name').then((String result) {
      if (mounted) {
        setState(() {
          userName = result;
        });
      }
    });
    return Container(
      decoration: backGround(),
      child: Scaffold(
        appBar: MyAppBar(context, false),
        backgroundColor: Colors.transparent,
        body: Container(
          child: Column(
            children: <Widget>[
              Spacer(flex: 1),
              Text(
                "Welcome, $userName",
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                      fontSize: 45,
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
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 10.0),
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0),
                        ]),
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                            //elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(150, 150),
                            backgroundColor: Colors.white),
                        onPressed: () {
                          toHomePage(context, 0);
                        },
                        child: Column(
                          children: <Widget>[
                            const Icon(
                              Icons.fitness_center_outlined,
                              size: 100,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Workout",
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    letterSpacing: .5,
                                    decoration: TextDecoration.none),
                              ),
                            )
                          ],
                        )),
                  ),
                  SizedBox(width: 15),
                  // Stats Button
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 10.0),
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0),
                        ]),
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(150, 150),
                            backgroundColor: Colors.white),
                        onPressed: () {
                          toHomePage(context, 1);
                        },
                        child: Column(
                          children: <Widget>[
                            const Icon(
                              Icons.insights_outlined,
                              size: 100,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Stats",
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    letterSpacing: .5,
                                    decoration: TextDecoration.none),
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Nutrition Button
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 10.0),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0),
                        ]),
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(150, 150),
                            backgroundColor: Colors.white),
                        onPressed: () {
                          toHomePage(context, 2);
                        },
                        child: Column(
                          children: <Widget>[
                            const Icon(
                              Icons.restaurant_outlined,
                              size: 100,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Nutrition",
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    letterSpacing: .5,
                                    decoration: TextDecoration.none),
                              ),
                            )
                          ],
                        )),
                  ),
                  SizedBox(width: 15),
                  // Plan Button
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 10.0),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0),
                        ]),
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(150, 150),
                            backgroundColor: Colors.white),
                        onPressed: () {
                          toHomePage(context, 3);
                        },
                        child: Column(
                          children: <Widget>[
                            const Icon(
                              Icons.edit,
                              size: 100,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Plan",
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    letterSpacing: .5,
                                    decoration: TextDecoration.none),
                              ),
                            )
                          ],
                        )),
                  ),
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
