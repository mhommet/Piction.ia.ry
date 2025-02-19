import 'package:flutter/material.dart';
import '../screens/drawing_page_style.dart';

class DrawingPoint {
  final Offset point;
  final Paint paint;

  DrawingPoint({required this.point, required this.paint});
}

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<DrawingPoint> points = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DrawingPageStyle.canvasBackgroundColor,
        border: Border.all(
          color: DrawingPageStyle.canvasBorderColor,
          width: DrawingPageStyle.canvasBorderWidth,
        ),
      ),
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            points.add(
              DrawingPoint(
                point: details.localPosition,
                paint: Paint()
                  ..color = DrawingPageStyle.drawingColor
                  ..strokeWidth = DrawingPageStyle.strokeWidth
                  ..strokeCap = StrokeCap.round,
              ),
            );
          });
        },
        onPanUpdate: (details) {
          setState(() {
            points.add(
              DrawingPoint(
                point: details.localPosition,
                paint: Paint()
                  ..color = DrawingPageStyle.drawingColor
                  ..strokeWidth = DrawingPageStyle.strokeWidth
                  ..strokeCap = StrokeCap.round,
              ),
            );
          });
        },
        child: CustomPaint(
          painter: _DrawingPainter(points: points),
          child: const SizedBox(
            width: double.infinity,
            height: 300,
          ),
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;

  _DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(
        points[i].point,
        points[i + 1].point,
        points[i].paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) => true;
} 