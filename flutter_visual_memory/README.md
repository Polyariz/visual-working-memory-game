# Visual Working Memory Game - Flutter

A complete port of the Visual Working Memory Game from Python/Pygame to Dart/Flutter.

## 🎮 About

This is a cognitive training game designed to improve visual working memory. The game uses hexagonal grids where players must memorize the positions of highlighted cells and recall them after a brief delay.

## ✨ Features

- **Dynamic Difficulty Adjustment (DDA)**: Automatically adapts game difficulty based on player performance
- **Cross-platform**: Works on Android, iOS, Web, Windows, macOS, and Linux
- **Data Collection**: Saves gameplay data in CSV format for analysis
- **Training Mode**: Includes guided practice rounds before the actual game
- **Responsive Design**: Adapts to different screen sizes

## 📚 Documentation

- **[Russian Documentation (Русская документация)](README_RU.md)** - Complete guide in Russian
- **[English Documentation](#quick-start)** - Quick start guide below

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.0 or higher
- Visual Studio Code (recommended)
- Flutter and Dart extensions for VS Code

### Installation

```bash
# Clone the repository
cd visual-working-memory-game/flutter_visual_memory

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Building for Production

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web

# Windows
flutter build windows

# macOS
flutter build macos

# Linux
flutter build linux
```

## 📱 How to Play

1. **Welcome Screen**: Tap "Next" to continue
2. **Sign Up**: Enter your information
3. **Instructions**: Read the game rules
4. **Training Rounds**: Practice with 3 guided trials
5. **Main Game**: Complete 15 rounds with dynamic difficulty
6. **Results**: View your performance statistics

### Game Mechanics

- **Memorization Phase (2 seconds)**: Yellow hexagons appear on a 6×6 grid
- **Recall Phase**: Grid turns white, click remembered positions
- **Feedback**: Green = correct, Red = incorrect
- **Scoring**: Score = correct clicks / total targets
- **Perfect Score**: 1.0 (all correct)

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── hexagon_tile.dart
│   └── user_info.dart
├── widgets/                  # Reusable widgets
│   ├── custom_button.dart
│   ├── custom_title.dart
│   └── custom_input.dart
├── screens/                  # App screens
│   ├── welcome_page.dart
│   ├── sign_up_page.dart
│   ├── guide_page.dart
│   └── start_actual_task_page.dart
└── game/                     # Game logic
    ├── task.dart
    ├── task_guiding.dart
    └── game_provider.dart
```

## 🔄 Porting Details

This Flutter version is a complete port from the original Python/Pygame implementation:

| Python Module | Flutter Equivalent |
|--------------|-------------------|
| `buttons.py` | `widgets/custom_*.dart` |
| `hexagon.py` | `models/hexagon_tile.dart` |
| `task.py` | `game/task.dart` |
| `task_guiding.py` | `game/task_guiding.dart` |
| `main_game.py` | `game/game_provider.dart` |
| `welcome_page.py` | `screens/welcome_page.dart` |
| `sign_up_page.py` | `screens/sign_up_page.dart` |
| `guid_page.py` | `screens/guide_page.dart` |

## 📊 Data Collection

Game data is automatically saved in CSV format including:
- User information
- Task parameters
- Response times
- Accuracy metrics
- Timestamps

Files are saved to the device's documents directory.

## 🛠️ Configuration

### Change Number of Rounds

In `screens/start_actual_task_page.dart`:
```dart
GameProviderPage(userInfo: userInfo, episodeLen: 15) // Change this number
```

### Adjust Memorization Time

In `game/task.dart` and `game/task_guiding.dart`:
```dart
showTime: 2, // Time in seconds
```

### Modify DDA Rules

In `game/game_provider.dart`:
```dart
if (score > 0.9 && score <= 1.0) {
  nTarget++; // Increase difficulty
} else if (score >= 0 && score < 0.7) {
  nTarget--; // Decrease difficulty
}
```

## 🧪 Testing

```bash
# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format lib/
```

## 📦 Dependencies

- `flutter`: SDK
- `path_provider`: File system access
- `csv`: CSV file handling
- `intl`: Internationalization
- `fl_chart`: Charts (optional)

## 🤝 Contributing

This is a port of the original Python/Pygame project. For contributions, please refer to the original repository.

## 📄 License

This project uses the same license as the original Python implementation.

## 🙏 Credits

**Original Author**: Masoud Rahimi
**Original Platform**: Python + Pygame
**Port**: Dart + Flutter

## 🔗 Links

- [Original Python/Pygame Project](https://github.com/masoudrahimi39/visual-working-memory-game)
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)

---

**For detailed Russian instructions, see [README_RU.md](README_RU.md)**
