// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:security_patrol_mx/main.dart';

void main() {
  testWidgets('Login screen shows correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the AppBar title is present
    expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
    
    // Verify that the app name is displayed
    expect(find.text('Security Patrol'), findsOneWidget);
    
    // Verify that email and password fields are present by their icons
    expect(find.byIcon(Icons.email), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
    
    // Verify that login button is present
    expect(find.text('Login'), findsAtLeastNWidgets(1));
  });
}
