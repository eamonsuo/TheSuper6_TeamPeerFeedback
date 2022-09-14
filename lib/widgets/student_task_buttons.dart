
import 'dart:collection';

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
    //They are currently Icons but will be clickable and functioning in the future.
    buttons.addAll({
      "kebab": Icon(Icons.kebab_dining), // these names aren't final
      "file": Icon(Icons.folder),
      "attach": Icon(Icons.attach_file),
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
    return Row(
      textDirection: TextDirection.rtl, 
      children: activeButtons,
    );
  }
}