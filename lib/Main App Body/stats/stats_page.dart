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
import 'package:draggable_fab/draggable_fab.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startDocked,
              floatingActionButton: DraggableFab(
                child: FloatingActionButton(
                  heroTag: "ResetButton",
                  onPressed: () {
                    zoomPanBehavior.reset();
                  },
                  child: const Icon(Icons.refresh, color: Colors.white),
                  backgroundColor: Colors.blue,
                ),
              ),
              resizeToAvoidBottomInset: false,
              backgroundColor: backgroundGrey,
              appBar: MyAppBar(context, false, "stats_page"),
              body: Column(
                children: [
                  const SearchExercise(),
                  Expanded(
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
