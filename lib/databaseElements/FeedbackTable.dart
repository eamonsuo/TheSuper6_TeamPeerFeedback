/// Code inspired by Mobile Programmer, 2019 - https://www.youtube.com/watch?v=F4Q6lEhmwCY

import 'dart:convert';
import 'package:deco3801_project/databaseElements/DBConstants.dart';
import 'package:http/http.dart' as http;

class FeedbackTable {
  /// Returns all records in the feedback table.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['feedback_id', 'feedback_contents']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {feedback_id: value, feedback_user_id: value, feedback_goal_id: value, feedback_contents: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getAllFeedback(
      [List<String> columns = const ['*']]) async {
    try {
      // Create map which stores the values needed for our sql query
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ALL_ACTION;
      map["table"] = DBConstants.FEEDBACK_TABLE;
      map["columns"] = columns.join(', ');
      map["clause"] = '';
      print(map.toString());

      // HTTP POST message sent to server and JSON is returned
      print('Start');
      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      print(response);
      List<dynamic> dataList = jsonDecode(response.body);
      //print(dataList);
      //print("Call to HTTP");

      // Error Checking on response from web serve
      if (dataList.isEmpty || response.statusCode != 200) {
        print("error in getAllFeedback");
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

  /// Returns records based on the passed [feedbackId]
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['feedback_id', 'feedback_contents']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {feedback_id: value, feedback_user_id: value, feedback_goal_id: value, feedback_contents: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getSelectedFeedback(
      String feedbackId,
      [List<String> columns = const ['*']]) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ONE_ACTION;
      map["table"] = DBConstants.FEEDBACK_TABLE;
      map["columns"] = columns.join(',');
      map["clause"] = "feedback_id = $feedbackId";
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

  /// Returns records based on the passed [goalId]
  /// Returns all feedback stored on a given goal
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['feedback_id', 'feedback_contents']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {feedback_id: value, feedback_user_id: value, feedback_goal_id: value, feedback_contents: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getGoalFeedback(String goalId,
      [List<String> columns = const ['*']]) async {
    try {
      // Create map which stores the values needed for our sql query
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ALL_ACTION;
      map["table"] = DBConstants.FEEDBACK_TABLE;
      map["columns"] = columns.join(', ');
      map["clause"] = '';
      print(map.toString());

      // HTTP POST message sent to server and JSON is returned
      // print('Start');
      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      // print(response);
      List<dynamic> dataList = jsonDecode(response.body);
      // print(dataList);
      print("Call to HTTP");

      // Error Checking on response from web serve
      if (dataList.isEmpty || response.statusCode != 200) {
        print("error in getAllFeedback");
        return [];
      }
      // Organise & output results in json style
      List<Map<String, String>> results = [];
      for (var i = 0; i < dataList.length; i++) {
        if (dataList[i]['feedback_goal_id'] == goalId)
          results.add(Map<String, String>.from(dataList[i]));
        // print(dataList[i]['feedback_goal_id']);
        // print(dataList[i]['feedback_goal_id'].runtimeType);
      }

      print("results: $results");
      return results;
    } catch (e) {
      return [];
    }
  }

  /// Adds a record into the feedback table.
  ///
  /// [userId] is the user who created the feedback
  /// [goalId] is the goal the feedback belongs to
  /// [feedbackString] can only be 200 characters long
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  /// All fields need to be provided, a feedback_id is automatically generated
  ///
  /// Returns true when user added successfully, false on error      TODO: maybe return user_id?
  static Future<bool> addFeedback(
      String userId, String goalId, String feedbackString) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.FEEDBACK_TABLE;
      map["columns"] =
          '(feedback_id, feedback_user_id, feedback_goal_id, feedback_contents)';

      // Set up values for a new user in sql query
      var newValues = [userId, goalId, feedbackString];
      map["clause"] = "(NULL,'${newValues.join("','")}')";
      print(map);

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in addFeedback");
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Updates an existing record in the feedback table.
  ///
  /// To update columns, pass them as positional parameters
  ///   e.g. updateFeedback('1', feedbackString: 'Change feedback to this')
  ///
  /// [userId] is the user who created the feedback TODO: REMOVE??
  /// [goalId] is the goal the feedback belongs to TODO: REMOVE??
  /// [feedbackString] can only be 200 characters long
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  /// TODO: FIX: returns true when invalid id provided
  static Future<bool> updateFeedback(String feedbackId,
      {String userId = '',
      String goalId = '',
      String feedbackString = ''}) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.UPDATE_ACTION;
      map["table"] = DBConstants.FEEDBACK_TABLE;

      // Add columns which have been specified to be changed
      map["columns"] = '';
      if (userId != '') {
        map["columns"] += "feedback_user_id = '$userId',";
      }
      if (goalId != '') {
        map["columns"] += "feedback_goal_id = '$goalId',";
      }
      if (feedbackString != '') {
        map["columns"] += "feedback_contents = "
            '"$feedbackString",'; // Can't be over 200 characters, also some fancy footwork to allow apostrophese
      }
      if (map["columns"] == '') {
        print("no cols chosen for update");
        return false;
      }

      //Remove trailing comma
      map["columns"] = map["columns"].substring(0, map["columns"].length - 1);

      map["clause"] = "feedback_id = $feedbackId";
      print(map);

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in updateFeedback");
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
