import 'package:deco3801_project/util/ui_colours.dart';
import 'package:deco3801_project/widgets/student_task.dart';
import 'package:flutter/material.dart';

class StudentDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: Container(
        color: UIColours.background,
        alignment: FractionalOffset.center,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Individual Tasks", style: TextStyle(color: UIColours.darkBlue, fontSize: 20)),
              ),
              StudentTask("The Super Six!!!!!!", "Do the code for that one bit"),
              StudentTask("Placebo", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
            ],
          ),
        ),
      )
    );
  }
}

      // body: Center(child: Text('Student Dashboard Page')),