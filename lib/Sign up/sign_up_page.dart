import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/Sign%20up/verify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/questionnairePages/askActive_page.dart';

import '../Main App Body/app_bar.dart';
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
    if (!email.contains('@') || email.contains(" ")) {
      invalidEmailOverlay(context, 'Invalid email format');
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
    return Scaffold(
      appBar: MyAppBar(context, true, "signUp"),
      backgroundColor: backgroundGrey,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'Sign-Up',
                style:
                    TextStyle(color: Colors.white, fontSize: size.height / 20),
              ),
            ),
            //////// Email label and textfield/////////
            Spacer(),
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
                  fontSize: size.height / 52,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                suffix: Material(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: IconButton(
                      iconSize: size.height / 52,
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
                  fontSize: size.height / 52,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                suffix: Material(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: IconButton(
                      iconSize: size.height / 52,
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
                  fontSize: size.height / 52,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                suffix: Material(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: IconButton(
                      iconSize: size.height / 52,
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
            Spacer(),
            CupertinoButton(
              // pressedOpacity: 100,
              color: foregroundGrey,
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              padding: EdgeInsets.only(
                  left: size.width * 1 / 8,
                  right: size.width * 1 / 8,
                  top: 5,
                  bottom: 5),
              child: Icon(
                color: accentColor,
                Icons.check,
                size: size.height / 32,
              ),
              onPressed: () {
                validation(context);
              }, //validation(context),
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
