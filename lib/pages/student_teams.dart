import 'dart:async';
import 'dart:ffi';
//import 'dart:html';

import 'package:deco3801_project/databaseElements/FeedbackTable.dart';
import 'package:deco3801_project/databaseElements/TutorMessagesTable.dart';
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

String userID = '28119';

class _StudentTeamsPageState extends State<StudentTeamsPage> {
  late Future<List<Map<String, String>>> _teams;
  late Future<List<String>> _userTeams;
  late Future<List<Map<String, String>>> _usersInTeam;
  late Future<List<Map<String, String>>> _allUsers;

  TextEditingController teamNameController = TextEditingController();
  TextEditingController writeToTutorController = TextEditingController();
  TextEditingController addMembersNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _teams = TeamsTable.getAllTeams();
    _userTeams = UsersTable.getTeamsofUser(userID);
    _usersInTeam = TeamsTable.getAllFromUsersInTeams();
    _allUsers = UsersTable.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //future: _teams,
      future: Future.wait([_teams, _userTeams, _usersInTeam, _allUsers]),
      builder:
          (BuildContext context, AsyncSnapshot<List<List<Object>>> snapshot) {
        //builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          List<Map<String, String>> _teamData =
              snapshot.data![0] as List<Map<String, String>>;
          List<String> _userTeamsData = snapshot.data![1] as List<String>;
          List<Map<String, String>> _usersInTeamData =
              snapshot.data![2] as List<Map<String, String>>;
          List<Map<String, String>> _allUsersData =
              snapshot.data![3] as List<Map<String, String>>;

          List<Map<String, String>> _specificTeams = [];
          for (int i = 0; i < _teamData.length; i++) {
            if (_userTeamsData
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
                String tutorID = "";
                for (int i = 0; i < _usersInTeamData.length; i++) {
                  if (_usersInTeamData
                          .elementAt(i)
                          .entries
                          .elementAt(0)
                          .value ==
                      _specificTeams
                          .elementAt(index)
                          .entries
                          .elementAt(0)
                          .value) {
                    String currUserID = _usersInTeamData
                        .elementAt(i)
                        .entries
                        .elementAt(1)
                        .value;
                    for (int j = 0; j < _allUsersData.length; j++) {
                      if (_allUsersData
                              .elementAt(j)
                              .entries
                              .elementAt(0)
                              .value ==
                          currUserID) {
                        if (_allUsersData
                                .elementAt(j)
                                .entries
                                .elementAt(2)
                                .value ==
                            '1') {
                          tutorID = _allUsersData
                              .elementAt(j)
                              .entries
                              .elementAt(0)
                              .value;
                        }
                      }
                    }
                  }
                }
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
                        value: 0,
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
                        value: 1,
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
                        value: 2,
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
                        value: 3,
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
                    onSelected: (value) {
                      if (value == 0) {
                        //Write to tutors for team
                        writeToTutorController.clear();
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
                                            color: Color.fromRGBO(
                                                21, 90, 148, 10)),
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
                                          color:
                                              Color.fromRGBO(21, 90, 148, 10),
                                          width: 1.5)),
                                  content: Column(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.7,
                                          child: TextField(
                                            controller: writeToTutorController,
                                            maxLines: null,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 3,
                                                      color: Colors.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 3,
                                                      color: Colors.red),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                )),
                                          )),
                                      TextButton(
                                          onPressed: () async {
                                            await TutorMessagesTable.addMessage(
                                                userID,
                                                tutorID,
                                                _specificTeams
                                                    .elementAt(index)
                                                    .entries
                                                    .elementAt(0)
                                                    .value,
                                                tutorID,
                                                writeToTutorController.text);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Send"))
                                    ],
                                  )
                                  /**/
                                  );
                            });
                      } else if (value == 1) {
                        //See members
                        List<String> members = [];

                        for (int i = 0; i < _usersInTeamData.length; i++) {
                          if (_usersInTeamData
                                  .elementAt(i)
                                  .entries
                                  .elementAt(0)
                                  .value ==
                              _specificTeams
                                  .elementAt(index)
                                  .entries
                                  .elementAt(0)
                                  .value) {
                            for (int j = 0; j < _allUsersData.length; j++) {
                              if (_allUsersData
                                      .elementAt(j)
                                      .entries
                                      .elementAt(0)
                                      .value ==
                                  _usersInTeamData
                                      .elementAt(i)
                                      .entries
                                      .elementAt(1)
                                      .value) {
                                members.add(_allUsersData
                                    .elementAt(j)
                                    .entries
                                    .elementAt(1)
                                    .value);
                              }
                            }
                          }
                        }
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
                                      "Members",
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
                                content: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: ListView.separated(
                                    itemCount: members.length,
                                    itemBuilder: (context, index2) {
                                      return ListTile(
                                        title: Text(members[index2],
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Color.fromRGBO(
                                                    38, 153, 251, 10))),
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  21, 90, 148, 10),
                                              width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                      } else if (value == 2) {
                        teamNameController.clear();

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  insetPadding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  scrollable: true,
                                  title: Row(
                                    children: [
                                      const Text(
                                        "Add a Member",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Color.fromRGBO(
                                                21, 90, 148, 10)),
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
                                          color:
                                              Color.fromRGBO(21, 90, 148, 10),
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
                                                    addMembersNameController,
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    labelText: "Username",
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 3,
                                                              color:
                                                                  Colors.blue),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 3,
                                                              color:
                                                                  Colors.red),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    )),
                                              )),
                                        ],
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            String userToAdd = "";
                                            for (int i = 0;
                                                i < _allUsersData.length;
                                                i++) {
                                              if (_allUsersData
                                                      .elementAt(i)
                                                      .entries
                                                      .elementAt(1)
                                                      .value ==
                                                  addMembersNameController
                                                      .text) {
                                                userToAdd = _allUsersData
                                                    .elementAt(i)
                                                    .entries
                                                    .elementAt(0)
                                                    .value;
                                              }
                                            }
                                            await TeamsTable.addUserToTeam(
                                                userToAdd,
                                                teamId: _specificTeams
                                                    .elementAt(index)
                                                    .entries
                                                    .elementAt(0)
                                                    .value);
                                            print("Added");
                                            Navigator.pop(context);
                                            setState(() {});
                                            //Todo fix page refresh
                                          },
                                          child: const Text("Add"))
                                    ],
                                  )
                                  /**/
                                  );
                            });
                      } else if (value == 3) {
                        //Leave team
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  insetPadding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  scrollable: true,
                                  title: Row(
                                    children: [
                                      const Text(
                                        "Leave Team",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Color.fromRGBO(
                                                21, 90, 148, 10)),
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
                                          color:
                                              Color.fromRGBO(21, 90, 148, 10),
                                          width: 1.5)),
                                  content: Column(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: const Text(
                                              "Are you sure you want to leave this team?")),
                                      TextButton(
                                          onPressed: () async {
                                            await TeamsTable.deleteUserFromTeam(
                                                userID,
                                                _specificTeams
                                                    .elementAt(index)
                                                    .entries
                                                    .elementAt(0)
                                                    .value);
                                            Navigator.pop(context);
                                            //Todo fix page refresh
                                          },
                                          child: const Text("Leave"))
                                    ],
                                  )
                                  /**/
                                  );
                            });
                      }
                    },
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
                //Add bottom one here
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.transparent,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Add Team

                teamNameController.clear();

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
                                "Add a Team",
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
                                        controller: teamNameController,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Team Name",
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
                                  onPressed: () async {
                                    await TeamsTable.addTeam(
                                        teamNameController.text, userID);
                                    Navigator.pop(context);
                                    setState(() {});
                                    //todo fix page refresh
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
}

