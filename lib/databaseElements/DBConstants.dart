class DBConstants {
  // static const url = 'https://vegetarian-twenties.000webhostapp.com/query.php';
  static const url = 'https://deco3801-thesupersix.uqcloud.net/getData.php';
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
  static const String GOALS_COL_USER_ID = 'goal_user_id';
  static const String GOALS_COL_TEAM_ID = 'goal_team_id';

  static const String TEAMS_TABLE = 'teams';
  static const String TEAMS_COL_ID = 'team_id';
  static const String TEAMS_COL_NAME = 'team_name';
  static const String TEAMS_COL_GOAL = 'team_goal';

  static const String USERS_TABLE = 'users';
  static const String USERS_COL_USER_ID = 'user_id';
  static const String USERS_COL_USERNAME = 'username';
  static const String USERS_COL_TEAM_ID = 'team_id';
  static const String USERS_COL_TUTOR = 'tutor_status';

  static const String ERROR_MESSAGE = 'error';
  static const String SUCCESS_MESSAGE = 'success';
}
