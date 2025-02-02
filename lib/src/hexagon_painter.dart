import 'package:flutter/material.dart';
import 'package:hexagon/src/hexagon_outline.dart';

import 'hexagon_path_builder.dart';

/// This class is responsible for painting HexagonWidget color and shadow in proper shape.
class HexagonPainter extends CustomPainter {
  HexagonPainter(this.pathBuilder,
      {this.color, this.elevation = 0, this.outline});

  final HexagonPathBuilder pathBuilder;
  final double elevation;
  final Color? color;
  final HexagonOutline? outline;

  final Paint _paint = Paint();
  Path? _path;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = color ?? Colors.white;
    _paint.isAntiAlias = true;
    _paint.style = PaintingStyle.fill;

    Path path = pathBuilder.build(size);
    _path = path;

    if ((elevation) > 0)
      canvas.drawShadow(path, Colors.black, elevation, false);
    canvas.drawPath(path, _paint);
    if (outline != null) {
      final _strokePaint = Paint();
      _strokePaint.color = outline!.color;
      _strokePaint.strokeWidth = outline!.strokeWidth;
      _strokePaint.style = PaintingStyle.stroke;
      canvas.drawPath(path, _strokePaint);
    }
  }

  @override
  bool hitTest(Offset position) {
    return _path?.contains(position) ?? false;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HexagonPainter &&
          runtimeType == other.runtimeType &&
          pathBuilder == other.pathBuilder &&
          elevation == other.elevation &&
          color == other.color &&
          outline == other.outline;

  @override
  int get hashCode =>
      pathBuilder.hashCode ^
      elevation.hashCode ^
      color.hashCode ^
      outline.hashCode;
}
