// ignore_for_file: unnecessary_new

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/Main%20App%20Body/app_bar.dart';
import 'package:gymchimp/main.dart';

class askInfo extends StatefulWidget {
  @override
  _askInfoState createState() => _askInfoState();
}

// Reference: https://thatmandonald.medium.com/using-cupertinopicker-and-textfield-to-create-a-fancy-height-picker-with-flutter-da03e990e9e5

enum HeightUnit { ft, cm }

enum WeightUnit { lbs, kg }

class _askInfoState extends State<askInfo> {
  // Variable

  //Height
  HeightUnit selectedHeightUnit = HeightUnit.ft;
  TextEditingController heightController = TextEditingController();
  int ft = 0;
  int inches = 0;
  String cm = "";

  //Weight
  WeightUnit selectedWeightUnit = WeightUnit.lbs;
  TextEditingController weightController = TextEditingController();
  double lbs = 0;
  double kg = 0;

  //Birth date
  DateTime dateTime = DateTime.now();
  bool formSubmitted = false;
  TextEditingController dateController = TextEditingController();

  /*
  Prompts user with a Cupertino-styled popup for selecting a date based on Month/Day/Year
 */
  void _showDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Container(
        height: 500,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(children: [
          SizedBox(
            height: 400,
            child: CupertinoDatePicker(
              minimumDate: DateTime(1900, 1, 1),
              maximumDate: DateTime.now(),
              maximumYear: DateTime.now().year,
              initialDateTime: dateTime,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (dateTime) =>
                  setState(() => this.dateTime = dateTime),
            ),
          ),

          // Close the modal
          CupertinoButton(
            child: const Text('OK'),
            onPressed: ({dynamic formSubmitted = true}) =>
                Navigator.of(ctx).pop(),
          )
        ]),
      ),
    );
  }

  /*
  - Called when top left back arrow is pressed
  - Pops back to FirstLogIn()
*/
  void goBack(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  /*
  - Navigates to desired page with custom transition
*/
  Route navigate(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backgroundGrey,
        appBar: MyAppBar(context, true, "askInfo"),
        body: Center(
            child: Column(
          children: [
            Text(
              'Extra Info',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: accentColor,
                fontSize: size.height / 32,
              ),
            ),
            Spacer(),

            Row(
              children: [
                Container(
                  width: size.width * (3 / 4),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      hintText: 'Enter your height',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w100,
                        color: Colors.white,
                        fontSize: size.height / 32,
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                      fontSize: size.height / 32,
                    ),
                    onTap: selectedHeightUnit == HeightUnit.ft
                        ? () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: size.height / 4,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: CupertinoPicker(
                                            itemExtent: 32.0,
                                            onSelectedItemChanged: (int index) {
                                              // print(index + 1);
                                              setState(() {
                                                ft = (index + 1);
                                                heightController.text =
                                                    "$ft' $inches\"";
                                              });
                                            },
                                            children:
                                                List.generate(12, (index) {
                                              return Center(
                                                child: Text('${index + 1}'),
                                              );
                                            }),
                                          ),
                                        ),
                                        const Expanded(
                                            // flex: 1,
                                            child: Center(
                                                child: Text('ft',
                                                    style: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    )))),
                                        Expanded(
                                          child: CupertinoPicker(
                                            itemExtent: 32.0,
                                            onSelectedItemChanged: (int index) {
                                              print(index);
                                              setState(() {
                                                inches = (index);
                                                heightController.text =
                                                    "$ft' $inches\"";
                                              });
                                            },
                                            children:
                                                List.generate(12, (index) {
                                              return Center(
                                                child: Text('$index'),
                                              );
                                            }),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 3,
                                          child: Center(
                                              child: Text('inches',
                                                  style: TextStyle(
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ))),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          }
                        : null,
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.center,
                    cursorColor: Color.fromARGB(255, 46, 47, 55),

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (heightController.text.isEmpty) {
                          selectedHeightUnit = HeightUnit.ft;
                        } else {
                          selectedHeightUnit = HeightUnit.ft;
                          checkHeightUnit();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: selectedHeightUnit == HeightUnit.ft
                              ? Color(0xFFFF7401)
                              : Colors.transparent,
                        ),
                        color: Colors.transparent,
                      ),
                      width: 31,
                      height: 31,
                      child: Center(
                          child: Text('ft', style: TextStyle(fontSize: 16))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (heightController.text.isEmpty) {
                          selectedHeightUnit = HeightUnit.cm;
                        } else {
                          selectedHeightUnit = HeightUnit.cm;
                          checkHeightUnit();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: selectedHeightUnit == HeightUnit.cm
                              ? Color(0xFFFF7401)
                              : Colors.transparent,
                        ),
                        color: Colors.transparent,
                      ),
                      width: 31,
                      height: 31,
                      child: Center(
                          child: Text('cm', style: TextStyle(fontSize: 16))),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
///////////////////////////////////////////////////////////////////////////////////////////////

            Row(
              children: [
                Container(
                  //decoration: backGround(),

                  width: size.width * (3 / 4),
                  child: TextFormField(
//
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      hintText: 'Enter your weight',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w100,
                        color: Colors.white,
                        fontSize: size.height / 32,
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                      fontSize: size.height / 32,
                    ),
//
                    onTap: selectedWeightUnit == WeightUnit.lbs
                        ? () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          }
                        : null,
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.center,
                    cursorColor: Color.fromARGB(255, 46, 47, 55),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (weightController.text.isEmpty) {
                          selectedWeightUnit = WeightUnit.lbs;
                        } else {
                          selectedWeightUnit = WeightUnit.lbs;
                          //checkWeightUnit();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: selectedWeightUnit == WeightUnit.lbs
                              ? Color(0xFFFF7401)
                              : Colors.transparent,
                        ),
                        color: Colors.transparent,
                      ),
                      width: 31,
                      height: 31,
                      child: Center(
                          child: Text('lbs', style: TextStyle(fontSize: 16))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (weightController.text.isEmpty) {
                          selectedWeightUnit = WeightUnit.kg;
                        } else {
                          selectedWeightUnit = WeightUnit.kg;
                          //checkWeightUnit();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: selectedWeightUnit == WeightUnit.kg
                              ? Color(0xFFFF7401)
                              : Colors.transparent,
                        ),
                        color: Colors.transparent,
                      ),
                      width: 31,
                      height: 31,
                      child: Center(
                          child: Text('kg', style: TextStyle(fontSize: 16))),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _showDatePicker(context),
                  child: TextFormField(
                    controller: dateController,
//
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      hintText: 'Enter your birthday',
                      hintStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),

                    onTap: () => _showDatePicker(context),
                  ),
                ),
              ),
            ),

            Spacer(flex: 10),
          ],
        )));
  }

  void checkHeightUnit() {
    if (selectedHeightUnit == HeightUnit.ft) {
      setState(() {
        int inchess = (double.parse(heightController.text) ~/ 2.54).toInt();
        cmToInches(inchess);
        heightController.text = '$ft\' $inches"';
      });
    } else if (selectedHeightUnit == HeightUnit.cm) {
      setState(() {
        print(heightController.text);
        inchesToCm();
      });
    }
  }

  cmToInches(inchess) {
    ft = inchess ~/ 12;
    inches = inchess % 12;
    print('$ft feet and $inches inches');
    print("test");
  }

  inchesToCm() {
    int inchesTotal = (ft * 12) + inches;
    cm = (inchesTotal * 2.54).toStringAsPrecision(5);
    heightController.text = cm;
  }
}
