import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymchimp/openingScreens/first_time_login.dart';
import 'package:gymchimp/openingScreens/verify.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void goBack(BuildContext ctx) {
    Navigator.of(ctx).push(createRoute(FirstLogIn()));
  }

  void toVerify(BuildContext ctx) {
    Navigator.of(ctx).push(createRoute(Verification()));
  }

  Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration(milliseconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(5, 0);
        const end = Offset(0, 0);
        const curve = Curves.decelerate;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  var result;
  void _submitForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    try {
      //email.trim();
      print(email);
      result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firestore
          .collection('users')
          .doc(result.user.uid)
          .set({'email': email, 'password': password});
      print('Signed Up');
      toVerify(ctx);
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
              shadows: <Shadow>[
                Shadow(
                    color: Colors.black.withOpacity(0.4),
                    offset: const Offset(7, 7),
                    blurRadius: 5),
              ],
              color: Colors.black,
              Icons.send,
              size: size.width / 2,
            ),
            Center(
              child: Card(
                shadowColor: Colors.transparent,
                color: Color.fromARGB(0, 255, 255, 255),
                child: Container(
                  child: Text(
                    'Sign-Up',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          // shadows: <Shadow>[
                          //   Shadow(
                          //       color: Colors.black.withOpacity(0.4),
                          //       offset: const Offset(7, 7),
                          //       blurRadius: 50),
                          // ],
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
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
            Container(
              margin: EdgeInsets.only(top: size.width * 1 / 3),
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                    child: IconButton(
                  onPressed: () {
                    goBack(context);
                  },
                  color: Color.fromARGB(255, 0, 0, 0),

                  highlightColor:
                      Color.fromARGB(255, 135, 135, 135), //<-- SEE HERE
                  iconSize: 30,
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
