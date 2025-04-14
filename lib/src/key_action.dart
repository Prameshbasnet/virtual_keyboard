part of '../virtual_keyboard_plus.dart';

/// Represents the type of action a virtual keyboard key performs.
///
/// These actions are used by the virtual keyboard to handle
/// non-character keys such as backspace, return, shift, etc.
enum VirtualKeyboardKeyAction {
  /// Deletes the character before the cursor.
  Backspace,

  /// Inserts a new line character (`\n`).
  Return,

  /// Toggles between lowercase and uppercase characters.
  Shift,

  /// Inserts a space character.
  Space,

  /// Switches to the symbols keyboard layout.
  Symbols,

  /// Switches to the alphanumeric keyboard layout.
  Alpha,
}
