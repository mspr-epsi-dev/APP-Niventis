// A widget test (in other UI frameworks referred to as component test) tests a single widget.

import "dart:async";
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niventis_app/main.dart';

void main() {
  // ---- Widget test
  // Widget MyHomePag
  group('MyHomePage', () {
    testWidgets('MyHomePage as a title and message', (WidgetTester tester) async {
      final myApp = MyApp();

      await tester.pumpWidget(myApp);

      //expect(find.text("Niventis"), findsOneWidget);
    });
  });
}
