/// Code inspired by Mobile Programmer, 2019 - https://www.youtube.com/watch?v=F4Q6lEhmwCY

import 'dart:convert';
import 'package:deco3801_project/databaseElements/DBConstants.dart';
import 'package:http/http.dart' as http;

class TeamsTable {
  /// Returns all records in the teams table.
  ///
  /// Needs to be called with await to get synchronous operation
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// where each Map is an individual record
  /// Returns an empty list on error
  ///
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
      // print(dataList);
      // print("Call to HTTP");

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
      print('Error');
      return [];
    }
  }

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

  /// Adds a record into the users table.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  /// All fields need to be provided, a user_id is automatically generated
  ///
  /// Returns true when user added successfully, false on error      TODO: maybe return user_id?
  static Future<bool> addTeam(String teamName, String teamGoals) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.TEAMS_TABLE;
      map["columns"] = '(team_id, team_name, team_goal)';

      var newValues = [teamName, teamGoals];
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

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Updates an existing record in the users table.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// TODO: Decide on [tutorStatus] input type, when [userId] is not a valid user it returns true but nothing is affected
  ///
  /// Meant to Return true when user updated successfully, false on error      TODO: maybe return user_id?
  /// TODO: FIX: returns true when invalid id provided
  static Future<bool> updateTeam(String teamId,
      {String teamName = '', String teamGoals = ''}) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.UPDATE_ACTION;
      map["table"] = DBConstants.TEAMS_TABLE;

      // Add columns which have been specified to be changed
      map["columns"] = '';
      if (teamName != '') {
        map["columns"] += "team_name = '$teamName',";
      }
      if (teamGoals != '') {
        map["columns"] += "team_goal = '$teamGoals',";
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
}
