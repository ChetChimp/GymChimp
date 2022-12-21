import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/Main%20App%20Body/app_bar.dart';
import 'package:gymchimp/Main%20App%20Body/home_page.dart';
import 'package:gymchimp/Main%20App%20Body/stats/stats_page.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:gymchimp/Main%20App%20Body/plan/plan_page.dart';
import 'package:gymchimp/Sign%20up/sign_up_page.dart';
import 'package:gymchimp/Main%20App%20Body/start_page.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workout_page.dart';
import '../firebase_options.dart';
import 'nutrition/nutrition_page.dart';

class HomePage extends StatefulWidget {
  final int selectedIndex;
  const HomePage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _HomePage createState() => _HomePage(selectedIndex: this.selectedIndex);
}

void goBack(BuildContext ctx) {
  Navigator.of(ctx).pop();
}

var currentIndex = 0;

class _HomePage extends State<HomePage> {
  int selectedIndex;
  _HomePage({required this.selectedIndex});

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // List of 4 pages
  static const List<Widget> _widgetOptions = <Widget>[
    WorkoutPage(),
    StatsPage(),
    NutritionPage(),
    PlanPage(),
  ];

  void _onItemTapped(int index) {
    currentIndex = index;
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Widget page = _widgetOptions.elementAt(selectedIndex);
    // var testKey;
    return Scaffold(
      appBar: MyAppBar(context),
      extendBodyBehindAppBar: false,
      body: _widgetOptions.elementAt(selectedIndex),
      // Navigator(
      //   onGenerateRoute: (settings) {
      //     return MaterialPageRoute(
      //         builder: (_) => _widgetOptions.elementAt(selectedIndex));
      //   },
      // ),

      // body: Center(
      //   child: _widgetOptions.elementAt(selectedIndex),
      // ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights_outlined),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Plan',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Color.fromARGB(255, 35, 178, 90),
        onTap: _onItemTapped,
      ),
    );
  }
}
