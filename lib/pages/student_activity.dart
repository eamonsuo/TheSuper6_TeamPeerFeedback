import 'package:deco3801_project/databaseElements/GoalsTable.dart';
import 'package:deco3801_project/databaseElements/TutorMessagesTable.dart';
import 'package:flutter/material.dart';

String userID = '28121';

class StudentActivityPage extends StatefulWidget {
  @override
  _StudentActivityPageState createState() => _StudentActivityPageState();
}

class _StudentActivityPageState extends State<StudentActivityPage> {
  late Future<List<Map<String, String>>> _recievedMessages;
  late Future<List<Map<String, String>>> _goals;

  @override
  void initState() {
    super.initState();
    _recievedMessages = TutorMessagesTable.getReceivedMessages("28119");
    _goals = GoalsTable.getAllGoals();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_recievedMessages, _goals]),
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
            print("Recieved messages: $_recievedMessagesData");

            return Scaffold(
                appBar: AppBar(title: const Text('Student Activity')),
                body: Container(
                  padding: const EdgeInsets.all(10),
                  child: ListView.separated(
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
                        subtitle: Text("Message from tutor"),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ));
          } else {
            return Container();
          }
        });
  }
}
