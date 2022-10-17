import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymchimp/openingScreens/first_time_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/openingScreens/home_page.dart';
import 'package:gymchimp/openingScreens/start_page.dart';
import 'firebase_options.dart';

//initialize and connect to flutter firebase, run main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // isLoggedIn() async {
  //   if (await FirebaseAuth.instance.currentUser != null) {
  //     print('User is currently signed out!');
  //     loggedIn = false;
  //   } else {
  //     loggedIn = true;
  //   }
  // }

  // This widget is the root of your application. Launches firstLogin page
  @override
  Widget build(BuildContext context) {
    bool loggedIn = false;
    if (FirebaseAuth.instance.currentUser != null) {
      //await
      loggedIn = true;
    } else {
      loggedIn = false;
    }

    return MaterialApp(
        title: 'GymChimp',

        //home: loggedIn ? const StartPage() : const FirstLogIn(),
        home: HomePage(selectedIndex: 3));
  }
}
