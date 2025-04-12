import 'package:flutter/material.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Virtual Keyboard Example')),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(controller: controller),
            ),
            VirtualKeyboard(
              type: VirtualKeyboardType.Alphanumeric,
              textController: controller,
              exp: RegExp(r'^[a-zA-Z0-9]*$'),
            ),
          ],
        ),
      ),
    );
  }
}
