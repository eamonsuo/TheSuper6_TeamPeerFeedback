import 'package:deco3801_project/util/ui_colours.dart';
import 'package:deco3801_project/widgets/progress_slider.dart';
import 'package:deco3801_project/widgets/student_task_buttons.dart';
import 'package:flutter/material.dart';

class StudentTask extends StatelessWidget {

  /// Things I still want to add:
  ///    Truncate long text and have a '...read mode'
  ///    

  String teamName;
  String taskDescription;
  StudentTask(this.teamName, this.taskDescription);

  // This spaghetti is brought to you by Jack, I intend to de-spaghetti it at some point.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          color: UIColours.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Team: $teamName", style: TextStyle(color: UIColours.darkBlue)),
                  StudentTaskButtons()
                ],
              ),
              Text(taskDescription, style: TextStyle(color: UIColours.lightBlue)),
              ProgressSlider()
            ],
          ),
        ),
      ),
    );
  }
}