import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../models/project.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  
  List<Task> _tasks = [];
  List<Project> _projects = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedProjectId;
  String? _selectedCategory;
  Priority? _selectedPriority;
  bool _showCompleted = true;

  // Getters
  List<Task> get tasks => _tasks;
  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedProjectId => _selectedProjectId;
  String? get selectedCategory => _selectedCategory;
  Priority? get selectedPriority => _selectedPriority;
  bool get showCompleted => _showCompleted;

  // Filtered tasks
  List<Task> get filteredTasks {
    List<Task> filtered = _tasks;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) =>
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (task.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          task.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()))).toList();
    }

    // Filter by project
    if (_selectedProjectId != null) {
      filtered = filtered.where((task) => task.projectId == _selectedProjectId).toList();
    }

    // Filter by category
    if (_selectedCategory != null) {
      filtered = filtered.where((task) => task.category == _selectedCategory).toList();
    }

    // Filter by priority
    if (_selectedPriority != null) {
      filtered = filtered.where((task) => task.priority == _selectedPriority).toList();
    }

    // Filter by completion status
    if (!_showCompleted) {
      filtered = filtered.where((task) => !task.isCompleted).toList();
    }

    return filtered;
  }

  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get overdueTasks => _tasks.where((task) =>
      !task.isCompleted && task.dueDate != null && task.dueDate!.isBefore(DateTime.now())).toList();
  List<Task> get tasksDueToday => _tasks.where((task) {
      if (task.isCompleted || task.dueDate == null) return false;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      return task.dueDate!.isAfter(today) && task.dueDate!.isBefore(tomorrow);
  }).toList();

  List<Project> get activeProjects => _projects.where((project) => !project.isArchived).toList();

  // Initialize
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _taskService.initialize();
      await _loadData();
    } catch (e) {
      debugPrint('Error initializing TaskProvider: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load data
  Future<void> _loadData() async {
    _tasks = _taskService.getAllTasks();
    _projects = _taskService.getAllProjects();
    notifyListeners();
  }

  // Task operations
  Future<void> addTask(Task task) async {
    try {
      await _taskService.addTask(task);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _taskService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting task: $e');
      rethrow;
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      await _taskService.toggleTaskCompletion(taskId);
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(
          isCompleted: !_tasks[index].isCompleted,
          lastModified: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling task completion: $e');
      rethrow;
    }
  }

  Future<void> updateTaskTime(String taskId, int additionalMinutes) async {
    try {
      await _taskService.updateTaskTime(taskId, additionalMinutes);
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(
          timeSpent: _tasks[index].timeSpent + additionalMinutes,
          lastModified: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating task time: $e');
      rethrow;
    }
  }

  // Project operations
  Future<void> addProject(Project project) async {
    try {
      await _taskService.addProject(project);
      _projects.add(project);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding project: $e');
      rethrow;
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      await _taskService.updateProject(project);
      final index = _projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        _projects[index] = project;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating project: $e');
      rethrow;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _taskService.deleteProject(projectId);
      _projects.removeWhere((project) => project.id == projectId);
      _tasks.removeWhere((task) => task.projectId == projectId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting project: $e');
      rethrow;
    }
  }

  // Filter operations
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedProject(String? projectId) {
    _selectedProjectId = projectId;
    notifyListeners();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedPriority(Priority? priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void toggleShowCompleted() {
    _showCompleted = !_showCompleted;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedProjectId = null;
    _selectedCategory = null;
    _selectedPriority = null;
    notifyListeners();
  }

  // Statistics
  Map<String, dynamic> getStatistics() {
    return _taskService.getTaskStatistics();
  }

  // Categories
  List<String> get availableCategories {
    final categories = _tasks
        .where((task) => task.category != null)
        .map((task) => task.category!)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  // Tags
  List<String> get availableTags {
    final tags = <String>{};
    for (final task in _tasks) {
      tags.addAll(task.tags);
    }
    final sortedTags = tags.toList();
    sortedTags.sort();
    return sortedTags;
  }
  List<Task> getTasksByProject(String projectId) {
    return _tasks.where((task) => task.projectId == projectId).toList();
  }

  // Refresh data
  Future<void> refresh() async {
    await _loadData();
  }

  // Export/Import
  Future<String> exportData() async {
    return await _taskService.exportData();
  }

  Future<void> importData(String jsonData) async {
    try {
      await _taskService.importData(jsonData);
      await _loadData();
    } catch (e) {
      debugPrint('Error importing data: $e');
      rethrow;
    }
  }

  // Utility methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Task? getTaskById(String taskId) {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  Project? getProjectById(String projectId) {
    try {
      return _projects.firstWhere((project) => project.id == projectId);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _taskService.close();
    super.dispose();
  }
}
