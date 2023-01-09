import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/openingScreens/first_time_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/Main%20App%20Body/start_page.dart';
import 'package:gymchimp/user.dart';
import 'package:sqflite/sqflite.dart';
import 'Main App Body/plan/plan_page.dart';
import 'Main App Body/workout/workout.dart';
import 'firebase_options.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//initialize and connect to flutter firebase, run main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final database = openDatabase(
    join(await getDatabasesPath(), 'user_database.db'),
  );
  runApp(const MyApp());
}

//***************************************************//
//Global Variables
var userInstance = FirebaseAuth.instance.currentUser;
var imperialSystem = true;
var weightUnit = '';
var userName = "";
// StreamController<int> streamController = StreamController<int>();
StreamController<String> nameController = StreamController<String>();

//***************************************************//
//Global colors
List<Color> secondaryGradient = GradientColors.happyAcid;
List<Color> primaryGradient = GradientColors.royalBlue;
Color backgroundGrey = Color.fromARGB(255, 221, 221, 221);
Color accentColor = Color.fromARGB(255, 43, 94, 167);
List<BoxShadow> shadow = const [
  BoxShadow(
      color: Color.fromARGB(72, 0, 0, 0),
      offset: Offset(0.0, 2.0),
      blurRadius: 8.0),
  BoxShadow(
      color: Color.fromARGB(72, 0, 0, 0),
      offset: Offset(0.0, -2.0),
      blurRadius: 8.0),
];

//***************************************************//
//Global changepage method
void changePage(BuildContext ctx, Widget page) {
  Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => page));
}
//***************************************************//

//***************************************************//
//Default background for entire app
BoxDecoration backGround() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color.fromARGB(255, 255, 255, 255),
        Color.fromARGB(255, 255, 255, 255),
      ], // Gradient from https://learnui.design/tools/gradient-generator.html
      tileMode: TileMode.mirror,
    ),
  );
}
//***************************************************//

//***************************************************//
//Global method to fetch a user data from database
FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<String> fetchInfo(String info) async {
  String output = "";
  var firebaseUser = await FirebaseAuth.instance.currentUser!;
  await firestore.collection('users').doc(firebaseUser.uid).get().then((value) {
    output = value.get(info);
  });
  return output;
}
//***************************************************//

//***************************************************//
//Global method to updates user data on database
void updateInfo(String label, String text) async {
  var firebaseUser = await FirebaseAuth.instance.currentUser!;
  await firestore.collection('users').doc(firebaseUser.uid).update(({
        label: text,
      }));
}
//***************************************************//

CurrentUser currentUser = CurrentUser();

Future<void> addUserInfo() async {
  Future<List> addUserInfo2() async {
    List queries = ["name", "email", "gender", "unit", "level"];
    List querieReturn = [];
    queries.forEach((element) async {
      await fetchInfo(element).then((String result) {
        querieReturn.add(result);
      });
    });

    return queries;
  }

  List querieReturn = await addUserInfo2();
  currentUser.setName = querieReturn[0];
  currentUser.setEmail = querieReturn[1];
  currentUser.setGender = querieReturn[2];
  currentUser.setUnits = querieReturn[3];
  currentUser.setLevel = querieReturn[4];

  //Future.delayed(Duration(milliseconds: 1000), () {});
}

