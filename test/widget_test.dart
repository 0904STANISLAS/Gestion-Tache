// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/main.dart';
import 'package:taskflow/providers/task_provider.dart';

void main() {
  testWidgets('TaskFlow app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => TaskProvider(),
        child: const TaskFlowApp(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('TaskFlow'), findsOneWidget);
    
    // Verify that the main navigation tabs are present
    expect(find.text('Tableau de bord'), findsOneWidget);
    expect(find.text('Tâches'), findsOneWidget);
    expect(find.text('Projets'), findsOneWidget);
    expect(find.text('Statistiques'), findsOneWidget);
    
    // Verify that the floating action button is present
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Nouvelle tâche'), findsOneWidget);
  });

  testWidgets('TaskFlow provider test', (WidgetTester tester) async {
    final taskProvider = TaskProvider();
    
    // Test initial state
    expect(taskProvider.tasks, isEmpty);
    expect(taskProvider.projects, isEmpty);
    expect(taskProvider.isLoading, isFalse);
    
    // Test filtered tasks
    expect(taskProvider.filteredTasks, isEmpty);
    expect(taskProvider.pendingTasks, isEmpty);
    expect(taskProvider.completedTasks, isEmpty);
  });
}
