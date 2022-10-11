
import 'dart:collection';

import 'package:deco3801_project/util/ui_colours.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StudentTaskButtons extends StatefulWidget {
  @override
  State<StudentTaskButtons> createState() => _StudentTaskButtons(); 
}

class _StudentTaskButtons extends State<StudentTaskButtons> {

  Map<String, Widget> buttons = HashMap();
  List<Widget> activeButtons = [];

  @override
  void initState() {
    super.initState();
    // initialise the map of all buttons. 
    buttons.addAll({
      // "kebab": IconButton(
      //   icon: Icon(Icons.more_vert),
      //   iconSize: 20,
      //   splashRadius: 15,
      //   color: UIColours.darkBlue,
      //   onPressed: () {
      //     debugPrint("Kebad pressed");
      //     activateButton("file");
      //   },
      // ),
      "kebab": PopupMenuButton(
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
                  debugPrint("Tutor notified")

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
            const PopupMenuItem(
              child: ListTile(
                title: Text(
                  'Edit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(38, 153, 251, 60),
                      fontSize: 14),
                ),
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
      "file": IconButton(
        icon: Icon(Icons.folder),
        iconSize: 20,
        splashRadius: 15,
        color: UIColours.darkBlue,
        onPressed: () {
          debugPrint("folder pressed");
          activateButton("attach");
        },
      ),
      "attach": IconButton(
        icon: Icon(Icons.attach_file),
        iconSize: 20,
        splashRadius: 15,
        color: UIColours.darkBlue,
        onPressed: () {
          debugPrint("attach pressed");
          removeButton("file");
        },
      ),
    });
    activateButton("kebab"); // the kebab menu is active by default on all StudentTasks
  }

  void activateButton(String buttonName) {
    if (buttons.containsKey(buttonName)) {
      setState(() {
        activeButtons.add(buttons[buttonName]!);
      });
    }
  }
  void removeButton(String buttonName) {
    setState(() {
      activeButtons.remove(buttons[buttonName]);
    });
  }

  @override
  Widget build(BuildContext context) {

    // Define all possible buttons
    // filter buy active buttons
    // pass the list of active buttons to the thing

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
                    debugPrint("Tutor notified")

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
              const PopupMenuItem(
                child: ListTile(
                  title: Text(
                    'Edit',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(38, 153, 251, 60),
                        fontSize: 14),
                  ),
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
            // activateButton("attach");
            // setState(() {
            //   var tmp = buttons.where((element) => element.name == "attach");
            // });
          },
        )
      ),
      Button("attach", false, 
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