import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizStartTimer extends ConsumerStatefulWidget {
  final VoidCallback onCountdownComplete;

  const QuizStartTimer({super.key, required this.onCountdownComplete});

  @override
  QuizStartTimerState createState() => QuizStartTimerState();
}

class QuizStartTimerState extends ConsumerState<QuizStartTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  int _counter = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        widget.onCountdownComplete();
      } else {
        setState(() {
          _counter = (5 - (_controller.value * 5).floor());
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 16),
        SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(
            painter: CirclePainter(_progressAnimation.value),
            child: Center(
              child: Text(
                _counter > 0 ? _counter.toString() : '',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;

  CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.orange, Colors.deepOrangeAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ))
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start angle (12 o'clock position)
      sweepAngle, // Sweep angle (counterclockwise)
      false, // Do not draw as a filled arc
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint to reflect changes in the timer
  }
}