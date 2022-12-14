import 'package:deco3801_project/databaseElements/TeamsTable.dart';
import 'package:deco3801_project/databaseElements/TutorMessagesTable.dart';
import 'package:deco3801_project/databaseElements/health_score.dart';
import 'package:flutter/material.dart';

import '../util/ui_colours.dart';

class TutorTeamCard extends StatelessWidget {
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
                            Text(
                              "Team: $name",
                              style: TextStyle(color: UIColours.darkBlue),
                            ),
                            const Spacer(),
                            MembersButton(id, name),
                            HealthScoreInfoButton(),
                          ],
                        ),
                        Text(
                          'Health Score $healthScore%',
                          style: TextStyle(
                            color: UIColours.blue,
                            fontSize: 15,
                          ),
                        ),
                        TeamProgressSlider(healthScore.toDouble())
                      ]))));
        } else {
          return Container();
        }
      }),
    );
  }
}

class TeamProgressSlider extends StatelessWidget {
  double progress;
  TeamProgressSlider(this.progress);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(4),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: progress / 100,
            )));
  }
}

class MembersButton extends StatelessWidget {
  String id;
  String teamName;
  MembersButton(this.id, this.teamName);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        child: Container(
          color: UIColours.darkBlue,
          padding: EdgeInsets.all(5),
          child: Text(
            "Members",
            style:
                TextStyle(color: UIColours.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onPressed: () async {
        List<Map<String, String>> memebers =
            await TeamsTable.getUsersInTeamInfo(id);
        List<Map<String, String>> students = memebers
            .where((element) => element["tutor_status"] == "0")
            .toList();

        List<Widget> memberList = [];
        for (var student in students) {
          memberList.add(MemberListItem(student, id));
        }

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setSateDropdown) {
                return AlertDialog(
                    insetPadding: const EdgeInsets.only(left: 20, right: 20),
                    scrollable: true,
                    title: Row(
                      children: [
                        Text(
                          teamName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color.fromRGBO(21, 90, 148, 10)),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
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
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: UIColours.blue,
                          style: BorderStyle.solid,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: memberList,
                      ),
                    ));
              });
            });
      },
    );
  }
}

class MemberListItem extends StatelessWidget {
  Map<String, String> memberInfo;
  String teamId;
  late String username;
  late String userId;
  MemberListItem(this.memberInfo, this.teamId) {
    username = memberInfo["username"]!;
    userId = memberInfo["user_id"]!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(username, style: TextStyle(color: UIColours.blue)),
          IconButton(
            splashRadius: 5,
            icon: Icon(
              Icons.mode_edit,
              color: UIColours.darkBlue,
            ),
            onPressed: () {
              TextEditingController controller = TextEditingController();
              showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        insetPadding:
                            const EdgeInsets.only(left: 20, right: 20),
                        scrollable: true,
                        title: Row(
                          children: [
                            const Text(
                              "Send a Private Note",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Color.fromRGBO(21, 90, 148, 10)),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
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
                        content: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: UIColours.blue,
                                      style: BorderStyle.solid,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Text(
                                      "To: $username",
                                    ),
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: TextField(
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: "Subject:",
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
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: TextField(
                                      maxLines: 14,
                                      textAlign: TextAlign.left,
                                      controller: controller,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
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
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  TutorMessagesTable.addMessage(
                                          "28121",
                                          userId,
                                          teamId,
                                          "28121",
                                          controller.value.text)
                                      .then((value) =>
                                          {Navigator.of(context).pop()});
                                },
                                child: const Text("Submit"))
                          ],
                        ));
                  });
            },
          )
        ],
      ),
    );
  }
}

class HealthScoreInfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.question_mark_rounded),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setSateDropdown) {
                return AlertDialog(
                    insetPadding: const EdgeInsets.only(left: 20, right: 20),
                    scrollable: true,
                    title: Row(
                      children: [
                        const Text(
                          "Health Score",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color.fromRGBO(21, 90, 148, 10)),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
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
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: UIColours.blue,
                          style: BorderStyle.solid,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                            "A team's health score is determined by two factors, the amount of progress they have made on their team goals relative to their set deadlines and the number of messages they have sent to a tutor",
                            style: TextStyle(color: UIColours.blue)),
                      ),
                    ));
              });
            });
      },
    );
  }
}
