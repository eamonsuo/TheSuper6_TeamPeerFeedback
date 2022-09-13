/// Code inspired by Mobile Programmer, 2019 - https://www.youtube.com/watch?v=F4Q6lEhmwCY

import 'dart:convert';
import 'package:deco3801_project/databaseElements/DBConstants.dart';
import 'package:http/http.dart' as http;

class FeedbackTable {
  /// Returns all records in the feedback table.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// where each Map is an individual record.
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
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// where each Map is an individual record.
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
  /// Return all feedback on given goal
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// where each Map is an individual record.
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
        if (dataList[i]['feedback_goal_id'] == goalId)
          results.add(Map<String, String>.from(dataList[i]));
      }

      print("results: $results");
      return results;
    } catch (e) {
      return [];
    }
  }
}
