// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:gymchimp/openingScreens/login_page.dart';
// import '../app_bar.dart';
// import 'new_workout.dart';

// class PlanPage extends StatefulWidget {
//   const PlanPage({Key? key}) : super(key: key);

//   @override
//   State<PlanPage> createState() => _PlanPage();
// }

// void newWorkout(BuildContext ctx) {
//   Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => NewWorkout()));
// }

// class _PlanPage extends State<PlanPage> {
//   Widget build(BuildContext context) {
//     return Navigator(
//       onGenerateRoute: (settings) {
//         return MaterialPageRoute(
//             builder: (_) => MaterialApp(
//                   title: 'Welcome to Flutter',
//                   home: Scaffold(
//                     appBar: MyAppBar(context, true),
//                     body: const Center(
//                       child: Text('Welcome to Plan Page'),
//                     ),
//                     floatingActionButton: FloatingActionButton(
//                       onPressed: () {
//                         newWorkout(_);
//                       },
//                       child: Icon(Icons.add),
//                     ),
//                   ),
//                 ));
//         // WidgetBuilder builder;
//         // builder = (BuildContext _) =>
//       },
//     );
//   }
// }
