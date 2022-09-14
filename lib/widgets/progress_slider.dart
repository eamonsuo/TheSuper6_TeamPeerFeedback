import 'package:deco3801_project/util/ui_colours.dart';
import 'package:flutter/material.dart';

class ProgressSlider extends StatefulWidget {

  double? currentProgress;
  bool embeded;
  ProgressSlider({this.currentProgress, this.embeded = false});

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
    final embededStyle = SliderTheme.of(context).copyWith(
      trackHeight: 18,
      thumbColor: Colors.transparent,
      overlayColor: Colors.transparent,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0)
    );
    final defaultStyle = SliderTheme.of(context).copyWith(
      trackHeight: 18,
      thumbColor: UIColours.background,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14.0)
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Progesss: ${progress.floor()}%", style: TextStyle(color: UIColours.darkBlue),),
        SliderTheme(
          data: widget.embeded? embededStyle: defaultStyle, 
          child: Slider(
            min: 0,
            max: 100,
            value: progress, 
            onChanged: (double value) {
              if (!widget.embeded){
                setState(() {
                  progress = value;
                });
              }
            }
          ),
        )
      ],
    );
  }

}