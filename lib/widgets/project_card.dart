import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final bool showTaskCount;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.project,
    this.showTaskCount = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _parseColor(project.color).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with color indicator and project name
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _parseColor(project.color),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      project.name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Description (if exists)
              if (project.description != null && project.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  project.description!,
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
                  if (project.dueDate != null) ...[
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: _isOverdue(project.dueDate!)
                          ? Colors.red
                          : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDueDate(project.dueDate!),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: _isOverdue(project.dueDate!)
                            ? Colors.red
                            : Colors.grey[600],
                        fontWeight: _isOverdue(project.dueDate!)
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],

                  // Task count (if requested)
                  if (showTaskCount) ...[
                    Icon(
                      Icons.task,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '0 tâches', // This will be updated by the parent
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Creation date
                  Text(
                    'Créé le ${_formatDate(project.createdAt)}',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
      return '${dueDate.day}/${dueDate.month}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
