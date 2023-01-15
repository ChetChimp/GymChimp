import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/login-signup/Sign%20up/check_pass_email.dart';
import 'package:gymchimp/main.dart';

import 'login_page.dart';

class ForgotPassWord extends StatefulWidget {
  const ForgotPassWord({Key? key}) : super(key: key);

  @override
  State<ForgotPassWord> createState() => _ForgotPassWordState();
}

Future _submitForm(String email, BuildContext context) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  toCheckPass(context);
}

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

void goBack(BuildContext ctx) {
  Navigator.of(ctx).pop(navigate(LoginPage()));
}

void toCheckPass(BuildContext ctx) {
  Navigator.of(ctx).push(navigate(CheckPassEmail()));
}

class _ForgotPassWordState extends State<ForgotPassWord> {
  var _emailController = TextEditingController();
  String email = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundGrey,
      // width: size.width / 1.5,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Spacer(flex: 8),

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
              'Forgot Password?',
              style: TextStyle(
                  fontSize: size.height / 42,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  letterSpacing: .5,
                  decoration: TextDecoration.none),
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
              placeholder: 'Enter Email:',
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
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          CupertinoButton(
            color: foregroundGrey,
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
            padding: EdgeInsets.only(
                left: size.width * 1 / 8,
                right: size.width * 1 / 8,
                top: size.height * 1 / 80,
                bottom: size.height * 1 / 80),
            child: Icon(
              color: accentColor,
              Icons.check,
              size: size.height / 36,
            ),
            onPressed: () {
              _submitForm(email, context);
            }, //validation(context),
          ),
          Spacer(
            flex: 8,
          ),
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
                iconSize: size.height / 22,
                icon: Icon(
                  color: Colors.white,
                  Icons.arrow_back,
                ),
              )),
          Spacer(flex: 1),
        ],
      ),
    );
  }
}
