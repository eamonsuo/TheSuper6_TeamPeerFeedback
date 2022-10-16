import 'package:deco3801_project/databaseElements/FeedbackTable.dart';
import 'package:deco3801_project/databaseElements/GoalsTable.dart';
import 'package:deco3801_project/databaseElements/TutorMessagesTable.dart';
import 'package:deco3801_project/pages/student_teams.dart';
import 'package:flutter/material.dart';

class StudentActivityPage extends StatefulWidget {
  @override
  _StudentActivityPageState createState() => _StudentActivityPageState();
}

class _StudentActivityPageState extends State<StudentActivityPage> {
  late Future<List<Map<String, String>>> _recievedMessages;
  late Future<List<Map<String, String>>> _goals;
  late Future<List<Map<String, String>>> _feedback;

  @override
  void initState() {
    super.initState();
    _recievedMessages = TutorMessagesTable.getReceivedMessages(userID);
    _goals = GoalsTable.getSubGoalsInfoFromUser(userID);
    _feedback = FeedbackTable.getAllFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_recievedMessages, _goals, _feedback]),
        builder:
            (BuildContext context, AsyncSnapshot<List<List<Object>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            List<Map<String, String>> _recievedMessagesData =
                snapshot.data![0] as List<Map<String, String>>;
            List<Map<String, String>> _goalsData =
                snapshot.data![1] as List<Map<String, String>>;
            List<Map<String, String>> _feedbackData =
                snapshot.data![2] as List<Map<String, String>>;

            List<List<String>> specificFeedback = [];
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
            }

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
                                "Message from tutor"), //Should include tutor name and team name
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
                      const Divider(),
                      ListView.separated(
                        shrinkWrap: true,
                        controller: ScrollController(),
                        itemCount: specificFeedback.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                specificFeedback.elementAt(index).elementAt(1)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(
                                    color: Color.fromRGBO(21, 90, 148, 50))),
                            tileColor: Colors.white,
                            subtitle: Text(
                                "For the goal: ${specificFeedback.elementAt(index).elementAt(0)}"), //Should include tutor name and team name
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
