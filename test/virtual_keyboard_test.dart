import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

void main() {
  testWidgets('VirtualKeyboard builds and shows keys',
      (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VirtualKeyboard(
            type: VirtualKeyboardType.Dual,
            textController: controller,
            exp: RegExp(r'^[0-9.]*$'),
          ),
        ),
      ),
    );

    // Check that at least one key is found (e.g., '1')
    expect(find.text('1'), findsOneWidget);
  });
}
