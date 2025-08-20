import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/project.dart';

class TaskService {
  static const String _taskBoxName = 'tasks';
  static const String _projectBoxName = 'projects';
  static const String _lastSyncKey = 'last_sync';

  late Box<Task> _taskBox;
  late Box<Project> _projectBox;
  late SharedPreferences _prefs;

  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    
    if (!Hive.isBoxOpen(_taskBoxName)) {
      _taskBox = await Hive.openBox<Task>(_taskBoxName);
    } else {
      _taskBox = Hive.box<Task>(_taskBoxName);
    }

    if (!Hive.isBoxOpen(_projectBoxName)) {
      _projectBox = await Hive.openBox<Project>(_projectBoxName);
    } else {
      _projectBox = Hive.box<Project>(_projectBoxName);
    }
  }

  // Task operations
  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    final updatedTask = task.copyWith(
      lastModified: DateTime.now(),
      isSynced: false,
    );
    await _taskBox.put(task.id, updatedTask);
  }

  Future<void> deleteTask(String taskId) async {
    await _taskBox.delete(taskId);
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final task = _taskBox.get(taskId);
    if (task != null) {
      final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
        lastModified: DateTime.now(),
        isSynced: false,
      );
      await _taskBox.put(taskId, updatedTask);
    }
  }

  Future<void> updateTaskTime(String taskId, int additionalMinutes) async {
    final task = _taskBox.get(taskId);
    if (task != null) {
      final updatedTask = task.copyWith(
        timeSpent: task.timeSpent + additionalMinutes,
        lastModified: DateTime.now(),
        isSynced: false,
      );
      await _taskBox.put(taskId, updatedTask);
    }
  }

  Task? getTask(String taskId) {
    return _taskBox.get(taskId);
  }

  List<Task> getAllTasks() {
    return _taskBox.values.toList();
  }

  List<Task> getTasksByProject(String projectId) {
    return _taskBox.values.where((task) => task.projectId == projectId).toList();
  }

  List<Task> getTasksByCategory(String category) {
    return _taskBox.values.where((task) => task.category == category).toList();
  }

  List<Task> getTasksByPriority(Priority priority) {
    return _taskBox.values.where((task) => task.priority == priority).toList();
  }

  List<Task> getPendingTasks() {
    return _taskBox.values.where((task) => !task.isCompleted).toList();
  }

  List<Task> getCompletedTasks() {
    return _taskBox.values.where((task) => task.isCompleted).toList();
  }

  List<Task> getOverdueTasks() {
    final now = DateTime.now();
    return _taskBox.values
        .where((task) => 
            !task.isCompleted && 
            task.dueDate != null && 
            task.dueDate!.isBefore(now))
        .toList();
  }

  List<Task> getTasksDueToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return _taskBox.values
        .where((task) => 
            !task.isCompleted && 
            task.dueDate != null && 
            task.dueDate!.isAfter(today) && 
            task.dueDate!.isBefore(tomorrow))
        .toList();
  }

  // Project operations
  Future<void> addProject(Project project) async {
    await _projectBox.put(project.id, project);
  }

  Future<void> updateProject(Project project) async {
    final updatedProject = project.copyWith(
      lastModified: DateTime.now(),
      isSynced: false,
    );
    await _projectBox.put(project.id, updatedProject);
  }

  Future<void> deleteProject(String projectId) async {
    // Delete all tasks in the project first
    final tasksToDelete = _taskBox.values
        .where((task) => task.projectId == projectId)
        .map((task) => task.id)
        .toList();
    
    for (final taskId in tasksToDelete) {
      await _taskBox.delete(taskId);
    }
    
    await _projectBox.delete(projectId);
  }

  Project? getProject(String projectId) {
    return _projectBox.get(projectId);
  }

  List<Project> getAllProjects() {
    return _projectBox.values.toList();
  }

  List<Project> getActiveProjects() {
    return _projectBox.values.where((project) => !project.isArchived).toList();
  }

  // Search operations
  List<Task> searchTasks(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _taskBox.values
        .where((task) => 
            task.title.toLowerCase().contains(lowercaseQuery) ||
            (task.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            task.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)))
        .toList();
  }

  // Statistics
  Map<String, dynamic> getTaskStatistics() {
    final allTasks = getAllTasks();
    final completedTasks = getCompletedTasks();
    final pendingTasks = getPendingTasks();
    final overdueTasks = getOverdueTasks();
    
    final totalTimeSpent = allTasks.fold<int>(0, (sum, task) => sum + task.timeSpent);
    
    return {
      'totalTasks': allTasks.length,
      'completedTasks': completedTasks.length,
      'pendingTasks': pendingTasks.length,
      'overdueTasks': overdueTasks.length,
      'completionRate': allTasks.isEmpty ? 0.0 : (completedTasks.length / allTasks.length) * 100,
      'totalTimeSpent': totalTimeSpent,
      'averageTimePerTask': allTasks.isEmpty ? 0.0 : totalTimeSpent / allTasks.length,
    };
  }

  // Sync operations
  Future<DateTime?> getLastSyncTime() async {
    final timestamp = _prefs.getInt(_lastSyncKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> setLastSyncTime(DateTime time) async {
    await _prefs.setInt(_lastSyncKey, time.millisecondsSinceEpoch);
  }

  List<Task> getUnsyncedTasks() {
    return _taskBox.values.where((task) => !task.isSynced).toList();
  }

  List<Project> getUnsyncedProjects() {
    return _projectBox.values.where((project) => !project.isSynced).toList();
  }

  Future<void> markTaskAsSynced(String taskId) async {
    final task = _taskBox.get(taskId);
    if (task != null) {
      final updatedTask = task.copyWith(isSynced: true);
      await _taskBox.put(taskId, updatedTask);
    }
  }

  Future<void> markProjectAsSynced(String projectId) async {
    final project = _projectBox.get(projectId);
    if (project != null) {
      final updatedProject = project.copyWith(isSynced: true);
      await _projectBox.put(projectId, updatedProject);
    }
  }

  // Export/Import
  Future<String> exportData() async {
    final data = {
      'tasks': getAllTasks().map((task) => task.toJson()).toList(),
      'projects': getAllProjects().map((project) => project.toJson()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
    };
    return jsonEncode(data);
  }

  Future<void> importData(String jsonData) async {
    final data = jsonDecode(jsonData) as Map<String, dynamic>;
    
    // Clear existing data
    await _taskBox.clear();
    await _projectBox.clear();
    
    // Import projects first
    final projects = (data['projects'] as List)
        .map((json) => Project.fromJson(json))
        .toList();
    
    for (final project in projects) {
      await addProject(project);
    }
    
    // Import tasks
    final tasks = (data['tasks'] as List)
        .map((json) => Task.fromJson(json))
        .toList();
    
    for (final task in tasks) {
      await addTask(task);
    }
  }

  // Cleanup
  Future<void> close() async {
    await _taskBox.close();
    await _projectBox.close();
  }
}
