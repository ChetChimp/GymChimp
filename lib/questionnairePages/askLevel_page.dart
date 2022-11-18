// ignore_for_file: unnecessary_new

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/openingScreens/home_page.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:gymchimp/questionnairePages/askBody_page.dart';
import 'package:gymchimp/questionnairePages/askGoal_page.dart';
import 'package:gymchimp/questionnairePages/askSex.dart';
import 'package:gymchimp/questionnairePages/askLevel_page.dart';
import 'package:gymchimp/openingScreens/sign_up_page.dart';
import '../firebase_options.dart';

class askLevel extends StatefulWidget {
  const askLevel({Key? key}) : super(key: key);

  @override
  State<askLevel> createState() => _askLevel();
}

var level = "";

/*
  - Called when top left back arrow is pressed
  - Pops back to FirstLogIn()
*/
void goBack(BuildContext ctx) {
  Navigator.of(ctx).pop();
}

/*
  - Navigates to desired page with custom transition
*/
Route navigate(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration(milliseconds: 1),
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

class _askLevel extends State<askLevel> {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            //Background color
            colors: <Color>[
              Color.fromARGB(233, 228, 240, 255),
              Color.fromARGB(211, 204, 227, 255),
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
        ),
        child: Scaffold(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0),
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            elevation: 0,
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  goBack(context);
                }),
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {}),
            ],
          ),
          body: Center(
            child: Column(
              children: [
                Container(
                  height: size.width / 5,
                  child: Text(
                    'Select Your Level',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: .5,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
                Spacer(flex: 2),
                /*
            Container containing FloatingActionButton
            */
                Container(
                  /*
              Floating Action Button with tag "btn2"
              -preset space between button text and border
              -Text: "Already have an account? Log in here!", font = lato, fontSize = 16,
                      color = black
              -background = white
              -when pressed make call to loggedIn(), takes user to login page
              */
                  child: FloatingActionButton.extended(
                    heroTag: "btn1",
                    extendedPadding: EdgeInsets.only(
                        left: size.width / 8,
                        right: size.width / 8,
                        top: size.width / 2,
                        bottom: size.width / 2),
                    label: Text(
                      'Beginner',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(197, 68, 83, 100),
                            letterSpacing: .5,
                            decoration: TextDecoration.none),
                      ),
                    ), // <-- Text
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    onPressed: () {
                      level = "Beginner";
                      Navigator.of(context).push(navigate(askGoal()));
                    },
                  ),
                ),
                Spacer(flex: 1),
                FloatingActionButton.extended(
                  heroTag: "btn2",
                  extendedPadding: EdgeInsets.only(
                      left: size.width / 8,
                      right: size.width / 8,
                      top: size.width / 2,
                      bottom: size.width / 2),
                  label: Text(
                    'Intermediate',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(197, 68, 83, 100),
                          letterSpacing: .5,
                          decoration: TextDecoration.none),
                    ),
                  ), // <-- Text
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  onPressed: () {
                    level = "Intermediate";
                    Navigator.of(context).push(navigate(askGoal()));
                  },
                ),
                Spacer(),
                FloatingActionButton.extended(
                  heroTag: "btn3",
                  extendedPadding: EdgeInsets.only(
                      left: size.width / 8,
                      right: size.width / 8,
                      top: size.width / 2,
                      bottom: size.width / 2),
                  label: Text(
                    'Advanced',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(197, 68, 83, 100),
                          letterSpacing: .5,
                          decoration: TextDecoration.none),
                    ),
                  ), // <-- Text
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  onPressed: () {
                    level = "Advanced";
                    Navigator.of(context).push(navigate(askSex()));
                  },
                ),
                Spacer(flex: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
