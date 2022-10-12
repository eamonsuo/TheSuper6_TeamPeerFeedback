import 'package:deco3801_project/databaseElements/GoalsTable.dart';
import 'package:deco3801_project/util/ui_colours.dart';
import 'package:deco3801_project/widgets/student_task.dart';
import 'package:flutter/material.dart';

class StudentDashboardPage extends StatefulWidget {

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPage();
}

class _StudentDashboardPage extends State<StudentDashboardPage> {


  late var _goals;

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
          _goals = snapshot.data;

          // print(_goals);
          // print("goal");
          // print(_goals[0]);
          List<StudentTask> tasks = [];
          for (var goal in _goals) {
            tasks.add(StudentTask(int.parse(goal["goal_id"]), "the super 6", goal["goal_desc"], double.parse(goal["goal_progress"]), goal));
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


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Student Dashboard')),
  //     body: Container(
  //       color: UIColours.background,
  //       alignment: FractionalOffset.center,
  //       child: Center(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.all(10),
  //               child: Text("Individual Tasks", style: TextStyle(color: UIColours.darkBlue, fontSize: 20)),
  //             ),
  //             StudentTask("Team: The Super Six!!!!!!", "Do the code for that one bit"),
  //             StudentTask("Team: Placebo", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", embeded: true,)
  //           ],
  //         ),
  //       ),
  //     )
  //   );
  // }
}

      // body: Center(child: Text('Student Dashboard Page')),