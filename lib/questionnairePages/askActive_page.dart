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
import 'package:gymchimp/Main%20App%20Body/app_bar.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:gymchimp/questionnairePages/askGoal_page.dart';
import 'package:gymchimp/questionnairePages/askSex.dart';
import '../firebase_options.dart';

class askActive extends StatefulWidget {
  const askActive({Key? key}) : super(key: key);

  @override
  State<askActive> createState() => _askActive();
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
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class _askActive extends State<askActive> {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: MyAppBar(context, true, "askActive"),
      body: Center(
        child: Column(
          children: [
            // const LinearProgressIndicator(
            //     backgroundColor: Color.fromARGB(255, 209, 209, 209),
            //     valueColor:
            //         AlwaysStoppedAnimation(Color.fromARGB(185, 54, 255, 40)),
            //     value: 0.5),
            Container(
              height: size.width / 5,
              child: Text(
                'How Active Are You?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: accentColor,
                  fontSize: size.height / 32,
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
                heroTag: 1,
                extendedPadding: EdgeInsets.only(
                    left: size.width / 8,
                    right: size.width / 8,
                    top: size.width / 2,
                    bottom: size.width / 2),
                label: Text(
                  'No exercise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height / 40,
                  ),
                ), // <-- Text
                backgroundColor: foregroundGrey,
                onPressed: () {
                  level = "1";
                  Navigator.of(context).push(navigate(askGoal()));
                },
              ),
            ),
            Spacer(flex: 1),
            FloatingActionButton.extended(
              heroTag: 2,
              extendedPadding: EdgeInsets.only(
                  left: size.width / 8,
                  right: size.width / 8,
                  top: size.width / 2,
                  bottom: size.width / 2),
              label: Text(
                'Light: 1-2 days/week',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height / 40,
                ),
              ), // <-- Text
              backgroundColor: foregroundGrey,
              onPressed: () {
                level = "2";
                Navigator.of(context).push(navigate(askGoal()));
              },
            ),
            Spacer(flex: 1),
            FloatingActionButton.extended(
              heroTag: 3,
              extendedPadding: EdgeInsets.only(
                  left: size.width / 8,
                  right: size.width / 8,
                  top: size.width / 2,
                  bottom: size.width / 2),
              label: Text(
                'Moderate: 3-5 days/week',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height / 40,
                ),
              ), // <-- Text
              backgroundColor: foregroundGrey,
              onPressed: () {
                level = "3";
                Navigator.of(context).push(navigate(askGoal()));
              },
            ),
            Spacer(flex: 1),
            FloatingActionButton.extended(
              heroTag: 4,
              extendedPadding: EdgeInsets.only(
                  left: size.width / 8,
                  right: size.width / 8,
                  top: size.width / 2,
                  bottom: size.width / 2),
              label: Text(
                'Active: 6-7 days/week',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height / 40,
                ),
              ), // <-- Text
              backgroundColor: foregroundGrey,
              onPressed: () {
                level = "4";
                Navigator.of(context).push(navigate(askGoal()));
              },
            ),
            Spacer(flex: 1),
            FloatingActionButton.extended(
              heroTag: 5,
              extendedPadding: EdgeInsets.only(
                  left: size.width / 8,
                  right: size.width / 8,
                  top: size.width / 2,
                  bottom: size.width / 2),
              label: Text(
                'Athlete: 2x per day',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height / 40,
                ),
              ), // <-- Text
              backgroundColor: foregroundGrey,
              onPressed: () {
                level = "5";
                Navigator.of(context).push(navigate(askGoal()));
              },
            ),
            Spacer(flex: 10),
          ],
        ),
      ),
    );
  }
}
