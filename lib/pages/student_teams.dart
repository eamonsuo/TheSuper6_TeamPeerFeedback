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

  //Used to store feedback input
  TextEditingController feedbackController = new TextEditingController();

  final TeamData teamData;

  List<List<String>> teamGoals = [
    ["goal1", "finish this", "finish that"],
    ["goal2", "finish this", "finish that"],
    ["goal3", "finish this", "finish that"]
  ];

  final List<String> feedback = <String>[
    'This is so cool',
    'Lots of effort',
    'Very good, top sensation'
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
        body: SingleChildScrollView(
            child: Column(
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
                  return _buildList(teamGoals[index], context);
                },
              ),
            ),
          ],
        )));
  }

  Widget _buildList(List<String> item, BuildContext context) {
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
              onPressed: () {},
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
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  e + " assigned person",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color.fromRGBO(21, 90, 148, 10)),
                ),
                const Spacer(),
                IconButton(
                  splashRadius: 15,
                  icon: const Icon(
                    Icons.folder,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  splashRadius: 15,
                  icon: const Icon(
                    Icons.attach_file,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
                PopupMenuButton(
                  splashRadius: 20,
                  tooltip: '',
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      child: ListTile(
                        title: Text(
                          'Write to tutor',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(38, 153, 251, 60),
                              fontSize: 13),
                        ),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        title: Text(
                          'View feedback',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(38, 153, 251, 60),
                              fontSize: 13),
                        ),
                      ),
                      value: 1,
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        title: Text(
                          'Give feedback',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(38, 153, 251, 60),
                              fontSize: 13),
                        ),
                      ),
                      value: 2,
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        title: Text(
                          'Edit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(38, 153, 251, 60),
                              fontSize: 13),
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
                              fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                  onSelected: (result) {
                    if (result == 1) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding:
                                  EdgeInsets.only(left: 20, right: 20),
                              scrollable: true,
                              title: Row(
                                children: [
                                  const Text(
                                    "Feedback",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Color.fromRGBO(21, 90, 148, 10)),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: const Icon(Icons.close),
                                    splashRadius: 15,
                                  )
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color: Color.fromRGBO(21, 90, 148, 10),
                                      width: 1.5)),
                              content: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: ListView.separated(
                                  itemCount: feedback.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(feedback[index],
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Color.fromRGBO(
                                                  38, 153, 251, 10))),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color:
                                                Color.fromRGBO(21, 90, 148, 10),
                                            width: 0.5),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                ),
                              ),
                            );
                          });
                    }
                    if (result == 2) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding:
                                  EdgeInsets.only(left: 20, right: 20),
                              scrollable: true,
                              title: Row(
                                children: [
                                  const Text(
                                    "Give Feedback",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Color.fromRGBO(21, 90, 148, 10)),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: const Icon(Icons.close),
                                    splashRadius: 15,
                                  )
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color: Color.fromRGBO(21, 90, 148, 10),
                                      width: 1.5)),
                              content: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: TextField(
                                    controller: feedbackController,
                                    maxLines: null,
                                    textAlign: TextAlign.left,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter feedback',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 3, color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 3, color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        )),
                                  )),
                            );
                          });
                    }
                  },
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
                      fontSize: 11, color: Color.fromRGBO(38, 153, 251, 10)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Progress: ${progress * 100}%",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Color.fromRGBO(21, 90, 148, 10)),
                ),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
