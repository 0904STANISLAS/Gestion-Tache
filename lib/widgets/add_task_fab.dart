import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class AddTaskFAB extends StatelessWidget {
  const AddTaskFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddTaskDialog(context),
      icon: const Icon(Icons.add),
      label: const Text('Nouvelle tâche'),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddTaskBottomSheet(),
    );
  }
}

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _tagsController = TextEditingController();
  
  DateTime? _selectedDueDate;
  Priority _selectedPriority = Priority.medium;
  String? _selectedProjectId;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Nouvelle tâche',
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

          // Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre *',
                    hintText: 'Entrez le titre de la tâche',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le titre est requis';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Description optionnelle de la tâche',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Row for Priority and Due Date
                Row(
                  children: [
                    // Priority
                    Expanded(
                      child: DropdownButtonFormField<Priority>(
                        value: _selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Priorité',
                        ),
                        items: Priority.values.map((priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(priority.displayName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPriority = value;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Due Date
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDueDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date d\'échéance',
                          ),
                          child: Text(
                            _selectedDueDate != null
                                ? _formatDate(_selectedDueDate!)
                                : 'Sélectionner',
                            style: TextStyle(
                              color: _selectedDueDate != null
                                  ? Colors.black87
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Row for Category and Project
                Row(
                  children: [
                    // Category
                    Expanded(
                      child: TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Catégorie',
                          hintText: 'ex: Travail, Personnel',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Project
                    Expanded(
                      child: Consumer<TaskProvider>(
                        builder: (context, taskProvider, child) {
                          final projects = taskProvider.activeProjects;
                          return DropdownButtonFormField<String>(
                            value: _selectedProjectId,
                            decoration: const InputDecoration(
                              labelText: 'Projet',
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Aucun projet'),
                              ),
                              ...projects.map((project) {
                                return DropdownMenuItem(
                                  value: project.id,
                                  child: Text(project.name),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedProjectId = value;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tags
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'ex: urgent, réunion, développement (séparés par des virgules)',
                  ),
                ),
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitTask,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Créer la tâche'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final task = Task(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        category: _categoryController.text.trim().isEmpty
            ? null
            : _categoryController.text.trim(),
        projectId: _selectedProjectId,
        dueDate: _selectedDueDate,
        priority: _selectedPriority,
        tags: _tagsController.text
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList(),
      );

      await context.read<TaskProvider>().addTask(task);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tâche créée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la création: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
