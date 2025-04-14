part of '../virtual_keyboard_plus.dart';

/// Represents the different types of virtual keyboard layouts.
///
/// These layouts determine the set of keys available on the keyboard.
///
/// - [Numeric]: A keyboard layout with numeric keys (0-9).
/// - [Alphanumeric]: A standard alphanumeric layout with letters and numbers.
/// - [Symbolic]: A keyboard layout for symbols and special characters.
/// - [Dual]: A keyboard layout that combines both alphanumeric and symbolic keys.
enum VirtualKeyboardType {
  /// A keyboard layout with numeric keys (0-9).
  Numeric,

  /// A keyboard layout with both letters (A-Z) and numbers (0-9).
  Alphanumeric,

  /// A keyboard layout with special symbols (e.g., punctuation, currency symbols).
  Symbolic,

  /// A keyboard layout that combines both alphanumeric and symbolic keys.
  Dual,
}