void readWorkoutsFirebase() async {
  QuerySnapshot querySnapshot = await firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('workouts')
      .get();

  List list = querySnapshot.docs;
  List list2 = [];

  for (dynamic element in list) {
    String doc = "";
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(element.id)
        .get()
        .then(
      (value) {
        doc = value.get("name");
        currentUser.addWorkout(Workout(doc));
      },
    );
    // listKey.currentState
    //     ?.insertItem(0, duration: const Duration(milliseconds: 200));
  }
  //await new Future.delayed(const Duration(milliseconds: 150));

  // list.forEach((element) {
  //   String doc = "";
  //   firestore
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('workouts')
  //       .doc(element.id)
  //       .get()
  //       .then(
  //     (value) {
  //       print("test");
  //       doc = value.get("name");
  //       currentUser.addWorkout(Workout(doc));
  //     },
  //   );
  //   listKey.currentState
  //       ?.insertItem(0, duration: const Duration(milliseconds: 200));
  // });

  for (Workout workout in currentUser.userWorkouts) {
    querySnapshot = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(workout.getName())
        .collection('exercises')
        .get();

    List list = querySnapshot.docs;

    workout.exercises = List<String>.filled(list.length, "", growable: true);
    workout.reps = List<List<int>>.filled(list.length, [], growable: true);

    for (dynamic element in list) {
      String exerciseName = "";
      List<int> repetitions = [];
      int exerciseIndex = 0;
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('workouts')
          .doc(workout.getName())
          .collection('exercises')
          .doc(element.id)
          .get()
          .then(
        (value) {
          exerciseName = value.get('name');
          value.get('reps').forEach((rep) {
            repetitions.add(rep);
            exerciseIndex = value.get('index');
          });
          workout.exercises[exerciseIndex] = exerciseName;
          workout.reps[exerciseIndex] = repetitions;
        },
      );
    }

    // list.forEach((element) async {
    //   String exerciseName = "";
    //   List<int> repetitions = [];
    //   int exerciseIndex = 0;
    //   await firestore
    //       .collection('users')
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .collection('workouts')
    //       .doc(workout.getName())
    //       .collection('exercises')
    //       .doc(element.id)
    //       .get()
    //       .then(
    //     (value) {
    //       exerciseName = value.get('name');
    //       value.get('reps').forEach((rep) {
    //         repetitions.add(rep);
    //         exerciseIndex = value.get('index');
    //       });
    //       workout.exercises[exerciseIndex] = exerciseName;
    //       workout.reps[exerciseIndex] = repetitions;
    //     },
    //   );
    // });
  }
  // currentUser.userWorkouts.forEach((workout) async {
  //   querySnapshot = await firestore
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('workouts')
  //       .doc(workout.getName())
  //       .collection('exercises')
  //       .get();

  //   List list = querySnapshot.docs;

  //   workout.exercises = List<String>.filled(list.length, "", growable: true);
  //   workout.reps = List<List<int>>.filled(list.length, [], growable: true);

  //   list.forEach((element) async {
  //     String exerciseName = "";
  //     List<int> repetitions = [];
  //     int exerciseIndex = 0;
  //     await firestore
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .collection('workouts')
  //         .doc(workout.getName())
  //         .collection('exercises')
  //         .doc(element.id)
  //         .get()
  //         .then(
  //       (value) {
  //         exerciseName = value.get('name');
  //         value.get('reps').forEach((rep) {
  //           repetitions.add(rep);
  //           exerciseIndex = value.get('index');
  //         });
  //         workout.exercises[exerciseIndex] = exerciseName;
  //         workout.reps[exerciseIndex] = repetitions;
  //       },
  //     );
  //   });
  // });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application. Launches firstLogin page
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    bool loggedIn = false;
    if (FirebaseAuth.instance.currentUser != null) {
      loggedIn = true;
      addUserInfo();
      readWorkoutsFirebase();
    } else {
      loggedIn = false;
    }
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.

/*
          EXAMPLE USAGE:
                  style: Theme.of(context).textTheme.titleLarge,

                  To make color changes:
                  ?.copyWith(color: Theme.of(context).colorScheme.primary)),
          */
        colorScheme: ColorScheme.fromSeed(
            background: Color.fromARGB(255, 221, 221, 221),
            seedColor: Color.fromARGB(255, 157, 191, 255),
            secondary: Color.fromARGB(255, 44, 57, 64)),

        // Define the default font family.
        fontFamily: 'sourceSansPro',
      ),
      title: 'GymChimp',
      home: loggedIn ? StartPage() : const FirstLogIn(),
    );
  }
}
