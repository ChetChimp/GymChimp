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
import 'package:gymchimp/openingScreens/plan_page.dart';
import 'package:gymchimp/openingScreens/sign_up_page.dart';
import '../firebase_options.dart';

class NewWorkout extends StatefulWidget {
  const NewWorkout({Key? key}) : super(key: key);

  @override
  State<NewWorkout> createState() => _NewWorkout();
}

class _NewWorkout extends State<NewWorkout> {
  final List<int> _items = List<int>.generate(25, (int index) => index);
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: MyAppBar(ctx),
        body: Center(
          child: ReorderableListView(
            onReorderStart: (int oldIndex) {},
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final int item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });
            },
            padding: EdgeInsets.all(8),
            children: <Widget>[
              for (int index = 0; index < _items.length; index += 1)
                ExerciseListItem(
                  key: Key('$index'),
                  //tileColor: _items[index].isOdd ? oddItemColor : evenItemColor,
                  name: 'Item ${_items[index]}',
                ),
              ExerciseListItem(
                key: Key("0"),
                name: "George",
              ),
              Container(
                  key: Key("1"),
                  height: 50,
                  //color: Colors.amber[600],
                  //child: Center(
                  child: GestureDetector(
                    onLongPress: () {},
                    child: OutlinedButton(
                        onPressed: () {
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
                                height: 400,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.all(30),
                                        child: Text("Add/Edit Exercise")),
                                    Spacer(),
                                    ElevatedButton(
                                      child: const Text('Close BottomSheet'),
                                      onPressed: () => Navigator.pop(context),
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
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                padding: EdgeInsets.all(25),
                                                primary: Colors.red,
                                                minimumSize: Size(150, 75)),
                                            onPressed: () {
                                              showDialog<String>(
                                                context: context,
                                                barrierDismissible:
                                                    false, // user must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return ConfirmDeletePopup(
                                                    ctx: ctx,
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
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                padding: EdgeInsets.all(25),
                                                primary: Colors.blue,
                                                minimumSize: Size(150, 75)),
                                            onPressed: () {
                                              Navigator.pop(context);
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
}

class ConfirmDeletePopup extends StatelessWidget {
  final BuildContext ctx;

  const ConfirmDeletePopup({
    Key? key,
    required this.ctx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      title: const Text('Are you sure you want to delete this exercise?'),
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
          },
        )
      ],
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  final String name;
  const ExerciseListItem({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
        key: Key("0"),
        height: 50,
        //color: Colors.amber[600],
        //child: Center(
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
            onPressed: () {},
            child: Row(
              children: [
                Icon(Icons.drag_indicator),
                Spacer(),
                Text(name),
                Spacer(),
                Icon(Icons.edit),
              ],
            )) //),
        );
  }
}
