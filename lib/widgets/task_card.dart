import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool showProject;
  final VoidCallback? onTap;
  final bool showActions;

  const TaskCard({
    super.key,
    required this.task,
    this.showProject = false,
    this.onTap,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.read<TaskProvider>();
    final project = showProject && task.projectId != null
        ? taskProvider.getProjectById(task.projectId!)
        : null;

    return Slidable(
      endActionPane: showActions
          ? ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => _editTask(context),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Modifier',
                ),
                SlidableAction(
                  onPressed: (_) => _deleteTask(context),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Supprimer',
                ),
              ],
            )
          : null,
      child: Card(
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: task.isCompleted
                ? Colors.grey.withOpacity(0.3)
                : _getPriorityColor(task.priority).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onTap ?? () => _editTask(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with priority and completion
                Row(
                  children: [
                    // Priority indicator
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(task.priority),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Completion checkbox
                    GestureDetector(
                      onTap: () => _toggleCompletion(context),
                      child: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: task.isCompleted ? Colors.green : Colors.grey,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    // Project indicator
                    if (showProject && project != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _parseColor(project.color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          project.name,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: _parseColor(project.color),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Task title
                Text(
                  task.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.isCompleted
                        ? Colors.grey
                        : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Description (if exists)
                if (task.description != null && task.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    task.description!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 12),

                // Footer with metadata
                Row(
                  children: [
                    // Due date
                    if (task.dueDate != null) ...[
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: _isOverdue(task.dueDate!)
                            ? Colors.red
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDueDate(task.dueDate!),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: _isOverdue(task.dueDate!)
                              ? Colors.red
                              : Colors.grey[600],
                          fontWeight: _isOverdue(task.dueDate!)
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],

                    // Time spent
                    if (task.timeSpent > 0) ...[
                      Icon(
                        Icons.timer,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(task.timeSpent),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],

                    // Tags
                    if (task.tags.isNotEmpty) ...[
                      Icon(
                        Icons.label,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.tags.first,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (task.tags.length > 1)
                        Text(
                          ' +${task.tags.length - 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
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

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  bool _isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now());
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (dueDateOnly == today) {
      return 'Aujourd\'hui';
    } else if (dueDateOnly == tomorrow) {
      return 'Demain';
    } else if (dueDateOnly.isBefore(today)) {
      return 'En retard';
    } else {
      return DateFormat('dd/MM').format(dueDate);
    }
  }

  String _formatTime(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${remainingMinutes}m';
      }
    }
  }

  void _toggleCompletion(BuildContext context) {
    context.read<TaskProvider>().toggleTaskCompletion(task.id);
  }

  void _editTask(BuildContext context) {
    // TODO: Navigate to edit task screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonctionnalité à implémenter')),
    );
  }

  void _deleteTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la tâche'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${task.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskProvider>().deleteTask(task.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
