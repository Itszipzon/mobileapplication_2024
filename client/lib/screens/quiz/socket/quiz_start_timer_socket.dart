import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizStartTimer extends ConsumerStatefulWidget {
  final VoidCallback onCountdownComplete;

  const QuizStartTimer({super.key, required this.onCountdownComplete});

  @override
  QuizStartTimerState createState() => QuizStartTimerState();
}

class QuizStartTimerState extends ConsumerState<QuizStartTimer> {
  int _counter = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer?.cancel();
          widget.onCountdownComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Game starting in:'),
            Text(_counter.toString()),
          ],
        ),
      ),
    );
  }
}