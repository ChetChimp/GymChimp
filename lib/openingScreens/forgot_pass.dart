import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/Sign%20up/check_pass_email.dart';
import 'package:gymchimp/openingScreens/first_time_login.dart';
import 'package:gymchimp/openingScreens/login_page.dart';

class ForgotPassWord extends StatefulWidget {
  const ForgotPassWord({Key? key}) : super(key: key);

  @override
  State<ForgotPassWord> createState() => _ForgotPassWordState();
}

Future _submitForm(String email, BuildContext context) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  changePage(context, CheckPassEmail());
}

void changePage(BuildContext ctx, Widget page) {
  Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => page));
}

void goBackToLogin(BuildContext ctx) async {
  Navigator.of(ctx).pop();
}

class _ForgotPassWordState extends State<ForgotPassWord> {
  var _emailController = TextEditingController();
  String email = '';

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
      child: Column(
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
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                    fontSize: 30,
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
              placeholder: 'Enter Email:',
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
                  goBackToLogin(context);
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
    );
  }
}
