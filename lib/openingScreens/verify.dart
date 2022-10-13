import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymchimp/openingScreens/login_page.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
      child: Column(
        children: [
          // Container(
          //   margin: EdgeInsets.only(top: size.width * 1 / 1.5),
          //   child: Icon(
          //     color: Colors.black,
          //     size: size.width / 3,
          //     Icons.check_box_rounded,
          //   ),
          // ),
          Center(
            child: Card(
              margin: EdgeInsets.only(top: size.height * 1 / 2.5),
              shadowColor: Colors.transparent,
              color: Color.fromARGB(0, 255, 255, 255),
              child: Text(
                'Verify Email',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Center(
            child: Card(
              shadowColor: Colors.transparent,
              color: Color.fromARGB(0, 255, 255, 255),
              child: Text(
                'Please check your email!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      var alertDialog = Material(
        color: Colors.redAccent.withOpacity(0),
        child: IconButton(
            color: Colors.greenAccent[700],
            iconSize: MediaQuery.of(context).size.width / 2,
            icon: Icon(Icons.check_circle),
            onPressed: () {
              toLoginPage(context);
            }),
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog;
          });
    }
  }

  void toLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
