import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymchimp/openingScreens/login_page.dart';

import '../app_bar.dart';

class NewWorkout extends StatefulWidget {
  const NewWorkout({Key? key}) : super(key: key);

  @override
  State<NewWorkout> createState() => _NewWorkout();
}

class _NewWorkout extends State<NewWorkout> {
  final List<String> _items =
      List<String>.generate(25, (int index) => index.toString());
  Widget build(BuildContext ctx) {
    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Material(
            child: child,
          );
        },
        child: child,
      );
    }

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: MyAppBar(context, true),
        body: Center(
          child: ReorderableListView(
            proxyDecorator: proxyDecorator,
            onReorderStart: (int oldIndex) {},
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                if (newIndex >= _items.length) {
                  newIndex -= 1;
                }
                final String item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });
            },
            padding: EdgeInsets.all(8),
            children: <Widget>[
              for (int index = 0; index < _items.length; index += 1)
                Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    key: Key('$index'),
                    height: 50,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(Icons.drag_indicator),
                            Spacer(),
                            Text('${_items[index]}'),
                            Spacer(),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.transparent)),
                              child: Icon(Icons.edit),
                              onPressed: () {
                                modifyExercise(ctx, '${_items[index]}', index);
                              },
                            ),
                          ],
                        ))),
              Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  key: Key("-1"),
                  height: 50,
                  child: GestureDetector(
                    onLongPress:
                        () {}, //Ensures that the plus button cannot be moved
                    child: OutlinedButton(
                        onPressed: () {
                          modifyExercise(ctx, "", -1);
                        },
                        child: Center(
                          child: Icon(Icons.add),
                        )),
                  ) //),
                  )
            ],
          ),
        ),
      ),
    );
  }

  void modifyExercise(BuildContext ctx, String name, int changeIndex) {
    //If changeIndex is -1, we are adding a new exercise
    String newName = name;
    showModalBottomSheet<void>(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(35),
        topRight: Radius.circular(35),
      )),
      context: ctx,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(30), child: Text("Add/Edit Exercise")),
              Spacer(),
              TextField(
                // decoration:
                //     InputDecoration(labelText: name, fillColor: Colors.black),
                controller: TextEditingController(text: name),
                onChanged: (value) {
                  newName = value;
                },
              ),
              Spacer(),
              Row(
                children: <Widget>[
                  Spacer(
                    flex: 3,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          padding: EdgeInsets.all(25),
                          primary: Colors.red,
                          minimumSize: Size(150, 75)),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              title: const Text(
                                  'Are you sure you want to delete this exercise?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('No, go back'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    'Yes, delete it',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pop(ctx);
                                    setState(() {
                                      if (changeIndex != -1) {
                                        _items.removeAt(changeIndex);
                                      }
                                    });
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Delete")),
                  Spacer(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          padding: EdgeInsets.all(25),
                          primary: Colors.blue,
                          minimumSize: Size(150, 75)),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          if (changeIndex == -1) {
                            _items.add(newName);
                          } else {
                            _items[changeIndex] = newName;
                          }
                        });
                      },
                      child: Text("Save")),
                  Spacer(
                    flex: 3,
                  ),
                ],
              ),
              Spacer()
            ],
          ),
        );
      },
    );
  }
}
