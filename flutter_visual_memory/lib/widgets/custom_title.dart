import 'package:flutter/material.dart';

/// Кастомный заголовок
/// Портировано из buttons.py - класс Title
class CustomTitle extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color borderColor;
  final double fontRatioToScreen;

  const CustomTitle({
    Key? key,
    required this.text,
    this.textColor = const Color(0xFF003B66),
    this.borderColor = const Color(0xFFD3D3D3),
    this.fontRatioToScreen = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      top: screenHeight / 30,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: screenWidth / fontRatioToScreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
