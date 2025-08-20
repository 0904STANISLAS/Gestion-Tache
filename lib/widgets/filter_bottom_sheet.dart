import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedProjectId;
  String? _selectedCategory;
  Priority? _selectedPriority;
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    final taskProvider = context.read<TaskProvider>();
    _selectedProjectId = taskProvider.selectedProjectId;
    _selectedCategory = taskProvider.selectedCategory;
    _selectedPriority = taskProvider.selectedPriority;
    _showCompleted = taskProvider.showCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Filtres',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Project filter
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final projects = taskProvider.activeProjects;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Projet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedProjectId,
                    decoration: const InputDecoration(
                      hintText: 'Tous les projets',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Tous les projets'),
                      ),
                      ...projects.map((project) {
                        return DropdownMenuItem(
                          value: project.id,
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
                                child: Text(project.name),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedProjectId = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Category filter
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final categories = taskProvider.availableCategories;
              if (categories.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catégorie',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      hintText: 'Toutes les catégories',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Toutes les catégories'),
                      ),
                      ...categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Priority filter
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Priorité',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Priority>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  hintText: 'Toutes les priorités',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Toutes les priorités'),
                  ),
                  ...Priority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Row(
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
                          Text(priority.displayName),
                        ],
                      ),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Completion status filter
          Row(
            children: [
              Checkbox(
                value: _showCompleted,
                onChanged: (value) {
                  setState(() {
                    _showCompleted = value ?? true;
                  });
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Afficher les tâches terminées',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  child: const Text('Effacer tout'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Appliquer'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
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

  void _clearFilters() {
    setState(() {
      _selectedProjectId = null;
      _selectedCategory = null;
      _selectedPriority = null;
      _showCompleted = true;
    });
  }

  void _applyFilters() {
    final taskProvider = context.read<TaskProvider>();
    taskProvider.setSelectedProject(_selectedProjectId);
    taskProvider.setSelectedCategory(_selectedCategory);
    taskProvider.setSelectedPriority(_selectedPriority);
    
    if (!_showCompleted) {
      taskProvider.toggleShowCompleted();
    }
    
    Navigator.of(context).pop();
  }
}
