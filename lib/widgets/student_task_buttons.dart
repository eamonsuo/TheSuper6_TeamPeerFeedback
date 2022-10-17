import 'package:deco3801_project/databaseElements/FeedbackTable.dart';
import 'package:deco3801_project/databaseElements/GoalsTable.dart';
import 'package:deco3801_project/mainStructures/student_home.dart';
import 'package:deco3801_project/util/ui_colours.dart';
import 'package:flutter/material.dart';

class StudentTaskButtons extends StatefulWidget {
  @override
  State<StudentTaskButtons> createState() => _StudentTaskButtons();

  int id;
  String description;
  Map<String, String> goalInfo;
  StudentTaskButtons(this.id, this.description, this.goalInfo);
}

class _StudentTaskButtons extends State<StudentTaskButtons> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Button> buttons = [
      Button(
        "kebab",
        true,
        PopupMenuButton(
          splashRadius: 20,
          tooltip: '',
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: ListTile(
                title: const Text(
                  'Write to tutors',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(38, 153, 251, 60),
                      fontSize: 14),
                ),
                onTap: () {
                  var subGoalDescriptionController = TextEditingController();
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
                                  "Write to tutor",
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
                                        child: TextField(
                                          // controller:
                                          //     subGoalAssignedPersonController,
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: "Subject:",
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
                                          controller:
                                              subGoalDescriptionController,
                                          maxLines: 20,
                                          textAlign: TextAlign.left,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: "",
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
                                    onPressed: () {
                                      // Write to tutor
                                    },
                                    child: const Text("Submit"))
                              ],
                            )
                            /**/
                            );
                      });
                  // ==== end of pop up ====
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                title: const Text(
                  'View feedback',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(38, 153, 251, 60),
                      fontSize: 14),
                ),
                onTap: () async {
                  var feedback =
                      await FeedbackTable.getGoalFeedback(widget.id.toString());
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          insetPadding: EdgeInsets.only(left: 20, right: 20),
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
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: ListView.separated(
                              itemCount: feedback.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      feedback.elementAt(index)["feedback_contents"]!,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Color.fromRGBO(
                                              38, 153, 251, 10))),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Color.fromRGBO(21, 90, 148, 10),
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
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                title: const Text(
                  'Edit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(38, 153, 251, 60),
                      fontSize: 14),
                ),
                onTap: () {
                  TextEditingController editController =
                      TextEditingController(text: widget.goalInfo["goal_desc"]);

                  showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                insetPadding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                scrollable: true,
                                title: Row(
                                  children: [
                                    const Text(
                                      "Update Individual Task",
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
                                        const Text("Contents"),
                                        Container(
                                            padding: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: TextField(
                                              controller: editController,
                                              maxLines: 4,
                                              textAlign: TextAlign.left,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  // labelText: goalInfo["goal_description"],
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
                                        onPressed: () {
                                          String newDescription =
                                              editController.value.text;
                                          String goalID =
                                              widget.goalInfo["goal_id"]!;
                                          String deadline =
                                              widget.goalInfo["goal_deadline"]!;
                                          String progress =
                                              widget.goalInfo["goal_progress"]!;

                                          GoalsTable.updateGoal(goalID,
                                              description: newDescription,
                                              progress: progress,
                                              deadline: deadline);

                                          // this exits the showDialog widget
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text("Update"))
                                  ],
                                ));
                          })
                      .then((value) => value!
                          ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      StudentHome()))
                          : {});
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                title: const Text(
                  'Delete',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(38, 153, 251, 60),
                      fontSize: 14),
                ),
                onTap: () {
                  showDialog<bool>(
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
                                            "Are you sure you want to delete this goal?")),
                                    TextButton(
                                        onPressed: () {
                                          GoalsTable.deleteGoal(
                                              widget.goalInfo["goal_id"]!);
                                          // Navigator.of(context).pop(true).then()
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Delete"))
                                  ],
                                )
                                /**/
                                );
                          })
                      .then((value) => value!
                          ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      StudentHome()))
                          : {});
                },
              ),
            ),
          ],
        ),
      ),
      Button(
          "file",
          true,
          IconButton(
            icon: Icon(Icons.folder),
            iconSize: 20,
            splashRadius: 15,
            color: UIColours.darkBlue,
            onPressed: () {
              debugPrint("folder pressed");
            },
          )),
      Button(
          "attach",
          true,
          IconButton(
            icon: Icon(Icons.attach_file),
            iconSize: 20,
            splashRadius: 15,
            color: UIColours.darkBlue,
            onPressed: () {
              debugPrint("attach pressed");
            },
          ))
    ];

    List<Widget> activeButtons = [];
    for (var button in buttons) {
      if (button.active) {
        activeButtons.add(button.widget);
      }
    }

    return Row(textDirection: TextDirection.rtl, children: activeButtons);
  }
}

class Button {
  String name;
  bool active;
  Widget widget;
  Button(this.name, this.active, this.widget);
}
