import 'package:deco3801_project/pages/student_activity.dart';
import 'package:deco3801_project/pages/student_dashboard.dart';
import 'package:deco3801_project/pages/student_teams.dart';
import 'package:deco3801_project/util/ui_colours.dart';
import 'package:deco3801_project/widgets/nav_icon.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
      bottomNavigationBar: CurvedNavigationBar (
        color: UIColours.blue,
        buttonBackgroundColor: UIColours.background,
        backgroundColor: UIColours.background,
        height: 50,
        animationCurve: Curves.easeOut,
        items: <Widget>[
          NavIcon(Icon(Icons.person), "Dashboard"),
          NavIcon(Icon(Icons.people), "Teams"),
          NavIcon(Icon(Icons.notifications), "Activity"),
        ],
        onTap: (index) {
          changePageIndex(index);
        },
      ),
      body: pages[currentIndex],
    );
  }
}
