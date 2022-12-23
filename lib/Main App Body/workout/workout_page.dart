import 'package:flutter/material.dart';
import 'package:gymchimp/Main%20App%20Body/workout/countdown.dart';
import 'package:gymchimp/Main%20App%20Body/workout/stopwatch.dart';
import '../app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPage();
}

class _WorkoutPage extends State<WorkoutPage> {
  @override
  void initState() {
    super.initState();
  }

  int activepage = 0;

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.blue : Colors.grey,
            shape: BoxShape.circle),
      );
    });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Navigator(onGenerateRoute: (settings) {
      return MaterialPageRoute(
        builder: (_) => MaterialApp(
          title: 'Welcome to Flutter',
          home: Scaffold(
            appBar: MyAppBar(context, true),
            backgroundColor: Colors.transparent,
            body: Container(
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  CarouselSlider(
                    items: [StopWatch(), countdown()],
                    options: CarouselOptions(
                      height: size.height / 5,
                      enableInfiniteScroll: false,
                      onPageChanged: ((index, reason) {
                        setState(() {
                          activepage = index;
                        });
                      }),
                      viewportFraction: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators(2, activepage),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
