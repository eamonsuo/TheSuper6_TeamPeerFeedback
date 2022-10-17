import 'package:deco3801_project/util/ui_colours.dart';
import 'package:deco3801_project/widgets/progress_slider.dart';
import 'package:deco3801_project/widgets/student_task_buttons.dart';
import 'package:flutter/material.dart';

class StudentTask extends StatelessWidget {

  String taskTitle;
  String taskDescription;
  double progress;
  int id;

  Map<String, String> goalInfo;

  StudentTask(this.id, this.taskTitle, this.taskDescription, this.progress, this.goalInfo);


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
                Text(taskTitle, style: TextStyle(color: UIColours.darkBlue)),
                StudentTaskButtons(id, taskDescription, goalInfo)
              ],
            ),
            Text(taskDescription, style: TextStyle(color: UIColours.lightBlue)),
            ProgressSlider(goalInfo, currentProgress: progress)
          ],
        ),
      )
    );
  }
}

class ProgesssBar extends StatelessWidget {

  double progress;
  ProgesssBar(this.progress);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Progesss: ${progress * 100 ~/ 1}%", style: TextStyle(color: UIColours.darkBlue),),
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
        ),
      ],
    );
  }
}