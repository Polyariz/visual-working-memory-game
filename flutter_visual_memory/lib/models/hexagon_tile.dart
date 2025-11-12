import 'dart:math';
import 'package:flutter/material.dart';

/// Класс для представления шестиугольной плитки в игре
/// Портировано из hexagon.py
class HexagonTile {
  final bool isTargetCell;
  final Offset position;
  final int index;
  final double radius;
  bool isClickedAsAnswer;
  bool? isAnsweredTrue;
  Color clrAnswer;
  late Color clrHex;
  late List<Offset> vertices;

  HexagonTile({
    required this.isTargetCell,
    required this.position,
    required this.index,
    required this.radius,
    this.isClickedAsAnswer = false,
    this.isAnsweredTrue,
    this.clrAnswer = Colors.white,
  }) {
    clrHex = isTargetCell ? const Color(0xFFFFD700) : Colors.white; // Gold or White
    vertices = computeVertices();
  }

  /// Вычисляет вершины шестиугольника
  List<Offset> computeVertices() {
    final x = position.dx;
    final y = position.dy;
    final halfRadius = radius / 2;
    final minimalRadius = this.minimalRadius;

    return [
      Offset(x, y),
      Offset(x - minimalRadius, y + halfRadius),
      Offset(x - minimalRadius, y + 3 * halfRadius),
      Offset(x, y + 2 * radius),
      Offset(x + minimalRadius, y + 3 * halfRadius),
      Offset(x + minimalRadius, y + halfRadius),
    ];
  }

  /// Проверяет столкновение с точкой (клик мыши)
  bool collideWithPoint(Offset point) {
    final distance = sqrt(
      pow(point.dx - centre.dx, 2) + pow(point.dy - centre.dy, 2),
    );

    if (distance < minimalRadius) {
      isClickedAsAnswer = true;
      if (isTargetCell) {
        isAnsweredTrue = true;
        clrAnswer = Colors.green;
      } else {
        isAnsweredTrue = false;
        clrAnswer = Colors.red;
      }
      return true;
    }
    return false;
  }

  /// Отрисовка шестиугольника
  void render(Canvas canvas, Paint paint) {
    paint.color = highlightColor;
    paint.style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(vertices[0].dx, vertices[0].dy);
    for (int i = 1; i < vertices.length; i++) {
      path.lineTo(vertices[i].dx, vertices[i].dy);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  /// Отрисовка ответа (с цветом правильного/неправильного ответа)
  void renderAnswer(Canvas canvas, Paint paint) {
    paint.color = clrAnswer;
    paint.style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(vertices[0].dx, vertices[0].dy);
    for (int i = 1; i < vertices.length; i++) {
      path.lineTo(vertices[i].dx, vertices[i].dy);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  /// Отрисовка границы шестиугольника
  void renderBorder(Canvas canvas, {Color borderColor = Colors.black}) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();
    path.moveTo(vertices[0].dx, vertices[0].dy);
    for (int i = 1; i < vertices.length; i++) {
      path.lineTo(vertices[i].dx, vertices[i].dy);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  /// Центр шестиугольника
  Offset get centre => Offset(position.dx, position.dy + radius);

  /// Минимальный радиус (горизонтальная длина)
  double get minimalRadius => radius * cos(pi / 6); // cos(30°)

  /// Цвет подсветки
  Color get highlightColor => clrHex;
}
