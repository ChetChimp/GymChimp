import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymchimp/main.dart';
import 'package:gymchimp/Main App Body/start_page.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

var name = userName;
TextEditingController nameEditController = TextEditingController(text: name);
bool nameEditActive = false;
Icon nameEditIcon = Icon(Icons.edit);

Color notSelected = Color.fromARGB(255, 140, 140, 143);
Color selected = Color.fromARGB(255, 11, 214, 79);
Color male = Color.fromARGB(255, 73, 102, 219);
Color female = Color.fromARGB(255, 234, 157, 206);
Color maleCurrent = notSelected;
Color femaleCurrent = notSelected;

String userGender = "";
void currentGender() {
  if (userGender == "Male") {
    maleCurrent = male;
    femaleCurrent = notSelected;
  } else {
    maleCurrent = notSelected;
    femaleCurrent = female;
  }
}

String userGoal = "";
Color bulkCurrent = notSelected;
Color cutCurrent = notSelected;
Color maintainCurrent = notSelected;
void currentGoal() {
  if (userGoal == "Cut") {
    bulkCurrent = notSelected;
    cutCurrent = selected;
    maintainCurrent = notSelected;
  } else if (userGoal == "Bulk") {
    bulkCurrent = selected;
    cutCurrent = notSelected;
    maintainCurrent = notSelected;
  } else {
    bulkCurrent = notSelected;
    cutCurrent = notSelected;
    maintainCurrent = selected;
  }
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  void initState() {
    fetchInfo('gender').then((String result) {
      if (mounted) {
        setState(() {
          userGender = result;
          currentGender();
        });
      }
    });
    fetchInfo('goal').then((String result) {
      if (mounted) {
        setState(() {
          userGoal = result;
          currentGoal();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: foregroundGrey,
        leading: IconButton(
            splashRadius: 20,
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            }),
        title: Text(style: TextStyle(color: accentColor), "Account Settings"),
      ),
      body: Container(
        color: backgroundGrey,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            //Spacer(flex: 1),
            Card(
              color: foregroundGrey,
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
                              color: accentColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          "Name:"),
                    ),
                    Flexible(
                        child: TextField(
                            style: TextStyle(color: Colors.white),
                            enabled: nameEditActive,
                            controller: nameEditController)),
                    IconButton(
                      splashRadius: 5,
                      color: accentColor,
                      onPressed: () {
                        setState(() {
                          nameEditActive = !nameEditActive;
                          if (nameEditActive) {
                            nameEditIcon = Icon(Icons.check);
                          } else {
                            updateInfo('name', nameEditController.text);
                            holder(nameEditController.text);
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
            Card(
              color: foregroundGrey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: Row(
                  children: [
                    Container(
                      width: size.width / 6.5,
                      padding: EdgeInsets.all(10),
                      child: Text(
                          style: TextStyle(
                              color: accentColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          "Sex:"),
                    ),
                    Spacer(),
                    Container(
                      width: size.width / 4,
                      child: FloatingActionButton.extended(
                        heroTag: "btn1",
                        extendedPadding: EdgeInsets.only(
                            left: size.width / 16,
                            right: size.width / 16,
                            top: size.width / 4,
                            bottom: size.width / 4),
                        label: Text(
                          'Male',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(197, 0, 0, 0),
                                letterSpacing: .5,
                                decoration: TextDecoration.none),
                          ),
                        ), // <-- Text
                        backgroundColor: maleCurrent,
                        onPressed: () {
                          setState(() {
                            userGender = "Male";
                            updateInfo('gender', userGender);
                            currentGender();
                          });
                        },
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: size.width / 4,
                      child: FloatingActionButton.extended(
                        heroTag: "btn2",
                        extendedPadding: EdgeInsets.only(
                            left: size.width / 16,
                            right: size.width / 16,
                            top: size.width / 4,
                            bottom: size.width / 4),
                        label: Text(
                          'Female',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(197, 0, 0, 0),
                                letterSpacing: .5,
                                decoration: TextDecoration.none),
                          ),
                        ), // <-- Text
                        backgroundColor: femaleCurrent,
                        onPressed: () {
                          setState(() {
                            userGender = "Female";
                            updateInfo('gender', userGender);
                            currentGender();
                          });
                        },
                      ),
                    ),
                    Spacer(flex: 2),
                  ],
                ),
              ),
            ),
            Card(
              color: foregroundGrey,
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
                            color: accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        "Goal:",
                      ),
                    ),
                    Spacer(flex: 1),
                    FloatingActionButton.extended(
                      heroTag: "btn1",
                      extendedPadding: EdgeInsets.only(
                          left: size.width / 16,
                          right: size.width / 16,
                          top: size.width / 4,
                          bottom: size.width / 4),
                      label: Text(
                        'Bulk',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(197, 0, 0, 0),
                              letterSpacing: .5,
                              decoration: TextDecoration.none),
                        ),
                      ), // <-- Text
                      backgroundColor: bulkCurrent,
                      onPressed: () {
                        setState(() {
                          userGoal = "Bulk";
                          updateInfo('goal', userGoal);
                          currentGoal();
                        });
                      },
                    ),
                    Spacer(flex: 1),
                    FloatingActionButton.extended(
                      heroTag: "btn1",
                      extendedPadding: EdgeInsets.only(
                          left: size.width / 16,
                          right: size.width / 16,
                          top: size.width / 4,
                          bottom: size.width / 4),
                      label: Text(
                        'Cut',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(197, 0, 0, 0),
                              letterSpacing: .5,
                              decoration: TextDecoration.none),
                        ),
                      ), // <-- Text
                      backgroundColor: cutCurrent,
                      onPressed: () {
                        setState(() {
                          userGoal = "Cut";
                          updateInfo('goal', userGoal);
                          currentGoal();
                        });
                      },
                    ),
                    Spacer(flex: 1),
                    FloatingActionButton.extended(
                      heroTag: "btn1",
                      extendedPadding: EdgeInsets.only(
                          left: size.width / 16,
                          right: size.width / 16,
                          top: size.width / 4,
                          bottom: size.width / 4),
                      label: Text(
                        'Maintain',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(197, 0, 0, 0),
                              letterSpacing: .5,
                              decoration: TextDecoration.none),
                        ),
                      ), // <-- Text
                      backgroundColor: maintainCurrent,
                      onPressed: () {
                        setState(() {
                          userGoal = "Maintain";
                          updateInfo('goal', userGoal);
                          currentGoal();
                        });
                      },
                    ),
                    Spacer(flex: 3),
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
