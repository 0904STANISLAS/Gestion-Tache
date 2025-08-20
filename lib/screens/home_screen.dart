import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/project_card.dart';
import '../widgets/statistics_card.dart';
import '../widgets/add_task_fab.dart';
import 'task_list_screen.dart';
import 'project_list_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _DashboardTab(),
          _TasksTab(),
          _ProjectsTab(),
          _StatisticsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Tableau de bord',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tâches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Projets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Statistiques',
          ),
        ],
      ),
      floatingActionButton: const AddTaskFAB(),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = taskProvider.getStatistics();
        final overdueTasks = taskProvider.overdueTasks;
        final tasksDueToday = taskProvider.tasksDueToday;
        final activeProjects = taskProvider.activeProjects;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'TaskFlow',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Statistics Cards
                    Row(
                      children: [
                        Expanded(
                          child: StatisticsCard(
                            title: 'Tâches en cours',
                            value: '${stats['pendingTasks']}',
                            icon: Icons.pending_actions,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatisticsCard(
                            title: 'Tâches terminées',
                            value: '${stats['completedTasks']}',
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: StatisticsCard(
                            title: 'Tâches en retard',
                            value: '${stats['overdueTasks']}',
                            icon: Icons.warning,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatisticsCard(
                            title: 'Taux de réussite',
                            value: '${stats['completionRate'].toStringAsFixed(1)}%',
                            icon: Icons.trending_up,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    Text(
                      'Actions rapides',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            title: 'Ajouter une tâche',
                            icon: Icons.add_task,
                            color: Theme.of(context).primaryColor,
                            onTap: () => _showAddTaskDialog(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _QuickActionCard(
                            title: 'Nouveau projet',
                            icon: Icons.create_new_folder,
                            color: Colors.green,
                            onTap: () => _showAddProjectDialog(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Overdue Tasks
                    if (overdueTasks.isNotEmpty) ...[
                      Text(
                        'Tâches en retard',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: overdueTasks.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 280,
                              child: TaskCard(
                                task: overdueTasks[index],
                                showProject: true,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Tasks Due Today
                    if (tasksDueToday.isNotEmpty) ...[
                      Text(
                        'Tâches pour aujourd\'hui',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: tasksDueToday.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 280,
                              child: TaskCard(
                                task: tasksDueToday[index],
                                showProject: true,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Recent Projects
                    if (activeProjects.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Projets récents',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProjectListScreen(),
                                ),
                              );
                            },
                            child: const Text('Voir tout'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: activeProjects.length > 3 ? 3 : activeProjects.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 200,
                              child: ProjectCard(
                                project: activeProjects[index],
                                showTaskCount: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    // This will be implemented in the AddTaskFAB
  }

  void _showAddProjectDialog(BuildContext context) {
    // This will be implemented in the ProjectListScreen
  }
}

class _TasksTab extends StatelessWidget {
  const _TasksTab();

  @override
  Widget build(BuildContext context) {
    return const TaskListScreen();
  }
}

class _ProjectsTab extends StatelessWidget {
  const _ProjectsTab();

  @override
  Widget build(BuildContext context) {
    return const ProjectListScreen();
  }
}

class _StatisticsTab extends StatelessWidget {
  const _StatisticsTab();

  @override
  Widget build(BuildContext context) {
    return const StatisticsScreen();
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
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
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
