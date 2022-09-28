/// Code inspired by Mobile Programmer, 2019 - https://www.youtube.com/watch?v=F4Q6lEhmwCY

import 'dart:convert';
import 'package:deco3801_project/databaseElements/DBConstants.dart';
import 'package:http/http.dart' as http;

class TeamsTable {
  /// Returns all records in the teams table.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['team_name']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {team_id: value, team_name: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getAllTeams(
      [List<String> columns = const ['*']]) async {
    try {
      // Create map which stores the values needed for our sql query
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ALL_ACTION;
      map["table"] = DBConstants.TEAMS_TABLE;
      map["columns"] = columns.join(', ');
      map["clause"] = '';
      print(map.toString());

      // HTTP POST message sent to server and JSON is returned
      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      print(response);
      List<dynamic> dataList = jsonDecode(response.body);
      print(dataList);
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
      print("Type of var");
      print(results.runtimeType);
      print("results: $results");
      return results;
    } catch (e) {
      print('Error');
      return [];
    }
  }

  /// Returns records based on the passed [teamId]
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['team_name']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {team_id: value, team_name: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getSelectedTeam(String teamId,
      [List<String> columns = const ['*']]) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ONE_ACTION;
      map["table"] = DBConstants.TEAMS_TABLE;
      map["columns"] = columns.join(',');
      map["clause"] = "team_id = $teamId";
      print(map.toString());

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      List<dynamic> dataList = jsonDecode(response.body);
      print("Call to HTTP");

      // Error Checking on response from web serve
      if (dataList.isEmpty || response.statusCode != 200) {
        print("error in getSelectedTeam");
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

  /// Adds a record into the teams table. Adds a record in usersInTeams table
  ///
  /// [teamName] is the name of the team
  /// [userId] is the user who is creating the team
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  /// All fields need to be provided, a team_id is automatically generated
  ///
  /// Returns true when user added successfully, false on error      TODO: maybe return goal_id?
  static Future<bool> addTeam(String teamName, String userId) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.TEAMS_TABLE;
      map["columns"] = '(team_id, team_name)';

      var newValues = [teamName];
      map["clause"] = "(NULL,'${newValues.join("','")}')";
      print(map);

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("Error in addTeam");
        return false;
      }

      addUserToTeam(userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Updates an existing record in the teams table.
  ///
  /// To update columns, pass them as positional parameters
  ///   e.g. updateTeam('1', teamName: 'Team ChangedName')
  ///
  /// [teamName] is the percentage completion of the goal (e.g. 20% = '20')
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  /// TODO: FIX: returns true when invalid id provided
  static Future<bool> updateTeam(String teamId, {String teamName = ''}) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.UPDATE_ACTION;
      map["table"] = DBConstants.TEAMS_TABLE;

      // Add columns which have been specified to be changed
      map["columns"] = '';
      if (teamName != '') {
        map["columns"] += "team_name = '$teamName',";
      }

      if (map["columns"] == '') {
        print("no cols chosen for update");
        return false;
      }

      //Remove trailing comma
      map["columns"] = map["columns"].substring(0, map["columns"].length - 1);

      map["clause"] = "team_id = $teamId";
      print(map);

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in updateTeam");
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  ///
  /// Create new function, assignUserToTeam(username/user_id, team_id)
  ///   Call this in add team
  ///   Assign user to team in userInTeams Table
  ///
  /// Adds a given user to a given team
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  static Future<bool> addUserToTeam(String userId, {String teamId = ''}) async {
    try {
      var futureTeamId = '';
      if (teamId == '') {
        // Add to most recently created team
        var allTeams = await getAllTeams();
        futureTeamId = (allTeams[allTeams.length - 1]['team_id'])!;
      } else {
        futureTeamId = teamId;
      }

      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.USERS_IN_TEAM_TABLE;
      map["columns"] = '(team_id, user_id)';

      var newValues = [futureTeamId, userId];
      map["clause"] = "('${newValues.join("','")}')";
      print(map);

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("Error in addUserToTeam");
        return false;
      }

      return true;
    } catch (e) {
      print('Rip Error is actually here lol');
      return false;
    }
  }

  /// Deletes an existing team from the teams table.
  /// Propogates through database and deletes records related to [teamId].
  ///
  /// [teamId] is the ID of the team
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  /// TODO: Returns success when invalid ids are used
  static Future<bool> deleteTeam(String teamId) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.DELETE_ACTION;
      map["table"] = DBConstants.TEAMS_TABLE;
      map["columns"] = '';
      map["clause"] = "team_id = $teamId";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print(data.toString());

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in deleteTeam");
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes an existing user from a team in the usersInTeams table.
  ///
  /// [teamId] is the ID of the team
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  /// TODO: Returns success when invalid ids are used
  static Future<bool> deleteUserFromTeam(String userId, String teamId) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.DELETE_ACTION;
      map["table"] = DBConstants.USERS_IN_TEAM_TABLE;
      map["columns"] = '';
      map["clause"] = "team_id = $teamId AND user_id = $userId";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print(data.toString());

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in deleteUserFromTeam");
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
