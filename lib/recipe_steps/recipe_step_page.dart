import 'package:elective_project/recipe_steps/step_indicator.dart';
import 'package:elective_project/recipe_steps/timer_widget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../util/colors.dart';
import 'finished_page.dart';

class RecipeStepPage extends StatefulWidget {
  RecipeStepPage(
      this.recipe_image,
      this.recipe_name,
      this.recipe_source,
      this.steps,
      this.steps_timer,
      this.total_steps_count,
      this.step_index,
      this.current_step,
      this.current_step_duration);

  String recipe_image;
  String recipe_name;
  String recipe_source;
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

    setState(() {
      FlutterRingtonePlayer.stop();
    });

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.recipe_name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "by ${widget.recipe_source}",
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          elevation: 0,
          foregroundColor: mBackgroundColor,
          centerTitle: true,
        ),
        //extendBodyBehindAppBar: true,
        backgroundColor: mBackgroundColor,
        body: Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                  child: Text("Step ${widget.step_index }", 
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: appBarColor)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      widget.step_index > 1
                    ? IconButton(
                        iconSize: 40,
                        onPressed: () => Navigator.of(context).pop(true),
                        icon: Icon(FluentIcons.arrow_circle_left_28_filled),
                      )
                    : Container(),
                widget.step_index < widget.steps.length
                    ? IconButton(
                        iconSize: 40,
                        onPressed: () => pushNewScreen(
                          context,
                          screen: RecipeStepPage(
                            widget.recipe_image,
                            widget.recipe_name,
                            widget.recipe_source,
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
                        icon: Icon(FluentIcons.arrow_circle_right_28_filled),
                      )
                    : IconButton(
                        iconSize: 40,
                        onPressed: () {
                          for (int i = widget.step_index;
                              i >= 0;
                              i--) {
                            print(widget.step_index);
                            Navigator.of(context).pop(true);
                          }
                          FlutterRingtonePlayer.stop;
                          pushNewScreen(
                            context,
                            screen: FinishedRecipePage(
                                widget.recipe_image, widget.recipe_name, widget.recipe_source),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        icon: Icon(FluentIcons.arrow_circle_right_28_filled),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: StepsIndicatorPage(
                      widget.step_index, widget.total_steps_count
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
