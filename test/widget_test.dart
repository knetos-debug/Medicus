// Basic widget test for the Klinisk AI Assistent

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klinisk_ai_assistent/app.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: KliniskAIApp(),
      ),
    );

    // Verify that the app initializes
    await tester.pumpAndSettle();

    // The app should show either the provider selection or home screen
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
