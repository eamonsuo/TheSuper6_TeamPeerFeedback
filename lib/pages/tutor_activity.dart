import 'package:deco3801_project/databaseElements/TeamsTable.dart';
import 'package:deco3801_project/databaseElements/UsersTable.dart';
import 'package:flutter/material.dart';

import '../databaseElements/TutorMessagesTable.dart';

String tutorId = "28121";

class TutorActivityPage extends StatefulWidget {
  @override
  _TutorActivityPageState createState() => _TutorActivityPageState();
}

class _TutorActivityPageState extends State<TutorActivityPage> {
  late Future<List<Map<String, String>>> _recievedMessages;
  late Future<List<Map<String, String>>> _teams;
  late Future<List<Map<String, String>>> _users;

  @override
  void initState() {
    super.initState();
    _recievedMessages = TutorMessagesTable.getReceivedMessages(tutorId);
    _teams = TeamsTable.getAllTeams();
    _users = UsersTable.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_recievedMessages, _teams, _users]),
        builder:
            (BuildContext context, AsyncSnapshot<List<List<Object>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            List<Map<String, String>> _recievedMessagesData =
                snapshot.data![0] as List<Map<String, String>>;
            List<Map<String, String>> _teamsData =
                snapshot.data![1] as List<Map<String, String>>;
            List<Map<String, String>> _userData =
                snapshot.data![2] as List<Map<String, String>>;

            /*List<List<String>> specificFeedback = [];
            for (Map<String, String> item in _feedbackData) {
              String currGoalID = item.entries.elementAt(2).value;
              for (Map<String, String> goalItem in _goalsData) {
                if (goalItem.entries.elementAt(0).value == currGoalID) {
                  List<String> feedbackData = [];
                  feedbackData.add(goalItem.entries.elementAt(1).value);
                  feedbackData.add(item.entries.elementAt(3).value);
                  specificFeedback.add(feedbackData);
                }
              }
            }*/

            return Scaffold(
                appBar: AppBar(title: const Text('Student Activity')),
                body: Container(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                      ListView.separated(
                        shrinkWrap: true,
                        controller: ScrollController(),
                        itemCount: _recievedMessagesData.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_recievedMessagesData
                                .elementAt(index)
                                .entries
                                .elementAt(5)
                                .value),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(
                                    color: Color.fromRGBO(21, 90, 148, 50))),
                            tileColor: Colors.white,
                            subtitle: Text(
                                //"Message from ${_recievedMessagesData.elementAt(index)['sender_id']}"),
                                "Message from ${_userData.firstWhere((element) => element["user_id"] == _recievedMessagesData.elementAt(index)['sender_id'])["username"]} regarding ${_teamsData.firstWhere((element) => element["team_id"] == _recievedMessagesData.elementAt(index)['team_id'])["team_name"]}"), //Should include tutor name and team name
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
                    ]))));
          } else {
            return Container();
          }
        });
  }
}
