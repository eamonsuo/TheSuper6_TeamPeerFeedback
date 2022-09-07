import 'package:flutter/material.dart';

class TeamData {
  final String teamName;

  const TeamData(this.teamName);
}

class StudentTeamsPage extends StatelessWidget {
  List<TeamData> teamData = [
    TeamData("team1"),
    TeamData("team2"),
    TeamData("team3")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
      ),
      backgroundColor: Color.fromRGBO(241, 249, 255, 50),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: teamData.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == teamData.length) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
              title: Text(
                "Create new team",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(21, 90, 148, 50),
                    fontSize: 15),
              ),
              trailing: Icon(Icons.add),
              onTap: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Color.fromRGBO(21, 90, 148, 50))),
              tileColor: Colors.white,
            );
          } else {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
              title: Text(
                teamData[index].teamName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(21, 90, 148, 50),
                    fontSize: 15),
              ),
              trailing: Icon(Icons.more_vert),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TeamDisplay(teamData: teamData[index]),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Color.fromRGBO(21, 90, 148, 50))),
              tileColor: Colors.white,
            );
          }
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.transparent,
        ),
      ),
    );
  }
}

class TeamDisplay extends StatelessWidget {
  // Requiring the list of todos.
  const TeamDisplay({super.key, required this.teamData});

  final TeamData teamData;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(teamData.teamName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(teamData.teamName),
      ),
    );
  }
}
