import 'package:deco3801_project/pages/tutor_activity.dart';
import 'package:deco3801_project/pages/tutor_dashboard.dart';
import 'package:deco3801_project/pages/tutor_teams.dart';
import 'package:deco3801_project/util/ui_colours.dart';
import 'package:deco3801_project/widgets/nav_icon.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class TutorHome extends StatefulWidget {
  @override
  State<TutorHome> createState() => _TutorHomePageState();
}

class _TutorHomePageState extends State<TutorHome> {
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
      TutorDashboardPage(),
      TutorTeamsPage(),
      TutorActivityPage(),
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
