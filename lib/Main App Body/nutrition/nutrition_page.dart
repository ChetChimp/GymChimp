import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gymchimp/Main%20App%20Body/app_bar.dart';

import '../../openingScreens/first_time_login.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({Key? key}) : super(key: key);

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (_) => MaterialApp(
                  title: 'Welcome to Flutter',
                  home: Scaffold(
                    appBar: MyAppBar(context),
                    body: const Center(
                      child: Text('Coming soon :)'),
                    ),
                  ),
                ));
        // WidgetBuilder builder;
        // builder = (BuildContext _) =>
      },
    );
  }
}
