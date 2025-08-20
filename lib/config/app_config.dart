class AppConfig {
  // App Information
  static const String appName = 'TaskFlow';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Application de gestion de tâches cross-platform';
  
  // Database Configuration
  static const String taskBoxName = 'tasks';
  static const String projectBoxName = 'projects';
  static const String settingsBoxName = 'settings';
  
  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 2.0;
  
  // Task Configuration
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxTagsPerTask = 10;
  static const int maxTagLength = 20;
  
  // Project Configuration
  static const int maxProjectNameLength = 50;
  static const int maxProjectDescriptionLength = 200;
  
  // Time Configuration
  static const int maxTimeSpent = 9999; // minutes
  static const int defaultTaskDuration = 30; // minutes
  
  // Search Configuration
  static const int minSearchQueryLength = 2;
  static const int maxSearchResults = 100;
  
  // Sync Configuration
  static const int syncIntervalMinutes = 5;
  static const int maxRetryAttempts = 3;
  
  // Colors
  static const List<String> projectColors = [
    '#2196F3', // Blue
    '#4CAF50', // Green
    '#FF9800', // Orange
    '#F44336', // Red
    '#9C27B0', // Purple
    '#00BCD4', // Cyan
    '#FF5722', // Deep Orange
    '#795548', // Brown
    '#607D8B', // Blue Grey
    '#E91E63', // Pink
  ];
  
  // Default Categories
  static const List<String> defaultCategories = [
    'Travail',
    'Personnel',
    'Études',
    'Santé',
    'Finance',
    'Maison',
    'Loisirs',
    'Voyage',
  ];
  
  // Default Tags
  static const List<String> defaultTags = [
    'urgent',
    'important',
    'réunion',
    'développement',
    'design',
    'marketing',
    'vente',
    'support',
  ];
  
  // Validation Messages
  static const String titleRequired = 'Le titre est requis';
  static const String titleTooLong = 'Le titre est trop long (max $maxTitleLength caractères)';
  static const String descriptionTooLong = 'La description est trop longue (max $maxDescriptionLength caractères)';
  static const String projectNameRequired = 'Le nom du projet est requis';
  static const String projectNameTooLong = 'Le nom du projet est trop long (max $maxProjectNameLength caractères)';
  
  // Success Messages
  static const String taskCreated = 'Tâche créée avec succès !';
  static const String taskUpdated = 'Tâche mise à jour avec succès !';
  static const String taskDeleted = 'Tâche supprimée avec succès !';
  static const String projectCreated = 'Projet créé avec succès !';
  static const String projectUpdated = 'Projet mis à jour avec succès !';
  static const String projectDeleted = 'Projet supprimé avec succès !';
  
  // Error Messages
  static const String generalError = 'Une erreur est survenue';
  static const String networkError = 'Erreur de connexion réseau';
  static const String syncError = 'Erreur de synchronisation';
  static const String saveError = 'Erreur lors de la sauvegarde';
  static const String loadError = 'Erreur lors du chargement';
  
  // Confirmation Messages
  static const String deleteTaskConfirmation = 'Êtes-vous sûr de vouloir supprimer cette tâche ?';
  static const String deleteProjectConfirmation = 'Êtes-vous sûr de vouloir supprimer ce projet ? Toutes les tâches associées seront également supprimées.';
  static const String clearFiltersConfirmation = 'Êtes-vous sûr de vouloir effacer tous les filtres ?';
  
  // Empty State Messages
  static const String noTasksMessage = 'Aucune tâche pour le moment';
  static const String noProjectsMessage = 'Aucun projet pour le moment';
  static const String noSearchResultsMessage = 'Aucune tâche trouvée';
  static const String noRecentActivityMessage = 'Aucune activité récente';
  
  // Hints
  static const String taskTitleHint = 'Entrez le titre de la tâche';
  static const String taskDescriptionHint = 'Description optionnelle de la tâche';
  static const String taskCategoryHint = 'ex: Travail, Personnel';
  static const String taskTagsHint = 'ex: urgent, réunion, développement (séparés par des virgules)';
  static const String projectNameHint = 'Entrez le nom du projet';
  static const String projectDescriptionHint = 'Description optionnelle du projet';
  static const String searchHint = 'Rechercher une tâche...';
}
