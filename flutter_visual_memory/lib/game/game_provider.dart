import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/hexagon_tile.dart';
import '../models/user_info.dart';
import '../widgets/custom_title.dart';
import 'task.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Основной провайдер игры с правилами DDA (Dynamic Difficulty Adjustment)
/// Портировано из main_game.py
class GameProviderPage extends StatefulWidget {
  final UserInfo userInfo;
  final int episodeLen;

  const GameProviderPage({
    Key? key,
    required this.userInfo,
    this.episodeLen = 15,
  }) : super(key: key);

  @override
  State<GameProviderPage> createState() => _GameProviderPageState();
}

class _GameProviderPageState extends State<GameProviderPage> {
  int currentStep = 0;
  int nTarget = 5;
  List<double> scoreList = [];
  List<Map<String, dynamic>> gamePlayDataList = [];
  bool isGameComplete = false;

  @override
  void initState() {
    super.initState();
    _startNextTask();
  }

  void _startNextTask() {
    if (currentStep < widget.episodeLen) {
      // Ограничиваем количество целей от 4 до 14
      nTarget = nTarget.clamp(4, 14);

      // Ячейки, которые могут быть целевыми (исключая края)
      final canBeTargetCell = <int>{
        for (int i = 0; i < 36; i++)
          if (![0, 5, 8, 9, 11, 17, 20, 22, 30, 33, 35].contains(i)) i
      };

      // Выбираем случайные целевые ячейки
      final indicesOne = _randomSample(canBeTargetCell.toList(), nTarget);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskWidget(
            indicesTarget: indicesOne,
            userInfo: widget.userInfo,
            taskNumber: currentStep,
            onComplete: (score, taskData) {
              setState(() {
                scoreList.add(score);
                gamePlayDataList.add(taskData);
                currentStep++;

                // Регулировка сложности на основе счета
                if (score > 0.9 && score <= 1.0) {
                  nTarget++;
                } else if (score >= 0 && score < 0.7) {
                  nTarget--;
                }
              });

              if (currentStep < widget.episodeLen) {
                _startNextTask();
              } else {
                _completeGame();
              }
            },
          ),
        ),
      );
    }
  }

  List<int> _randomSample(List<int> list, int k) {
    final random = Random();
    final result = <int>[];
    final tempList = List<int>.from(list);

    for (int i = 0; i < k && tempList.isNotEmpty; i++) {
      final index = random.nextInt(tempList.length);
      result.add(tempList.removeAt(index));
    }

    return result;
  }

  Future<void> _completeGame() async {
    setState(() {
      isGameComplete = true;
    });

    // Сохраняем данные игры
    await _saveGameData();

    // Показываем результаты
    if (mounted) {
      _showResultsDialog();
    }
  }

  Future<void> _saveGameData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final filePath = '${directory.path}/game_data_$timestamp.csv';

      final file = File(filePath);
      final buffer = StringBuffer();

      // Заголовки CSV
      if (gamePlayDataList.isNotEmpty) {
        final keys = gamePlayDataList[0].keys;
        buffer.writeln(keys.join(','));

        // Данные
        for (var data in gamePlayDataList) {
          final values = data.values.map((v) => v.toString()).join(',');
          buffer.writeln(values);
        }
      }

      await file.writeAsString(buffer.toString());
      print('Game data saved to: $filePath');
    } catch (e) {
      print('Error saving game data: $e');
    }
  }

  void _showResultsDialog() {
    final avgScore = scoreList.isEmpty
        ? 0.0
        : scoreList.reduce((a, b) => a + b) / scoreList.length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Игра завершена!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Всего раундов: ${scoreList.length}'),
            const SizedBox(height: 10),
            Text('Средний счет: ${avgScore.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            Text('Лучший счет: ${scoreList.isEmpty ? 0 : scoreList.reduce(max).toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            Text('Худший счет: ${scoreList.isEmpty ? 0 : scoreList.reduce(min).toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Вернуться на главную'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isGameComplete) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text('Обработка результатов...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Раунд ${currentStep + 1} из ${widget.episodeLen}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Виджет для отдельной задачи
class TaskWidget extends StatefulWidget {
  final List<int> indicesTarget;
  final UserInfo userInfo;
  final int taskNumber;
  final Function(double score, Map<String, dynamic> taskData) onComplete;

  const TaskWidget({
    Key? key,
    required this.indicesTarget,
    required this.userInfo,
    required this.taskNumber,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  Task? task;
  late TaskParameters taskParams;
  bool isMemorizationPhase = true;
  Set<int> clickedHexagonIds = {};
  bool isCompleted = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _startMemorizationPhase();
  }

  void _startMemorizationPhase() {
    // Получаем параметры задачи на основе размера экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      taskParams = TaskParameters.fromScreenSize(screenSize);

      setState(() {
        task = Task(
          indicesTarget: widget.indicesTarget,
          ddaMethod: 'rule-base',
          userInfo: widget.userInfo,
          numX: 6,
          numY: 6,
          showTime: 2,
          positionInit: taskParams.positionInit,
          rHexagon: taskParams.rHexagon,
          taskNumber: widget.taskNumber,
        );

        task!.startShowingTaskTs = DateTime.now();
      });

      // Фаза запоминания - 2 секунды
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            task!.endShowingTaskTs = DateTime.now();
            task!.startAnsweringTs = DateTime.now();
            isMemorizationPhase = false;
          });
        }
      });
    });
  }

  void _handleTap(TapDownDetails details) {
    if (isMemorizationPhase || isCompleted || task == null) return;

    final localPosition = details.localPosition;
    final currentTime = DateTime.now();

    for (var hexagon in task!.hexagons) {
      if (hexagon.collideWithPoint(localPosition) &&
          !clickedHexagonIds.contains(hexagon.index)) {
        setState(() {
          // Добавляем время отклика
          if (clickedHexagonIds.isEmpty) {
            task!.sequenceResponseTime.add(
              currentTime.difference(task!.startAnsweringTs!).inMilliseconds /
                  1000.0,
            );
          } else {
            final lastClickTime = task!.startAnsweringTs!.add(
              Duration(
                milliseconds: (task!.sequenceResponseTime
                            .reduce((a, b) => a + b) *
                        1000)
                    .toInt(),
              ),
            );
            task!.sequenceResponseTime.add(
              currentTime.difference(lastClickTime).inMilliseconds / 1000.0,
            );
          }

          // Добавляем индекс ответа
          task!.indicesAnswer.add(hexagon.index);
          clickedHexagonIds.add(hexagon.index);

          // Добавляем в последовательность ответов
          if (hexagon.isAnsweredTrue == true) {
            task!.sequenceAnswer.add(1);
          } else if (hexagon.isAnsweredTrue == false) {
            task!.sequenceAnswer.add(0);
          }
        });

        // Проверяем, завершена ли задача
        if (clickedHexagonIds.length == widget.indicesTarget.length) {
          isCompleted = true;
          task!.endOfTask();

          Timer(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pop(context);
              widget.onComplete(task!.score!, task!.toMap());
            }
          });
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Если задача еще не инициализирована, показываем индикатор загрузки
    if (task == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomTitle(
            text: isMemorizationPhase
                ? 'Запомните жёлтые ячейки!'
                : 'Кликните на запомненные позиции',
            borderColor: Colors.white,
            fontRatioToScreen: 30,
          ),
          GestureDetector(
            onTapDown: _handleTap,
            child: CustomPaint(
              painter: HexagonTaskPainter(
                hexagons: task!.hexagons,
                isMemorizationPhase: isMemorizationPhase,
              ),
              size: screenSize,
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter для отрисовки шестиугольников задачи
class HexagonTaskPainter extends CustomPainter {
  final List<HexagonTile> hexagons;
  final bool isMemorizationPhase;

  HexagonTaskPainter({
    required this.hexagons,
    required this.isMemorizationPhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var hexagon in hexagons) {
      if (isMemorizationPhase) {
        hexagon.render(canvas, paint);
      } else {
        hexagon.renderAnswer(canvas, paint);
      }
      hexagon.renderBorder(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
