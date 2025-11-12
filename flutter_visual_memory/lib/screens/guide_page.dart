import 'package:flutter/material.dart';
import '../models/user_info.dart';
import '../widgets/custom_button.dart';
import 'start_actual_task_page.dart';
import '../game/task_guiding.dart';

/// Страница с инструкциями
/// Портировано из guid_page.py
class GuidePage extends StatelessWidget {
  final UserInfo userInfo;

  const GuidePage({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ИНСТРУКЦИЯ',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003B66),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildInstructionText(),
                  const SizedBox(height: 40),
                  _buildExampleDiagram(),
                ],
              ),
            ),
          ),
          CustomNextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskGuidingPage(userInfo: userInfo),
                ),
              );
            },
            borderColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionText() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF003B66), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1. В начале игры на 2 секунды показывается сетка 6×6 из шестиугольников.',
            style: TextStyle(fontSize: 18, height: 1.5),
          ),
          SizedBox(height: 15),
          Text(
            '2. Некоторые шестиугольники будут подсвечены ЖЕЛТЫМ цветом - это цели, которые нужно запомнить.',
            style: TextStyle(fontSize: 18, height: 1.5),
          ),
          SizedBox(height: 15),
          Text(
            '3. После 2 секунд все шестиугольники станут БЕЛЫМИ.',
            style: TextStyle(fontSize: 18, height: 1.5),
          ),
          SizedBox(height: 15),
          Text(
            '4. Ваша задача - кликнуть на те позиции, где были ЖЕЛТЫЕ шестиугольники.',
            style: TextStyle(fontSize: 18, height: 1.5),
          ),
          SizedBox(height: 15),
          Text(
            '5. Правильные клики становятся ЗЕЛЁНЫМИ, неправильные - КРАСНЫМИ.',
            style: TextStyle(fontSize: 18, height: 1.5),
          ),
          SizedBox(height: 15),
          Text(
            '6. Ваш счет = количество правильных кликов / общее количество целей.',
            style: TextStyle(fontSize: 18, height: 1.5),
          ),
          SizedBox(height: 15),
          Text(
            '7. Счет 1.0 означает победу, любой другой счет - проигрыш.',
            style: TextStyle(
              fontSize: 18,
              height: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleDiagram() {
    return Column(
      children: [
        const Text(
          'Пример:',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003B66),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildExampleBox('ЗАПОМНИТЕ', Colors.yellow.shade700, '2 сек'),
            const Icon(Icons.arrow_forward, size: 40),
            _buildExampleBox('ВСПОМНИТЕ', Colors.white, 'Кликайте'),
            const Icon(Icons.arrow_forward, size: 40),
            _buildExampleBox('РЕЗУЛЬТАТ', Colors.green, 'Зелёный=✓\nКрасный=✗'),
          ],
        ),
      ],
    );
  }

  Widget _buildExampleBox(String title, Color color, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.black, width: 2),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
