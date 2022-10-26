import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class TimerWidget extends StatefulWidget {
  int current_step_duration;
  TimerWidget({Key? key, required this.current_step_duration})
      : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  bool _isRunning = true;
  final _controller = CountDownController();
  int addTwoMinutes = 0;

  @override
  Widget build(BuildContext context) {
    int stepDurationSeconds = widget.current_step_duration * (60 / 1).toInt();
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              child: CountDownProgressIndicator(
                controller: _controller,
                valueColor: Color(0xFFF2E5D9),
                backgroundColor: Color(0xFF12A2726),
                initialPosition: 0,
                duration: stepDurationSeconds + addTwoMinutes,
                timeFormatter: (seconds) {
                  return Duration(seconds: seconds)
                      .toString()
                      .split('.')[0]
                      .padLeft(8, '0');
                },
                onComplete: () => null,
                timeTextStyle: TextStyle(fontSize: 40),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF12A2726)),
              onPressed: () => setState(() {
                if (_isRunning) {
                  _controller.pause();
                } else {
                  _controller.resume();
                }

                _isRunning = !_isRunning;
              }),
              child: Text(
                _isRunning ? 'Pause' : 'Resume',
                style: TextStyle(color: Color(0xFFF2E5D9)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF12A2726)),
              onPressed: () => setState(() {
                //stepDurationSeconds += 300;
                addTwoMinutes += 120; //adds 2 mins (300s) to the time
              }),
              child: Text('+2 minutes', style: TextStyle(color: Color(0xFFF2E5D9)),),
            ),
          ],
        ),
      ),
    );
  }
}
