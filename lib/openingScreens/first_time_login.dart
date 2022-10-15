import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:gymchimp/openingScreens/sign_up_page.dart';

class FirstLogIn extends StatelessWidget {
  const FirstLogIn({Key? key}) : super(key: key);

/*
  -animation for page change, used for majority of navigation
  -changes pages instantly
  -will be cleaned up, animaitons are not necessary
*/
  Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration(milliseconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
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

  void test() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

/*
  -called when "Already have an account" button is pushed, 
  -makes call to createRoute method to take user to login page
*/
  void loggedIn(BuildContext ctx) {
    Navigator.of(ctx).push(createRoute(LoginPage()));
  }

/*
  -called when "GetStarted" button is pushed, 
  -makes call to createRoute method to take user to signup page
*/
  void signup(BuildContext ctx) {
    Navigator.of(ctx).push(createRoute(SignUpPage()));
  }

/*
  Overarching structure of page layout
*/
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home:
          /*
      -Container that represents the full background of the app screen, 
      -creates light gray to dark gray gradient
      */
          Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color.fromARGB(233, 228, 240, 255),
              Color.fromARGB(211, 204, 227, 255),
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
        ),
        child:
            /*
        Column with three widgets:
          -Container for title
          -"Get Started" Button
          -"Already have an account? Log in here!" Button
        */
            Column(
          children: [
            /*
            Container holding title with set height and width
            -offset from top of the sreen by 25% of the height
            */
            Container(
              height: size.height - size.height / 8,
              width: size.width,
              padding: EdgeInsets.only(top: size.height * 1 / 4),
              child: Container(
                /*
                Column used to align Text widget
                */
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*
                    Text widget: "GymChimp", drop shadow, font = lato
                                -fontSize = 60, color = black
                    */
                    Text(
                      'GymChimp',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            letterSpacing: .5,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    /*
                    Container with margin to offset from previous container
                    -contains FloatingActionButton
                    */
                    Container(
                      margin: EdgeInsets.only(top: size.height / 25),
                      /*
                        FloatingActionButton with tag "btn1"
                        -preset space inside of button between border and text
                        - Text: "Get Started", font = lato, fontSize = 25, bold, color = black
                        -background = white
                        -when pressed, calls signUp method (takes user to signup page)
                      */
                      child: FloatingActionButton.extended(
                        heroTag: "btn1",
                        extendedPadding: EdgeInsets.only(
                            left: size.width / 8,
                            right: size.width / 8,
                            top: size.width / 16,
                            bottom: size.width / 16),
                        label: Text(
                          'Get Started',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1,
                                decoration: TextDecoration.none),
                          ),
                        ), // <-- Text
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        onPressed: () {
                          signup(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*
            Container containing FloatingActionButton
            */
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
                  'Already have an account? Log in here!',
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
                  loggedIn(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
