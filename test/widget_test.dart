import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:roman_calculator/main.dart';

void expectDisplayEquals(String expected) {
  const displayKey = Key('display');

  var displayFinder = find.byKey(displayKey);
  expect(displayFinder, findsOneWidget);

  var display = displayFinder.evaluate().first.widget as Text;
  expect(display.data, equals(expected));
}

void main() {
  testWidgets(
    'Tests input, delete, and clear buttons',
    (WidgetTester tester) async {
      void expectTapToDisplay(String tap, String display) async {
        await tester.tap(find.text(tap));
        await tester.pump();
        expectDisplayEquals(display);
      }

      await tester.pumpWidget(RomanCalculatorApp());

      expectDisplayEquals('N');

      expectTapToDisplay('I', 'I');
      expectTapToDisplay('V', 'IV');
      expectTapToDisplay('X', 'IVX');
      expectTapToDisplay('Del', 'IV');
      expectTapToDisplay('Clear', 'N');
    },
  );
}
