part of '../virtual_keyboard_plus.dart';

const double _virtualKeyboardDefaultHeight = 300;

/// A custom virtual keyboard widget for Flutter.
///
/// This widget provides a virtual keyboard with different layouts (numeric, alphanumeric, symbolic)
/// that can be used in text input fields. It is highly customizable with options like font size,
/// text color, and the ability to define the input pattern using regular expressions.
class VirtualKeyboard extends StatefulWidget {
  /// Creates a new instance of the VirtualKeyboard.
  ///
  /// [type] specifies the keyboard layout type (numeric, alphanumeric, symbolic, or dual).
  /// [textController] is the TextEditingController to control the text input field.
  /// [builder] is an optional custom builder function for individual keys.
  /// [height] is the height of the virtual keyboard (default: 300).
  /// [textColor] specifies the text color (default: black).
  /// [fontSize] sets the font size of the keyboard keys (default: 20).
  /// [alwaysCaps] determines whether the keyboard always shows capital letters (default: false).
  /// [exp] is a regular expression to validate the text input.
  const VirtualKeyboard({
    super.key,
    required this.type,
    required this.textController,
    this.builder,
    this.height = _virtualKeyboardDefaultHeight,
    this.textColor = Colors.black,
    this.fontSize = 20,
    this.alwaysCaps = false,
    required this.exp,
  });

  /// An optional custom builder for rendering individual keys on the keyboard.
  final Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;

  /// Determines whether the keyboard should always show capital letters.
  final bool alwaysCaps;

  /// The font size of the text on the keyboard keys.
  final double fontSize;

  /// The height of the virtual keyboard.
  final double height;

  /// The text color of the keys.
  final Color textColor;

  /// The [TextEditingController] to bind the keyboard input to a text field.
  final TextEditingController textController;

  /// The layout type of the virtual keyboard (numeric, alphanumeric, symbolic, dual).
  final VirtualKeyboardType type;

  /// A regular expression for validating the text input.
  final RegExp exp;

  @override
  State<StatefulWidget> createState() => _VirtualKeyboardState();
}

/// The state for the VirtualKeyboard widget, handling key input and layout.
class _VirtualKeyboardState extends State<VirtualKeyboard> {
  late RegExp exp;
  late bool alwaysCaps;
  late double fontSize;
  late double height;
  late double keyHeight;
  late double keySpacing;
  late double maxRowWidth;
  late Color textColor;
  late TextEditingController textController;
  late TextStyle textStyle;
  late double width;
  bool isShiftEnabled = false;
  bool longPress = false;
  VirtualKeyboardType? type;
  TextSelection? cursorPosition;

