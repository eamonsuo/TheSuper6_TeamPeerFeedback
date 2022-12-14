import 'package:deco3801_project/databaseElements/FeedbackTable.dart';
import 'package:deco3801_project/databaseElements/GoalsTable.dart';
import 'package:deco3801_project/databaseElements/TeamsTable.dart';
import 'package:flutter/material.dart';

class TeamDisplay extends StatefulWidget {
  // Requiring the list of todos.
  TeamDisplay({super.key, required this.teamID, required this.teamName});

  // final Map<String, String> teamData;
  final String teamID;
  final String teamName;
  String userID = "28119";

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
    _goals = GoalsTable.getTeamGoalInfo(widget.teamID);
    _subgoals = GoalsTable.getAllTeamSubGoals(widget.teamID);
    _usersInTeam = TeamsTable.getUsersInTeamInfo(widget.teamID);
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
          List<Map<String, String>> userGoals =
              snapshot.data![4] as List<Map<String, String>>;

          //Subgoals for the current goal
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.teamName),
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
                      // return Text("buildList_");
                      return _buildList(
                          _goalData.elementAt(index),
                          context,
                          index,
                          _subgoalData,
                          _feedbackData,
                          _usersInTeamData,
                          userGoals);
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
                                        widget.teamID,
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
      Map<String, String> teamGoal,
      BuildContext context,
      int index,
      Map<String, List> subgoals,
      List<Map<String, String>> feedback,
      List<Map<String, String>> userData,
      List<Map<String, String>> userGoalsData) {
    String deadline = teamGoal.entries.elementAt(4).value;
    double progress = double.parse(teamGoal.entries.elementAt(2).value);

    List<Map<String, String>> specificSubgoals = [];
    for (int i = 0; i < subgoals.length; i++) {
      if (subgoals.entries.elementAt(i).key ==
          teamGoal.entries.elementAt(0).value) {
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
            Column(
              children: [
                Text(
                  "Team Goal $index",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color.fromRGBO(21, 90, 148, 10)),
                ),
                Text(
                  "Deadline: $deadline",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color.fromRGBO(21, 90, 148, 10)),
                ),
              ],
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
                // how should this work for the tutors?
                List<DropdownMenuItem<String>> dropdownItems = [];
                for (var user in userData) {
                  if (user["tutor_status"] == '0') {
                    dropdownItems.add(DropdownMenuItem(
                        value: user["user_id"]!,
                        child: Text(user["username"]!)));
                  }
                }

                String selectedValue = widget.userID;

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
                                          widget.teamID,
                                          true,
                                          teamGoalId: teamGoal.entries
                                              .elementAt(0)
                                              .value,
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
                  goalDescriptionController.text = teamGoal["goal_desc"]!;
                  goalDeadlineController.text = teamGoal["goal_deadline"]!;

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
                                          teamGoal["goal_id"]!,
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
                                          teamGoal["goal_id"]!);
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
              teamGoal.entries.elementAt(1).value,
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
                                    const EdgeInsets.only(left: 20, right: 20),
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
                                              widget.userID,
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
                                        child: const Text("Submit"))
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
