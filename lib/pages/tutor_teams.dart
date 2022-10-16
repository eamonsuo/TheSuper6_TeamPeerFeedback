import 'package:deco3801_project/databaseElements/TeamsTable.dart';
import 'package:deco3801_project/databaseElements/UsersTable.dart';
import 'package:deco3801_project/widgets/team_display.dart';
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
            backgroundColor: const Color.fromRGBO(241, 249, 255, 50),
            appBar: AppBar(title: const Text('Tutor Teams')),
            body: ListView.separated(
              itemCount: teams.length,
              itemBuilder: (BuildContext context, int index) {
                String teamName = teams.elementAt(index)["team_name"]!;
                String teamID = teams.elementAt(index)["team_id"]!;

                return TeamListCard(teamID, teamName);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.transparent,
              ),
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Add Team
                var teamNameController = TextEditingController();

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
                                        teamNameController.text, tutorID);
                                    Navigator.pop(context);
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

PopupMenuItem SeeMembersButton(context, teamId) {
  return PopupMenuItem(
    child: ListTile(
      title: const Text(
        'See members',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(38, 153, 251, 60),
            fontSize: 14),
      ),
      onTap: () async {
        //See members
        List<String> members = [];

        var _usersInTeamData = await TeamsTable.getAllFromUsersInTeams();

        var _allUsersData = await UsersTable.getAllUsers();

        var usersInThisTeam = _usersInTeamData.where((element) => element["team_id"] == teamId).toList();

        for (var member in usersInThisTeam) {
          for (var user in _allUsersData) {
            if (user["user_id"]! == member["user_id"]!) {
              members.add(user["username"]!);
            }
          }
        }
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
                  child: ListView.separated(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(members[index],
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color.fromRGBO(38, 153, 251, 10))),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color.fromRGBO(21, 90, 148, 10),
                              width: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
              );
            });
      },
    ),
  );
}

PopupMenuItem AddMembersButton(context, teamId) {
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
        var addMembersNameController = TextEditingController();

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
                                controller: addMembersNameController,
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
                          onPressed: () async {

                            var _allUsersData = await UsersTable.getAllUsers();
                            
                            String userToAdd = "";
                            for (int i = 0; i < _allUsersData.length; i++) {
                              if (_allUsersData
                                      .elementAt(i)
                                      .entries
                                      .elementAt(1)
                                      .value ==
                                  addMembersNameController.text) {
                                userToAdd = _allUsersData
                                    .elementAt(i)
                                    .entries
                                    .elementAt(0)
                                    .value;
                              }
                            }
                            await TeamsTable.addUserToTeam(userToAdd,
                                teamId: teamId);
                            Navigator.pop(context);
                          },
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

PopupMenuItem DeleteTeamButton(context, teamId) {
  return PopupMenuItem(
    child: ListTile(
      title: const Text(
        'Delete team',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(38, 153, 251, 60),
            fontSize: 14),
      ),
      onTap: () {
        // Delete team
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  insetPadding: const EdgeInsets.only(left: 20, right: 20),
                  scrollable: true,
                  title: Row(
                    children: [
                      const Text(
                        "Delete Team",
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
                              "Are you sure you want to delete this team?")),
                      TextButton(
                          onPressed: () async {
                            await TeamsTable.deleteTeam(teamId);
                            
                            Navigator.pop(context);
                            //Todo fix page refresh
                          },
                          child: const Text("Delete"))
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
          SeeMembersButton(context, teamID),
          AddMembersButton(context, teamID),
          DeleteTeamButton(context, teamID),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TeamDisplay(teamID: teamID, teamName: teamName),
          ),
        );
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Color.fromRGBO(21, 90, 148, 50))),
      tileColor: Colors.white,
    );
  }
}
