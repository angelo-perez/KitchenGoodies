import 'package:elective_project/recipe_steps/step_indicator.dart';
import 'package:elective_project/recipe_steps/timer_widget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../util/colors.dart';
import '../recipes_page/finished_page.dart';

class RecipeStepPage extends StatefulWidget {
  RecipeStepPage(
      this.recipeId,
      this.collection_name,
      this.recipe_image,
      this.recipe_name,
      this.recipe_source,
      this.steps,
      this.steps_timer,
      this.total_steps_count,
      this.step_index,
      this.current_step,
      this.current_step_duration,
      this.recipe_rating,
      this.recipe_type);

  String recipeId;
  String collection_name;
  String recipe_image;
  String recipe_name;
  String recipe_source;
  List steps;
  List steps_timer;
  int total_steps_count;
  int step_index;
  String current_step;
  int current_step_duration;
  List recipe_rating;
  String recipe_type;

  @override
  State<RecipeStepPage> createState() => _RecipeStepPageState();
}

bool _isTtsEnabled = true;

class _RecipeStepPageState extends State<RecipeStepPage> {
  final FlutterTts stepTextToSpeech = FlutterTts();

  speak(int stepNumber, String step) async {
    await stepTextToSpeech.setLanguage("en-US");
    await stepTextToSpeech.setPitch(1); //voice pitch of the speaker
    await stepTextToSpeech.setSpeechRate(0.5);
    await stepTextToSpeech.speak("Step ${stepNumber}, ${step}");
  }

  @override
  Widget build(BuildContext context) {
    Color iconTextColor = Colors.white;

    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit the recipe\'s procedure?'),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      Color.fromARGB(51, 42, 39, 38),
                    ),
                  ),
                  onPressed: () {
                    // FlutterRingtonePlayer.stop();
                    stepTextToSpeech.stop();
                    for (int i = widget.step_index; i >= 0; i--) {
                      print(widget.step_index);
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: new Text(
                    'Yes',
                    style: TextStyle(color: mPrimaryColor),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      Color.fromARGB(51, 42, 39, 38),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text(
                    'No',
                    style: TextStyle(color: mPrimaryColor),
                  ),
                ),
              ],
            ),
          )) ??
          false;
    }

    if (widget.step_index < widget.total_steps_count) {
      widget.step_index++;
    }

    // setState(() {
    //   FlutterRingtonePlayer.stop();
    // });

    if (_isTtsEnabled) {
      speak(widget.step_index, widget.current_step);
    } else {
      stepTextToSpeech.stop();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: mBackgroundColor,
            ),
            onPressed: () => _onWillPop(),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  widget.step_index--;
                  _isTtsEnabled = !_isTtsEnabled;
                  if (_isTtsEnabled) {
                    speak(widget.step_index, widget.current_step);
                  } else {
                    stepTextToSpeech.stop();
                  }
                });
              },
              icon: _isTtsEnabled
                  ? Icon(Icons.spatial_audio_off)
                  : Icon(Icons.spatial_audio_off_outlined),
            ),
          ],
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
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.normal),
              ),
            ],
          ),
          elevation: 0,
          foregroundColor: mBackgroundColor,
          centerTitle: true,
        ),
        //extendBodyBehindAppBar: true,
        backgroundColor: appBarColor,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: widget.recipe_image != null
              ? BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.recipe_image),
                      fit: BoxFit.cover,
                      opacity: 175),
                )
              : BoxDecoration(),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                    child: Text("Step ${widget.step_index}",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: iconTextColor)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                    child: Text(
                      widget.steps[widget.step_index - 1],
                      style: TextStyle(fontSize: 20, color: iconTextColor),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.step_index > 1
                            ? IconButton(
                                iconSize: 50,
                                onPressed: () {
                                  widget.step_index--;
                                  stepTextToSpeech.stop();
                                  if (_isTtsEnabled) {
                                    speak(
                                        widget.step_index,
                                        widget.steps[widget.steps
                                                .indexOf(widget.current_step) -
                                            1]);
                                  }
                                  Navigator.of(context).pop(true);
                                },
                                icon: Icon(
                                  FluentIcons.arrow_circle_left_28_filled,
                                  color: iconTextColor,
                                ),
                              )
                            : Container(),
                        widget.step_index > 1
                            ? SizedBox(
                                width: 170,
                              )
                            : SizedBox(
                                width: 0,
                              ),
                        widget.step_index < widget.steps.length
                            ? IconButton(
                                iconSize: 50,
                                onPressed: () {
                                  stepTextToSpeech.stop();

                                  pushNewScreen(
                                    context,
                                    screen: RecipeStepPage(
                                        widget.recipeId,
                                        widget.collection_name,
                                        widget.recipe_image,
                                        widget.recipe_name,
                                        widget.recipe_source,
                                        widget.steps,
                                        widget.steps_timer,
                                        widget.total_steps_count,
                                        widget.step_index,
                                        widget.steps[widget.step_index],
                                        widget.steps_timer[widget.step_index],
                                        widget.recipe_rating,
                                        widget.recipe_type),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.fade,
                                  );
                                },
                                icon: Icon(
                                  FluentIcons.arrow_circle_right_28_filled,
                                  color: iconTextColor,
                                ),
                              )
                            : IconButton(
                                iconSize: 50,
                                onPressed: () {
                                  stepTextToSpeech.stop();

                                  for (int i = widget.step_index; i >= 0; i--) {
                                    print(widget.step_index);
                                    Navigator.of(context).pop(true);
                                  }
                                  // FlutterRingtonePlayer.stop;
                                  pushNewScreen(
                                    context,
                                    screen: FinishedRecipePage(
                                      widget.recipeId,
                                      widget.collection_name,
                                      widget.recipe_image,
                                      widget.recipe_name,
                                      widget.recipe_source,
                                      widget.recipe_rating,
                                      widget.recipe_type,
                                    ),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                },
                                icon: Icon(
                                  FluentIcons.arrow_circle_right_28_filled,
                                  color: iconTextColor,
                                ),
                              ),
                      ],
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
      ),
    );
  }
}
