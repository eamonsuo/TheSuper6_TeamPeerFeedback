/// Code inspired by Mobile Programmer, 2019 - https://www.youtube.com/watch?v=F4Q6lEhmwCY

import 'dart:convert';
import 'package:http/http.dart' as http;

class Database {
  static const url = 'https://vegetarian-twenties.000webhostapp.com/query.php';
  static const String _GET_ALL_ACTION = 'GET_ALL';
  static const String _GET_ONE_ACTION = 'GET_SELECTION';
  static const String _ADD_ACTION = 'ADD_RECORD';
  static const String _UPDATE_ACTION = 'UPDATE_RECORD';
  static const String _DELETE_ACTION = 'DELETE_RECORD';

  static const String _USERS_TABLE = 'users';
  static const String _ERROR_MESSAGE = 'error';

  /// Returns all records in the users table.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// where each Map is an individual record.
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getAllUsers(
      [List<String> columns = const ['*']]) async {
    try {
      // Create map which stores the values needed for our sql query
      var map = Map<String, dynamic>();
      map["action"] = _GET_ALL_ACTION;
      map["table"] = _USERS_TABLE;
      map["columns"] = columns.join(', ');
      map["clause"] = '';
      print(map.toString());

      // HTTP POST message sent to server and JSON is returned
      http.Response response = await http.post(Uri.parse(url), body: map);
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

//TODO: Work to do on this....
  static Future<List<String>> getSelectedUser(String id,
      [List<String> columns = const ['*']]) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = _GET_ONE_ACTION;
      map["table"] = _USERS_TABLE;
      map["columns"] = columns.join(',');
      map["clause"] = id;
      print(map.toString());

      http.Response response = await http.post(Uri.parse(url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking...

    } catch (e) {
      // return List<Employee>();
    }
    return [];
  }

  /// Adds a record into the users table.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  /// All fields need to be provided, a user_id is automatically generated
  ///
  /// Returns a ... (int: user_id?)
  static Future<bool> addUser(
      String username, String teamId, bool tutorStatus) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _ADD_ACTION;
      map["table"] = _USERS_TABLE;
      map["columns"] = '(user_id, username, team_id, tutor_status)';

      // Set up new values for sql query
      var tutorInput = '';
      (tutorStatus) ? tutorInput = '1' : tutorInput = '0';
      var newValues = [username, teamId, tutorInput];
      map["clause"] = "(NULL,'${newValues.join("','")}')";
      print(map);

      http.Response response = await http.post(Uri.parse(url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking on response from web server
      if (data == _ERROR_MESSAGE || response.statusCode != 200) {
        print("error in addUser");
        return false;
      }

      //TODO: More error checking, Check when invalid message is returned
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
  /// Returns a ... (int: user_id?)
  static Future<bool> updateUser(String userId,
      {String username = '',
      String teamId = '',
      String tutorStatus = ''}) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _UPDATE_ACTION;
      map["table"] = _USERS_TABLE;

      // Add columns which are specified to be changed
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
        return false; // TODO: What should I return when nothing passed??
      }
      map["columns"] = map["columns"]
          .substring(0, map["columns"].length - 1); //Remove trailing comma

      map["clause"] = "user_id = $userId";
      print(map);

      http.Response response = await http.post(Uri.parse(url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking on response from web server
      if (data == _ERROR_MESSAGE || response.statusCode != 200) {
        print("error in updateUser");
        return false;
      }

      //TODO: returns true when invalid id provided
      return true;
    } catch (e) {
      return false;
    }
  }

  //TODO: Implement?
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
}
