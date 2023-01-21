import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gymchimp/Main%20App%20Body/plan/plan%20page/plan_page.dart';
import 'package:gymchimp/main.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'plan/nutrition/nutrition_page.dart';
import 'stats/stats_page.dart';
import 'workout/workout_page.dart';
import 'package:path/path.dart' as Path;

class HomePage extends StatefulWidget {
  final int selectedIndex;
  const HomePage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  HomePageState createState() =>
      HomePageState(selectedIndex: this.selectedIndex);
}

void goBack(BuildContext ctx) {
  Navigator.of(ctx).pop();
}

var currentIndex = 0;

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int selectedIndex;
  HomePageState({required this.selectedIndex});

  PageController pageController = PageController(initialPage: 0);
  @override
  void initState() {
    pageController = PageController(initialPage: selectedIndex);
    super.initState();
  }

  PageController getPageController() {
    return pageController;
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // List of 4 pages
  static List<Widget> _children = <Widget>[
    WorkoutPage(),
    StatsPage(),
    NutritionPage(),
    PlanPage()
  ];

  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //Widget page = _widgetOptions.elementAt(selectedIndex);
    // var testKey;
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: IndexedStack(
        index: selectedIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            label: 'Workout',
            backgroundColor: foregroundGrey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights_outlined),
            label: 'Stats',
            backgroundColor: foregroundGrey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            label: 'Nutrition',
            backgroundColor: foregroundGrey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Plan',
            backgroundColor: foregroundGrey,
          ),
        ],
        currentIndex: selectedIndex,
        backgroundColor: accentColor,
        enableFeedback: true,
        showUnselectedLabels: true,
        unselectedItemColor: textColor,
        selectedItemColor: accentColor,
        onTap: (idx) => setState(() {
          selectedIndex = idx;
          if (idx == 0) {
            showTopSnackBar(
              curve: Curves.easeIn,
              animationDuration: Duration(milliseconds: 450),
              displayDuration: Duration(milliseconds: 650),
              Overlay.of(context)!,
              const CustomSnackBar.error(
                message: 'Swipe down to reload',
              ),
            );
          }
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
