import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskflow/models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<TaskProvider>().setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Tâches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher une tâche...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<TaskProvider>().setSearchQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Filter chips
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final hasActiveFilters = taskProvider.selectedProjectId != null ||
                  taskProvider.selectedCategory != null ||
                  taskProvider.selectedPriority != null ||
                  !taskProvider.showCompleted;

              if (!hasActiveFilters) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 8,
                  children: [
                    if (taskProvider.selectedProjectId != null)
                      _buildFilterChip(
                        label: taskProvider
                                .getProjectById(taskProvider.selectedProjectId!)
                                ?.name ??
                            'Projet',
                        onRemove: () => taskProvider.setSelectedProject(null),
                      ),
                    if (taskProvider.selectedCategory != null)
                      _buildFilterChip(
                        label: taskProvider.selectedCategory!,
                        onRemove: () => taskProvider.setSelectedCategory(null),
                      ),
                    if (taskProvider.selectedPriority != null)
                      _buildFilterChip(
                        label: taskProvider.selectedPriority!.displayName,
                        onRemove: () => taskProvider.setSelectedPriority(null),
                      ),
                    if (!taskProvider.showCompleted)
                      _buildFilterChip(
                        label: 'Tâches en cours',
                        onRemove: () => taskProvider.toggleShowCompleted(),
                      ),
                    TextButton(
                      onPressed: () => taskProvider.clearFilters(),
                      child: const Text('Effacer tout'),
                    ),
                  ],
                ),
              );
            },
          ),

          // Task list
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                if (taskProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tasks = taskProvider.filteredTasks;

                if (tasks.isEmpty) {
                  return _buildEmptyState(taskProvider);
                }

                return RefreshIndicator(
                  onRefresh: () => taskProvider.refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        task: task,
                        showProject: true,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onRemove,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildEmptyState(TaskProvider taskProvider) {
    final hasFilters = taskProvider.searchQuery.isNotEmpty ||
        taskProvider.selectedProjectId != null ||
        taskProvider.selectedCategory != null ||
        taskProvider.selectedPriority != null ||
        !taskProvider.showCompleted;

    if (hasFilters) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune tâche trouvée',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Essayez de modifier vos filtres ou de créer une nouvelle tâche',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => taskProvider.clearFilters(),
              child: const Text('Effacer les filtres'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune tâche pour le moment',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez par créer votre première tâche !',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }
}