class TeamDisplay extends StatefulWidget {
  // Requiring the list of todos.
  TeamDisplay({super.key, required this.teamData});

  final Map<String, String> teamData;
  //String userId = "28119";

  @override
  _TeamDisplayState createState() => _TeamDisplayState();
}

class _TeamDisplayState extends State<TeamDisplay> {
  late Future<List<Map<String, String>>> _feedback;
  late Future<List<Map<String, String>>> _goals;
  late Future<Map<String, List>> _subgoals;
  late Future<List<Map<String, String>>> _usersInTeam;
  late Future<List<Map<String, String>>> _userGoals;

  @override
  void initState() {
    super.initState();
    _feedback = FeedbackTable.getAllFeedback();
    _goals =
        GoalsTable.getTeamGoalInfo(widget.teamData.entries.elementAt(0).value);
    _subgoals = GoalsTable.getAllTeamSubGoals(
        widget.teamData.entries.elementAt(0).value);
    _usersInTeam = TeamsTable.getUsersInTeamInfo(
        widget.teamData.entries.elementAt(0).value);
    _userGoals = GoalsTable.getAllFromUserGoals();
  }

  //Used to store feedback input
  TextEditingController feedbackController = TextEditingController();
  TextEditingController goalDeadlineController = TextEditingController();
  TextEditingController goalDescriptionController = TextEditingController();
  TextEditingController subGoalAssignedPersonController =
      TextEditingController();
  TextEditingController subGoalDescriptionController = TextEditingController();
  TextEditingController writeToTutorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Future.wait([_feedback, _goals, _subgoals, _usersInTeam, _userGoals]),
      builder: (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          List<Map<String, String>> _feedbackData =
              snapshot.data![0] as List<Map<String, String>>;
          List<Map<String, String>> _goalData =
              snapshot.data![1] as List<Map<String, String>>;
          Map<String, List> _subgoalData =
              snapshot.data![2] as Map<String, List>;
          List<Map<String, String>> _usersInTeamData =
              snapshot.data![3] as List<Map<String, String>>;
          List<Map<String, String>> _userGoalsData =
              snapshot.data![4] as List<Map<String, String>>;

          List<Map<String, String>> teamSpecificGoals;

          //Subgoals for the current goal

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
                          _goalData.elementAt(index),
                          context,
                          index,
                          _subgoalData,
                          _feedbackData,
                          _usersInTeamData,
                          _userGoalsData);
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

