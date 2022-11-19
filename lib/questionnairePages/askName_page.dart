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
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:gymchimp/questionnairePages/askLevel_page.dart';
import '../firebase_options.dart';
import '../main.dart';

class askName extends StatefulWidget {
  const askName({Key? key}) : super(key: key);

  @override
  State<askName> createState() => _askName();
}

var name = "";

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

class _askName extends State<askName> {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: backGround(),
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
            body: Container(
              child: Center(
                /*
                  Text Form Field 
                    - Asks User 'Enter your first name'
                    - When Form is Submitted (clicking done on Keyboard popup) screen routes to askLevel page
                    - Horizontally centered
                    - Width: 350, Height: 400
                */
                child: SizedBox(
                  width: 350,
                  height: 400,
                  child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        hintText: 'Enter your first name',
                        hintStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      // When form is submitted routes to askLevel page
                      onFieldSubmitted: (value) {
                        name = value;
                        Navigator.of(context).push(navigate(askLevel()));
                      }),
                ),
              ),
            )),
      ),
    );
  }
}
