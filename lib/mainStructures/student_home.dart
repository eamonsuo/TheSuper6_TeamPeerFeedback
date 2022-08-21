import 'package:deco3801_project/pages/student_activity.dart';
import 'package:deco3801_project/pages/student_dashboard.dart';
import 'package:deco3801_project/pages/student_teams.dart';
import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget {
  @override
  State<StudentHome> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHome> {
  int currentIndex = 0;
  void changePageIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      StudentDashboardPage(),
      StudentTeamsPage(),
      StudentActivityPage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              onPressed: () => changePageIndex(0),
              icon: Icon(Icons.person),
              tooltip: 'Dashboard'),
          IconButton(
              onPressed: () => changePageIndex(1),
              icon: Icon(Icons.people),
              tooltip: 'Teams'),
          IconButton(
              onPressed: () => changePageIndex(2),
              icon: Icon(Icons.notifications),
              tooltip: 'Activity')
        ]),
      ),
      body: pages[currentIndex],
    );
  }
}
