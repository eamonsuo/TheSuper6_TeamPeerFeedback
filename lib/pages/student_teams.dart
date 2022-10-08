import 'dart:ffi';
//import 'dart:html';

import 'package:deco3801_project/databaseElements/FeedbackTable.dart';
import 'package:flutter/material.dart';
import '../databaseElements/GoalsTable.dart';
import '../databaseElements/TeamsTable.dart';
import '../databaseElements/UsersTable.dart';

class TeamData {
  final String teamName;

  const TeamData(this.teamName);
}

class StudentTeamsPage extends StatefulWidget {
  @override
  _StudentTeamsPageState createState() => _StudentTeamsPageState();
}

class _StudentTeamsPageState extends State<StudentTeamsPage> {
  late Future<List<Map<String, String>>> _teams;
  late Future<List<String>> _userTeams;

  @override
  void initState() {
    super.initState();

    _teams = TeamsTable.getAllTeams();
    _userTeams = UsersTable.getTeamsofUser('28121');
  }

  /*List<TeamData> teamData = [
    const TeamData("team1"),
    const TeamData("team2"),
    const TeamData("team3")
  ];*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //future: _teams,
      future: Future.wait([_teams, _userTeams]),
      builder:
          (BuildContext context, AsyncSnapshot<List<List<Object>>> snapshot) {
        //builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          List<Map<String, String>> _teamData =
              snapshot.data![0] as List<Map<String, String>>;
          List<String> _userTeams = snapshot.data![1] as List<String>;

          List<Map<String, String>> _specificTeams = [];
          for (int i = 0; i < _teamData.length; i++) {
            if (_userTeams
                .contains(_teamData.elementAt(i).entries.elementAt(0).value)) {
              _specificTeams.add(_teamData.elementAt(i));
            }
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Teams'),
            ),
            backgroundColor: const Color.fromRGBO(241, 249, 255, 50),
            body: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _specificTeams.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                  title: Text(
                    _specificTeams.elementAt(index).entries.last.value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(21, 90, 148, 50),
                        fontSize: 15),
                  ),
                  trailing: PopupMenuButton(
                    splashRadius: 20,
                    tooltip: '',
                    icon: const Icon(Icons.more_vert),
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
                        builder: (context) => TeamDisplay(
                            teamData: _specificTeams.elementAt(index)),
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(
                          color: Color.fromRGBO(21, 90, 148, 50))),
                  tileColor: Colors.white,
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.transparent,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class TeamDisplay extends StatefulWidget {
  // Requiring the list of todos.
  TeamDisplay({super.key, required this.teamData});

  final Map<String, String> teamData;

  @override
  _TeamDisplayState createState() => _TeamDisplayState();
}

class _TeamDisplayState extends State<TeamDisplay> {
  late Future<List<Map<String, String>>> _feedback;
  late Future<List<Map<String, String>>> _goals;

  @override
  void initState() {
    super.initState();
    _feedback = FeedbackTable.getAllFeedback();
    _goals = GoalsTable.getAllGoals();
  }

  //Used to store feedback input
  TextEditingController feedbackController = TextEditingController();
  TextEditingController goalDeadlineController = TextEditingController();
  TextEditingController goalDescriptionController = TextEditingController();
  TextEditingController subGoalAssignedPersonController =
      TextEditingController();
  TextEditingController subGoalDescriptionController = TextEditingController();
  TextEditingController writeToTutorController = TextEditingController();

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
    return FutureBuilder(
      future: Future.wait([_feedback, _goals]),
      builder: (BuildContext context,
          AsyncSnapshot<List<List<Map<String, String>>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          List<Map<String, String>> _feedbackData = snapshot.data![0];
          List<Map<String, String>> _goalData = snapshot.data![1];

          List<Map<String, String>> teamSpecificGoals;
          /*for (var i = 0; i < _goalData.length; i++) {
            if _goalData.elementAt(i).entries.elementAt(2)
          }*/
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.teamData.entries.last.value),
            ),
            backgroundColor: const Color.fromRGBO(241, 249, 255, 1),
            body: SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Team Goals",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color.fromRGBO(21, 90, 148, 10)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _goalData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildList(
                          _goalData.elementAt(index), context, index);
                    },
                  ),
                ),
              ],
            )),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                goalDescriptionController.clear();
                goalDeadlineController.clear();
                //ADD Goal
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          insetPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                          scrollable: true,
                          title: Row(
                            children: [
                              const Text(
                                "Add a Goal",
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
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: TextField(
                                        controller: goalDeadlineController,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Deadline",
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
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: TextField(
                                        controller: goalDescriptionController,
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Description",
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
                                      ))
                                ],
                              ),
                              TextButton(
                                  onPressed: () async {
                                    await GoalsTable.addGoal(
                                        goalDescriptionController.text,
                                        goalDeadlineController.text,
                                        widget.teamData.entries
                                            .elementAt(0)
                                            .value,
                                        false);
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              super.widget),
                                    );
                                  },
                                  child: const Text("Add"))
                            ],
                          )
                          /**/
                          );
                    });
              },
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildList(Map<String, String> item, BuildContext context, int index) {
    String deadline = item.entries.elementAt(4).value;
    double progress = double.parse(item.entries.elementAt(2).value);
    index += 1;
    return Card(
      child: ExpansionTile(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Team Goal $index - Deadline: $deadline",
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
              onPressed: () {
                subGoalAssignedPersonController.clear();
                subGoalDescriptionController.clear();
                //Add a new subgoal
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          insetPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                          scrollable: true,
                          title: Row(
                            children: [
                              const Text(
                                "Add a Subgoal",
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
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: TextField(
                                        controller:
                                            subGoalAssignedPersonController,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Assigned person",
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
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: TextField(
                                        controller:
                                            subGoalDescriptionController,
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Description",
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
                                      ))
                                ],
                              ),
                              TextButton(
                                  onPressed: () {
                                    //Add new sub goal to database
                                  },
                                  child: const Text("Add"))
                            ],
                          )
                          /**/
                          );
                    });
              },
            ),
            PopupMenuButton(
              splashRadius: 20,
              tooltip: '',
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  value: 0,
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
                  value: 1,
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
              onSelected: (value) {
                if (value == 0) {
                  //EDIT GOAL
                  goalDescriptionController.text =
                      item.entries.elementAt(1).value;
                  goalDeadlineController.text = item.entries.elementAt(4).value;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            insetPadding:
                                const EdgeInsets.only(left: 20, right: 20),
                            scrollable: true,
                            title: Row(
                              children: [
                                const Text(
                                  "Edit Goal",
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
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                            "Team Goal $index - Deadline: $deadline")),
                                    Container(
                                        padding: const EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: TextField(
                                          controller: goalDescriptionController,
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 3,
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 3,
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              )),
                                        )),
                                  ],
                                ),
                                TextButton(
                                    onPressed: () {
                                      //StudentTeamsPage();
                                    },
                                    child: const Text("Update"))
                              ],
                            )
                            /**/
                            );
                      });
                }
                if (value == 1) {
                  //DELETE A Goal
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            insetPadding:
                                const EdgeInsets.only(left: 20, right: 20),
                            scrollable: true,
                            title: Row(
                              children: [
                                const Text(
                                  "Delete Goal",
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
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: const Text(
                                        "Are you sure you want to delete this goal?")),
                                TextButton(
                                    onPressed: () async {
                                      /*await GoalsTable.addGoal(
                                          goalDescriptionController.text,
                                          goalDeadlineController.text,
                                          widget.teamData.entries
                                              .elementAt(0)
                                              .value,
                                          false);*/
                                      await GoalsTable.deleteGoal(
                                          item.entries.elementAt(0).value);
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                super.widget),
                                      );
                                    },
                                    child: const Text("Delete"))
                              ],
                            )
                            /**/
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
            Text(
              item.entries.elementAt(1).value,
              style: const TextStyle(
                  fontSize: 13, color: const Color.fromRGBO(38, 153, 251, 10)),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Progress: $progress",
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
                value: progress / 100,
                minHeight: 10,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.platform,
        /*children: item.map((e) {
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
                      value: 0,
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
                      value: 1,
                      child: ListTile(
                        title: Text(
                          'View feedback',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(38, 153, 251, 60),
                              fontSize: 13),
                        ),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: ListTile(
                        title: Text(
                          'Give feedback',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(38, 153, 251, 60),
                              fontSize: 13),
                        ),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 3,
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
                      value: 4,
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
                    if (result == 0) {
                      //WRITE TO TUTOR SUB-GOAL
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
                                      "Write to Tutor",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color:
                                              Color.fromRGBO(21, 90, 148, 10)),
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
                                content: Column(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        child: TextField(
                                          controller: writeToTutorController,
                                          maxLines: null,
                                          textAlign: TextAlign.left,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 3,
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 3,
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              )),
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text("Send"))
                                  ],
                                )
                                /**/
                                );
                          });
                    }
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
                                          color:
                                              Color.fromRGBO(21, 90, 148, 10)),
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
                                content: Column(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        child: TextField(
                                          controller: feedbackController,
                                          maxLines: null,
                                          textAlign: TextAlign.left,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Enter feedback',
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 3,
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 3,
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              )),
                                        )),
                                    TextButton(
                                        onPressed: () {}, child: Text("Submit"))
                                  ],
                                )
                                /**/
                                );
                          });
                    }
                    if (result == 3) {
                      //EDIT SUB-GOAL
                      //Will need to update assigned to controller and description
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
                                      "Edit Sub-Goal",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color:
                                              Color.fromRGBO(21, 90, 148, 10)),
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
                                content: Column(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: TextField(
                                              controller:
                                                  subGoalAssignedPersonController,
                                              maxLines: 1,
                                              textAlign: TextAlign.left,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 3,
                                                            color: Colors.blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 3,
                                                            color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  )),
                                            )),
                                        Container(
                                            padding: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: TextField(
                                              controller:
                                                  subGoalDescriptionController,
                                              maxLines: 1,
                                              textAlign: TextAlign.left,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      "Description to be connected to database", //Goal title
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 3,
                                                            color: Colors.blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 3,
                                                            color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  )),
                                            )),
                                      ],
                                    ),
                                    TextButton(
                                        onPressed: () {}, child: Text("Update"))
                                  ],
                                )
                                /**/
                                );
                          });
                    }
                    if (result == 4) {
                      //DELETE SUB-GOAL
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
        }).toList(),*/
      ),
    );
  }
}
