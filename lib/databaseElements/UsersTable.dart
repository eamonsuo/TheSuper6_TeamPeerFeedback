/// Code inspired by Mobile Programmer, 2019 - https://www.youtube.com/watch?v=F4Q6lEhmwCY

import 'dart:convert';
import 'package:deco3801_project/databaseElements/DBConstants.dart';
import 'package:http/http.dart' as http;

class UsersTable {
  /// Returns all records in the users table.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['username', 'tutor_status']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {user_id: value, username: value, team_id: value, tutor_status: value} TODO: Remove team_id??
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getAllUsers(
      [List<String> columns = const ['*']]) async {
    try {
      // Create map which stores the values needed for our sql query
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ALL_ACTION;
      map["table"] = DBConstants.USERS_TABLE;
      map["columns"] = columns.join(', ');
      map["clause"] = '';
      print(map.toString());

      // HTTP POST message sent to server and JSON is returned
      print('Start');
      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      print(response);
      print(jsonDecode(response.body));
      List<dynamic> dataList = jsonDecode(response.body);
      //print(dataList);
      //print("Call to HTTP");

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

  /// Returns records based on the passed [userId]
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['username', 'tutor_status']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {user_id: value, username: value, team_id: value, tutor_status: value} TODO: Remove team_id??
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getSelectedUser(String userId,
      [List<String> columns = const ['*']]) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ONE_ACTION;
      map["table"] = DBConstants.USERS_TABLE;
      map["columns"] = columns.join(',');
      map["clause"] = "user_id = $userId";
      print(map.toString());

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      List<dynamic> dataList = jsonDecode(response.body);
      print("Call to HTTP");

      // Error Checking on response from web serve
      if (dataList.isEmpty || response.statusCode != 200) {
        print("error in getSelectedUser");
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

  /// Adds a record into the users table. TODO: Add into UsersInTeams Table??
  ///
  /// [username] is the name of the user
  /// [teamId] is the team which the user is being added to TODO: what to do with this??
  /// [tutorStatus] true is a user is a tutor, else false
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  /// All fields need to be provided, a user_id is automatically generated
  ///
  /// Returns true when user added successfully, false on error      TODO: maybe return goal_id?
  static Future<bool> addUser(
      String username, String teamId, bool tutorStatus) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.USERS_TABLE;
      map["columns"] = '(user_id, username, team_id, tutor_status)';

      // Set up values for a new user in sql query
      var tutorInput = '';
      (tutorStatus) ? tutorInput = '1' : tutorInput = '0';
      var newValues = [username, teamId, tutorInput];
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

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Updates an existing record in the users table.
  ///
  /// To update columns, pass them as positional parameters
  ///   e.g. updateTeam('1', username: 'TooCoolForSchool')
  ///
  /// [username] is the name of the user
  /// [teamId] is the team which the user is being added to TODO: REMOVE??
  /// [tutorStatus] true is a user is a tutor, else false TODO: REMOVE??
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  /// TODO: FIX: returns true when invalid id provided
  static Future<bool> updateUser(String userId,
      {String username = '',
      String teamId = '',
      String tutorStatus = ''}) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.UPDATE_ACTION;
      map["table"] = DBConstants.USERS_TABLE;

      // Add columns which have been specified to be changed
      map["columns"] = '';
      if (username != '') {
        map["columns"] += "username = '$username',";
      }
      if (teamId != '') {
        map["columns"] += "team_id = '$teamId',";
      }
      if (tutorStatus != '') {
        map["columns"] +=
            "tutor_status = '$tutorStatus',"; // Might need objects to change tutor status with bool input
      }
      if (map["columns"] == '') {
        print("no cols chosen for update");
        return false;
      }

      //Remove trailing comma
      map["columns"] = map["columns"].substring(0, map["columns"].length - 1);

      map["clause"] = "user_id = $userId";
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

  //TODO: Implement?
  /*
  static Future<bool> deleteUser() async {
    try {
      // var map = new Map<String, dynamic>();
      // map["action"] = _DELETE_EMP_ACTION;
      // map["emp_id"] = empId;

      // http.Response response = await http.post(Uri.parse(url), body: map);
      // var data = jsonDecode(response.body);
      // print(data.toString());
      return false;
    } catch (e) {
      return false;
    }
  }
  */
}
