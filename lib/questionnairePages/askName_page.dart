// ignore_for_file: unnecessary_new, prefer_const_constructors

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

import 'package:gymchimp/questionnairePages/askSex.dart';
import '../customWidgets/ShakerState.dart';
import '../firebase_options.dart';

class askName extends StatefulWidget {
  const askName({Key? key}) : super(key: key);

  @override
  State<askName> createState() => _askName();
}

var name = "";
final shakeKey = GlobalKey<ShakeWidgetState>();
TextEditingController nameControl = TextEditingController(text: "");
FocusNode inputNode = FocusNode();

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

class _askName extends State<askName> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // to open keyboard call this function;

    void openKeyboard() {
      FocusScope.of(context).requestFocus(inputNode);
    }

    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: MyAppBar(context, true, "askName"),
      body: Container(
        child: Center(
          child: Column(
            /*
                    Text Form Field 
                      - Asks User 'Enter your first name'
                      - When Form is Submitted (clicking done on Keyboard popup) screen routes to askLevel page
                      - Horizontally centered
                      - Width: 350, Height: 400
                  */
            children: [
              // const LinearProgressIndicator(
              //     backgroundColor: Color.fromARGB(255, 209, 209, 209),
              //     valueColor: AlwaysStoppedAnimation(
              //         Color.fromARGB(185, 54, 255, 40)),
              //     value: 0.0),
              //Spacer(),
              Text(
                'What is your name?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.height / 32,
                  color: accentColor,
                ),
              ),

              //Spacer(flex: 10),
              ShakeWidget(
                // 4. pass the GlobalKey as an argument
                key: shakeKey,
                // 5. configure the animation parameters
                shakeCount: 3,
                shakeOffset: 10,
                shakeDuration: Duration(milliseconds: 500),
                // 6. Add the child widget that will be animated
                child: SizedBox(
                  width: 350,
                  height: size.height / 3,
                  child: TextFormField(
                    autofocus: true,
                    focusNode: inputNode,
                    controller: nameControl,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      hintText: 'Enter your first name',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    onFieldSubmitted: (value) {
                      if (nameControl.text.isNotEmpty) {
                        name = nameControl.text;
                        Navigator.of(context).push(navigate(askSex()));
                      } else {
                        ShakeWidget(child: Text("test"), shakeOffset: 3);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  child: Text('Next', style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    if (nameControl.text.isNotEmpty) {
                      name = nameControl.text;
                      Navigator.of(context).push(navigate(askSex()));
                    } else {
                      ShakeWidget(child: Text("test"), shakeOffset: 3);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
