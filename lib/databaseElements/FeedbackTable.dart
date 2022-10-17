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
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, ...]
  ///
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

  /// Returns records based on the passed [feedbackId]
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['feedback_id', 'feedback_contents']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, ...]
  ///
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

  /// Returns records based on the passed [goalId].
  /// Returns all feedback given on a specified goal.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['feedback_id', 'feedback_contents']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, ...]
  ///
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
        if (dataList[i]['feedback_goal_id'] == goalId) {
          results.add(Map<String, String>.from(dataList[i]));
        }
      }

      return results;
    } catch (e) {
      return [];
    }
  }

  /// Adds a record into the feedback table.
  ///
  /// All fields need to be provided, a feedback_id is automatically generated
  ///
  /// [userId] is the user who created the feedback.
  /// [goalId] is the goal the feedback belongs to.
  /// [feedbackString] can only be 200 characters long.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when user added successfully, false on error
  static Future<bool> addFeedback(
      String userId, String goalId, String feedbackString) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.FEEDBACK_TABLE;
      map["columns"] =
          '(feedback_id, feedback_user_id, feedback_goal_id, feedback_contents)';

      // Set up values for a new user in sql query
      var newValues = [userId, goalId, feedbackString];
      map["clause"] = "(NULL,'${newValues.join("','")}')";

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

  /// Updates an existing record in the feedback table.
  ///
  /// To update columns, pass them as positional parameters
  ///   e.g. updateFeedback('1', feedbackString: 'Change feedback to this')
  ///
  /// [userId] is the user who created the feedback.
  /// [goalId] is the goal the feedback belongs to.
  /// [feedbackString] can only be 200 characters long.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  static Future<bool> updateFeedback(String feedbackId,
      {String userId = '',
      String goalId = '',
      String feedbackString = ''}) async {
    try {
      var map = Map<String, dynamic>();
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
            '"$feedbackString",'; // Can't be over 200 characters, allows single apostrophese
      }
      if (map["columns"] == '') {
        return false;
      }

      //Remove trailing comma
      map["columns"] = map["columns"].substring(0, map["columns"].length - 1);

      map["clause"] = "feedback_id = $feedbackId";

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

  /// Deletes an existing record from the feedback table.
  ///
  /// [feedbackId] is the ID of the feedback
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  static Future<bool> deleteFeedback(String feedbackId) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.DELETE_ACTION;
      map["table"] = DBConstants.FEEDBACK_TABLE;
      map["columns"] = '';
      map["clause"] = "feedback_id = $feedbackId";

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
}
