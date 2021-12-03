import 'dart:ui';

class HexagonOutline {
  double strokeWidth;
  Color color;

  HexagonOutline({required this.strokeWidth, required this.color});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HexagonOutline &&
          strokeWidth == other.strokeWidth &&
          color == other.color;

  @override
  int get hashCode => strokeWidth.hashCode ^ color.hashCode;
}
