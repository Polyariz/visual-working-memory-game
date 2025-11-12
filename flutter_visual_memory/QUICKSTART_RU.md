# 🚀 Быстрый старт - Игра на визуальную рабочую память

## Минимальные шаги для запуска

### 1️⃣ Установите Flutter (если не установлен)

#### Windows:
```bash
# Скачайте Flutter SDK: https://flutter.dev/docs/get-started/install/windows
# Распакуйте и добавьте в PATH

flutter doctor
```

#### macOS/Linux:
```bash
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

### 2️⃣ Перейдите в папку проекта

```bash
cd visual-working-memory-game/flutter_visual_memory
```

### 3️⃣ Установите зависимости

```bash
flutter pub get
```

### 4️⃣ Запустите приложение

```bash
# Для Android/iOS эмулятора или подключенного устройства
flutter run

# Для Web браузера
flutter run -d chrome

# Для Desktop (Windows/macOS/Linux)
flutter run -d windows  # или macos, или linux
```

### 5️⃣ Сборка готового приложения

```bash
# Android APK
flutter build apk --release

# Web
flutter build web

# Windows
flutter build windows
```

## 📱 Как играть

1. **Приветствие** → Нажмите "Next"
2. **Регистрация** → Заполните поля → "Next"
3. **Инструкция** → Прочитайте правила → "Next"
4. **Обучение** → 3 пробных раунда
5. **Игра** → 15 основных раундов

### Правила игры:

- **Фаза запоминания (2 сек):** Запомните ЖЕЛТЫЕ шестиугольники
- **Фаза ответа:** Кликните на запомненные позиции
- **Оценка:** ЗЕЛЁНЫЙ = правильно ✓, КРАСНЫЙ = неправильно ✗

## 🎯 Цель

Набрать счет 1.0 (100% правильных ответов)

---

**Полная документация:** [README_RU.md](README_RU.md)

**Приятной игры! 🎮**
