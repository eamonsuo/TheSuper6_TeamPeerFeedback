import 'package:deco3801_project/databaseElements/GoalsTable.dart';
import 'package:deco3801_project/util/ui_colours.dart';
import 'package:deco3801_project/widgets/student_task.dart';
import 'package:flutter/material.dart';

class StudentDashboardPage extends StatefulWidget {

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPage();
}

class _StudentDashboardPage extends State<StudentDashboardPage> {


  late Future<List<Map<String, String>>> _goals;

  @override
  void initState() {
    super.initState();
    _goals = GoalsTable.getSubGoalsInfoFromUser("28119");
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _goals,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          List<Map<String, String>> goals = snapshot.data;

          List<StudentTask> tasks = [];
          for (var goal in goals) {
            tasks.add(StudentTask(int.parse(goal["goal_id"]!), goal["team_name"]!, goal["goal_desc"]!, double.parse(goal["goal_progress"]!), goal));
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Student Dashboard')),
            body: Container(
              color: UIColours.background,
              alignment: FractionalOffset.center,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Individual Tasks", style: TextStyle(color: UIColours.darkBlue, fontSize: 20)),
                    ),
                    ...tasks
                  ],
                ),
              ),
            )
          );
        } else {
          return Container();
        }
      }
    );
  }
}