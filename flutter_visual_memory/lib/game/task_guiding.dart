import 'dart:async';
import 'package:flutter/material.dart';
import '../models/hexagon_tile.dart';
import '../models/user_info.dart';
import '../widgets/custom_title.dart';
import '../screens/start_actual_task_page.dart';
import 'task.dart';

/// Страница с обучающими заданиями
/// Портировано из task_guiding.py
class TaskGuidingPage extends StatefulWidget {
  final UserInfo userInfo;

  const TaskGuidingPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<TaskGuidingPage> createState() => _TaskGuidingPageState();
}

class _TaskGuidingPageState extends State<TaskGuidingPage> {
  int currentGuidingIndex = 0;
  final List<List<int>> guidingTasks = [
    [1, 4, 13],
    [9, 12, 17, 21, 23],
    [3, 4, 9, 10, 15, 16, 20],
  ];

  @override
  void initState() {
    super.initState();
    // Автоматически начинаем первое обучающее задание
    Future.microtask(() => _startNextGuidingTask());
  }

  void _startNextGuidingTask() {
    if (currentGuidingIndex < guidingTasks.length) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskGuidingWidget(
            indicesTarget: guidingTasks[currentGuidingIndex],
            userInfo: widget.userInfo,
            onComplete: () {
              setState(() {
                currentGuidingIndex++;
              });
              if (currentGuidingIndex < guidingTasks.length) {
                _startNextGuidingTask();
              } else {
                // Переход к странице начала основной игры
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StartActualTaskPage(userInfo: widget.userInfo),
                  ),
                );
              }
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Виджет для обучающей задачи
class TaskGuidingWidget extends StatefulWidget {
  final List<int> indicesTarget;
  final UserInfo userInfo;
  final VoidCallback onComplete;

  const TaskGuidingWidget({
    Key? key,
    required this.indicesTarget,
    required this.userInfo,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<TaskGuidingWidget> createState() => _TaskGuidingWidgetState();
}

class _TaskGuidingWidgetState extends State<TaskGuidingWidget> {
  late List<HexagonTile> hexagons;
  late TaskParameters taskParams;
  bool isMemorizationPhase = true;
  Set<int> clickedHexagonIds = {};
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    _startMemorizationPhase();
  }

  void _startMemorizationPhase() {
    // Начало фазы запоминания
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isMemorizationPhase = false;
        });
      }
    });
  }

  void _handleTap(TapDownDetails details) {
    if (isMemorizationPhase || isCompleted) return;

    final localPosition = details.localPosition;

    for (var hexagon in hexagons) {
      if (hexagon.collideWithPoint(localPosition) &&
          !clickedHexagonIds.contains(hexagon.index)) {
        setState(() {
          clickedHexagonIds.add(hexagon.index);
        });

        if (clickedHexagonIds.length == widget.indicesTarget.length) {
          isCompleted = true;
          Timer(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pop(context);
              widget.onComplete();
            }
          });
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    taskParams = TaskParameters.fromScreenSize(screenSize);

    // Создаем шестиугольники
    hexagons = _createHexagons();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const CustomTitle(
            text: 'guiding trials',
            borderColor: Colors.white,
          ),
          GestureDetector(
            onTapDown: _handleTap,
            child: CustomPaint(
              painter: HexagonPainter(
                hexagons: hexagons,
                isMemorizationPhase: isMemorizationPhase,
              ),
              size: screenSize,
            ),
          ),
        ],
      ),
    );
  }

  List<HexagonTile> _createHexagons() {
    final hexagons = <HexagonTile>[];
    int hexCounter = 0;
    const numX = 6;
    const numY = 6;

    bool temp = widget.indicesTarget.contains(0);
    var leftmostHexagon = HexagonTile(
      isTargetCell: temp,
      position: taskParams.positionInit,
      index: hexCounter,
      radius: taskParams.rHexagon,
    );
    hexagons.add(leftmostHexagon);

    for (int x = 0; x < numY; x++) {
      if (x > 0) {
        int index = x % 2 == 1 ? 2 : 4;
        Offset position = leftmostHexagon.vertices[index];

        bool isTargetCell = widget.indicesTarget.contains(hexCounter);
        leftmostHexagon = HexagonTile(
          isTargetCell: isTargetCell,
          position: position,
          index: hexCounter,
          radius: taskParams.rHexagon,
        );
        hexagons.add(leftmostHexagon);
        hexCounter++;
      } else {
        hexCounter++;
      }

      var hexagon = leftmostHexagon;

      for (int i = 1; i < numX; i++) {
        double x = hexagon.position.dx;
        double y = hexagon.position.dy;
        Offset position = Offset(x + hexagon.minimalRadius * 2, y);

        bool isTargetCell = widget.indicesTarget.contains(hexCounter);
        hexagon = HexagonTile(
          isTargetCell: isTargetCell,
          position: position,
          index: hexCounter,
          radius: taskParams.rHexagon,
        );
        hexagons.add(hexagon);
        hexCounter++;
      }
    }

    return hexagons;
  }
}

/// Painter для отрисовки шестиугольников
class HexagonPainter extends CustomPainter {
  final List<HexagonTile> hexagons;
  final bool isMemorizationPhase;

  HexagonPainter({
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
