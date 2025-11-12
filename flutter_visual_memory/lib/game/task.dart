import 'dart:math';
import 'package:flutter/material.dart';
import '../models/hexagon_tile.dart';
import '../models/user_info.dart';

/// Класс для представления задачи в игре
/// Портировано из task.py
class Task {
  final List<int> indicesTarget;
  final String ddaMethod;
  final UserInfo userInfo;
  final double? difficulty;
  final int numX;
  final int numY;
  final int showTime;
  final Offset positionInit;
  final double rHexagon;
  final bool isEyeTracker;
  final int taskNumber;

  late List<HexagonTile> hexagons;
  late int nTarget;

  // Атрибуты, основанные на ответе пользователя
  DateTime? startShowingTaskTs;
  DateTime? endShowingTaskTs;
  DateTime? startAnsweringTs;
  DateTime? endAnsweringTs;
  List<int> indicesAnswer = [];
  List<int> sequenceAnswer = [];
  List<double> sequenceResponseTime = [];
  int? numTrue;
  int? numFalse;
  bool? isWined;
  double? score;

  Task({
    required this.indicesTarget,
    required this.ddaMethod,
    required this.userInfo,
    this.difficulty,
    required this.numX,
    required this.numY,
    required this.showTime,
    required this.positionInit,
    required this.rHexagon,
    this.isEyeTracker = false,
    required this.taskNumber,
  }) {
    nTarget = indicesTarget.length;
    hexagons = createTask(rHexagon);
  }

  /// Создает шестиугольную сетку
  List<HexagonTile> createTask(double rHexagon) {
    final hexagons = <HexagonTile>[];
    int hexCounter = 0;

    // Определяем, является ли первая ячейка целевой
    bool temp = indicesTarget.contains(0);
    var leftmostHexagon = HexagonTile(
      isTargetCell: temp,
      position: positionInit,
      index: hexCounter,
      radius: rHexagon,
    );
    hexagons.add(leftmostHexagon);

    // Итерация по строкам
    for (int x = 0; x < numY; x++) {
      if (x > 0) {
        // Чередуем между нижней левой и нижней правой вершинами шестиугольника выше
        int index = x % 2 == 1 ? 2 : 4;
        Offset position = leftmostHexagon.vertices[index];

        // Определяем, является ли текущая ячейка целевой
        bool isTargetCell = indicesTarget.contains(hexCounter);
        leftmostHexagon = HexagonTile(
          isTargetCell: isTargetCell,
          position: position,
          index: hexCounter,
          radius: rHexagon,
        );
        hexagons.add(leftmostHexagon);
        hexCounter++;
      } else {
        hexCounter++;
      }

      // Размещаем шестиугольники слева от самого левого шестиугольника
      var hexagon = leftmostHexagon;

      // Итерация по столбцам
      for (int i = 1; i < numX; i++) {
        double x = hexagon.position.dx;
        double y = hexagon.position.dy;
        Offset position = Offset(x + hexagon.minimalRadius * 2, y);

        // Определяем, является ли текущая ячейка целевой
        bool isTargetCell = indicesTarget.contains(hexCounter);
        hexagon = HexagonTile(
          isTargetCell: isTargetCell,
          position: position,
          index: hexCounter,
          radius: rHexagon,
        );
        hexagons.add(hexagon);
        hexCounter++;
      }
    }

    return hexagons;
  }

  /// Обработка завершения задачи
  void endOfTask() {
    endAnsweringTs = DateTime.now();
    numTrue = sequenceAnswer.where((x) => x == 1).length;
    numFalse = sequenceAnswer.where((x) => x == 0).length;
    isWined = numTrue == nTarget;
    score = numTrue! / nTarget;
  }

  /// Конвертация в Map для сохранения
  Map<String, dynamic> toMap() {
    return {
      'indices_target': indicesTarget,
      'dda_method': ddaMethod,
      'difficulty': difficulty,
      'num_x': numX,
      'num_y': numY,
      'show_time': showTime,
      'n_target': nTarget,
      'start_showing_task_ts': startShowingTaskTs?.toIso8601String(),
      'end_showing_task_ts': endShowingTaskTs?.toIso8601String(),
      'start_answering_ts': startAnsweringTs?.toIso8601String(),
      'end_answering_ts': endAnsweringTs?.toIso8601String(),
      'indices_answer': indicesAnswer,
      'sequence_answer': sequenceAnswer,
      'sequence_response_time': sequenceResponseTime,
      'num_true': numTrue,
      'num_false': numFalse,
      'is_wined': isWined,
      'score': score,
      'task_number': taskNumber,
      ...userInfo.toMap(),
    };
  }
}

/// Вычисляет параметры задачи на основе размера экрана
class TaskParameters {
  final Offset positionInit;
  final double rHexagon;

  TaskParameters({required this.positionInit, required this.rHexagon});

  static TaskParameters fromScreenSize(Size screenSize,
      {int numX = 6, int numY = 6}) {
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final rHexagon = screenWidth / 25;
    final dHexagon = 2 * rHexagon * cos(pi / 6); // cos(30°)

    final positionInit = Offset(
      screenWidth / 2 - (numX - 1.5) / 2 * dHexagon,
      screenHeight / 2 - (numY - 0.5) * rHexagon,
    );

    return TaskParameters(positionInit: positionInit, rHexagon: rHexagon);
  }
}
