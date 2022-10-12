
import 'dart:collection';

import 'package:deco3801_project/databaseElements/GoalsTable.dart';
import 'package:deco3801_project/databaseElements/UsersTable.dart';
import 'package:deco3801_project/util/ui_colours.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StudentTaskButtons extends StatefulWidget {
  @override
  State<StudentTaskButtons> createState() => _StudentTaskButtons(); 

  int id;
  String description;
  Map<String, String> goalInfo;
  StudentTaskButtons(this.id, this.description, this.goalInfo);
}

class _StudentTaskButtons extends State<StudentTaskButtons> {

  // late Future<List<Map<String, String>>> _allUsers;

  @override
  void initState() {
    super.initState();

    // _allUsers = GoalsTable.getSubGoalsInfoFromUser("28115");

  }

  @override
  Widget build(BuildContext context) {

    List<Button> buttons = [
      Button("kebab", true, 
        PopupMenuButton(
            splashRadius: 20,
            tooltip: '',
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  title: const Text(
                    'Write to tutors',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(38, 153, 251, 60),
                        fontSize: 14),
                  ),
                  onTap: () => {
                    // debugPrint("Tutor notified")

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              insetPadding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              scrollable: true,
                              title: Row(
                                children: [
                                  const Text(
                                    "Write to tutor",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Color.fromRGBO(21, 90, 148, 10)),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    icon: const Icon(Icons.close),
                                    splashRadius: 15,
                                  )
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color: Color.fromRGBO(21, 90, 148, 10),
                                      width: 1.5)),
                              content: Column(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(10),
                                          width: MediaQuery.of(context).size.width *
                                              0.7,
                                          child: TextField(
                                            // controller:
                                            //     subGoalAssignedPersonController,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                labelText: "Subject:",
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 3, color: Colors.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 3, color: Colors.red),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                )),
                                          )),
                                      Container(
                                          padding: const EdgeInsets.all(10),
                                          width: MediaQuery.of(context).size.width *
                                              0.7,
                                          child: TextField(
                                            // controller:
                                            //     subGoalDescriptionController,
                                            maxLines: 20,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                labelText: "",
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 3, color: Colors.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 3, color: Colors.red),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                )),
                                          ))
                                    ],
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        // Write to tutor
                                      },
                                      child: const Text("Submit"))
                                ],
                              )
                              /**/
                              );
                  })
                  // ==== end of pop up ====
                  },
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  title: Text(
                    'View feedback',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(38, 153, 251, 60),
                        fontSize: 14),
                  ),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  title: const Text(
                    'Edit',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(38, 153, 251, 60),
                        fontSize: 14),
                  ),
                  onTap: () {
                    tmp(context, widget.goalInfo);
                  },
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  title: Text(
                    'Delete',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(38, 153, 251, 60),
                        fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      Button("file", true, 
        IconButton(
          icon: Icon(Icons.folder),
          iconSize: 20,
          splashRadius: 15,
          color: UIColours.darkBlue,
          onPressed: () {
            debugPrint("folder pressed");
            // editThing("attach");
            // activateButton("attach");
            // setState(() {
            //   var tmp = buttons.where((element) => element.name == "attach");
            // });
          },
        )),
      Button("attach", true, 
        IconButton(
          icon: Icon(Icons.attach_file),
          iconSize: 20,
          splashRadius: 15,
          color: UIColours.darkBlue,
          onPressed: () {
            debugPrint("attach pressed");
            // removeButton("file");
          },
        )
      )
    ];

    List<Widget> activeButtons = [];
    for (var button in buttons) {
      if (button.active) {
        activeButtons.add(button.widget);
      }
    }

    // return FutureBuilder(
    //   future: _allUsers,
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //     if (snapshot.hasData) {
    //       List<Map<String, String>> _allUsersData = snapshot.data;
    //       print(_allUsersData);
    //       return Row(
    //         textDirection: TextDirection.rtl, 
    //         children: activeButtons
    //       );
    //     } else {
    //       return Container();
    //     }
    //   },
    // );

    return Row(
      textDirection: TextDirection.rtl, 
      children: activeButtons
    );
  }
}

class Button {
  String name;
  bool active;
  Widget widget;
  Button(this.name, this.active, this.widget);
}

var tmp = (context, goalInfo) => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              insetPadding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              scrollable: true,
                              title: Row(
                                children: [
                                  const Text(
                                    "Update Individual Task",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Color.fromRGBO(21, 90, 148, 10)),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    icon: const Icon(Icons.close),
                                    splashRadius: 15,
                                  )
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color: Color.fromRGBO(21, 90, 148, 10),
                                      width: 1.5)),
                              content: Column(
                                children: [
                                  Column(
                                    children: [
                                      Text("Contents"),
                                      Container(
                                          padding: const EdgeInsets.all(10),
                                          width: MediaQuery.of(context).size.width *
                                              0.7,
                                          child: TextField(
                                            // controller:
                                            //     subGoalAssignedPersonController,
                                            maxLines: 4,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                // labelText: goalInfo["goal_description"],
                                                labelText: "test",
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 3, color: Colors.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 3, color: Colors.red),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                )),
                                          )),
                                    ],
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        // Write to tutor
                                      },
                                      child: const Text("Update"))
                                ],
                              )
                              );
                  });