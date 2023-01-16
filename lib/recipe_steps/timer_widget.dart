import 'package:audioplayers/audioplayers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../util/colors.dart';

class TimerWidget extends StatefulWidget {
  int current_step_duration;
  TimerWidget({Key? key, required this.current_step_duration})
      : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  bool _isRunning = true;
  bool _isFinished = false;
  final CountDownController _controller = CountDownController();
  int addTwoMinutes = 0;

  @override
  Widget build(BuildContext context) {
    Color iconTextColor = Colors.white;

    int stepDurationSeconds = widget.current_step_duration;

    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: NeonCircularTimer(
                width: 200,
                duration: stepDurationSeconds,
                controller: _controller,
                isTimerTextShown: true,
                neumorphicEffect: true,
                backgroudColor: _isFinished
                    ? Color.fromARGB(255, 170, 53, 67)
                    : Colors.white54,
                isReverse: true,
                innerFillGradient:
                    LinearGradient(colors: [appBarColor, appBarColor]),
                neonGradient:
                    LinearGradient(colors: [appBarColor, appBarColor]),
                onComplete: () => setState(() {
                  _isFinished = !_isFinished;
                  FlutterRingtonePlayer.play(
                    fromAsset: "audio/microwave-timer.wav",
                    looping: false, // Android only - API >= 28
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          int remainingSeconds = _controller.getTimeInSeconds();
                          if (remainingSeconds <= 0) {
                            _isFinished = !_isFinished;
                          }
                          _controller.restart();
                        });
                        print(_isFinished);
                      },
                      icon: Icon(
                        FluentIcons.arrow_reset_24_filled,
                        color: iconTextColor,
                      ),
                      iconSize: 35,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: IconButton(
                      onPressed: () => setState(() {
                        if (_isRunning) {
                          _controller.pause();
                          //FlutterRingtonePlayer.stop();
                        } else {
                          _controller.resume();
                          //FlutterRingtonePlayer.play();
                        }

                        _isRunning = !_isRunning;
                      }),
                      icon: _isRunning
                          ? Icon(
                              FluentIcons.pause_24_filled,
                              color: iconTextColor,
                            )
                          : Icon(
                              FluentIcons.play_24_filled,
                              color: iconTextColor,
                            ),
                      iconSize: 35,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          //stepDurationSeconds += 300;
                          addTwoMinutes += 120; //adds 2 mins (120s) to the time
                          int remainingSeconds = _controller.getTimeInSeconds();
                          if (remainingSeconds <= 0) {
                            _isFinished = !_isFinished;
                          }
                          _controller.restart(
                              duration: remainingSeconds + addTwoMinutes);
                        });
                        Fluttertoast.showToast(
                            msg: "Extended 2 minutes",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 1,
                            backgroundColor: splashScreenBgColor,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      icon: Icon(
                        FluentIcons.timer_2_24_filled,
                        color: iconTextColor,
                      ),
                      iconSize: 35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
