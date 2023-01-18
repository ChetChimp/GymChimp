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
import 'package:gymchimp/login-signup/Sign%20up/sign_up_page.dart';

import '../../main.dart';
import 'askActive_page.dart';

class askSex extends StatefulWidget {
  const askSex({Key? key}) : super(key: key);

  @override
  State<askSex> createState() => _askSex();
}

var gender = "";

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

class _askSex extends State<askSex> {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: MyAppBar(context, true, "askSex"),
      body: Center(
        child: Column(
          children: [
            Container(
              height: size.width / 12,
              child: Text(
                'Select Your Sex',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: accentColor, fontSize: size.height / 32),
              ),
            ),
            Spacer(),
            Hero(
              tag: 1,
              child: Material(
                color: Colors.transparent,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue)))),
                  child: Icon(
                    Icons.man,
                    size: size.height / 3,
                  ),
                  onPressed: () {
                    gender = "Male";
                    Navigator.of(context).push(navigate(askActive()));
                  },
                ),
              ),
            ),
            Spacer(),
            Hero(
              tag: 2,
              child: Material(
                color: Colors.transparent,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red))),
                      backgroundColor: MaterialStateProperty.all(Colors.pink)),
                  child: Icon(
                    Icons.woman,
                    size: size.height / 3,
                  ),
                  onPressed: () {
                    gender = "Male";
                    Navigator.of(context).push(navigate(askActive()));
                  },
                ),
              ),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
