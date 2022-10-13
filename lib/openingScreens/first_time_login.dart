import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/openingScreens/login_page.dart';

class FirstLogIn extends StatelessWidget {
  const FirstLogIn({Key? key}) : super(key: key);

  void loggedIn(BuildContext ctx) {
    Navigator.of(ctx).push(_createRoute());
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginPage(),
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Container(
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
        child: Column(
          children: [
            Container(
              height: size.height - size.height / 8,
              width: size.width,
              padding: EdgeInsets.only(top: size.height * 1 / 4),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'GymChimp',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                  color: Colors.black.withOpacity(0.4  ),
                                  offset: const Offset(7, 7),
                                  blurRadius: 20),
                            ],
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: .5,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: size.height / 15),
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

                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
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
