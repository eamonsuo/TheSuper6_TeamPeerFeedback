import 'package:deco3801_project/databaseElements/TeamsTable.dart';
import 'package:flutter/material.dart';

class TutorTeamsPage extends StatefulWidget {
  @override
  State<TutorTeamsPage> createState() => _TutorTeamsPage();
}

class _TutorTeamsPage extends State<TutorTeamsPage> {
  // this is the sample tutor account used to testing as there is no login system.
  String tutorID = "28121";

  late Future<List<Map<String, String>>> _teams;

  @override
  void initState() {
    super.initState();
    _teams = TeamsTable.getAllTeams();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _teams,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Map<String, String>> teams = snapshot.data;

          return Scaffold(
            appBar: AppBar(title: const Text('Tutor Teams')),
            body: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (BuildContext context, int index) {
                String teamName = teams.elementAt(index)["team_name"]!;
                String teamID = teams.elementAt(index)["team_id"]!;

                return TeamListCard(teamID, teamName);
                // return Text(teams.elementAt(index)["team_name"]!);
              },
            ),
            // body: Center(child: Text('Tutor Teams Page')),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

// class WriteToTutorButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuItem(
//       child: const ListTile(
//         title: Text(
//           'Write to tutors',
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Color.fromRGBO(38, 153, 251, 60),
//               fontSize: 14),
//         ),
//       ),
//       onTap: () {

//       },
//     );
//   }
// }

PopupMenuItem WriteToTutorButton(BuildContext context) {
  return PopupMenuItem(
    child: ListTile(
      title: const Text(
        'Write to tutors',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(38, 153, 251, 60),
            fontSize: 14),
      ),
      onTap: () {
        //Write to tutors for team
        // writeToTutorController.clear();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  insetPadding: EdgeInsets.only(left: 20, right: 20),
                  scrollable: true,
                  title: Row(
                    children: [
                      const Text(
                        "Write to Tutor",
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
                          color: Color.fromRGBO(21, 90, 148, 10), width: 1.5)),
                  content: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: TextField(
                            // controller: writeToTutorController,
                            maxLines: null,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.red),
                                  borderRadius: BorderRadius.circular(15),
                                )),
                          )),
                      TextButton(
                          onPressed: () {},
                          // onPressed: () async {
                          //   await TutorMessagesTable.addMessage(
                          //       userID,
                          //       tutorID,
                          //       _specificTeams
                          //           .elementAt(index)
                          //           .entries
                          //           .elementAt(0)
                          //           .value,
                          //       tutorID,
                          //       writeToTutorController.text);
                          //   Navigator.pop(context);
                          // },
                          child: const Text("Send"))
                    ],
                  )
                  /**/
                  );
            });
      },
    ),
  );
}

PopupMenuItem SeeMembersButton(context) {
  return PopupMenuItem(
    child: ListTile(
      title: const Text(
        'See members',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(38, 153, 251, 60),
            fontSize: 14),
      ),
      onTap: () {
        //See members
        // List<String> members = [];

        // for (int i = 0; i < _usersInTeamData.length; i++) {
        //   if (_usersInTeamData.elementAt(i).entries.elementAt(0).value ==
        //       _specificTeams.elementAt(index).entries.elementAt(0).value) {
        //     for (int j = 0; j < _allUsersData.length; j++) {
        //       if (_allUsersData.elementAt(j).entries.elementAt(0).value ==
        //           _usersInTeamData
        //               .elementAt(i)
        //               .entries
        //               .elementAt(1)
        //               .value) {
        //         members.add(
        //             _allUsersData.elementAt(j).entries.elementAt(1).value);
        //       }
        //     }
        //   }
        // }
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                insetPadding: EdgeInsets.only(left: 20, right: 20),
                scrollable: true,
                title: Row(
                  children: [
                    const Text(
                      "Members",
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
                        color: Color.fromRGBO(21, 90, 148, 10), width: 1.5)),
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.7,
                  // child: ListView.separated(
                  //   itemCount: members.length,
                  //   itemBuilder: (context, index2) {
                  //     return ListTile(
                  //       title: Text(members[index2],
                  //           style: const TextStyle(
                  //               fontSize: 13,
                  //               color: Color.fromRGBO(38, 153, 251, 10))),
                  //       shape: RoundedRectangleBorder(
                  //         side: const BorderSide(
                  //             color: Color.fromRGBO(21, 90, 148, 10),
                  //             width: 0.5),
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //     );
                  //   },
                  //   separatorBuilder: (BuildContext context, int index) =>
                  //       const Divider(),
                  // ),
                ),
              );
            });
      },
    ),
  );
}

