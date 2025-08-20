import 'package:flutter/material.dart';
import '../models/task.dart';

class PriorityColors {
  static Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
      case Priority.urgent:
        return Colors.purple;
    }
  }

  static Color getPriorityBackgroundColor(Priority priority) {
    return getPriorityColor(priority).withOpacity(0.1);
  }

  static Color getPriorityBorderColor(Priority priority) {
    return getPriorityColor(priority).withOpacity(0.3);
  }

  static String getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.low:
        return '⬇️';
      case Priority.medium:
        return '➖';
      case Priority.high:
        return '⬆️';
      case Priority.urgent:
        return '🚨';
    }
  }

  static IconData getPriorityIconData(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Icons.keyboard_arrow_down;
      case Priority.medium:
        return Icons.remove;
      case Priority.high:
        return Icons.keyboard_arrow_up;
      case Priority.urgent:
        return Icons.priority_high;
    }
  }
}
