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
import 'package:gymchimp/openingScreens/plan_page.dart';
import 'package:gymchimp/openingScreens/sign_up_page.dart';
import '../firebase_options.dart';

class NewWorkout extends StatefulWidget {
  const NewWorkout({Key? key}) : super(key: key);

  @override
  State<NewWorkout> createState() => _NewWorkout();
}

class _NewWorkout extends State<NewWorkout> {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: MyAppBar(context),
        body: const Center(
          child: Text('New Workout Page'),
        ),
      ),
    );
  }
}
