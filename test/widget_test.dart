// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:seasonbox/main.dart';
import 'package:seasonbox/data/services/posthog_service.dart';
import 'helpers/mock_firebase.dart';

void main() {
  setUpAll(() async {
    setupFirebaseMocks();
    await Firebase.initializeApp();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final postHogService = PostHogService();
    await tester.pumpWidget(SeasonBox(postHogService: postHogService));

    // Verify that our app starts on LoginScreen or similar and shows the title.
    // Use find.textContaining if the title is inside other widgets.
    expect(find.text('SeasonBox'), findsWidgets);
  });
}
