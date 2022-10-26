import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StepsIndicatorPage extends StatefulWidget {
  StepsIndicatorPage(this.step_index, this.total_steps_count);

  int step_index;
  int total_steps_count;

  @override
  State<StepsIndicatorPage> createState() => _StepsIndicatorPageState();
}

class _StepsIndicatorPageState extends State<StepsIndicatorPage> {
  late int numSteps;
  late double stepPercent;
  @override
  Widget build(BuildContext context) {
    numSteps = widget.total_steps_count;
    stepPercent = widget.step_index / numSteps;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 500,
              percent: stepPercent,
              center: Text(
                "${widget.step_index}/${numSteps}",
                style: TextStyle(color: Colors.white),
              ),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Color(0xFF12A2726),
            ),
          ),
        ],
      ),
    );
  }
}