  @override
  void didUpdateWidget(VirtualKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      type = widget.type;
      height = widget.height;
      textColor = widget.textColor;
      fontSize = widget.fontSize;
      alwaysCaps = widget.alwaysCaps;
      exp = widget.exp;
      textStyle = TextStyle(fontSize: fontSize, color: textColor);
    });
  }

  @override
  void initState() {
    super.initState();
    textController = widget.textController;
    type = widget.type;
    height = widget.height;
    textColor = widget.textColor;
    fontSize = widget.fontSize;
    alwaysCaps = widget.alwaysCaps;
    exp = widget.exp;

    // Listen for changes in the text controller (e.g., cursor position).
    textController.addListener(() {
      if (textController.selection.toString() != "TextSelection.invalid") {
        cursorPosition = textController.selection;
      } else {
        cursorPosition ??= const TextSelection(baseOffset: 0, extentOffset: 0);
      }
    });

    // Initialize the text style used for displaying keys.
    textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
      color: textColor,
    );
  }

  /// Generates the layout of keys based on the current keyboard type.
  Widget _keyLayout(List<List<VirtualKeyboardKey>> layout, RegExp exp) {
    keySpacing = 8.0;
    double totalSpacing = keySpacing * (layout.length + 1);
    keyHeight = (height - totalSpacing) / layout.length;
    int maxLengthRow =
        layout.map((row) => row.length).reduce((a, b) => a > b ? a : b);
    maxRowWidth =
        ((maxLengthRow - 1) * keySpacing) + (maxLengthRow * keyHeight);

    return SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _rows(layout),
      ),
    );
  }

  /// Builds a list of rows for the keyboard layout, where each row contains keys.
  List<Widget> _rows(List<List<VirtualKeyboardKey>> layout) {
    List<Widget> rows = [];

    for (var rowEntry in layout.asMap().entries) {
      int rowNum = rowEntry.key;
      List<VirtualKeyboardKey> rowKeys = rowEntry.value;

      List<Widget> cols = [];

      for (var colEntry in rowKeys.asMap().entries) {
        int colNum = colEntry.key;
        VirtualKeyboardKey key = colEntry.value;

        // Create either a regular key or a custom key using the builder if provided.
        Widget keyWidget = widget.builder == null
            ? (key.keyType == VirtualKeyboardKeyType.String
                ? _keyboardDefaultKey(key)
                : _keyboardDefaultActionKey(key))
            : widget.builder!(context, key);

        cols.add(keyWidget);

        if (colNum != rowKeys.length - 1) cols.add(SizedBox(width: keySpacing));
      }

      rows.add(Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxRowWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cols,
          ),
        ),
      ));

      if (rowNum != layout.length - 1) rows.add(SizedBox(height: keySpacing));
    }

    return rows;
  }

  /// Default implementation for rendering a text key (e.g., letters and numbers).
  Widget _keyboardDefaultKey(VirtualKeyboardKey key) {
    return Material(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        highlightColor: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        onTap: () => _onKeyPress(key, exp),
        child: Container(
          width: keyHeight,
          height: keyHeight,
          child: Center(
            child: Text(
              alwaysCaps
                  ? key.capsText!
                  : (isShiftEnabled ? key.capsText! : key.text!),
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }

  /// Handles the logic when a key is pressed.
  void _onKeyPress(VirtualKeyboardKey key, RegExp exp) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      String newText = textController.text + key.text!;
      RegExpMatch? match = exp.firstMatch(newText);
      if (match != null && match[0] == newText) {
        textController.text += (isShiftEnabled ? key.capsText! : key.text!);
      }
    } else {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (textController.text.isNotEmpty) {
            textController.text = textController.text
                .substring(0, textController.text.length - 1);
          }
          break;
        case VirtualKeyboardKeyAction.Return:
          textController.text += '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          String newText = '${textController.text} ';
          RegExpMatch? match = exp.firstMatch(newText);
          if (match != null && match[0] == newText) {
            textController.text += ' ';
          }
          break;
        case VirtualKeyboardKeyAction.Shift:
          if (!alwaysCaps) {
            setState(() => isShiftEnabled = !isShiftEnabled);
          }
          break;
        case VirtualKeyboardKeyAction.Alpha:
          setState(() => type = VirtualKeyboardType.Alphanumeric);
          break;
        case VirtualKeyboardKeyAction.Symbols:
          setState(() => type = VirtualKeyboardType.Symbolic);
          break;
        default:
          break;
      }
    }
  }

  /// Default implementation for rendering an action key (e.g., backspace, shift, space).
  Widget _keyboardDefaultActionKey(VirtualKeyboardKey key) {
    String label;

    switch (key.action!) {
      case VirtualKeyboardKeyAction.Backspace:
        label = '⌫';
        break;
      case VirtualKeyboardKeyAction.Shift:
        label = isShiftEnabled ? '⇧ ON' : '⇧';
        break;
      case VirtualKeyboardKeyAction.Space:
        label = 'SPACE';
        break;
      case VirtualKeyboardKeyAction.Return:
        label = '⏎';
        break;
      case VirtualKeyboardKeyAction.Symbols:
        label = '123';
        break;
      case VirtualKeyboardKeyAction.Alpha:
        label = 'ABC';
        break;
    }

    Widget finalKey = Material(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        highlightColor: Colors.blue.withAlpha(76),
        onTap: () {
          if (key.action == VirtualKeyboardKeyAction.Shift && !alwaysCaps) {
            setState(() => isShiftEnabled = !isShiftEnabled);
          }
          _onKeyPress(key, exp);
        },
        child: SizedBox(
          width: keyHeight,
          height: keyHeight,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    return key.willExpand ? Expanded(child: finalKey) : finalKey;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    switch (type) {
      case VirtualKeyboardType.Numeric:
        return _keyLayout(numericLayout, exp);
      case VirtualKeyboardType.Alphanumeric:
        return _keyLayout(usLayout, exp);
      case VirtualKeyboardType.Symbolic:
        return _keyLayout(symbolLayout, exp);
      case VirtualKeyboardType.Dual:
        return _keyLayout(dualLayout, exp);
      default:
        return const SizedBox.shrink();
    }
  }
}
