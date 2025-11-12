import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/welcome_page.dart';

/// Главный файл приложения Visual Working Memory Game
/// Портировано из main_game.py
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Устанавливаем полноэкранный режим
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Устанавливаем только горизонтальную ориентацию
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const VisualMemoryGameApp());
}

/// Основной класс приложения
class VisualMemoryGameApp extends StatelessWidget {
  const VisualMemoryGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visual Working Memory Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFD3D3D3),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Color(0xFF003B66)),
          bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF003B66)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      home: const WelcomePage(),
    );
  }
}
