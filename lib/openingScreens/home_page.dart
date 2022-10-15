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
import 'package:gymchimp/openingScreens/start_page.dart';
import 'package:gymchimp/openingScreens/workout_page.dart';
import '../firebase_options.dart';

class HomePage extends StatefulWidget {
  final int selectedIndex;
  const HomePage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _HomePage createState() => _HomePage(selectedIndex: this.selectedIndex);
}

void goBack(BuildContext ctx) {
  Navigator.of(ctx).pop();
}

class _HomePage extends State<HomePage> {
  int selectedIndex;
  _HomePage({required this.selectedIndex});

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // List of 4 pages
  static const List<Widget> _widgetOptions = <Widget>[
    WorkoutPage(),
    Text(
      'Index 1: Stats',
      style: optionStyle,
    ),
    Text(
      'Index 2: Nutrition',
      style: optionStyle,
    ),
    PlanPage(),
  ];

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HomePage(selectedIndex: 0),
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

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        //toolbarHeight: 30,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              goBack(context);
            }),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
              color: Colors.black,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {}),
        ],
      ),
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
