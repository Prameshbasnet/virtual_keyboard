part of '../virtual_keyboard_plus.dart';

/// Represents the type of a virtual keyboard key.
///
/// - [Action] keys perform control actions like backspace or shift.
/// - [String] keys insert text characters like letters or numbers.
enum VirtualKeyboardKeyType {
  /// A key that performs an action (e.g., backspace, shift).
  Action,

  /// A key that inserts a string or character.
  String,
}

/// A base class representing a key on the virtual keyboard.
///
/// Keys can be either text-producing or action-performing.
/// This class is extended by [TextKey] and [ActionKey].
class VirtualKeyboardKey {
  /// Whether the key should expand to fill available horizontal space.
  bool willExpand = false;

  /// The text this key represents.
  String? text;

  /// The uppercase version of [text], used for shift or caps lock.
  String? capsText;

  /// The type of this key (action or string).
  final VirtualKeyboardKeyType keyType;

  /// The action this key performs, if it is an [Action] key.
  final VirtualKeyboardKeyAction? action;

  /// Creates a virtual keyboard key with the specified [keyType].
  ///
  /// Use [TextKey] or [ActionKey] instead of this class directly in most cases.
  VirtualKeyboardKey({
    this.text,
    this.capsText,
    required this.keyType,
    this.action,
  });
}

/// A key that inserts a character into the input field.
class TextKey extends VirtualKeyboardKey {
  /// Creates a [TextKey] that displays and inserts [text].
  ///
  /// Optionally specify [capsText] if the uppercase version is different
  /// from the default `text.toUpperCase()`.
  TextKey(String text, {String? capsText})
      : super(
          text: text,
          capsText: capsText ?? text.toUpperCase(),
          keyType: VirtualKeyboardKeyType.String,
        );
}

/// A key that performs an action like space, return, or backspace.
class ActionKey extends VirtualKeyboardKey {
  /// Creates an [ActionKey] with the given [action].
  ///
  /// Automatically configures `text`, `capsText`, and `willExpand`
  /// based on the [action] type.
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
