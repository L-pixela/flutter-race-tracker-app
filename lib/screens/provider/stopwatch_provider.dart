import 'dart:async';
import 'package:flutter/foundation.dart';

class StopwatchProvider with ChangeNotifier {
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _timeDisplay = "00:00:00.00";

  bool _isRunning = false;
  bool _isPaused = false;

  StopwatchProvider() {
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (_stopwatch.isRunning) {
        _timeDisplay = _formatTime(_stopwatch.elapsedMilliseconds);
        notifyListeners();
      }
    });
  }

  String get timeDisplay => _timeDisplay;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;

  void start() {
    if (_isPaused) {
      _stopwatch.start(); // resume
    } else {
      _stopwatch.reset();
      _stopwatch.start(); // fresh start
    }
    _isRunning = true;
    _isPaused = false;
    notifyListeners();
  }

  void pause() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _isRunning = false;
      _isPaused = true;
      notifyListeners();
    }
  }

  void reset() {
    _stopwatch.reset();
    _timeDisplay = "00:00:00.00";
    _isRunning = false;
    _isPaused = false;
    notifyListeners();
  }

  String _formatTime(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds = twoDigits(duration.inMilliseconds.remainder(1000) ~/ 10);
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }
}
