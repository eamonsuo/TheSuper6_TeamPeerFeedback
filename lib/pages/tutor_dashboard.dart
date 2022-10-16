import 'package:deco3801_project/databaseElements/TeamsTable.dart';
import 'package:deco3801_project/widgets/tutor_team_card.dart';
import 'package:flutter/material.dart';

import '../util/ui_colours.dart';

class TutorDashboardPage extends StatefulWidget {
  @override
  State<TutorDashboardPage> createState() => _TutorDashboardPage();
}

class _TutorDashboardPage extends State<TutorDashboardPage> {
  late Future<List<Map<String, String>>> _teams;

  @override
  void initState() {
    super.initState();

    _teams = TeamsTable.getAllTeams();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _teams,
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          List<Map<String, String>> teams = snapshot.data;
          // print(teams);

          return Scaffold(
              appBar: AppBar(title: const Text('Tutor Dashboard')),
              body: Container(
                color: UIColours.background,
                alignment: FractionalOffset.center,
                child: ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: ((BuildContext context, int index) {
                    return TutorTeamCard(teams.elementAt(index));
                  }),
                )
              ));
        } else {
          return Container();
        }
      }),
    );
  }
}
