// ignore_for_file: unnecessary_new

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/openingScreens/home_page.dart';
import 'package:gymchimp/openingScreens/login_page.dart';
import 'package:gymchimp/questionnairePages/askLevel_page.dart';
import 'package:gymchimp/openingScreens/sign_up_page.dart';
import 'package:gymchimp/questionnairePages/weightPicker.dart';
import '../firebase_options.dart';

class askBody extends StatefulWidget {
  const askBody({Key? key}) : super(key: key);

  @override
  State<askBody> createState() => _askBody();
}

// Variables
bool heightEntered = false;
bool weightEntered = false;

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
    transitionDuration: Duration(milliseconds: 1),
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

class _askBody extends State<askBody> {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            //Background color
            colors: <Color>[
              Color.fromARGB(233, 228, 240, 255),
              Color.fromARGB(211, 204, 227, 255),
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
        ),
        child: Scaffold(
            backgroundColor: Color.fromRGBO(0, 0, 0, 0),
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              elevation: 0,
              leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    goBack(context);
                  }),
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                IconButton(
                    color: Colors.black,
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {}),
              ],
            ),
            body: Container(
              child: Center(
                /*
                  Text Form Field 
                    - Asks User 'Enter your first name'
                    - When Form is Submitted (clicking done on Keyboard popup) screen routes to askLevel page
                    - Horizontally centered
                    - Width: 350, Height: 400
                */
                child: SizedBox(
                  width: 350,
                  height: 400,
                  child: Column(
                    children: [
                      TextFormField(
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                            hintText: 'Enter your height',
                            hintStyle: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          // When form is submitted routes to askLevel page
                          onFieldSubmitted: (value) {
                            heightEntered = true;
                            if (weightEntered && heightEntered) {
                              Navigator.of(context).push(navigate(askLevel()));
                            }
                          }),
                      Spacer(),
                      TextFormField(
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          hintText: 'Enter your Weight',
                          hintStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),

                        // When form is submitted routes to askLevel page
                        onFieldSubmitted: (value) {
                          weightEntered = true;
                          if (weightEntered && heightEntered) {
                            Navigator.of(context).push(navigate(askLevel()));
                          }
                        },
                        // onTap: () => Navigator.of(context)
                        //     .push(navigate(weightPicker())),
                      ),
                      //                     InkWell(
                      // onTap: (){
                      //   showCupertinoModalPopup<void>(
                      //       context: context, builder: (BuildContext context){
                      //     return _buildBottomPicker(
                      //         _buildCupertinoPicker()
                      //     );
                      //   });
                      // },
                      // child: Column(
                      //   children: [
                      //     Container(
                      //       height: 50,
                      //       width:MediaQuery.of(context).size.width ,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(8),
                      //         color: Colors.pinkAccent
                      //       ),
                      //       child: Center(
                      //         child: Text("Cupertino Picker",
                      //         style: TextStyle(
                      //             color: Colors.white
                      //         ),),
                      //       ),
                      //     ),
                      //    // SizedBox(height: 30,),
                      //     Container(
                      //       padding: EdgeInsets.only(top: 8,bottom: 8),
                      //       child: Text("$selectItem",
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //               ),),
                      //                ),
                      //              ],
                      //             ),
                      //                 ),
                      Spacer(),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
