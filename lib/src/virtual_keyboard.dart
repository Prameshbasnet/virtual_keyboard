part of virtual_keyboard;

const double _virtualKeyboardDefaultHeight = 300;
const int _virtualKeyboardBackspaceEventPerioud = 250;

class VirtualKeyboard extends StatefulWidget {
  VirtualKeyboard({
    Key? key,
    required this.type,
    required this.textController,
    this.builder,
    this.height = _virtualKeyboardDefaultHeight,
    this.textColor = Colors.black,
    this.fontSize = 20,
    this.alwaysCaps = false,
    required this.exp,
  }) : super(key: key);

  final Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;
  final bool alwaysCaps;
  final double fontSize;
  final double height;
  final Color textColor;
  final TextEditingController textController;
  final VirtualKeyboardType type;
  final RegExp exp;

  @override
  State<StatefulWidget> createState() => _VirtualKeyboardState();
}

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

    textController.addListener(() {
      if (textController.selection.toString() != "TextSelection.invalid") {
        cursorPosition = textController.selection;
      } else {
        cursorPosition ??= const TextSelection(baseOffset: 0, extentOffset: 0);
      }
    });

    textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
      color: textColor,
    );
  }

  Widget _keyLayout(List<List<VirtualKeyboardKey>> layout, RegExp exp) {
    keySpacing = 8.0;
    double totalSpacing = keySpacing * (layout.length + 1);
    keyHeight = (height - totalSpacing) / layout.length;
    int maxLengthRow =
        layout.map((row) => row.length).reduce((a, b) => a > b ? a : b);
    maxRowWidth =
        ((maxLengthRow - 1) * keySpacing) + (maxLengthRow * keyHeight);

    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _rows(layout),
      ),
    );
  }

  List<Widget> _rows(List<List<VirtualKeyboardKey>> layout) {
    List<Widget> rows = [];

    for (var rowEntry in layout.asMap().entries) {
      int rowNum = rowEntry.key;
      List<VirtualKeyboardKey> rowKeys = rowEntry.value;

      List<Widget> cols = [];

      for (var colEntry in rowKeys.asMap().entries) {
        int colNum = colEntry.key;
        VirtualKeyboardKey key = colEntry.value;

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
          String newText = textController.text + ' ';
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
      default:
        label = '?';
    }

    Widget finalKey = Material(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        highlightColor: Colors.blue.withOpacity(0.3),
        onTap: () {
          if (key.action == VirtualKeyboardKeyAction.Shift && !alwaysCaps) {
            setState(() => isShiftEnabled = !isShiftEnabled);
          }
          _onKeyPress(key, exp);
        },
        child: Container(
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
