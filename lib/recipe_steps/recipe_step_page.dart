import 'package:elective_project/recipe_steps/step_indicator.dart';
import 'package:elective_project/recipe_steps/timer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'finished_page.dart';

class RecipeStepPage extends StatefulWidget {
  RecipeStepPage(
      this.recipe_image,
      this.recipe_name,
      this.steps,
      this.steps_timer,
      this.total_steps_count,
      this.step_index,
      this.current_step,
      this.current_step_duration);

  String recipe_image;
  String recipe_name;
  List steps;
  List steps_timer;
  int total_steps_count;
  int step_index;
  String current_step;
  int current_step_duration;

  @override
  State<RecipeStepPage> createState() => _RecipeStepPageState();
}

class _RecipeStepPageState extends State<RecipeStepPage> {
  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit the recipe\'s procedure?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    FlutterRingtonePlayer.stop();
                    for (int i = widget.step_index; i >= 0; i--) {
                      print(widget.step_index);
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    if (widget.step_index < widget.total_steps_count) {
      widget.step_index++;
    }

    FlutterRingtonePlayer.stop();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF12A2726),
        ),
        backgroundColor: Color(0xFFF2E5D9),
        body: Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    widget.steps[widget.step_index - 1],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                (widget.current_step_duration > 0)
                    ? TimerWidget(
                        current_step_duration: widget.current_step_duration)
                    : Container(),
                widget.step_index > 1
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF12A2726)),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          'Prev',
                          style: TextStyle(color: Color(0xFFF2E5D9)),
                        ),
                      )
                    : Container(),
                widget.step_index < widget.steps.length
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF12A2726)),
                        onPressed: () => pushNewScreen(
                          context,
                          screen: RecipeStepPage(
                            widget.recipe_image,
                            widget.recipe_name,
                            widget.steps,
                            widget.steps_timer,
                            widget.total_steps_count,
                            widget.step_index,
                            widget.steps[widget.step_index],
                            widget.steps_timer[widget.step_index],
                          ),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(color: Color(0xFFF2E5D9)),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF12A2726)),
                        onPressed: () {
                          FlutterRingtonePlayer.stop();
                          pushNewScreen(
                            context,
                            screen: FinishedRecipePage(
                                widget.recipe_image, widget.recipe_name),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(color: Color(0xFFF2E5D9)),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: StepsIndicatorPage(
                      widget.step_index, widget.total_steps_count),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
