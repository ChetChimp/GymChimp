import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gymchimp/Main%20App%20Body/app_bar.dart';
import 'package:gymchimp/Main%20App%20Body/stats/search_exercise_widget.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/objects/workout.dart';
import '../plan/new workout page/new_workout_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'lineChartWidget.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

bool beginLoading = false;

class _StatsPageState extends State<StatsPage> {
  @override
  void initState() {
    exerciseTempL = currentUser.userExerciseList.toList();
    exerciseSearchList = currentUser.userExerciseList.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => MaterialApp(
            home: Scaffold(
              backgroundColor: backgroundGrey,
              appBar: MyAppBar(context, false, "stats_page"),
              body: Column(
                children: [
                  const SearchExercise(),
                  if (beginLoading)
                    Container(
                      color: backgroundGrey,
                      child: Center(
                        child: SpinKitPouringHourGlassRefined(
                          duration: const Duration(seconds: 1),
                          color: accentColor,
                          size: MediaQuery.of(context).size.height / 12,
                        ),
                      ),
                    ),
                  if (!beginLoading)
                    SizedBox(
                      height: size.height / 3,
                      width: size.width - 20,
                      child: LineChartWidget(),
                    ),
                ],
              ),
            ),
          ),
        );
        // WidgetBuilder builder;
        // builder = (BuildContext _) =>
      },
    );
  }
}
