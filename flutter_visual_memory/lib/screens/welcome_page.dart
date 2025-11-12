import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_title.dart';
import 'sign_up_page.dart';

/// Страница приветствия
/// Портировано из welcome_page.py
class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3D3D3),
      body: Stack(
        children: [
          const CustomTitle(
            text: 'Welcome',
            borderColor: Color(0xFFD3D3D3),
          ),
          CustomNextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
