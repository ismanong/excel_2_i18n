import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnValueChanged = void Function(String value);
typedef OnComplete = void Function(String value);

/// PL 漂亮UI
///
// PrettyInput(
//   initText: '11111',
//   inputLength: 6,
//   onValueChanged: (value) {
//     print(value);
//   },
// ),
///
///
class PrettyInput extends StatefulWidget {
  final bool isOnlyNumber;
  final int inputLength;
  final OnValueChanged onValueChanged;
  final OnComplete onComplete;
  final String initText;

  PrettyInput({
    this.isOnlyNumber = true,
    this.inputLength = 6,
    this.onValueChanged,
    this.onComplete,
    this.initText,
  });

  @override
  _PrettyInputState createState() => _PrettyInputState();
}

class _PrettyInputState extends State<PrettyInput> with WidgetsBindingObserver {
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  List<String> _listText = [];
  int _focusOffset = 0;

  void _checkFocus() {
    _listText = List<String>.filled(widget.inputLength, '');
    List<String> _copy = _controller.text.split('');
    List.generate(_copy.length, (index) {
      _listText[index] = _copy[index];
    });
    _focusOffset = _copy.length; // 此时不用-1 代表下一个
  }

  void _checkKeyboardVisible(bool isKeyboardVisible) {
    if (isKeyboardVisible) {
      // 键盘弹起
      _checkFocus();
    } else {
      // 键盘收起
      _focusOffset = 9999;
      _focusNode.unfocus();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.text = widget.initText.toUpperCase();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      // auto focus
      _focusNode.requestFocus();
    });
    _checkFocus();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      change: (isKeyboardVisible) {
        if (isKeyboardVisible) {
          // 为可见的键盘建立布局
          _checkKeyboardVisible(true);
        } else {
          // 为隐形键盘建立布局
          _checkKeyboardVisible(false);
        }
      },
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    return Container(
      height: 50,
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          _buildRowIpInput(),
          Opacity(
            opacity: 0.0,
            child: TextField(
              style: TextStyle(color: Colors.transparent, fontSize: 0),
              // only digits
              inputFormatters: [
                widget.isOnlyNumber
                    ? FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))
                    : FilteringTextInputFormatter.allow(RegExp(r"[0-9a-zA-Z]"))
              ],
              keyboardType: widget.isOnlyNumber
                  ? TextInputType.number
                  : TextInputType.text,
              focusNode: _focusNode,
              controller: _controller,
              maxLength: widget.inputLength,
              onChanged: (String value) {
                if (value.length > widget.inputLength) {
                  return;
                }
                _checkFocus();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowIpInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_listText.length, (index) {
        return PrettyInputItem(
          text: _listText[index],
          focusIndex: index,
          focusOffset: _focusOffset,
        );
      }),
    );
  }

  Widget _buildRowInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_listText.length, (index) {
        return PrettyInputItem(
          text: _listText[index],
          focusIndex: index,
          focusOffset: _focusOffset,
        );
      }),
    );
  }
}

class PrettyInputItem extends StatelessWidget {
  final String text;
  final bool readonly;
  final int focusOffset;
  final int focusIndex;

  PrettyInputItem({
    this.text = "",
    this.readonly = false,
    this.focusOffset,
    this.focusIndex,
  });

  @override
  Widget build(BuildContext context) {
    bool isFocusedUnderline = focusIndex == focusOffset;
    bool isShowCursor = focusIndex == focusOffset;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 48,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6)),
            border: Border(
              top: BorderSide(
                  color: isFocusedUnderline
                      ? Color(0xFFF89E00)
                      : Color(0xffDDDDDD),
                  width: 1),
              left: BorderSide(
                  color: isFocusedUnderline
                      ? Color(0xFFF89E00)
                      : Color(0xffDDDDDD),
                  width: 1),
              right: BorderSide(
                  color: isFocusedUnderline
                      ? Color(0xFFF89E00)
                      : Color(0xffDDDDDD),
                  width: 1),
              bottom: BorderSide(
                  color: isFocusedUnderline
                      ? Color(0xFFF89E00)
                      : Color(0xffDDDDDD),
                  width: 1),
            ),
          ),
          child: Container(
            color: readonly ? Colors.grey.shade300 : Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              text.toString(),
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        isShowCursor ? CustomCursorWidget() : Container()
      ],
    );
  }
}

class CustomCursorWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CustomCursorWidgetState();
  }
}

class CustomCursorWidgetState extends State<CustomCursorWidget> {
  Timer _timer;
  Color _cursorColor = Color(0xFFF89E00);
  bool _flag = false;

  @override
  void initState() {
    super.initState();
    _timer = _createTimer();
  }

  Timer _createTimer() {
    return Timer.periodic(Duration(milliseconds: 500), (t) {
      _flag = !_flag;
      _cursorColor = _flag ? Colors.transparent : Color(0xFFF89E00);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 25,
      color: _cursorColor,
    );
  }
}

class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget child;
  final void Function(bool isKeyboardVisible) change;

  const KeyboardVisibilityBuilder({
    Key key,
    @required this.child,
    @required this.change,
  }) : super(key: key);

  @override
  _KeyboardVisibilityBuilderState createState() =>
      _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // double bottom = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
    //     .viewInsets
    //     .bottom;
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      // setState(() {
      _isKeyboardVisible = newValue;
      // });
      widget.change(_isKeyboardVisible);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
