import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'project.g.dart';

@HiveType(typeId: 2)
class Project extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String color;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? dueDate;

  @HiveField(6)
  bool isArchived;

  @HiveField(7)
  DateTime? lastModified;

  @HiveField(8)
  bool isSynced;

  Project({
    String? id,
    required this.name,
    this.description,
    this.color = '#2196F3',
    DateTime? createdAt,
    this.dueDate,
    this.isArchived = false,
    DateTime? lastModified,
    this.isSynced = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? color,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? isArchived,
    DateTime? lastModified,
    bool? isSynced,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      isArchived: isArchived ?? this.isArchived,
      lastModified: lastModified ?? this.lastModified,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'isArchived': isArchived,
      'lastModified': lastModified?.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      color: json['color'] ?? '#2196F3',
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      isArchived: json['isArchived'] ?? false,
      lastModified: json['lastModified'] != null ? DateTime.parse(json['lastModified']) : null,
      isSynced: json['isSynced'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Project(id: $id, name: $name, isArchived: $isArchived)';
  }
}
