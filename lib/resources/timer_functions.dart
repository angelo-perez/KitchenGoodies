class TimerFunctions {
  int timerToSecs(String value) {
    List durationList =
        value.split(':').map((duration) => int.parse(duration)).toList();
    int hour = durationList[0];
    int min = durationList[1];
    int sec = durationList[2];
    int totalTimeInSec =
        Duration(hours: hour, minutes: min, seconds: sec).inSeconds;

    // print(durationList);
    // print(totalTimeInSec);
    return totalTimeInSec;
  }

  String timerToDisplay(int timeInSecs) {
    format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
    Duration duration = Duration(seconds: timeInSecs, );
    return format(duration);
  }
}