import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todolist/main.dart';
import 'package:todolist/services/notification_service.dart';

void main() {
  group('ToDo List Tests', () {
    late NotificationService notificationService;

    setUpAll(() async {
      notificationService = NotificationService();
      await notificationService.init();
    });

    testWidgets('Add and remove a task', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that our task input field is present.
      expect(find.text('Enter a task'), findsOneWidget);

      // Enter a task
      await tester.enterText(find.byType(TextField), 'Task 1');
      await tester.tap(find.text('Add task'));
      await tester.pump();

      // Verify that the task has been added
      expect(find.text('Task 1'), findsOneWidget);

      // Tap the task to edit
      await tester.tap(find.text('Task 1'));
      await tester.pump();

      // Tap the save button in the dialog
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Verify that the task is still there
      expect(find.text('Task 1'), findsOneWidget);

      // Tap the delete button
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pump();

      // Verify that the task has been removed
      expect(find.text('Task 1'), findsNothing);
    });

    testWidgets('Add task with reminder', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that our task input field is present.
      expect(find.text('Enter a task'), findsOneWidget);

      // Enter a task
      await tester.enterText(find.byType(TextField), 'Task 2');
      await tester.tap(find.text('Add task'));
      await tester.pump();

      // Verify that the task has been added
      expect(find.text('Task 2'), findsOneWidget);

      // Tap the task to edit
      await tester.tap(find.text('Task 2'));
      await tester.pump();

      // Tap the "Add a reminder" button in the dialog
      await tester.tap(find.text('Add a reminder'));
      await tester.pump();

      // Close the dialog
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Verify that the task is still there
      expect(find.text('Task 2'), findsOneWidget);

      // Optionally, wait a bit to see if the reminder triggers
      // This part may not be testable easily in a unit test environment
      // without mocking the notification service.
    });

    testWidgets('Counter increments smoke test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that our counter starts at 0.
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      // Tap the '+' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that our counter has incremented.
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
    });
  });
}
