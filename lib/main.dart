import 'package:cloud_firestore/cloud_firestore.dart';
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
var input = '';

void changePage(BuildContext ctx, Widget page) {
  Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => page));
}

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

FirebaseFirestore firestore = FirebaseFirestore.instance;
String userName = "";
Future<String> fetchInfo(String info) async {
  String output = "";
  var firebaseUser = await FirebaseAuth.instance.currentUser!;
  await firestore.collection('users').doc(firebaseUser.uid).get().then((value) {
    output = value.get(info);
  });
  return output;
}

void updateInfo(String label, String text) async {
  var firebaseUser = await FirebaseAuth.instance.currentUser!;
  await firestore.collection('users').doc(firebaseUser.uid).update(({
        label: text,
      }));
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
      fetchInfo('name');
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
