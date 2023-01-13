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
import 'package:gymchimp/Sign%20up/sign_up_page.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:gymchimp/questionnairePages/askInfo_page.dart';
import 'package:gymchimp/questionnairePages/askSex.dart';
import '../firebase_options.dart';
import '../main.dart';

class askGoal extends StatefulWidget {
  const askGoal({Key? key}) : super(key: key);

  @override
  State<askGoal> createState() => _askGoal();
}

var goal = "";

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

class _askGoal extends State<askGoal> {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: MyAppBar(context, true, "askGoal"),
      body: Center(
        child: Column(
          children: [
            Container(
              height: size.width / 5,
              child: Text(
                'Select Your Weight Goal',
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
                heroTag: "btn1",
                extendedPadding: EdgeInsets.only(
                    left: size.width / 8,
                    right: size.width / 8,
                    top: size.width / 2,
                    bottom: size.width / 2),
                label: Text(
                  'Cut',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height / 32,
                  ),
                ), // <-- Text
                backgroundColor: foregroundGrey,
                onPressed: () {
                  goal = "Cut";
                  Navigator.of(context).push(navigate(SignUpPage()));
                },
              ),
            ),
            Spacer(flex: 1),
            FloatingActionButton.extended(
              heroTag: "btn3",
              extendedPadding: EdgeInsets.only(
                  left: size.width / 8,
                  right: size.width / 8,
                  top: size.width / 2,
                  bottom: size.width / 2),
              label: Text(
                'Mantain',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height / 32,
                ),
              ), // <-- Text
              backgroundColor: foregroundGrey,
              onPressed: () {
                goal = "Maintain";
                Navigator.of(context).push(navigate(SignUpPage()));
              },
            ),
            Spacer(),
            FloatingActionButton.extended(
              heroTag: "btn2",
              extendedPadding: EdgeInsets.only(
                  left: size.width / 8,
                  right: size.width / 8,
                  top: size.width / 2,
                  bottom: size.width / 2),
              label: Text(
                'Bulk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height / 32,
                ),
              ), // <-- Text
              backgroundColor: foregroundGrey,
              onPressed: () {
                goal = "Bulk";
                Navigator.of(context).push(navigate(SignUpPage()));
              },
            ),
            Spacer(flex: 8),
          ],
        ),
      ),
    );
  }
}
