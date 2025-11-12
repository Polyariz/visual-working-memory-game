import 'package:flutter/material.dart';
import '../models/user_info.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_title.dart';
import '../widgets/custom_input.dart';
import 'guide_page.dart';

/// Страница регистрации пользователя
/// Портировано из sign_up_page.py
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _subjectNumberController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _eyeNumberController = TextEditingController();
  final _astigmatismController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _subjectNumberController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _eyeNumberController.dispose();
    _astigmatismController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final userInfo = UserInfo(
      name: _nameController.text,
      lastName: _lastNameController.text,
      mobile: _mobileController.text,
      subjectNumber: _subjectNumberController.text,
      age: _ageController.text,
      gender: _genderController.text,
      eyeNumber: _eyeNumberController.text,
      astigmatism: _astigmatismController.text,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuidePage(userInfo: userInfo),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    double left,
    double top,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      left: left,
      top: top,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputBoxTitle(titleText: label),
          SizedBox(height: screenHeight / 27),
          CustomInputBox(controller: controller),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final leftColumn = screenWidth / 5;
    final rightColumn = 3 * screenWidth / 5;
    final startTop = screenHeight / 4;
    final spacing = screenHeight / 8;

    return Scaffold(
      backgroundColor: const Color(0xFFD3D3D3),
      body: Stack(
        children: [
          const CustomTitle(text: 'Sign Up'),
          // Левая колонка
          _buildInputField('name', _nameController, leftColumn, startTop),
          _buildInputField('last_name', _lastNameController, leftColumn,
              startTop + spacing),
          _buildInputField(
              'mobile', _mobileController, leftColumn, startTop + 2 * spacing),
          // Правая колонка
          _buildInputField(
              'sbjct_nmbr', _subjectNumberController, rightColumn, startTop),
          _buildInputField(
              'age', _ageController, rightColumn, startTop + spacing),
          _buildInputField(
              'gender', _genderController, rightColumn, startTop + 2 * spacing),
          _buildInputField('eye_numbr', _eyeNumberController, rightColumn,
              startTop + 3 * spacing),
          _buildInputField('astigmatism', _astigmatismController, rightColumn,
              startTop + 4 * spacing),
          CustomNextButton(onPressed: _handleNext),
        ],
      ),
    );
  }
}
