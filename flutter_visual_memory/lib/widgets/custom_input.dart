import 'package:flutter/material.dart';

/// Заголовок для поля ввода
/// Портировано из buttons.py - класс TitleOfInputBox
class InputBoxTitle extends StatelessWidget {
  final String titleText;

  const InputBoxTitle({
    Key? key,
    required this.titleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth / 7,
      height: screenHeight / 27,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC0C0C0), width: 2),
      ),
      child: Center(
        child: Text(
          titleText.replaceAll('_', ' ').toUpperCase(),
          style: TextStyle(
            color: const Color(0xFF003B66),
            fontSize: screenWidth / 48,
          ),
        ),
      ),
    );
  }
}

/// Поле ввода
/// Портировано из buttons.py - класс InputBox
class CustomInputBox extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const CustomInputBox({
    Key? key,
    required this.controller,
    this.hintText = '',
  }) : super(key: key);

  @override
  State<CustomInputBox> createState() => _CustomInputBoxState();
}

class _CustomInputBoxState extends State<CustomInputBox> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth / 7,
      height: screenHeight / 18,
      decoration: BoxDecoration(
        border: Border.all(
          color: _isFocused
              ? const Color(0xFF696969)
              : const Color(0xFFC0C0C0),
          width: 2,
        ),
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isFocused = hasFocus;
          });
        },
        child: TextField(
          controller: widget.controller,
          style: TextStyle(
            color: const Color(0xFF003B66),
            fontSize: screenWidth / 48,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(5),
          ),
        ),
      ),
    );
  }
}
