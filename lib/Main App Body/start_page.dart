import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/Main%20App%20Body/account_settings.dart';
import 'package:gymchimp/Main%20App%20Body/app_bar.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import 'package:gymchimp/login-signup/Sign%20up/sign_up_page.dart';
import 'package:gymchimp/objects/general_loader.dart';
import '../Firebase/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import 'home_page.dart';

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPage();
}

Widget HomeTile(BuildContext context, int index, String title, Widget icon,
    LinearGradient gradient) {
  return Container(
    child: ElevatedButton(
        style: TextButton.styleFrom(backgroundColor: foregroundGrey),
        onPressed: () {
          toHomePage(context, index);
          generalLoader(context);
        },
        child: Column(
          children: <Widget>[
            icon,
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  letterSpacing: .5,
                  decoration: TextDecoration.none),
            )
          ],
        )),
  );
}

Function holder = () {};

void toHomePage(BuildContext ctx, int page) {
  Navigator.of(ctx).push(
      MaterialPageRoute(builder: (context) => HomePage(selectedIndex: page)));
}

void extraPopOut(BuildContext ctx) {
  Widget build(BuildContext context) {
    return (PopupMenuButton(
      itemBuilder: (_) {
        return [
          const PopupMenuItem(child: Text("Item2")),
          const PopupMenuItem(child: Text("Item3"))
        ];
      },
    ));
  }
}

class _StartPage extends State<StartPage> {
  @override
  void initState() {
    fetchInfo('unit').then((String result) {
      if (mounted) {
        setState(() {
          weightUnit = result;
          if (weightUnit == 'inches/Lbs') {
            imperialSystem = true;
          } else {
            imperialSystem = false;
          }
        });
      }
    });
    fetchInfo('name').then((String result) {
      if (mounted) {
        setState(() {
          userName = result;
        });
      }
    });
    holder = mySetState;
    super.initState();
  }

  void mySetState(String newName) {
    setState(() {
      userName = newName;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundGrey),
      child: Scaffold(
        appBar: MyAppBar(context, false, "start_page"),
        backgroundColor: backgroundGrey,
        body: Center(
          child: Column(
            children: <Widget>[
              Spacer(flex: 1),
              Text(
                "GymChimp",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 6,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: .5,
                    decoration: TextDecoration.none),
              ),
              Spacer(flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Workout Button
                  Spacer(flex: 1),
                  HomeTile(
                      context,
                      0,
                      "Workout",
                      Text(
                        String.fromCharCode(
                            Icons.fitness_center_sharp.codePoint),
                        style: TextStyle(
                            fontFamily: Icons.fitness_center_sharp.fontFamily,
                            inherit: false,
                            package: Icons.fitness_center_sharp.fontPackage,
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 2.5),
                      ),
                      LinearGradient(colors: primaryGradient)),
                  const SizedBox(width: 5),
                  // Stats Button
                  HomeTile(
                      context,
                      1,
                      "Stats",
                      Text(
                        String.fromCharCode(Icons.insights_sharp.codePoint),
                        style: TextStyle(
                            fontFamily: Icons.insights_sharp.fontFamily,
                            inherit: false,
                            package: Icons.insights_sharp.fontPackage,
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 2.5),
                      ),
                      LinearGradient(
                        colors: [primaryGradient[1], primaryGradient[0]],
                      )),
                  Spacer(flex: 1),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Nutrition Button
                  HomeTile(
                      context,
                      2,
                      "Nutrition",
                      Icon(Icons.fastfood_sharp,
                          size: MediaQuery.of(context).size.width / 2.5,
                          color: accentColor),
                      LinearGradient(colors: primaryGradient)),
                  const SizedBox(width: 5),
                  // Plan Button
                  HomeTile(
                      context,
                      3,
                      "Plan",
                      Icon(Icons.edit_sharp,
                          size: MediaQuery.of(context).size.width / 2.5,
                          color: accentColor),
                      LinearGradient(colors: primaryGradient))
                ],
              ),
              Spacer(flex: 5)
            ],
          ),
        ),
      ),
    );
  }
}