  Widget _buildList(
      Map<String, String> item,
      BuildContext context,
      int index,
      Map<String, List> subgoals,
      List<Map<String, String>> feedback,
      List<Map<String, String>> userData,
      List<Map<String, String>> userGoalsData) {
    String deadline = item.entries.elementAt(4).value;
    double progress = double.parse(item.entries.elementAt(2).value);

    List<Map<String, String>> specificSubgoals = [];
    for (int i = 0; i < subgoals.length; i++) {
      if (subgoals.entries.elementAt(i).key ==
          item.entries.elementAt(0).value) {
        specificSubgoals =
            subgoals.entries.elementAt(i).value as List<Map<String, String>>;
      }
    }
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
                //Add a new subgoal
                subGoalAssignedPersonController.clear();
                subGoalDescriptionController.clear();

                //Setup dropdown box
                List<DropdownMenuItem<String>> dropdownItems = [];
                for (Map<String, String> userDetails in userData) {
                  if (userDetails.entries.elementAt(2).value == '0') {
                    dropdownItems.add(DropdownMenuItem(
                        child: Text(userDetails.entries.elementAt(1).value),
                        value: userDetails.entries.elementAt(0).value));
                  }
                }

                String selectedValue = userID;

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setSateDropdown) {
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: DropdownButton(
                                          items: dropdownItems,
                                          onChanged: (String? newValue) {
                                            setSateDropdown(() {
                                              selectedValue = newValue!;
                                            });
                                          },
                                          value: selectedValue,
                                        )),
                                    Container(
                                        padding: const EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        ))
                                  ],
                                ),
                                TextButton(
                                    onPressed: () async {
                                      await GoalsTable.addGoal(
                                          subGoalDescriptionController.text,
                                          deadline,
                                          widget.teamData.entries
                                              .elementAt(0)
                                              .value,
                                          true,
                                          teamGoalId:
                                              item.entries.elementAt(0).value,
                                          userId: selectedValue);
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
                                        child: Text("Team Goal $index")),
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
                                              labelText: "Description",
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
                                    Container(
                                        padding: const EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                      GoalsTable.updateGoal(
                                          item.entries.elementAt(0).value,
                                          description:
                                              goalDescriptionController.text,
                                          deadline:
                                              goalDeadlineController.text);
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                super.widget),
                                      );
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
        children: specificSubgoals.map((e) {
          return ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  userData
                      .firstWhere((element) =>
                          element.entries.elementAt(0).value ==
                          userGoalsData
                              .firstWhere((element) =>
                                  element.entries.elementAt(1).value ==
                                  e.entries.elementAt(0).value)
                              .entries
                              .elementAt(0)
                              .value)
                      .entries
                      .elementAt(1)
                      .value,
                  /*userGoalsData
                      .firstWhere((element) =>
                          element.entries.elementAt(1).value ==
                          e.entries.elementAt(0).value)
                      .entries
                      .elementAt(0)
                      .value,*/
                  //e.entries.elementAt(0).value,
                  //Link this to user goal table TODO
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
                    feedbackController.clear();
                    if (result == 0) {
                      //WRITE TO TUTOR SUB-GOAL

                      //find the tutor id
                      String teamTutorID = "";
                      for (Map<String, String> userDetails in userData) {
                        if (userDetails.entries.elementAt(2).value == '1') {
                          teamTutorID = userDetails.entries.elementAt(0).value;
                        }
                      }

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
                                        onPressed: () async {
                                          await TutorMessagesTable.addMessage(
                                              userID,
                                              teamTutorID,
                                              widget.teamData.entries
                                                  .elementAt(0)
                                                  .value,
                                              teamTutorID,
                                              writeToTutorController.text,
                                              subGoalId:
                                                  e.entries.elementAt(0).value);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        super.widget),
                                          );
                                        },
                                        child: const Text("Send"))
                                  ],
                                )
                                /**/
                                );
                          });
                    }
                    if (result == 1) {
                      //View feedback
                      List<Map<String, String>> specificFeedback = [];
                      for (Map<String, String> data in feedback) {
                        if (data.entries.elementAt(2).value ==
                            e.entries.elementAt(0).value) {
                          specificFeedback.add(data);
                        }
                      }
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
                                  itemCount: specificFeedback.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                          specificFeedback
                                              .elementAt(index)
                                              .entries
                                              .elementAt(3)
                                              .value,
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
                      //Give feedback
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
                                        onPressed: () {
                                          FeedbackTable.addFeedback(
                                              userID,
                                              e.entries.elementAt(0).value,
                                              feedbackController.text);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        super.widget),
                                          );
                                        },
                                        child: Text("Submit"))
                                  ],
                                )
                                /**/
                                );
                          });
                    }
                    if (result == 3) {
                      //EDIT SUB-GOAL
                      //Will need to update assigned to controller and description
                      subGoalDescriptionController.text =
                          e.entries.elementAt(1).value;

                      //Setup dropdown box - only needed if changing user assigned
                      /*List<DropdownMenuItem<String>> dropdownItems = [];
                      for (Map<String, String> userDetails in userData) {
                        if (userDetails.entries.elementAt(2).value == '0') {
                          dropdownItems.add(DropdownMenuItem(
                              child:
                                  Text(userDetails.entries.elementAt(1).value),
                              value: userDetails.entries.elementAt(0).value));
                        }
                      }

                      String selectedValue = userData
                          .firstWhere((element) =>
                              element.entries.elementAt(0).value ==
                              userGoalsData
                                  .firstWhere((element) =>
                                      element.entries.elementAt(1).value ==
                                      e.entries.elementAt(0).value)
                                  .entries
                                  .elementAt(0)
                                  .value)
                          .entries
                          .elementAt(0)
                          .value;*/

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(builder:
                                (BuildContext context2,
                                    StateSetter setSateDropdown) {
                              return AlertDialog(
                                  insetPadding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  scrollable: true,
                                  title: Row(
                                    children: [
                                      const Text(
                                        "Edit a Subgoal",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Color.fromRGBO(
                                                21, 90, 148, 10)),
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
                                          color:
                                              Color.fromRGBO(21, 90, 148, 10),
                                          width: 1.5)),
                                  content: Column(
                                    children: [
                                      Column(
                                        children: [
                                          //Only needed if reassigning
                                          /*Container(
                                              padding: const EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: DropdownButton(
                                                items: dropdownItems,
                                                onChanged: (String? newValue) {
                                                  setSateDropdown(() {
                                                    selectedValue = newValue!;
                                                  });
                                                },
                                                value: selectedValue,
                                              )),*/
                                          Container(
                                              padding: const EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: TextField(
                                                controller:
                                                    subGoalDescriptionController,
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    labelText: "Description",
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 3,
                                                              color:
                                                                  Colors.blue),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 3,
                                                              color:
                                                                  Colors.red),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    )),
                                              ))
                                        ],
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            //Update goal in GoalsTable TODO
                                            await GoalsTable.updateGoal(
                                                e.entries.elementAt(0).value,
                                                description:
                                                    subGoalDescriptionController
                                                        .text);
                                            Navigator.pop(context);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          super.widget),
                                            );
                                          },
                                          child: const Text("Update"))
                                    ],
                                  )
                                  /**/
                                  );
                            });
                          });
                    }
                    if (result == 4) {
                      //DELETE SUB-GOAL
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
                                      "Delete Sub-Goal",
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
                                        padding: const EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: const Text(
                                            "Are you sure you want to delete this subgoal?")),
                                    TextButton(
                                        onPressed: () async {
                                          await GoalsTable.deleteGoal(
                                              e.entries.elementAt(0).value);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
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
                  e.entries.elementAt(1).value,
                  style: TextStyle(
                      fontSize: 11, color: Color.fromRGBO(38, 153, 251, 10)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Progress: ${e.entries.elementAt(2).value}%",
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
        }).toList(),
      ),
    );
  }
}
