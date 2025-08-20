// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String?,
      title: fields[1] as String,
      description: fields[2] as String?,
      isCompleted: fields[3] as bool,
      createdAt: fields[4] as DateTime?,
      dueDate: fields[5] as DateTime?,
      priority: fields[6] as Priority,
      category: fields[7] as String?,
      tags: (fields[8] as List?)?.cast<String>(),
      timeSpent: fields[9] as int,
      lastModified: fields[10] as DateTime?,
      projectId: fields[11] as String?,
      isSynced: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.timeSpent)
      ..writeByte(10)
      ..write(obj.lastModified)
      ..writeByte(11)
      ..write(obj.projectId)
      ..writeByte(12)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  final int typeId = 1;

  @override
  Priority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Priority.low;
      case 1:
        return Priority.medium;
      case 2:
        return Priority.high;
      case 3:
        return Priority.urgent;
      default:
        return Priority.low;
    }
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    switch (obj) {
      case Priority.low:
        writer.writeByte(0);
        break;
      case Priority.medium:
        writer.writeByte(1);
        break;
      case Priority.high:
        writer.writeByte(2);
        break;
      case Priority.urgent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
