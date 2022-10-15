import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/openingScreens/home_page.dart';
import 'package:gymchimp/openingScreens/forgot_pass.dart';
import 'package:gymchimp/openingScreens/sign_up_page.dart';
import '../firebase_options.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(
        selectedIndex: 0,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void toSignUp(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return SignUpPage();
        },
      ),
    );
  }

  void forgotPass(BuildContext ctx) {
    Navigator.of(ctx).push(navigate(ForgotPassWord()));
  }

  void loggedIn(BuildContext ctx) {
    Navigator.of(ctx).push(_createRoute());
  }

  var _emailConfirmController = TextEditingController();
  var _emailController = TextEditingController();
  var _passController = TextEditingController();
  var _passConfirmController = TextEditingController();
  String email = '';
  String confirmEmail = '';
  String password = '';
  String confirmPassword = '';
  @override
  void _submitForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Logged in ');

      loggedIn(ctx);
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
      await Future.delayed(Duration(seconds: 6));

      overlayEntry.remove();
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
      // width: size.width / 1.5,
      child: Container(
        margin: EdgeInsets.only(top: size.width * 1 / 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              color: Colors.black,
              Icons.lock_open_sharp,
              size: size.width / 2,
            ),
            const Center(
              child: Card(
                shadowColor: Colors.transparent,
                color: Color.fromARGB(0, 255, 255, 255),
                child: Text(
                  'Log In',
                  style: TextStyle(fontSize: 40),
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
