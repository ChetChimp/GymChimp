import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/main.dart';

import '../login-signup/openingScreens/login_page.dart';

class CheckPassEmail extends StatelessWidget {
  const CheckPassEmail({Key? key}) : super(key: key);

  void backToLogin(BuildContext ctx) {
    Navigator.of(ctx)
        .push(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundGrey,
      body: Column(
        children: [
          Center(
            child: Card(
              margin: EdgeInsets.only(top: size.height * 1 / 2.5),
              shadowColor: Colors.transparent,
              color: Color.fromARGB(0, 255, 255, 255),
              child: Text(
                'Password change sent to email',
                style: TextStyle(
                    fontSize: size.height / 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(30),
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
                'Back to Login',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: size.height / 52,
                      fontWeight: FontWeight.normal,
                      color: accentColor,
                      letterSpacing: .5,
                      decoration: TextDecoration.none),
                ),
              ), // <-- Text
              backgroundColor: foregroundGrey,
              onPressed: () {
                backToLogin(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
