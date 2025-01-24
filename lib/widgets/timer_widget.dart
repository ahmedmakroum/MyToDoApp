import 'package:flutter/material.dart';
import 'dart:async';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTime);
  }

  // Update the UI every second
  void _updateTime(Timer timer) {
    if (_stopwatch.isRunning) {
      setState(() {});
    }
  }

  // Start or stop the timer
  void _toggleTimer() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
    setState(() {
      isRunning = _stopwatch.isRunning;
    });
  }

  // Reset the timer
  void _resetTimer() {
    _stopwatch.reset();
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the periodic timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = _stopwatch.elapsed;
    final seconds = duration.inSeconds % 60;
    final minutes = (duration.inSeconds / 60).floor() % 60;
    final hours = (duration.inSeconds / 3600).floor();

    return Column(
      children: [
        Text(
          "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _toggleTimer,
              child: Text(isRunning ? 'Stop' : 'Start'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _resetTimer,
              child: Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}
