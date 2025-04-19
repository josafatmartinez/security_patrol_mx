// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:security_patrol_mx/main.dart';
import 'package:security_patrol_mx/services/theme_controller.dart';

void main() {
  group('Login Screen Tests', () {
    testWidgets('Login screen shows correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: const MyApp(),
        ),
      );

      // Verify that the AppBar title is present
      expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);

      // Verify that the app name is displayed
      expect(find.text('Security Patrol'), findsOneWidget);

      // Verify that email and password fields are present
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Verify that login button is present
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('Shows validation errors when form is empty', (
      WidgetTester tester,
    ) async {
      // Build our app
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: const MyApp(),
        ),
      );

      // Tap the login button without entering any data
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      // Verify validation error messages
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Shows validation error for invalid email', (
      WidgetTester tester,
    ) async {
      // Build our app
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: const MyApp(),
        ),
      );

      // Type invalid email
      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'invalid-email',
      );

      // Type valid password
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password123',
      );

      // Tap the login button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      // Verify validation error messages
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Shows validation error for short password', (
      WidgetTester tester,
    ) async {
      // Build our app
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: const MyApp(),
        ),
      );

      // Type valid email
      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'test@example.com',
      );

      // Type short password
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        '12345',
      );

      // Tap the login button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      // Verify validation error messages
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });
  });
}
