import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends ConsumerStatefulWidget {
  final VoidCallback onCountdownComplete;
  final int duration;
  final double? marginTop;

  const Counter(
      {super.key,
      required this.onCountdownComplete,
      required this.duration,
      this.marginTop});

  @override
  CounterState createState() => CounterState();
}

class CounterState extends ConsumerState<Counter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.duration;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
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
        widget.marginTop != null
            ? SizedBox(height: widget.marginTop)
            : SizedBox(height: 0),
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

    canvas.drawCircle(center, radius, backgroundPaint);

    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
