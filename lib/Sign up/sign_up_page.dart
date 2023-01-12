import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/Sign%20up/verify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/questionnairePages/askActive_page.dart';

import '../questionnairePages/askGoal_page.dart';
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

  //***************************************************//
  //called when all input is valid, submits info to
  //database for storage and creates a new user.
  //then requests user to verify email.
  var result;
  void _submitForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    try {
      //creates an user with inputted email and password
      result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //adds user input to database to store
      await firestore.collection('users').doc(result.user.uid).set({
        'email': email,
        'password': password,
        'name': name,
        'gender': gender,
        'level': level,
        'goal': goal,
        'unit': 'inches/Lbs'
      });
      //sends user to the verification page
      changePage(ctx, Verification());
    } catch (err) {
      //incase there is an error, return as an overlay
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
      //create and remove overlay after 4 seconds
      overlaystate?.insert(overlayEntry);
      await Future.delayed(Duration(seconds: 4));
      overlayEntry.remove();
    }
  }
//***************************************************//

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _passConfirmController = TextEditingController();
  String email = '';
  String password = '';
  String confirmPassword = '';

  //***************************************************//
  //Displays an overlay with a message to user, has a 3 second delay
  //before removed
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
    //displays overlay
    overlaystate?.insert(overlayEntry);
    //3 second delay
    await Future.delayed(Duration(seconds: 3));
    //removes overlay
    overlayEntry.remove();
  }
  //***************************************************//

  void resetPass() {
    password = '';
    confirmPassword = '';
    _passController.clear();
    _passConfirmController.clear();
  }

  void resetEmail() {
    email = '';
    _emailController.clear();
  }

//***************************************************//
//Validates info on signup page, if everything is valid, submits info
//if not valid, displays overlay explaining error to user
  validation(BuildContext context) {
    if (!email.contains('@')) {
      invalidEmailOverlay(context, 'Invalid Email');
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
//***************************************************//

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
            //////// Email label and textfield/////////
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
            //***************************************************//
            ////////// Password label and texfield/////////
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
            //***************************************************//
            //////////// Confirm Password label and textfield//////
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
            //***************************************************//
            //////////// Confirm Button 'check' //////////
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
