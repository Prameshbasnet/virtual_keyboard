part of '../virtual_keyboard_plus.dart';

/// A layout for the numeric keyboard.
///
/// Contains keys for numbers (0-9), a decimal point, and a backspace key.
List<List<VirtualKeyboardKey>> numericLayout = [
  [TextKey('1'), TextKey('2'), TextKey('3')],
  [TextKey('4'), TextKey('5'), TextKey('6')],
  [TextKey('7'), TextKey('8'), TextKey('9')],
  [TextKey('.'), TextKey('0'), ActionKey(VirtualKeyboardKeyAction.Backspace)],
];

/// A layout for the standard US QWERTY keyboard.
///
/// Contains letters (a-z), and special keys like shift, space, return, and backspace.
List<List<VirtualKeyboardKey>> usLayout = [
  [
    TextKey("q"),
    TextKey("w"),
    TextKey("e"),
    TextKey("r"),
    TextKey("t"),
    TextKey("y"),
    TextKey("u"),
    TextKey("i"),
    TextKey("o"),
    TextKey("p")
  ],
  [
    TextKey("a"),
    TextKey("s"),
    TextKey("d"),
    TextKey("f"),
    TextKey("g"),
    TextKey("h"),
    TextKey("j"),
    TextKey("k"),
    TextKey("l")
  ],
  [
    ActionKey(VirtualKeyboardKeyAction.Shift),
    TextKey("z"),
    TextKey("x"),
    TextKey("c"),
    TextKey("v"),
    TextKey("b"),
    TextKey("n"),
    TextKey("m"),
    ActionKey(VirtualKeyboardKeyAction.Backspace)
  ],
  [
    ActionKey(VirtualKeyboardKeyAction.Symbols),
    TextKey(','),
    ActionKey(VirtualKeyboardKeyAction.Space),
    TextKey('.'),
    ActionKey(VirtualKeyboardKeyAction.Return)
  ],
];

/// A layout for the symbol keyboard.
///
/// Contains symbols and punctuation marks, such as @, &, $, and punctuation marks.
List<List<VirtualKeyboardKey>> symbolLayout = [
  [
    TextKey("1"),
    TextKey("2"),
    TextKey("3"),
    TextKey("4"),
    TextKey("5"),
    TextKey("6"),
    TextKey("7"),
    TextKey("8"),
    TextKey("9"),
    TextKey("0")
  ],
  [
    TextKey('@'),
    TextKey('&'),
    TextKey('\$'),
    TextKey('_'),
    TextKey('-'),
    TextKey('+'),
    TextKey('('),
    TextKey(')'),
    TextKey('/')
  ],
  [
    TextKey('|'),
    TextKey('*'),
    TextKey('"'),
    TextKey('\''),
    TextKey(':'),
    TextKey(';'),
    TextKey('!'),
    TextKey('?'),
    ActionKey(VirtualKeyboardKeyAction.Backspace)
  ],
  [
    ActionKey(VirtualKeyboardKeyAction.Alpha),
    TextKey(','),
    ActionKey(VirtualKeyboardKeyAction.Space),
    TextKey('.'),
    ActionKey(VirtualKeyboardKeyAction.Return)
  ],
];

/// A combined layout for both alphanumeric and symbolic keys.
///
/// Includes numbers, letters (a-z), and symbols.
List<List<VirtualKeyboardKey>> dualLayout = [
  [
    TextKey("1"),
    TextKey("2"),
    TextKey("3"),
    TextKey("4"),
    TextKey("5"),
    TextKey("6"),
    TextKey("7"),
    TextKey("8"),
    TextKey("9"),
    TextKey("0")
  ],
  [
    TextKey("q"),
    TextKey("w"),
    TextKey("e"),
    TextKey("r"),
    TextKey("t"),
    TextKey("y"),
    TextKey("u"),
    TextKey("i"),
    TextKey("o"),
    TextKey("p")
  ],
  [
    TextKey("a"),
    TextKey("s"),
    TextKey("d"),
    TextKey("f"),
    TextKey("g"),
    TextKey("h"),
    TextKey("j"),
    TextKey("k"),
    TextKey("l")
  ],
  [
    ActionKey(VirtualKeyboardKeyAction.Shift),
    TextKey("z"),
    TextKey("x"),
    TextKey("c"),
    TextKey("v"),
    TextKey("b"),
    TextKey("n"),
    TextKey("m"),
    ActionKey(VirtualKeyboardKeyAction.Backspace)
  ],
];
