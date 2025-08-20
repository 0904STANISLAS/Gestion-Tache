import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskflow/models/project.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<TaskProvider>().refresh(),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = taskProvider.getStatistics();
          final tasks = taskProvider.tasks;
          final projects = taskProvider.projects;

          return RefreshIndicator(
            onRefresh: () => taskProvider.refresh(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Statistics
                  Text(
                    'Vue d\'ensemble',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildOverviewCards(stats),
                  const SizedBox(height: 24),

                  // Productivity Chart
                  Text(
                    'Productivité',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProductivityChart(stats),
                  const SizedBox(height: 24),

                  // Priority Distribution
                  Text(
                    'Répartition par priorité',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPriorityDistribution(tasks),
                  const SizedBox(height: 24),

                  // Category Analysis
                  if (taskProvider.availableCategories.isNotEmpty) ...[
                    Text(
                      'Analyse par catégorie',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryAnalysis(tasks, taskProvider.availableCategories),
                    const SizedBox(height: 24),
                  ],

                  // Project Performance
                  if (projects.isNotEmpty) ...[
                    Text(
                      'Performance des projets',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildProjectPerformance(taskProvider, projects),
                    const SizedBox(height: 24),
                  ],

                  // Time Tracking
                  Text(
                    'Suivi du temps',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTimeTracking(stats),
                  const SizedBox(height: 24),

                  // Recent Activity
                  Text(
                    'Activité récente',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRecentActivity(tasks),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards(Map<String, dynamic> stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total des tâches',
          '${stats['totalTasks']}',
          Icons.task,
          Colors.blue,
        ),
        _buildStatCard(
          'Tâches terminées',
          '${stats['completedTasks']}',
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          'Tâches en cours',
          '${stats['pendingTasks']}',
          Icons.pending_actions,
          Colors.orange,
        ),
        _buildStatCard(
          'Taux de réussite',
          '${stats['completionRate'].toStringAsFixed(1)}%',
          Icons.trending_up,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductivityChart(Map<String, dynamic> stats) {
    final completionRate = stats['completionRate'] as double;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: completionRate / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completionRate >= 80 ? Colors.green : Colors.orange,
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${completionRate.toStringAsFixed(1)}%',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terminées',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'En cours',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityDistribution(List<Task> tasks) {
    final priorityCounts = <Priority, int>{};
    for (final priority in Priority.values) {
      priorityCounts[priority] = tasks.where((task) => task.priority == priority).length;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: priorityCounts.entries.map((entry) {
            final priority = entry.key;
            final count = entry.value;
            final percentage = tasks.isEmpty ? 0.0 : (count / tasks.length) * 100;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getPriorityColor(priority),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          priority.displayName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '$count tâches',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getPriorityColor(priority),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(_getPriorityColor(priority)),
                    minHeight: 4,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryAnalysis(List<Task> tasks, List<String> categories) {
    final categoryStats = <String, Map<String, dynamic>>{};
    
    for (final category in categories) {
      final categoryTasks = tasks.where((task) => task.category == category).toList();
      final completed = categoryTasks.where((task) => task.isCompleted).length;
      final total = categoryTasks.length;
      
      categoryStats[category] = {
        'total': total,
        'completed': completed,
        'completionRate': total > 0 ? (completed / total) * 100 : 0.0,
      };
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: categoryStats.entries.map((entry) {
            final category = entry.key;
            final stats = entry.value;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      category,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: LinearProgressIndicator(
                      value: (stats['completionRate'] as double) / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        (stats['completionRate'] as double) >= 80 ? Colors.green : Colors.orange,
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${stats['completed']}/${stats['total']}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProjectPerformance(TaskProvider taskProvider, List<Project> projects) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: projects.map((project) {
            final projectTasks = taskProvider.getTasksByProject(project.id);
            final completed = projectTasks.where((task) => task.isCompleted).length;
            final total = projectTasks.length;
            final completionRate = total > 0 ? (completed / total) * 100 : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _parseColor(project.color),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Text(
                      project.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: LinearProgressIndicator(
                      value: completionRate / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        completionRate >= 80 ? Colors.green : Colors.orange,
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${completionRate.toStringAsFixed(1)}%',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTimeTracking(Map<String, dynamic> stats) {
    final totalTime = stats['totalTimeSpent'] as int;
    final averageTime = stats['averageTimePerTask'] as double;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTimeCard(
                    'Temps total',
                    _formatTime(totalTime),
                    Icons.timer,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeCard(
                    'Moyenne par tâche',
                    _formatTime(averageTime.round()),
                    Icons.av_timer,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<Task> tasks) {
    final recentTasks = tasks
        .where((task) => task.lastModified != null)
        .toList()
      ..sort((a, b) => b.lastModified!.compareTo(a.lastModified!));

    final recentTasksList = recentTasks.take(5).toList();

    if (recentTasksList.isEmpty) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Aucune activité récente',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      child: Column(
        children: recentTasksList.map((task) {
          return ListTile(
            leading: Icon(
              task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.isCompleted ? Colors.green : Colors.grey,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              'Modifié le ${_formatDate(task.lastModified!)}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            trailing: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority),
                shape: BoxShape.circle,
              ),
            ),
          );
        }).toList(),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
