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


  @override
  Widget build(BuildContext context) {
    return Card(
      color: UIColours.white,
      margin: EdgeInsets.all(10),
      
      child: Padding(
        padding: EdgeInsets.all(10),
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
      )
    );
  }
}