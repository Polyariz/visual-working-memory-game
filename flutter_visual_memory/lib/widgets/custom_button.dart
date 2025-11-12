import 'package:flutter/material.dart';

/// Кастомная кнопка "Next"
/// Портировано из buttons.py - класс NextButton
class CustomNextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final Color borderColor;

  const CustomNextButton({
    Key? key,
    required this.onPressed,
    this.text = 'Next',
    this.textColor = const Color(0xFF003B66),
    this.borderColor = const Color(0xFFD3D3D3),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: 5 * screenWidth / 6 - 140,
      top: 3 * screenHeight / 4,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: screenWidth / 24,
            ),
          ),
        ),
      ),
    );
  }
}
