/// Code inspired by Mobile Programmer, 2019 - https://www.youtube.com/watch?v=F4Q6lEhmwCY

import 'dart:convert';
import 'package:deco3801_project/databaseElements/DBConstants.dart';
import 'package:deco3801_project/databaseElements/UsersTable.dart';
import 'package:http/http.dart' as http;

class TeamsTable {
  /// Returns all records in the teams table.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['team_name']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, ...]
  ///
  /// Each element of the list is a Map which represents an individual record
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

      // HTTP POST message sent to server and JSON is returned
      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      List<dynamic> dataList = jsonDecode(response.body);

      // Error Checking on response from web serve
      if (dataList.isEmpty || response.statusCode != 200) {
        return [];
      }

      // Organise & output results in json style
      List<Map<String, String>> results = [];
      for (var i = 0; i < dataList.length; i++) {
        results.add(Map<String, String>.from(dataList[i]));
      }

      return results;
    } catch (e) {
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
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, ...]
  ///
  /// Each element of the list is a Map which represents an individual record
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

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      List<dynamic> dataList = jsonDecode(response.body);

      // Error Checking on response from web serve
      if (dataList.isEmpty || response.statusCode != 200) {
        return [];
      }

      // Organise & output results in json style
      List<Map<String, String>> results = [];
      for (var i = 0; i < dataList.length; i++) {
        results.add(Map<String, String>.from(dataList[i]));
      }

      return results;
    } catch (e) {
      return [];
    }
  }

  /// Adds a record into the teams table. Adds a record in usersInTeams table
  ///
  /// [teamName] is the name of the team.
  /// [userId] is the user who is creating the team.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// All fields need to be provided, a team_id is automatically generated
  ///
  /// Returns true when user added successfully, false on error
  static Future<bool> addTeam(String teamName, String userId) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.TEAMS_TABLE;
      map["columns"] = '(team_id, team_name)';

      var newValues = [teamName];
      map["clause"] = "(NULL,'${newValues.join("','")}')";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
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
  /// [teamId] is the ID of the team being updated.
  /// [teamName] is the new name of the team.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  static Future<bool> updateTeam(String teamId, {String teamName = ''}) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.UPDATE_ACTION;
      map["table"] = DBConstants.TEAMS_TABLE;

      // Add columns which have been specified to be changed
      map["columns"] = '';
      if (teamName != '') {
        map["columns"] += "team_name = '$teamName',";
      }

      if (map["columns"] == '') {
        return false;
      }

      //Remove trailing comma
      map["columns"] = map["columns"].substring(0, map["columns"].length - 1);

      map["clause"] = "team_id = $teamId";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Adds a given user to a given team. Adds a record in usersInTeams table
  ///
  /// [userId] user to be added to a team.
  /// [teamId] if specified it is the team to add the user into, otherwise adds
  /// user into the most recently created team.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true on success, false on error
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

      var map = Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.USERS_IN_TEAM_TABLE;
      map["columns"] = '(team_id, user_id)';

      var newValues = [futureTeamId, userId];
      map["clause"] = "('${newValues.join("','")}')";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes an existing team from the teams table and the database.
  ///
  /// [teamId] is the ID of the team
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record deleted successfully, false on error
  static Future<bool> deleteTeam(String teamId) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.DELETE_ACTION;
      map["table"] = DBConstants.TEAMS_TABLE;
      map["columns"] = '';
      map["clause"] = "team_id = $teamId";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes an existing user from a team in the usersInTeams table.
  ///
  /// [userId] is the Id of the user to be deleted
  /// [teamId] is the ID of the team
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  static Future<bool> deleteUserFromTeam(String userId, String teamId) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.DELETE_ACTION;
      map["table"] = DBConstants.USERS_IN_TEAM_TABLE;
      map["columns"] = '';
      map["clause"] = "team_id = $teamId AND user_id = $userId";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets all of the users in a team
  ///
  /// [teamId] is the ID of the team
  ///
  /// Returns a list of user IDs on success, empty list on error
  static Future<List<String>> getUsersInTeam(String teamId,
      [List<String> columns = const ['*']]) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ONE_ACTION;
      map["table"] = DBConstants.USERS_IN_TEAM_TABLE;
      map["columns"] = columns.join(',');
      map["clause"] = "team_id = $teamId";
      List<String> users = [];

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        return [];
      }

      for (int i = 0; i < data.length; i++) {
        users.add(data[i]['user_id']);
      }

      return users;
    } catch (e) {
      return [];
    }
  }

  /// Gets the information of all users in a team
  ///
  /// [teamId] is the ID of the team
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, ...]
  ///
  /// Each element of the list is a Map which represents an individual user record
  ///   {user_id: value, username: value, tutor_status: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getUsersInTeamInfo(String teamId,
      [List<String> columns = const ['*']]) async {
    try {
      List<String> userIds = await getUsersInTeam(teamId);
      List<Map<String, String>> userInfo = [];

      // Get goal info for each team goal
      for (int i = 0; i < userIds.length; i++) {
        List<Map<String, String>> user =
            await UsersTable.getSelectedUser(userIds[i]);
        userInfo.add(user[0]);
      }

      return userInfo;
    } catch (e) {
      return [];
    }
  }

  /// Get all records in the usersInTeams table.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, ...]
  ///
  /// Each element of the list is a Map which represents an individual record
  ///   {team_id: value, user_id: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getAllFromUsersInTeams(
      [List<String> columns = const ['*']]) async {
    try {
      // Create map which stores the values needed for our sql query
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ALL_ACTION;
      map["table"] = DBConstants.USERS_IN_TEAM_TABLE;
      map["columns"] = columns.join(', ');
      map["clause"] = '';

      // HTTP POST message sent to server and JSON is returned
      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      List<dynamic> dataList = jsonDecode(response.body);

      // Error Checking on response from web serve
      if (dataList.isEmpty || response.statusCode != 200) {
        return [];
      }

      // Organise & output results in json style
      List<Map<String, String>> results = [];
      for (var i = 0; i < dataList.length; i++) {
        results.add(Map<String, String>.from(dataList[i]));
      }

      return results;
    } catch (e) {
      return [];
    }
  }
}
