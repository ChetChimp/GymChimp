import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gymchimp/Main%20App%20Body/app_bar.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

// void signOutUser(BuildContext ctx) {
//   final auth = FirebaseAuth.instance;
//   auth.signOut();
//   Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => FirstLogIn()));
// }

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (_) => MaterialApp(
                  home: Scaffold(
                    body: const Center(
                      child: Text('Stats Page'),
                    ),
                  ),
                ));
        // WidgetBuilder builder;
        // builder = (BuildContext _) =>
      },
    );
  }
}
