import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymchimp/Main%20App%20Body/home_page.dart';
import '../openingScreens/first_time_login.dart';
import 'package:gymchimp/main.dart';

void logOutUser(BuildContext ctx) {
  final auth = FirebaseAuth.instance;
  auth.signOut();

  Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => new FirstLogIn(),
      ),
      (route) => false);
}

class MyAppBar extends AppBar {
  MyAppBar(
    BuildContext ctx,
  ) : super(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          leading: IconButton(
              splashRadius: 20,
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                if (Navigator.of(ctx).canPop()) {
                  Navigator.of(ctx).pop();
                } else {
                  Navigator.of(ctx, rootNavigator: true).pop();
                }
              }),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            Container(
              child: PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                itemBuilder: (
                  BuildContext context,
                ) =>
                    <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Container(
                      child: ListTile(
                        leading: Icon(Icons.person_outline),
                        title: Text('Account'),
                      ),
                    ),
                  ),
                  // PopupMenuItem(
                  //   child: new Container(
                  //     color: Colors.transparent,
                  //     width: 1000,
                  //     child: ListTile(
                  //       onTap: () {},
                  //       leading: Icon(Icons.notifications_outlined),
                  //       title: PopupMenuButton(
                  //         child: Text("Notifications"),
                  //         itemBuilder: (_) {
                  //           return [
                  //             PopupMenuItem(
                  //                 child: ListTile(leading: Text("Item2"))),
                  //             PopupMenuItem(child: Text("Item3"))
                  //           ];
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  //   onTap: () {},
                  // ),
                  PopupMenuItem(
                    enabled: true,
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          child: ListTile(
                            onTap: () {},
                            leading: Icon(Icons.scale_outlined),
                            title: Text(weightUnit),
                            trailing: Container(
                              child: Switch(
                                // This bool value toggles the switch.
                                value: imperialSystem,
                                activeColor: Colors.blue,
                                inactiveThumbColor: Colors.red,
                                inactiveTrackColor:
                                    Color.fromARGB(131, 255, 73, 73),
                                onChanged: (bool value) {
                                  // This is called when the user toggles the switch.
                                  setState(() {
                                    imperialSystem = value;
                                    if (value) {
                                      weightUnit = 'inches/Lbs';
                                    } else {
                                      weightUnit = 'cm/Kg';
                                    }
                                    updateInfo('unit', weightUnit);
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: Container(
                      child: ListTile(
                        leading: Icon(Icons.lock_outline),
                        title: Text('Sign Out'),
                        onTap: () {
                          logOutUser(context);
                        },
                      ),
                    ),
                  ),
                ],
                splashRadius: 20,
                icon: Icon(color: Colors.black, Icons.settings_outlined),
              ),
            ),
          ],
        );
  // }
}
