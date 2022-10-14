import 'package:deco3801_project/databaseElements/health_score.dart';
import 'package:deco3801_project/widgets/progress_slider.dart';
import 'package:flutter/material.dart';

import '../util/ui_colours.dart';

class TutorTeamCard extends StatelessWidget {
  // What info is needed
  // team name
  // health score
  // members, and associated member info

  Map<String, String> teamInfo;
  late String id;
  late String name;
  late Future<int> _heathScore;

  TutorTeamCard(this.teamInfo) {
    id = teamInfo["team_id"]!;
    name = teamInfo["team_name"]!;

    _heathScore = HealthScore.getHealthScore(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _heathScore,
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          int healthScore = snapshot.data;
          return Card(
              color: UIColours.white,
              margin: EdgeInsets.all(10),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(
                          children: [
                            Text("Team: $name"),
                          ],
                        ),
                        Text('Health Score $healthScore%'),
                        TeamProgressSlider()
                      ]))));
        } else {
          return Container();
        }
      }),
    );
  }
}

class TeamProgressSlider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final embededStyle = SliderTheme.of(context).copyWith(
      trackHeight: 18,
      thumbColor: Colors.transparent,
      overlayColor: Colors.transparent,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0)
    );
    return SliderTheme(
      data: embededStyle,
      child: Slider(
        value: 0.69,
        onChanged: (value) => {},
      )
    );
  }
}