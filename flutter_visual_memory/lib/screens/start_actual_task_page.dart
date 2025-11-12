import 'package:flutter/material.dart';
import '../models/user_info.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_title.dart';
import '../game/game_provider.dart';

/// Страница начала основной игры
/// Портировано из start_actual_task_page.py
class StartActualTaskPage extends StatelessWidget {
  final UserInfo userInfo;

  const StartActualTaskPage({Key? key, required this.userInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const CustomTitle(
            text: 'Click to start!',
            borderColor: Colors.white,
          ),
          CustomNextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameProviderPage(userInfo: userInfo),
                ),
              );
            },
            borderColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
