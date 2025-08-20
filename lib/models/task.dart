import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? dueDate;

  @HiveField(6)
  Priority priority;

  @HiveField(7)
  String? category;

  @HiveField(8)
  List<String> tags;

  @HiveField(9)
  int timeSpent; // in minutes

  @HiveField(10)
  DateTime? lastModified;

  @HiveField(11)
  String? projectId;

  @HiveField(12)
  bool isSynced;

  Task({
    String? id,
    required this.title,
    this.description,
    this.isCompleted = false,
    DateTime? createdAt,
    this.dueDate,
    this.priority = Priority.medium,
    this.category,
    List<String>? tags,
    this.timeSpent = 0,
    DateTime ? lastModified,
    this.projectId,
    this.isSynced = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        tags = tags ?? [],
        lastModified = lastModified ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    Priority? priority,
    String? category,
    List<String>? tags,
    int? timeSpent,
    DateTime? lastModified,
    String? projectId,
    bool? isSynced,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      timeSpent: timeSpent ?? this.timeSpent,
      lastModified: lastModified ?? this.lastModified,
      projectId: projectId ?? this.projectId,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.index,
      'category': category,
      'tags': tags,
      'timeSpent': timeSpent,
      'lastModified': lastModified?.toIso8601String(),
      'projectId': projectId,
      'isSynced': isSynced,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      priority: Priority.values[json['priority'] ?? 1],
      category: json['category'],
      tags: List<String>.from(json['tags'] ?? []),
      timeSpent: json['timeSpent'] ?? 0,
      lastModified: json['lastModified'] != null ? DateTime.parse(json['lastModified']) : null,
      projectId: json['projectId'],
      isSynced: json['isSynced'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, isCompleted: $isCompleted)';
  }
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
  @HiveField(3)
  urgent,
}

extension PriorityExtension on Priority {
  String get displayName {
    switch (this) {
      case Priority.low:
        return 'Faible';
      case Priority.medium:
        return 'Moyenne';
      case Priority.high:
        return 'Élevée';
      case Priority.urgent:
        return 'Urgente';
    }
  }

  int get value {
    switch (this) {
      case Priority.low:
        return 1;
      case Priority.medium:
        return 2;
      case Priority.high:
        return 3;
      case Priority.urgent:
        return 4;
    }
  }
}
