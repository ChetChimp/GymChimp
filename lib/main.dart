import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymchimp/openingScreens/first_time_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/Main%20App%20Body/start_page.dart';
import 'firebase_options.dart';

//initialize and connect to flutter firebase, run main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

var user = FirebaseAuth.instance.currentUser;
var kg = true;
var input = 'inches/Lbs';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
BoxDecoration backGround() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment(0.8, 1),
      colors: <Color>[
        Color.fromARGB(255, 228, 240, 255),
        Color.fromARGB(255, 204, 227, 255),
      ], // Gradient from https://learnui.design/tools/gradient-generator.html
      tileMode: TileMode.mirror,
    ),
  );
}
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

      // initialRoute: FirebaseAuth.instance.currentUser() == null
      //     ? const FirstLogIn()
      //     : const StartPage(),
      // routes: {
      //   FirstLogIn.id: (context) => FirstLogIn(),
      //   StartPage.id: (context) => StartPage()
      // },
      home: loggedIn ? const StartPage() : const FirstLogIn(),
    );
  }
}
