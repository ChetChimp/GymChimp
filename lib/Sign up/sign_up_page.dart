import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/Sign%20up/verify.dart';
import 'package:google_fonts/google_fonts.dart';

import '../questionnairePages/askGoal_page.dart';
import '../questionnairePages/askLevel_page.dart';
import '../questionnairePages/askName_page.dart';
import '../questionnairePages/askSex.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;

  void goBack(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  var result;
  void _submitForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    try {
      //email.trim();
      result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firestore.collection('users').doc(result.user.uid).set({
        'email': email,
        'password': password,
        'name': name,
        'gender': gender,
        'level': level,
        'goal': goal,
        'unit': 'inches/Lbs'
      });
      changePage(ctx, Verification());
    } catch (err) {
      OverlayState? overlaystate = Overlay.of(ctx);
      OverlayEntry overlayEntry = OverlayEntry(builder: (ctx) {
        return Container(
          alignment: Alignment.center,
          child: AlertDialog(
            backgroundColor: Colors.red[300],
            content: Text(
              err.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        );
      });
      overlaystate?.insert(overlayEntry);
      await Future.delayed(Duration(seconds: 4));
      overlayEntry.remove();
    }
  }

  var _emailConfirmController = TextEditingController();
  var _emailController = TextEditingController();
  var _passController = TextEditingController();
  var _passConfirmController = TextEditingController();
  String email = '';
  String confirmEmail = '';
  String password = '';
  String confirmPassword = '';

  invalidEmailOverlay(BuildContext ctx, String input) async {
    OverlayState? overlaystate = Overlay.of(ctx);
    OverlayEntry overlayEntry = OverlayEntry(builder: (ctx) {
      return Container(
        alignment: Alignment.center,
        child: AlertDialog(
          backgroundColor: Colors.red[300],
          title: Text(
            input,
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
    overlaystate?.insert(overlayEntry);
    await Future.delayed(Duration(seconds: 3));

    overlayEntry.remove();
  }

  void resetPass() {
    password = '';
    confirmPassword = '';
    _passController.clear();
    _passConfirmController.clear();
  }

  void resetEmail() {
    email = '';
    confirmEmail = '';
    _emailController.clear();
    _emailConfirmController.clear();
  }

  validation(BuildContext context) {
    if (!email.contains('@')) {
      invalidEmailOverlay(context, 'Invalid Email');
    } else if (email != confirmEmail) {
      invalidEmailOverlay(context, 'Emails do not match');
    } else if (password.length < 7) {
      invalidEmailOverlay(context, 'Password is too short');
      resetPass();
    } else if (password != confirmPassword) {
      invalidEmailOverlay(context, 'Passwords do not match');
      resetPass();
    } else {
      _submitForm(email, password, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color.fromARGB(255, 228, 240, 255),
            Color.fromARGB(255, 169, 188, 211),
          ], // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.mirror,
        ),
      ),
      height: size.height,
      // width: size.width / 1.5,
      child: Container(
        margin: EdgeInsets.only(top: size.width * 1 / 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Spacer(flex: 2),
            Center(
              child: Card(
                shadowColor: Colors.transparent,
                color: Color.fromARGB(0, 255, 255, 255),
                child: Container(
                  child: Text(
                    'Sign-Up',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          letterSpacing: .5,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ),
            ),
            //////// Email /////////
            Container(
              margin: EdgeInsets.only(
                  left: size.width * 1 / 8,
                  right: size.width * 1 / 8,
                  bottom: size.width * 1 / 32),
              child: CupertinoTextField(
                controller: _emailController,
                onChanged: (value) {
                  email = value;
                },
                placeholder: 'Email:',
                placeholderStyle: TextStyle(
                  color: Color.fromARGB(255, 73, 73, 73),
                  fontSize: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                suffix: Material(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        _emailController.clear();
                      },
                      icon: const Icon(Icons.clear)),
                ),
              ),
            ),
            /////// Confirm Email //////////
            Container(
              margin: EdgeInsets.only(
                  left: size.width * 1 / 8,
                  right: size.width * 1 / 8,
                  bottom: size.width * 1 / 32),
              child: CupertinoTextField(
                controller: _emailConfirmController,
                onChanged: (value) {
                  confirmEmail = value;
                },
                placeholder: 'Confirm Email',
                placeholderStyle: TextStyle(
                  color: Color.fromARGB(255, 73, 73, 73),
                  fontSize: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                suffix: Material(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        _emailConfirmController.clear();
                        confirmEmail = '';
                      },
                      icon: const Icon(Icons.clear)),
                ),
              ),
            ),
            //////// Password /////////
            Container(
              margin: EdgeInsets.only(
                  left: size.width * 1 / 8,
                  right: size.width * 1 / 8,
                  bottom: size.width * 1 / 32),
              child: CupertinoTextField(
                obscureText: true,
                controller: _passController,
                onChanged: (value) {
                  password = value;
                },
                placeholder: 'Password:',
                placeholderStyle: TextStyle(
                  color: Color.fromARGB(255, 73, 73, 73),
                  fontSize: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                suffix: Material(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        _passController.clear();
                        password = '';
                      },
                      icon: const Icon(Icons.clear)),
                ),
              ),
            ),
            ////////// Confirm Pass Wordddddd//////
            Container(
              margin: EdgeInsets.only(
                  left: size.width * 1 / 8,
                  right: size.width * 1 / 8,
                  bottom: size.width * 1 / 32),
              child: CupertinoTextField(
                obscureText: true,
                controller: _passConfirmController,
                onChanged: (value) {
                  confirmPassword = value;
                },
                placeholder: 'Confirm Password',
                placeholderStyle: TextStyle(
                  color: Color.fromARGB(255, 73, 73, 73),
                  fontSize: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                suffix: Material(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        _passConfirmController.clear();
                        confirmPassword = '';
                      },
                      icon: const Icon(Icons.clear)),
                ),
              ),
            ),
            //////// Button //////////
            CupertinoButton(
              // pressedOpacity: 100,
              color: Color.fromARGB(255, 0, 0, 0),
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              padding: EdgeInsets.only(
                  left: size.width * 1 / 8,
                  right: size.width * 1 / 8,
                  top: 5,
                  bottom: 5),
              child: Icon(
                Icons.check,
                size: 25,
              ),
              onPressed: () {
                validation(context);
              }, //validation(context),
            ),
            Spacer(flex: 1),
            Container(
              margin: EdgeInsets.only(top: size.width * 1 / 3),
              child: Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      goBack(context);
                    },
                    color: Color.fromARGB(255, 0, 0, 0),

                    highlightColor:
                        Color.fromARGB(255, 135, 135, 135), //<-- SEE HERE
                    iconSize: 40,
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                  )),
            ),
            Spacer(flex: 1)
          ],
        ),
      ),
    );
  }
}
