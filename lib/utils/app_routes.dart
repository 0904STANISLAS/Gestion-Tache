class AppRoutes {
  // Main routes
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String tasks = '/tasks';
  static const String projects = '/projects';
  static const String statistics = '/statistics';
  
  // Task routes
  static const String taskList = '/tasks/list';
  static const String taskDetail = '/tasks/detail';
  static const String taskEdit = '/tasks/edit';
  static const String taskCreate = '/tasks/create';
  
  // Project routes
  static const String projectList = '/projects/list';
  static const String projectDetail = '/projects/detail';
  static const String projectEdit = '/projects/edit';
  static const String projectCreate = '/projects/create';
  
  // Settings routes
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String preferences = '/preferences';
  static const String about = '/about';
  
  // Utility routes
  static const String search = '/search';
  static const String filters = '/filters';
  static const String export = '/export';
  static const String import = '/import';
  
  // Auth routes (for future use)
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  
  // Helper method to build routes with parameters
  static String taskDetailRoute(String taskId) => '$taskDetail/$taskId';
  static String taskEditRoute(String taskId) => '$taskEdit/$taskId';
  static String projectDetailRoute(String projectId) => '$projectDetail/$projectId';
  static String projectEditRoute(String projectId) => '$projectEdit/$projectId';
}