PopupMenuItem AddMembersButton(context) {
  return PopupMenuItem(
    child: ListTile(
      title: const Text(
        'Add members',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(38, 153, 251, 60),
            fontSize: 14),
      ),
      onTap: () {
        // teamNameController.clear();

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  insetPadding: const EdgeInsets.only(left: 20, right: 20),
                  scrollable: true,
                  title: Row(
                    children: [
                      const Text(
                        "Add a Member",
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
                          color: Color.fromRGBO(21, 90, 148, 10), width: 1.5)),
                  content: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextField(
                                // controller: addMembersNameController,
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: "Username",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.blue),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.red),
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              )),
                        ],
                      ),
                      TextButton(
                          onPressed: () {},
                          // onPressed: () async {
                          //   String userToAdd = "";
                          //   for (int i = 0; i < _allUsersData.length; i++) {
                          //     if (_allUsersData
                          //             .elementAt(i)
                          //             .entries
                          //             .elementAt(1)
                          //             .value ==
                          //         addMembersNameController.text) {
                          //       userToAdd = _allUsersData
                          //           .elementAt(i)
                          //           .entries
                          //           .elementAt(0)
                          //           .value;
                          //     }
                          //   }
                          //   await TeamsTable.addUserToTeam(userToAdd,
                          //       teamId: _specificTeams
                          //           .elementAt(index)
                          //           .entries
                          //           .elementAt(0)
                          //           .value);
                          //   print("Added");
                          //   Navigator.pop(context);
                          //   setState(() {});
                          //   //Todo fix page refresh
                          // },
                          child: const Text("Add"))
                    ],
                  )
                  /**/
                  );
            });
      },
    ),
  );
}

PopupMenuItem LeaveTeamButton(context) {
  return PopupMenuItem(
    child: ListTile(
      title: const Text(
        'Leave team',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(38, 153, 251, 60),
            fontSize: 14),
      ),
      onTap: () {
        //Leave team
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  insetPadding: const EdgeInsets.only(left: 20, right: 20),
                  scrollable: true,
                  title: Row(
                    children: [
                      const Text(
                        "Leave Team",
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
                          color: Color.fromRGBO(21, 90, 148, 10), width: 1.5)),
                  content: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: const Text(
                              "Are you sure you want to leave this team?")),
                      TextButton(
                          onPressed: () {},
                          // onPressed: () async {
                          //   await TeamsTable.deleteUserFromTeam(
                          //       userID,
                          //       _specificTeams
                          //           .elementAt(index)
                          //           .entries
                          //           .elementAt(0)
                          //           .value);
                          //   Navigator.pop(context);
                          //   //Todo fix page refresh
                          // },
                          child: const Text("Leave"))
                    ],
                  )
                  /**/
                  );
            });
      },
    ),
  );
}

class TeamListCard extends StatelessWidget {
  String teamID;
  String teamName;
  TeamListCard(this.teamID, this.teamName);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
      title: Text(
        teamName,
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
          WriteToTutorButton(context),
          SeeMembersButton(context),
          AddMembersButton(context),
          LeaveTeamButton(context),
        ],
      ),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         TeamDisplay(teamData: _specificTeams.elementAt(index)),
        //   ),
        // );
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Color.fromRGBO(21, 90, 148, 50))),
      tileColor: Colors.white,
    );
  }
}
