import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/Main%20App%20Body/home_page.dart';
import 'package:gymchimp/Main%20App%20Body/workout/countdown.dart';
import 'package:gymchimp/Main%20App%20Body/workout/next_previous_done_button.dart';
import 'package:gymchimp/Main%20App%20Body/workout/stopwatch.dart';
import 'package:gymchimp/Main%20App%20Body/workout/workoutSummaryPopup.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/objects/exercise.dart';
import '../app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import '../../objects/workout.dart';

class MainCarousel extends StatefulWidget {
  MainCarousel({
    Key? key,
    required this.size,
    required this.setState,
  }) : super(key: key);

  final Size size;
  final Function setState;

  @override
  State<MainCarousel> createState() => _MainCarouselState();
}

class _MainCarouselState extends State<MainCarousel> {
  final CarouselController carouselController = CarouselController();

  int activepage = 0;

  List<Widget> indicators(currentIndex) {
    return List<Widget>.generate(2, (index) {
      if (index == 0) {
        return Container(
          // margin: EdgeInsets.only(left: 5, right: 5),
          child: IconButton(
            splashRadius: 1,
            onPressed: () {
              carouselController.animateToPage(0);
              widget.setState(() {
                indicators(0);
              });
            },
            icon: Icon(
              Icons.schedule,
              color: currentIndex == index ? Colors.white : Colors.grey,
            ),
          ),
        );
      } else if (index == 1) {
        return Container(
          // margin: EdgeInsets.only(left: 5, right: 5),
          child: IconButton(
            splashRadius: 1,
            onPressed: () {
              carouselController.animateToPage(1);
              widget.setState(() {
                indicators(1);
              });
            },
            icon: Icon(
              Icons.timer,
              color: currentIndex == index ? Colors.white : Colors.grey,
            ),
          ),
        );
      } else {
        return Icon(
          Icons.schedule,
          color: currentIndex == index ? Colors.white : Colors.grey,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: widget.size.height / 3.5,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(0, 255, 255, 255),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: CarouselSlider(
              carouselController: carouselController,
              items: [
                Container(
                    decoration: BoxDecoration(
                      color: foregroundGrey,
                      borderRadius: BorderRadius.circular(12.0),
                      // boxShadow: shadow
                    ),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: countdown()),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: foregroundGrey,
                      // gradient: LinearGradient(
                      //     colors: primaryGradient),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: StopWatch()),
              ],
              options: CarouselOptions(
                height: widget.size.height / 4,
                enableInfiniteScroll: false,
                onPageChanged: ((index, reason) {
                  widget.setState(() {
                    activepage = index;
                  });
                }),
                viewportFraction: .92,
              ),
            ),
          ),
        ),
        Positioned(
          left: widget.size.width / 2 - (widget.size.width / 8),
          top: widget.size.height / 4.55,
          child: Container(
            padding: EdgeInsets.all(5),
            width: widget.size.width / 4,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: indicators(activepage),
            ),
          ),
        ),
      ],
    );
  }
}
