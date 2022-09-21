/// Code inspired by Mobile Programmer, 2019 - https://www.youtube.com/watch?v=F4Q6lEhmwCY

import 'dart:convert';
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
  ///   {goal_id: value, goal_desc: value, goal_progress: value, goal_user_id: value, goal_team_id: value, goal_deadline: value}
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
      print("Call to HTTP");

      // Error Checking on response from web serve
      if (dataList.isEmpty || response.statusCode != 200) {
        print("error in getAllUsers");
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
  ///   {goal_id: value, goal_desc: value, goal_progress: value, goal_user_id: value, goal_team_id: value, goal_deadline: value}
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
      print(map.toString());

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      List<dynamic> dataList = jsonDecode(response.body);
      print("Call to HTTP");

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

  /// Adds a record into the goals table. Adds a record in teamGoals table
  ///
  /// [description] is the description of the goal TODO: CHECK, Do we need a goal title??
  /// [userId] is the user the goal is assigned to
  /// [teamId] is the team the goal belongs to
  /// [deadline] date for goal to be due by in format 'DD-MM-YY'
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  /// All fields need to be provided, a goal_id is automatically generated
  ///
  /// Returns true when user added successfully, false on error      TODO: maybe return goal_id?
  static Future<bool> addGoal(
      String description, String userId, String teamId, String deadline) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.GOALS_TABLE;
      map["columns"] =
          '(goal_id, goal_desc, goal_progress, goal_user_id, goal_team_id, goal_deadline)';

      // Set up values for a new user in sql query
      var progress = '0'; // Start new goal with 0 progress
      var newValues = [description, progress, userId, teamId, deadline];
      map["clause"] = "(NULL,'${newValues.join("','")}')";
      print(map);

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in addUser");
        return false;
      }

      addGoalToTeam(
          teamId); //TODO: Goal is still added even if this fails, not error checked

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
  /// [userId] is the user the goal is assigned to
  /// [teamId] is the team the goal belongs to
  /// [deadline] date for goal to be due by in format 'DD-MM-YY'
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  /// TODO: FIX: returns true when invalid id provided
  static Future<bool> updateGoal(String goalId,
      {String description = '',
      String progress = '',
      String userId = '',
      String teamId = '',
      String deadline = ''}) async {
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
      }
      if (userId != '') {
        map["columns"] += "goal_user_id = '$userId',";
      }
      if (teamId != '') {
        map["columns"] += "goal_team_id = '$teamId',";
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
      print(map);

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in updateUser");
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Create new function, addGoalToTeam(team_id)
  ///   Call this in add goal
  ///   Assign goal to team in teamGoals Table
  ///
  /// Adds a given goal to a given team
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  static Future<bool> addGoalToTeam(String teamId) async {
    try {
      var allGoals = await getAllGoals();
      var goalId = (allGoals[allGoals.length - 1]['goal_id']);

      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.TEAM_GOALS_TABLE;
      map["columns"] = '(team_id, goal_id)';

      var newValues = [teamId, goalId];
      map["clause"] = "('${newValues.join("','")}')";
      print(map);

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("Error in addGoalToTeam");
        return false;
      }

      return true;
    } catch (e) {
      print('Rip Error is actually here lol');
      return false;
    }
  }
}
