class DBConstants {
  static const url = 'https://deco3801-thesupersix.uqcloud.net/query.php';

  static const String GET_ALL_ACTION = 'GET_ALL';
  static const String GET_ONE_ACTION = 'GET_SELECTION';
  static const String ADD_ACTION = 'ADD_RECORD';
  static const String UPDATE_ACTION = 'UPDATE_RECORD';
  static const String DELETE_ACTION = 'DELETE_RECORD';

  static const String FEEDBACK_TABLE = 'feedback';
  static const String FEEDBACK_COL_FEEDBACK_ID = 'feedback_id';
  static const String FEEDBACK_COL_USER_ID = 'feedback_user_id';
  static const String FEEDBACK_COL_GOAL_ID = 'feedback_goal_id';
  static const String FEEDBACK_COL_CONTENTS = 'feedback_contents';

  static const String GOALS_TABLE = 'goals';
  static const String GOALS_COL_GOAL_ID = 'goal_id';
  static const String GOALS_COL_DESCRIPTION = 'goal_desc';
  static const String GOALS_COL_PROGRESS = 'goal_progress';
  static const String GOALS_COL_STARTTIME = 'goal_starttime';
  static const String GOALS_COL_DEADLINE = 'goal_deadline';

  static const String SUB_GOALS_TABLE = 'subGoals';
  static const String SUB_GOALS_COL_SUBGOAL_ID = 'user_goal';
  static const String SUB_GOALS_COL_TEAM_GOAL_ID = 'team_goal';

  static const String TEAM_GOALS_TABLE = 'teamGoals';
  static const String TG_COL_TEAM_ID = 'team_id';
  static const String TG_COL_GOAL_ID = 'goal_id';

  static const String TEAMS_TABLE = 'teams';
  static const String TEAMS_COL_ID = 'team_id';
  static const String TEAMS_COL_NAME = 'team_name';

  static const String TUTOR_MESSAGES_TABLE = 'tutorMessages';
  static const String TUTOR_MESSAGES_COL_MESSAGE_ID = 'message_id';
  static const String TUTOR_MESSAGES_COL_SENDER_ID = 'sender_id';
  static const String TUTOR_MESSAGES_COL_RECEIVER_ID = 'receiver_id';
  static const String TUTOR_MESSAGES_COL_TEAM_ID = 'team_id';
  static const String TUTOR_MESSAGES_COL_SUBGOAL_ID = 'subgoal_id';
  static const String TUTOR_MESSAGES_COL_CONTENTS = 'message_contents';
  static const String TUTOR_MESSAGES_COL_TUTOR_ID = 'tutor_id';

  static const String USER_GOALS_TABLE = 'userGoals';
  static const String USER_GOALS_COL_USER_ID = 'user_id';
  static const String USER_GOALS_COL_GOAL_ID = 'goal_id';

  static const String USERS_TABLE = 'users';
  static const String USERS_COL_USER_ID = 'user_id';
  static const String USERS_COL_USERNAME = 'username';
  static const String USERS_COL_TUTOR = 'tutor_status';

  static const String USERS_IN_TEAM_TABLE = 'usersInTeams';
  static const String UIT_COL_TEAM_ID = 'team_id';
  static const String UIT_COL_USER_ID = 'user_id';

  static const String ERROR_MESSAGE = 'error';
  static const String SUCCESS_MESSAGE = 'success';
  static const String NULL_STRING = 'NULL';
}
