part of '../virtual_keyboard.dart';

// ignore: constant_identifier_names
enum VirtualKeyboardKeyType { Action, String }

class VirtualKeyboardKey {
  bool willExpand = false;
  String? text;
  String? capsText;
  final VirtualKeyboardKeyType keyType;
  final VirtualKeyboardKeyAction? action;

  VirtualKeyboardKey({
    this.text,
    this.capsText,
    required this.keyType,
    this.action,
  });
}

class TextKey extends VirtualKeyboardKey {
  TextKey(String text, {String? capsText})
      : super(
          text: text,
          capsText: capsText ?? text.toUpperCase(),
          keyType: VirtualKeyboardKeyType.String,
        );
}

class ActionKey extends VirtualKeyboardKey {
  ActionKey(VirtualKeyboardKeyAction action)
      : super(keyType: VirtualKeyboardKeyType.Action, action: action) {
    switch (action) {
      case VirtualKeyboardKeyAction.Space:
        super.text = ' ';
        super.capsText = ' ';
        super.willExpand = true;
        break;
      case VirtualKeyboardKeyAction.Return:
        super.text = '\n';
        super.capsText = '\n';
        break;
      case VirtualKeyboardKeyAction.Backspace:
        super.willExpand = true;
        break;
      default:
        break;
    }
  }
}
