import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymchimp/openingScreens/first_time_login.dart';
import 'package:gymchimp/openingScreens/forgot_pass.dart';
import 'package:gymchimp/openingScreens/start_page.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  //initialize instance of firebase user
  final _auth = FirebaseAuth.instance;

  //initialize instance of firebase firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

/*
  -animation for page change, used for majority of navigation
  -changes pages instantly
  -will be cleaned up, animaitons are not necessary
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

/*
  -called when back arrow IconButton is pushed, 
  -makes call to createRoute method to take user to firsTimeLogin page
*/
  void goBack(BuildContext ctx) {
    Navigator.of(ctx).push(navigate(FirstLogIn()));
  }

  void forgotPass(BuildContext ctx) {
    Navigator.of(ctx).push(navigate(ForgotPassWord()));
  }

/*
  -called when checkMark IconButton is pushed, 
  -makes call to createRoute method to take user to start page
*/
  void loggedIn(BuildContext ctx) {
    Navigator.of(ctx).push(navigate(StartPage()));
  }

  /*
  Initializing controllers to take and store user input inside textfields
  */
  var _emailController = TextEditingController();
  var _passController = TextEditingController();
  String email = '';
  String password = '';
  /*
  Method to verify user input with database an log the user in
  */
  @override
  void _submitForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    try {
      //attemps to verify user-input, if data matches database --> takes user to login page
      var result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      loggedIn(ctx);
    } catch (err) {
      //if there is an error with the user's input, return the error String to the user as a popup
      //pop up duration lasts for 2 seconds
      //plan is to improve error handling and return custom messages that are easier to understand
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
      await Future.delayed(Duration(seconds: 2));
      overlayEntry.remove();
    }
  }

  /*
  Overarching structure of page layout
  */
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    /*
    -Container used for background with light gray to gray gradient
    -Child: container
    */
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color.fromARGB(233, 228, 240, 255),
            Color.fromARGB(211, 204, 227, 255),
          ], // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.mirror,
        ),
      ),
      height: size.height,
      /*
      Container with column as child
      -inset margin size 25% of the height of the screen
      */
      child: Container(
        margin: EdgeInsets.only(top: size.width * 1 / 4),
        /*
          Column with a 3 containers, cupertinoButton and IconButton
        */
        child: Column(
          children: [
            Spacer(flex: 3),
            /*
            Container with column child
            */
            /*
              Column with Icon and Container (text)
              */
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                /*
                  Container for text, has margins
                  */
                Container(
                  margin: EdgeInsets.only(
                      left: size.width * 1 / 8,
                      right: size.width * 1 / 8,
                      bottom: size.width * 1 / 32),
                  child:
                      /*
                    Text: "Login", font = lato, fontSize = 45, color = black
                    */
                      Text(
                    'Login',
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
                //Container for cupertinoTextField, has margins
                Container(
                  margin: EdgeInsets.only(
                      left: size.width * 1 / 8,
                      right: size.width * 1 / 8,
                      bottom: size.width * 1 / 32),
                  /*
                    CuperTinoTextField: 
                    -takes input into _emailController
                    -when value is changed email variable is updated
                    -"Email" placeholder, gray text, fontSize = 18
                    -rounded
                    -IconButton suffix
                            - "X" icon
                            - when pressed, clears textField
                    */
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
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
                //Container with cupertinoTextField
                Container(
                  margin: EdgeInsets.only(
                      left: size.width * 1 / 8,
                      right: size.width * 1 / 8,
                      bottom: size.width * 1 / 32),
                  /*
                    CuperTinoTextField: 
                    -takes input into _passController
                    -when value is changed password variable is updated
                    -"Password:" placeholder, gray text, fontSize = 18
                    -rounded
                    -IconButton suffix
                            - "X" icon
                            - when pressed, clears textField
                    */
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
                /*
                    CupertinoButton:
                    - color = black
                    - contains checkmark icon
                    - when pressed calls submitForm method which verifies all of the user's input
                      with the database
                  */
                CupertinoButton(
                  color: Color.fromARGB(255, 0, 0, 0),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  padding: EdgeInsets.only(
                      left: size.width * 1 / 8,
                      right: size.width * 1 / 8,
                      top: size.height * 1 / 80,
                      bottom: size.height * 1 / 80),
                  child: Icon(
                    Icons.check,
                    size: 25,
                  ),
                  onPressed: () {
                    _submitForm(email, password, context);
                  }, //validation(context),
                ),
              ],
            ),
            /*
            Material/Container with IconButton.
            -IconButton is a "back arrow"
            -When pressed, calls goBack() method, takes user to previous page
            */
            Spacer(
              flex: 5,
            ),
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
                heroTag: "btn2",
                extendedPadding: EdgeInsets.only(
                    left: size.width / 22,
                    right: size.width / 22,
                    top: size.width / 16,
                    bottom: size.width / 16),
                label: Text(
                  'Forgot password?',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        letterSpacing: .5,
                        decoration: TextDecoration.none),
                  ),
                ), // <-- Text
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  forgotPass(context);
                },
              ),
            ),
            Spacer(flex: 1),
            Material(
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
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
