/// Code inspired by Mobile Programmer, 2019 - https://www.youtube.com/watch?v=F4Q6lEhmwCY

import 'dart:convert';
import 'dart:math';
import 'package:deco3801_project/databaseElements/DBConstants.dart';
import 'package:http/http.dart' as http;

class GoalsTable {
  /// Returns all records in the goals table.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['goal_id', 'goal_progress']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {goal_id: value, goal_desc: value, goal_progress: value, goal_deadline: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getAllGoals(
      [List<String> columns = const ['*']]) async {
    try {
      // Create map which stores the values needed for our sql query
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ALL_ACTION;
      map["table"] = DBConstants.GOALS_TABLE;
      map["columns"] = columns.join(', ');
      map["clause"] = '';
      print(map.toString());

      // HTTP POST message sent to server and JSON is returned
      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      List<dynamic> dataList = jsonDecode(response.body);

      // Error Checking on response from web serve
      if (dataList.isEmpty || response.statusCode != 200) {
        print("error in getAllGoals");
        return [];
      }

      // Organise & output results in json style
      List<Map<String, String>> results = [];
      for (var i = 0; i < dataList.length; i++) {
        results.add(Map<String, String>.from(dataList[i]));
      }

      print("results: $results");
      return results;
    } catch (e) {
      return [];
    }
  }

  /// Returns records based on the passed [goalId]
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['goal_id', 'goal_progress']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {goal_id: value, goal_desc: value, goal_progress: value, goal_deadline: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getSelectedGoal(String goalId,
      [List<String> columns = const ['*']]) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ONE_ACTION;
      map["table"] = DBConstants.GOALS_TABLE;
      map["columns"] = columns.join(',');
      map["clause"] = "${DBConstants.GOALS_COL_GOAL_ID} = $goalId";
      //print(map.toString());

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      List<dynamic> dataList = jsonDecode(response.body);

      // Error Checking on response from web serve
      if (dataList.isEmpty || response.statusCode != 200) {
        print("error in getSelectedGoal");
        return [];
      }

      // Organise & output results in json style
      List<Map<String, String>> results = [];
      for (var i = 0; i < dataList.length; i++) {
        results.add(Map<String, String>.from(dataList[i]));
      }

      print("results: $results");
      return results;
    } catch (e) {
      return [];
    }
  }

  /// Adds a record into the goals table
  /// Adds a record in teamGoals (for a team goal) or the userGoals & subGoals table (for a sub goal)
  ///
  /// [description] is the description of the goal TODO: CHECK, Do we need a goal title??
  /// [deadline] date for goal to be due by in format 'DD-MM-YY'
  /// [teamId] ID of team assigned to goal
  /// [subGoal] Boolean value based on whether this goal is a sub goal or not (if true, MUST pass [teamGoalId] and [userId])
  /// [teamGoalId] The goalId of the teamGoal for this subGoal
  /// [userId] ID of user assigned to goal
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  /// All fields need to be provided, a goal_id is automatically generated
  ///
  /// Returns true when user added successfully, false on error      TODO: maybe return goal_id?
  static Future<bool> addGoal(
      String description, String deadline, String teamId, bool subGoal,
      {String teamGoalId = '', String userId = ''}) async {
    try {
      // If a subgoal exists it must have a teamGoal and user associated
      if (subGoal && teamGoalId == '' && userId == '') {
        return false;
      }

      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.GOALS_TABLE;
      map["columns"] =
          '(goal_id, goal_desc, goal_progress, goal_starttime, goal_deadline)';

      // Set up values for a new user in sql query
      var progress = '0'; // Start new goal with 0 progress
      var currentTime =
          DateTime.now(); // Start time of goal is time of creation
      var year = '${currentTime.year}';
      var startTime =
          "${currentTime.day}-${currentTime.month}-${year.substring(2, 4)}";
      var newValues = [description, progress, startTime, deadline];
      map["clause"] = "(NULL,'${newValues.join("','")}')";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in addGoal");
        return false;
      }

      // Get most recent goal, goal just created
      var allGoals = await getAllGoals();
      var goalId = (allGoals[allGoals.length - 1]['goal_id']) ?? '{}';

      if (subGoal) {
        await addGoalToUser(userId, goalId);
        await addGoalTosubGoals(goalId, teamGoalId);
      } else {
        await addGoalToTeam(teamId, goalId);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Updates an existing record in the goals table.
  ///
  /// To update columns, pass them as positional parameters
  ///   e.g. updateGoal('1', progress: '25')
  ///
  /// [description] is the description of the goal
  /// [progress] is the percentage completion of the goal (e.g. 20% = '20')
  /// [deadline] date for goal to be due by in format 'DD-MM-YY'
  /// [updateTeamGoalProgress] IGONORE THIS PARAMETER - internal use only
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  /// TODO: FIX: returns true when invalid id provided
  static Future<bool> updateGoal(String goalId,
      {String description = '',
      String progress = '',
      String deadline = '',
      bool updateTeamGoalProgress = true}) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.UPDATE_ACTION;
      map["table"] = DBConstants.GOALS_TABLE;

      // Add columns which have been specified to be changed
      map["columns"] = '';
      if (description != '') {
        map["columns"] += "goal_desc = '$description',";
      }
      if (progress != '') {
        map["columns"] += "goal_progress = '$progress',";
      } else {
        updateTeamGoalProgress = false;
      }
      if (deadline != '') {
        map["columns"] += "goal_deadline = '$deadline',";
      }
      if (map["columns"] == '') {
        print("no cols chosen for update");
        return false;
      }

      //Remove trailing comma
      map["columns"] = map["columns"].substring(0, map["columns"].length - 1);

      map["clause"] = "goal_id = $goalId";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in updateGoal");
        return false;
      }

      if (updateTeamGoalProgress) {
        _updateTeamGoalProgress(goalId);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Links the given goalId and teamId in the teamsGoals Table
  ///
  ///
  /// [teamId] is the team ID to be linked to the goal
  /// [goalId] is the goal ID to be linked to the team
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record added successfully
  static Future<bool> addGoalToTeam(String teamId, String goalId) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.TEAM_GOALS_TABLE;
      map["columns"] = '(team_id, goal_id)';

      var newValues = [teamId, goalId];
      map["clause"] = "('${newValues.join("','")}')";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("Error in addGoalToTeam");
        return false;
      }

      return true;
    } catch (e) {
      print('Error in addGoalToTeam');
      return false;
    }
  }

  /// Links the given goal and user to the userGoals Table
  ///
  /// [userId] is the user ID to be linked to the goal
  /// [goalId] is the goal ID to be linked to the user
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  static Future<bool> addGoalToUser(String userId, String goalId) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.USER_GOALS_TABLE;
      map["columns"] = '(user_id, goal_id)';

      var newValues = [userId, goalId];
      map["clause"] = "('${newValues.join("','")}')";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("Error in addGoalToUser");
        return false;
      }

      return true;
    } catch (e) {
      print('Error in addGoalToUser');
      return false;
    }
  }

  /// Links the subGoal to the teamGoal
  ///
  /// [subGoalId] is the subGoal to be linked to the teamGoal
  /// [teamGoalId] is the teamGoal to be linked to the subGoal
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  static Future<bool> addGoalTosubGoals(
      String subGoalId, String teamGoalId) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.SUB_GOALS_TABLE;
      map["columns"] = '(user_goal, team_goal)';

      var newValues = [subGoalId, teamGoalId];
      map["clause"] = "('${newValues.join("','")}')";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("Error in addGoalTosubGoals");
        return false;
      }

      return true;
    } catch (e) {
      print('Error in addGoalTosubGoals');
      return false;
    }
  }

  /// Deletes a goal from the goals table.
  ///
  /// [goalId] is the ID of the goal
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  /// TODO: Returns success when invalid ids are used
  static Future<bool> deleteGoal(String goalId) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.DELETE_ACTION;
      map["table"] = DBConstants.GOALS_TABLE;
      map["columns"] = '';
      map["clause"] = "goal_id = $goalId";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in deleteGoal");
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets all goals associated with a team
  ///
  /// [teamId] is the ID of the team
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns a dictionary mapping teamGoals to subGoals
  ///   {teamGoalId1: (subGoalId1, subGoalId2), teamGoalId2: (subGoalId3, subGoalId4) }
  /// TODO: Returns success when invalid ids are used
  static Future<Map<String, List>> getTeamGoals(String teamId,
      [List<String> columns = const ['*']]) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.GET_ALL_ACTION;
      map["table"] = DBConstants.TEAM_GOALS_TABLE;
      map["columns"] = columns.join(',');
      map["clause"] = "${DBConstants.TG_COL_TEAM_ID} = $teamId";
      Map<String, List> teamGoals = {};
      List<Map<String, String>> subGoalInfo = [];

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      for (var i = 0; i < data.length; i++) {
        var team = data[i]['team_id'];
        var teamGoalId = data[i]['goal_id'];
        if (team == teamId) {
          var subGoals = await getsubGoals(teamGoalId);
          teamGoals[teamGoalId] = subGoals;
        }
      }

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in getTeamGoals");
        return {};
      }
      print(teamGoals);
      return teamGoals;
    } catch (e) {
      return {};
    }
  }

  /// Gets all goals associated with a team
  ///
  /// [teamId] is the ID of the team
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns a dictionary mapping teamGoals to subGoals
  ///   {teamGoalId1: (subGoal1Info, subGoal2Info), teamGoalId2: (subGoal3Info, subGoal4Info) }
  static Future<Map<String, List>> getAllTeamSubGoals(String teamId,
      [List<String> columns = const ['*']]) async {
    try {
      Map<String, List> teamGoals = await getTeamGoals(teamId);
      List<String> teamGoalIds = teamGoals.keys.toList();

      Map<String, List> theAnswer = {};

      for (var i = 0; i < teamGoalIds.length; i++) {
        String teamGoalId = teamGoalIds[i];
        var subGoalIds = teamGoals[teamGoalId]!;
        List<Map<String, String>> allSubGoals =
            []; //List of all sub goal info for given teamGoalId

        for (var j = 0; j < subGoalIds.length; j++) {
          List<Map<String, String>> subGoalInfo =
              await getSelectedGoal(subGoalIds[j]);
          Map<String, String> subGoalInfod = subGoalInfo[0];
          allSubGoals.add(subGoalInfod);
        }
        theAnswer[teamGoalId] = allSubGoals;
      }

      print(theAnswer);
      return theAnswer;
    } catch (e) {
      return {};
    }
  }

  /// Returns records based on the passed [teamId].
  /// Returns all the information related to the team goals
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getTeamGoalInfo(
      String teamId) async {
    Map<String, List> teamGoals = await GoalsTable.getTeamGoals(teamId);
    List<Map<String, String>> goalInfo = [];
    List<String> teamGoalIds = teamGoals.keys.toList();

    // Get goal info for each team goal
    for (int i = 0; i < teamGoalIds.length; i++) {
      List<Map<String, String>> goal =
          await GoalsTable.getSelectedGoal(teamGoalIds[i]);
      goalInfo.add(goal[0]);
    }
    print(goalInfo);
    return goalInfo;
  }

  /// Gets all subGoals associated with a teamGoal
  ///
  /// [goalId] is the goalId of the teamGoal
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// returns a list of all subGoals
  static Future<List> getsubGoals(String goalId,
      [List<String> columns = const ['*']]) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.GET_ALL_ACTION;
      map["table"] = DBConstants.SUB_GOALS_TABLE;
      map["columns"] = columns.join(',');
      map["clause"] = '';
      var subGoals = [];

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      for (var i = 0; i < data.length; i++) {
        var teamGoal = data[i]['team_goal'];
        if (teamGoal == goalId) {
          subGoals.add(data[i]['user_goal']);
        }
      }

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in getSubGoals");
        return [];
      }

      print(subGoals);
      return subGoals;
    } catch (e) {
      return [];
    }
  }

  /// Returns records based on the passed [teamGoalId].
  /// Returns all the information related to the subGoals of a teamGoal
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getSubGoalInfo(
      String teamGoalId) async {
    List subGoalIds = await GoalsTable.getsubGoals(teamGoalId);
    List<Map<String, String>> goalInfo = [];

    // Get goal info for each team goal
    for (int i = 0; i < subGoalIds.length; i++) {
      List<Map<String, String>> goal =
          await GoalsTable.getSelectedGoal(subGoalIds[i]);
      goalInfo.add(goal[0]);
    }
    print(goalInfo);
    return goalInfo;
  }

  /// Returns the team goal id of the passed sub goal id
  ///
  /// Returns an empty string on error
  static Future<String> getTeamGoalFromSubGoal(String subGoalId,
      [List<String> columns = const ['*']]) async {
    var map = new Map<String, dynamic>();
    map["action"] = DBConstants.GET_ONE_ACTION;
    map["table"] = DBConstants.SUB_GOALS_TABLE;
    map["columns"] = columns.join(',');
    map["clause"] = "user_goal = $subGoalId";

    http.Response response =
        await http.post(Uri.parse(DBConstants.url), body: map);
    var data = jsonDecode(response.body);

    // Error Checking on response from web server
    if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
      print("error in getTeamGoalFromSubGoal");
      return "";
    }

    String teamGoalId = data[0]['team_goal'];
    return teamGoalId;
  }

  /// Used to update a team goal's progress when the progress of one of its subgoals' is updated
  /// Used in the updateGoal function
  ///
  /// returns true on success, false on error
  static Future<bool> _updateTeamGoalProgress(String subGoalId) async {
    // Get teamGoal id
    String teamGoalId = await getTeamGoalFromSubGoal(subGoalId);
    if (teamGoalId == "") {
      return false;
    }

    // Get information of all subGoals of teamGoal
    List subGoalsInfo = await getSubGoalInfo(teamGoalId);

    // Get progress of each subgoal
    // Calculate new teamgoal progress
    int goalsCount = subGoalsInfo.length;
    double teamGoalProgress = 0;
    for (int i = 0; i < goalsCount; i++) {
      int subgoalProgress = int.parse(subGoalsInfo[i]["goal_progress"]);
      teamGoalProgress += subgoalProgress / goalsCount;
    }

    // Update team goal progress, bound above by 100
    int goalProgress = min(teamGoalProgress.ceil(), 100);
    bool result = await updateGoal(teamGoalId,
        progress: goalProgress.toString(), updateTeamGoalProgress: false);
    return result;
  }
}
