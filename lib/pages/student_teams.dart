import 'dart:ffi';

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
              trailing: PopupMenuButton(
                splashRadius: 20,
                tooltip: '',
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    child: ListTile(
                      title: Text(
                        'Write to tutors',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(38, 153, 251, 60),
                            fontSize: 14),
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    child: ListTile(
                      title: Text(
                        'See members',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(38, 153, 251, 60),
                            fontSize: 14),
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    child: ListTile(
                      title: Text(
                        'Add members',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(38, 153, 251, 60),
                            fontSize: 14),
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    child: ListTile(
                      title: Text(
                        'Leave team',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(38, 153, 251, 60),
                            fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
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
  TeamDisplay({super.key, required this.teamData});

  final TeamData teamData;

  List<List<String>> teamGoals = [
    ["goal1", "finish this", "finish that"],
    ["goal2", "finish this", "finish that"],
    ["goal3", "finish this", "finish that"]
  ];
  double progress = 0.2;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.

    return Scaffold(
        appBar: AppBar(
          title: Text(teamData.teamName),
        ),
        backgroundColor: Color.fromRGBO(241, 249, 255, 1),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Team Goals",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromRGBO(21, 90, 148, 10)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: teamGoals.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildList(teamGoals[index]);
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildList(List<String> item) {
    String inTitle = item.removeAt(0);
    return Card(
      child: ExpansionTile(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              inTitle,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color.fromRGBO(21, 90, 148, 10)),
            ),
            const Spacer(),
            IconButton(
              splashRadius: 15,
              icon: const Icon(
                Icons.addchart,
                size: 20,
              ),
              onPressed: () {
                print('IconButton pressed ...');
              },
            ),
            PopupMenuButton(
              splashRadius: 20,
              tooltip: '',
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  child: ListTile(
                    title: Text(
                      'Edit',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(38, 153, 251, 60),
                          fontSize: 15),
                    ),
                  ),
                ),
                const PopupMenuItem(
                  child: ListTile(
                    title: Text(
                      'Delete',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(38, 153, 251, 60),
                          fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Goal description",
              style: TextStyle(
                  fontSize: 13, color: Color.fromRGBO(38, 153, 251, 10)),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Progress: ${progress * 100}%",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color.fromRGBO(21, 90, 148, 10)),
            ),
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.platform,
        children: item.map((e) {
          return ListTile(
            title: Text(
              e,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          );
        }).toList(),
      ),
    );
  }
}
