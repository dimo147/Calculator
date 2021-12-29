import 'package:calculator/settings.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:vibration/vibration.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Consts
const List<String> ops = ['*', '-', '+', '%', '/'];
const List<String> symbols = ['x', '-', '+', '%', '.', '÷'];
Parser p = Parser();
ContextModel cm = ContextModel();
const List<List<String>> keys = [
  ["7", "8", "9"],
  ["4", "5", "6"],
  ["1", "2", "3"]
];

// Functions
Future save() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('dark', dark);
  await prefs.setBool('vibrate', vibrate);
  await prefs.setBool('sound', sound);
  await prefs.setString('theme', theme);
  print(theme);
}

Future load() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dark = prefs.getBool('dark') ?? true;
  vibrate = prefs.getBool('vibrate') ?? true;
  sound = prefs.getBool('sound') ?? false;
  theme = prefs.getString('theme') ?? 'default';
  print('load');
  print(theme);
}

String addComma(String inp) {
  var x = inp.replaceAll(',', '');
  x = x.replaceAll('x', '*');
  x = x.replaceAll('÷', '/');
  List<String> lst = [];
  List<String> last = [];
  for (var i in ops) {
    x = x.replaceAll(i, " " + i + " ");
  }
  lst = x.split(' ');
  for (var j in lst) {
    if (!ops.contains(j)) {
      var d = '';
      if (j.contains('.')) {
        var db = (j.split('.')[0]).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
        d = db + '.' + j.split('.')[1];
      } else {
        d = j.replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      }
      last.add(d);
    } else {
      last.add(j);
    }
  }
  String formated = last.join();
  return formated;
}

bool isInteger(num value) {
  var isInt = value is int || !(value.toString().split('.')[1] == '0');
  return isInt;
}

operator(String inp) {
  var x = inp.replaceAll(',', '');
  x = x.replaceAll('x', '*');
  x = x.replaceAll('÷', '/');
  Expression exp = p.parse(x);
  double eval = exp.evaluate(EvaluationType.REAL, cm);
  return [eval, exp];
}

vibrator() async {
  if (await Vibration.hasVibrator() &&
      await Vibration.hasCustomVibrationsSupport()) {
    Vibration.vibrate(duration: 35, amplitude: 125);
  }
}

setTheme(context, mode) {
  if (mode == 'default') {
    AdaptiveTheme.of(context).setTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.orange,
        accentColor: Colors.grey[400],
        backgroundColor: Colors.white,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.orange,
        accentColor: Colors.grey,
        backgroundColor: Colors.grey[900],
      ),
    );
  } else if (mode == 'red') {
    AdaptiveTheme.of(context).setTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red,
        accentColor: Colors.grey[400],
        backgroundColor: Colors.white,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
        accentColor: Colors.grey,
        backgroundColor: Colors.grey[900],
      ),
    );
  } else if (mode == 'green') {
    AdaptiveTheme.of(context).setTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        accentColor: Colors.grey[400],
        backgroundColor: Colors.white,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        accentColor: Colors.grey,
        backgroundColor: Colors.grey[900],
      ),
    );
  } else if (mode == 'blue') {
    AdaptiveTheme.of(context).setTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.grey[400],
        backgroundColor: Colors.white,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        accentColor: Colors.grey,
        backgroundColor: Colors.grey[900],
      ),
    );
  } else if (mode == 'purple') {
    AdaptiveTheme.of(context).setTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.purple,
        accentColor: Colors.grey[400],
        backgroundColor: Colors.white,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        accentColor: Colors.grey,
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}

// Widgets
class Background extends StatefulWidget {
  Background({Key? key, required this.child}) : super(key: key);
  Widget child;

  @override
  _BackgroundState createState() => _BackgroundState();
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
  Button({
    Key? key,
    required this.backColor,
    required this.text,
    required this.onPress,
  }) : super(key: key);
  Color backColor;
  Widget text;
  Function onPress;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width / 10;
    double buttonHeight = MediaQuery.of(context).size.width / 7;

    Color? shadowDark = AdaptiveTheme.of(context).brightness == Brightness.dark
        ? Colors.black87
        : Colors.grey[400];
    Color? shadowLight = AdaptiveTheme.of(context).brightness == Brightness.dark
        ? Colors.grey[900]
        : Colors.white;

    return NeumorphicButton(
      margin: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: Center(
          child: widget.text,
        ),
      ),
      onPressed: () async {
        widget.onPress();
        if (vibrate) {
          vibrator();
        }
        if (sound) {
          var duration = await player.setAsset('assets/click.mp3');
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
    );
  }
}
