import 'dart:async';

class QuizTimer {
  final int duration;
  int timeLeft;
  Timer? _timer;

  QuizTimer({required this.duration}) : timeLeft = duration;

  void start(Function onTick, Function onTimeout) {
    timeLeft = duration;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeLeft--;
      if (timeLeft <= 0) {
        _timer?.cancel();
        onTimeout();
      } else {
        onTick();
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }
}
