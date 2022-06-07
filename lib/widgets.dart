import 'dart:math';
import 'package:calculator/fuctions.dart';
import 'package:calculator/settings.dart';
import 'package:just_audio/just_audio.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Background extends StatefulWidget {
  const Background({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    if (AdaptiveTheme.of(context).brightness == Brightness.dark) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: widget.child,
      );
    } else {
      return NeumorphicBackground(
        child: widget.child,
      );
    }
  }
}

class Button extends StatefulWidget {
  const Button({
    Key? key,
    required this.backColor,
    required this.text,
    required this.onPress,
  }) : super(key: key);
  final Color backColor;
  final Widget text;
  final Function onPress;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    double buttonWidth = (MediaQuery.of(context).size.width < 600)
        ? MediaQuery.of(context).size.width / 10
        : 60;
    double buttonHeight = (MediaQuery.of(context).size.width < 600)
        ? MediaQuery.of(context).size.width / 7
        : 80;

    Color? shadowDark = AdaptiveTheme.of(context).brightness == Brightness.dark
        ? Colors.black87
        : Colors.grey[400];
    Color? shadowLight = AdaptiveTheme.of(context).brightness == Brightness.dark
        ? Colors.grey[900]
        : Colors.white;
    return FadeUp(
      child: NeumorphicButton(
        margin: const EdgeInsets.only(bottom: 15),
        onPressed: () async {
          widget.onPress();
          if (vibrate) {
            vibrator();
          }
          if (sound) {
            await player.setAsset('assets/click.mp3');
            player.setVolume(100);
            player.play();
          }
        },
        style: NeumorphicStyle(
          shadowLightColor: shadowLight,
          shadowDarkColor: shadowDark,
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
          color: widget.backColor,
          depth: 10,
          intensity: 0.7,
          surfaceIntensity: 0.35,
          lightSource: LightSource.topLeft,
        ),
        child: SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: Center(
            child: widget.text,
          ),
        ),
      ),
    );
  }
}

class FadeUp extends StatefulWidget {
  const FadeUp({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<FadeUp> createState() => _FadeUpState();
}

class _FadeUpState extends State<FadeUp> {
  Random rnd = Random();
  @override
  Widget build(BuildContext context) {
    return ShowUpAnimation(
      delayStart: const Duration(seconds: 0),
      animationDuration: Duration(milliseconds: 300 + rnd.nextInt(500)),
      curve: Curves.bounceIn,
      direction: Direction.vertical,
      offset: 0.2,
      child: widget.child,
    );
  }
}
