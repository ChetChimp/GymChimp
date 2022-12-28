import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymchimp/openingScreens/first_time_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/Main%20App%20Body/start_page.dart';
import 'package:gymchimp/user.dart';
import 'Main App Body/plan/plan_page.dart';
import 'Main App Body/plan/workout.dart';
import 'firebase_options.dart';
import 'package:gymchimp/user.dart';

//initialize and connect to flutter firebase, run main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

//***************************************************//
//Global Variables
var userInstance = FirebaseAuth.instance.currentUser;
var imperialSystem = true;
var weightUnit = '';
var userName = "";
//***************************************************//

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
        Color.fromARGB(255, 187, 204, 255),
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
  print(querieReturn.toString());
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
  list.forEach((element) {
    currentUser.addWorkout(Workout(element.id));
    listKey.currentState
        ?.insertItem(0, duration: const Duration(milliseconds: 200));
  });

  currentUser.userWorkouts.forEach((workout) async {
    querySnapshot = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(workout.getName())
        .collection('exercises')
        .get();

    List list = querySnapshot.docs;

    list.forEach((element) async {
      String exerciseName = "";
      List<int> repetitions = [];
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
          });
          workout.addExercise(exerciseName, repetitions);
        },
      );
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application. Launches firstLogin page
  @override
  Widget build(BuildContext context) {
    addUserInfo();
    readWorkoutsFirebase();
    bool loggedIn = false;
    if (FirebaseAuth.instance.currentUser != null) {
      loggedIn = true;
    } else {
      loggedIn = false;
    }
    return MaterialApp(
      title: 'GymChimp',
      home: loggedIn ? const StartPage() : const FirstLogIn(),
    );
  }
}
