import 'dart:ffi';

import 'package:deco3801_project/util/ui_colours.dart';
import 'package:deco3801_project/widgets/progress_slider.dart';
import 'package:deco3801_project/widgets/student_task_buttons.dart';
import 'package:flutter/material.dart';

class StudentTask extends StatelessWidget {

  /// Things I still want to add:
  ///    Truncate long text and have a '...read mode'
  ///    

  String taskTitle;
  String taskDescription;
  bool embeded;

  StudentTask(this.taskTitle, this.taskDescription, {this.embeded = false});


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
                StudentTaskButtons()
              ],
            ),
            Text(taskDescription, style: TextStyle(color: UIColours.lightBlue)),
            // embeded? ProgesssBar(0.69): ProgressSlider()
            ProgressSlider(embeded: embeded,)
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