import 'package:flutter/material.dart';
import 'package:gymchimp/openingScreens/first_time_login.dart';
import 'package:firebase_core/firebase_core.dart';
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

  // This widget is the root of your application. Launches firstLogin page
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymChimp',
      home: const FirstLogIn(),
    );
  }
}
