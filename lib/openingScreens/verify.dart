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
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:gymchimp/openingScreens/sign_up_page.dart';
import '../firebase_options.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
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
            Color.fromARGB(255, 6, 184, 107),
            Color.fromARGB(255, 197, 193, 190),
          ], // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.mirror,
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: size.width * 1 / 1.5),
            child: Icon(
              color: Colors.black,
              size: size.width / 3,
              Icons.check_box_rounded,
            ),
          ),
          const Center(
            child: Card(
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
          Container(
            margin: EdgeInsets.only(top: size.width * 1 / 3),
            child: CupertinoButton(
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
              child: (Text(
                "Done",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              onPressed: () {}, //validation(context),
            ),
          ),
        ],
      ),
    );
  }
}
