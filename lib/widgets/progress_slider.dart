import 'package:deco3801_project/util/ui_colours.dart';
import 'package:flutter/material.dart';

class ProgressSlider extends StatefulWidget {

  double? currentProgress;
  ProgressSlider({this.currentProgress});

  @override
  State<ProgressSlider> createState() => _ProgressSlider();
}

class _ProgressSlider extends State<ProgressSlider> {
  
  double progress = 0;

  @override
  void initState() {
    super.initState();
    // The progress slider will have to resume its previous state
    // Currently it defaults to zero or what ever value was passed as an argument
    progress = widget.currentProgress ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Progesss: ${progress * 100 ~/ 1}%", style: TextStyle(color: UIColours.darkBlue),),
        Slider(
          value: progress, 
          onChanged: (double value) {
            setState(() {
              progress = value;
            });
          }
        ),
      ],
    );
  }

}