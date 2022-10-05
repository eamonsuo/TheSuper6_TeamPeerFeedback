import 'dart:math';
import 'package:deco3801_project/databaseElements/GoalsTable.dart';
import 'package:deco3801_project/databaseElements/TutorMessagesTable.dart';

class HealthScore {
  /// Calculates the health score of a team based on certain properties
  ///
  /// The health score is currently based on how much progress has been made on
  /// completing goals (weighted at 70%) and how many messages have been sent to
  /// a tutor (weighted at 30%).
  ///
  /// Returns an integer between 0 and 100 indicating the health score
  static Future<int> getHealthScore(String teamId) async {
    // Get information of each team goal
    List<Map<String, String>> goalInfo =
        await GoalsTable.getTeamGoalInfo(teamId);

    // Get goal health (progress on goals vs time used)
    int goalHealth = _calculateGoalHealth(goalInfo);
    print("Goal Health: $goalHealth");

    // Get messages sent to a tutor by the team
    List<Map<String, String>> messageResults =
        await TutorMessagesTable.getTeamMessages(teamId);

    // Get tutor health (number of messages sent to tutor)
    int tutorHealth = _calculateTutorHealth(messageResults);

    // Weight of each factor can be altered
    int health = min((goalHealth * 0.7) + (tutorHealth * 0.3), 100).ceil();
    print(health);
    return max(health, 0);
  }

  /// This is an internal function which is used to calculate the health score
  ///   of the goal progress
  ///
  /// Returns and integer between 0 and 100
  static int _calculateGoalHealth(List<Map<String, String>> goalsInfo) {
    // print(5 ~/ 3);
    // print("CALCULATE GOALS: $goalsInfo");
    double goalHealth = 100;
    double individualGoalWeight =
        goalHealth / goalsInfo.length; //Effect of goals weighted evenly
    DateTime currentDate = DateTime.now();

    for (int i = 0; i < goalsInfo.length; i++) {
      List<String> goalStart = goalsInfo[i]["goal_starttime"]!.split('-');
      List<String> goalEnd = goalsInfo[i]["goal_deadline"]!.split('-');
      int goalProgress = int.parse(goalsInfo[i]["goal_progress"]!);

      //TODO Remove this condition, just to stop errors during testing
      if (goalStart.length != 3) {
        continue;
      }

      DateTime startDate = DateTime(int.parse("20${goalStart[2]}"),
          int.parse(goalStart[1]), int.parse(goalStart[0]));
      DateTime endDate = DateTime(int.parse("20${goalEnd[2]}"),
          int.parse(goalEnd[1]), int.parse(goalEnd[0]));

      int goalDuration = endDate.difference(startDate).inDays;
      int timeUsed = currentDate.difference(startDate).inDays;
      int timeRemaining = endDate.difference(currentDate).inDays;

      print(
          "duration: $goalDuration,  time used: $timeUsed,  remaining: $timeRemaining");

      double percentPerDay = 100 / goalDuration;

      // percentPerDay * timeUsed is how much progress should be made (linear completion)
      if ((goalProgress * 2) < percentPerDay * timeUsed) {
        // More than half behind suggested progress
        goalHealth -= individualGoalWeight;
      } else if (goalProgress < percentPerDay * timeUsed) {
        // Behind suggested progress
        goalHealth -= (individualGoalWeight / 2);
      } else {
        // On target/ahead of suggested progress
        goalHealth -= 0;
      }
    }

    return goalHealth.ceil();
  }

  /// This is an internal function which is used to calculate the health score
  ///   based on messages sent to a tutor
  ///
  /// Returns and integer between 0 and 100
  static int _calculateTutorHealth(List<Map<String, String>> messageInfo) {
    int tutorHealth = 100;

    // Count messages sent to tutor
    int tutorMessages = 0;
    for (int i = 0; i < messageInfo.length; i++) {
      if (messageInfo[i]["receiver_id"] == messageInfo[i]["tutor_id"]) {
        tutorMessages++;
      }
    }

    if (tutorMessages > 20) {
      tutorHealth -= 100;
    } else if (tutorMessages > 15) {
      tutorHealth -= 75;
    } else if (tutorMessages > 10) {
      tutorHealth -= 50;
    } else if (tutorMessages > 5) {
      tutorHealth -= 25;
    } else {
      tutorHealth -= 0;
    }

    return tutorHealth;
  }
}
