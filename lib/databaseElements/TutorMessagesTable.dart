/// Code inspired by Mobile Programmer, 2019 - https://www.youtube.com/watch?v=F4Q6lEhmwCY

import 'dart:convert';
import 'package:deco3801_project/databaseElements/DBConstants.dart';
import 'package:http/http.dart' as http;

class TutorMessagesTable {
  /// Returns all records in the tutorMessages table.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['sender_id', 'receiver_id']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {message_id: value, sender_id: value, receiver_id: value, team_id: value, subgoal_id: value, message_contents: value, tutor_id: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getAllMessages(
      [List<String> columns = const ['*']]) async {
    try {
      // Create map which stores the values needed for our sql query
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ALL_ACTION;
      map["table"] = DBConstants.TUTOR_MESSAGES_TABLE;
      map["columns"] = columns.join(', ');
      map["clause"] = '';
      print(map.toString());

      // HTTP POST message sent to server and JSON is returned
      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      List<dynamic> dataList = jsonDecode(response.body);
      print(dataList);
      print("Call to HTTP");

      // Error Checking on response from web serve
      if (dataList.isEmpty || response.statusCode != 200) {
        print("error in getAllMessages");
        return [];
      }
      // Organise & output results in json style
      List<Map<String, String>> results = [];
      for (var i = 0; i < dataList.length; i++) {
        (dataList[i]['subgoal_id'] == null)
            ? dataList[i]['subgoal_id'] = DBConstants.NULL_STRING
            : true; // Trickery to avoid null error when casting responses (subgoal_id can be null)
        results.add(Map<String, String>.from(dataList[i]));
      }

      print("results: $results");
      return results;
    } catch (e) {
      print('Error');
      return [];
    }
  }

  /// Returns a record based on the passed [messageId]
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['sender_id', 'receiver_id']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {message_id: value, sender_id: value, receiver_id: value, team_id: value, subgoal_id: value, message_contents: value, tutor_id: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getSelectedMessage(String messageId,
      [List<String> columns = const ['*']]) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ONE_ACTION;
      map["table"] = DBConstants.TUTOR_MESSAGES_TABLE;
      map["columns"] = columns.join(',');
      map["clause"] = "message_id = $messageId";
      print(map.toString());

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      List<dynamic> dataList = jsonDecode(response.body);
      print("Call to HTTP");

      // Error Checking on response from web serve
      if (dataList.isEmpty || response.statusCode != 200) {
        print("error in getSelectedMessage");
        return [];
      }

      // Organise & output results in json style
      List<Map<String, String>> results = [];
      for (var i = 0; i < dataList.length; i++) {
        (dataList[i]['subgoal_id'] == null)
            ? dataList[i]['subgoal_id'] = DBConstants.NULL_STRING
            : true; // Trickery to avoid null error when casting responses (subgoal_id can be null)
        results.add(Map<String, String>.from(dataList[i]));
      }

      print("results: $results");
      return results;
    } catch (e) {
      return [];
    }
  }

  /// Returns all messages received by [userId]
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['sender_id', 'receiver_id']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {message_id: value, sender_id: value, receiver_id: value, team_id: value, subgoal_id: value, message_contents: value, tutor_id: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getReceivedMessages(String userId,
      [List<String> columns = const ['*']]) async {
    try {
      // Create map which stores the values needed for our sql query
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ONE_ACTION;
      map["table"] = DBConstants.TUTOR_MESSAGES_TABLE;
      map["columns"] = columns.join(', ');
      map["clause"] = 'receiver_id = $userId';
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
        print("error in getReceivedMessages");
        return [];
      }
      // Organise & output results in json style
      List<Map<String, String>> results = [];
      for (var i = 0; i < dataList.length; i++) {
        (dataList[i]['subgoal_id'] == null)
            ? dataList[i]['subgoal_id'] = DBConstants.NULL_STRING
            : true; // Trickery to avoid null error when casting responses (subgoal_id can be null)
        results.add(Map<String, String>.from(dataList[i]));
      }

      print("results: $results");
      return results;
    } catch (e) {
      return [];
    }
  }

  /// Returns all messages related to [teamId]
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Can be called with a list of columns to return specific columns
  ///   e.g. columns = ['sender_id', 'receiver_id']
  ///
  /// Returns a list of records in the format [{col1: value, col2: value, ...}, {col1: value, col2: value, ...}, ...]
  /// Each element of the list is a Map which representa an individual record
  ///   {message_id: value, sender_id: value, receiver_id: value, team_id: value, subgoal_id: value, message_contents: value, tutor_id: value}
  ///
  /// Returns an empty list on error
  static Future<List<Map<String, String>>> getTeamMessages(String teamId,
      [List<String> columns = const ['*']]) async {
    try {
      // Create map which stores the values needed for our sql query
      var map = Map<String, dynamic>();
      map["action"] = DBConstants.GET_ONE_ACTION;
      map["table"] = DBConstants.TUTOR_MESSAGES_TABLE;
      map["columns"] = columns.join(', ');
      map["clause"] = 'team_id = $teamId';
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
        print("error in getReceivedMessages");
        return [];
      }
      // Organise & output results in json style
      List<Map<String, String>> results = [];
      for (var i = 0; i < dataList.length; i++) {
        (dataList[i]['subgoal_id'] == null)
            ? dataList[i]['subgoal_id'] = DBConstants.NULL_STRING
            : true; // Trickery to avoid null error when casting responses (subgoal_id can be null)
        results.add(Map<String, String>.from(dataList[i]));
      }

      print("results: $results");
      return results;
    } catch (e) {
      return [];
    }
  }

  /// Adds a record into the tutorMessages table.
  ///
  /// [senderId] is the user who created the message
  /// [receiverId] is the user who the message was sent to
  /// [teamId] is the team which the message is relevant to
  /// [tutorId] is the id of the tutor involved in the message
  /// [messageString] is the contents of the message
  /// [subGoalId] is optional, will be the goall the message is relevant to if specified
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  /// All fields need to be provided except [subGoalId]. [subGoalId] should be provided when the message is related to/sent from a goal.
  ///
  /// Returns true when user added successfully, false on error      TODO: maybe return user_id?
  static Future<bool> addMessage(String senderId, String receiverId,
      String teamId, String tutorId, String messageString,
      {String subGoalId = ''}) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.ADD_ACTION;
      map["table"] = DBConstants.TUTOR_MESSAGES_TABLE;
      map["columns"] =
          '(message_id, sender_id, receiver_id, team_id, message_contents, tutor_id, subgoal_id)'; // Had to manipulate the insert to make it eaisier to work with [subGoalId]

      // Set up values for a new user in sql query
      var newValues = [senderId, receiverId, teamId, messageString, tutorId];
      if (subGoalId == '') {
        map["clause"] = "(NULL, '${newValues.join("','")}', NULL)";
      } else {
        map["clause"] = "(NULL, '${newValues.join("','")}', '$subGoalId')";
      }
      print(map);

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in addMessage");
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Updates an existing record in the tutorMessages table.
  ///
  /// To update columns, pass them as positional parameters
  ///   e.g. updateMessages('1', messageContents: 'Change message to this')
  ///
  /// [messageId] is the id of the message to be updated
  /// [messageContents] is the message to be updated
  /// -> This function has LIMITED FUNCTIONALITY. Let dev team know if more columns need to be updated.
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  /// TODO: FIX: returns true when invalid id provided
  static Future<bool> updateMessages(String messageId,
      {String messageContents = ''}) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.UPDATE_ACTION;
      map["table"] = DBConstants.TUTOR_MESSAGES_TABLE;

      // Add columns which have been specified to be changed
      map["columns"] = '';
      if (messageContents != '') {
        map["columns"] += "message_contents = '$messageContents',";
      }

      if (map["columns"] == '') {
        print("no cols chosen for update");
        return false;
      }

      //Remove trailing comma
      map["columns"] = map["columns"].substring(0, map["columns"].length - 1);

      map["clause"] = "message_id = $messageId";
      print(map);

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print("Call to HTTP: ${data.toString()}");

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in updateMessages");
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes an existing message from the tutorMessages table.
  ///
  /// [messageId] is the ID of the message
  ///
  /// Needs to be called with await to get synchronous operation (double check https://dart.dev/codelabs/async-await)
  ///
  /// Returns true when record updated successfully, false on error
  /// TODO: Returns success when invalid ids are used
  static Future<bool> deleteMessage(String messageId) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = DBConstants.DELETE_ACTION;
      map["table"] = DBConstants.TUTOR_MESSAGES_TABLE;
      map["columns"] = '';
      map["clause"] = "message_id = $messageId";

      http.Response response =
          await http.post(Uri.parse(DBConstants.url), body: map);
      var data = jsonDecode(response.body);
      print(data.toString());

      // Error Checking on response from web server
      if (data == DBConstants.ERROR_MESSAGE || response.statusCode != 200) {
        print("error in deleteMessage");
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
