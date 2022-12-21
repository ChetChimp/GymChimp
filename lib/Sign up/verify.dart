import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymchimp/main.dart';
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

//***************************************************//
//Sends an email verification to the user and uses a timer
//to check if the verification link was pressed
  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }
//***************************************************//

//***************************************************//
//Deletes timer used to check for email verification
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
//***************************************************//

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: backGround(),
      child: Column(
        children: [
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

//***************************************************//
//Method to check if email is verified when called
//If it is verified create pressable dialog to send user to login
  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    //if user is verified
    if (user.emailVerified) {
      timer.cancel();
      //initialize popup dialog 'check mark'
      var alertDialog = Material(
        color: Colors.redAccent.withOpacity(0),
        child: IconButton(
            color: Color.fromARGB(255, 0, 255, 106),
            iconSize: MediaQuery.of(context).size.width / 2,
            icon: Icon(Icons.check_circle),
            onPressed: () {
              //when dialog pressed --> Go To loginPage
              toLoginPage(context);
            }),
      );
      //display dialog to user
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog;
          });
    }
  }
//***************************************************//

  //remove and replace with generic navigation method
  void toLoginPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
