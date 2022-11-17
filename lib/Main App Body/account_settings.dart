import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gymchimp/main.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

bool nameEditActive = false;
Icon nameEditIcon = Icon(Icons.edit);
String name = user!.email.toString();
TextEditingController nameEditController = TextEditingController(text: name);

bool ageEditActive = false;
Icon ageEditIcon = Icon(Icons.edit);
String age = user!.email.toString();
TextEditingController ageEditController = TextEditingController(text: age);

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
            splashRadius: 20,
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            }),
        title: Text(style: TextStyle(color: Colors.black), "Account Settings"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: backGround(),
        child: Column(
          children: [
            Spacer(flex: 1),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          "Name:"),
                    ),
                    Flexible(
                        child: TextField(
                            enabled: nameEditActive,
                            controller: nameEditController)),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          nameEditActive = !nameEditActive;
                          if (nameEditActive) {
                            nameEditIcon = Icon(Icons.check);
                          } else {
                            nameEditIcon = Icon(Icons.edit);
                          }
                        });
                      },
                      icon: nameEditIcon,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
