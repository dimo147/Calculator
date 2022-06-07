import 'dart:math';
import 'package:calculator/settings.dart';
import 'package:vibration/vibration.dart';
import 'package:just_audio/just_audio.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> ops = ['*', '-', '+', '%', '/'];
const List<String> symbols = ['x', '-', '+', '%', '.', '÷'];
Parser p = Parser();
ContextModel cm = ContextModel();
const List<List<String>> keys = [
  ["7", "8", "9"],
  ["4", "5", "6"],
  ["1", "2", "3"]
];

Future save() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('dark', dark);
  await prefs.setBool('vibrate', vibrate);
  await prefs.setBool('sound', sound);
  await prefs.setString('theme', theme);
}

Future load() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dark = prefs.getBool('dark') ?? true;
  vibrate = prefs.getBool('vibrate') ?? true;
  sound = prefs.getBool('sound') ?? false;
  theme = prefs.getString('theme') ?? 'default';
}

String addComma(String inp) {
  var x = inp.replaceAll(',', '');
  x = x.replaceAll('x', '*');
  x = x.replaceAll('÷', '/');
  List<String> lst = [];
  List<String> last = [];
  for (var i in ops) {
    x = x.replaceAll(i, " $i ");
  }
  lst = x.split(' ');
  for (var j in lst) {
    if (!ops.contains(j)) {
      var d = '';
      if (j.contains('.')) {
        var db = (j.split('.')[0]).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
        d = '$db.${j.split('.')[1]}';
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
  bool? amp = await Vibration.hasAmplitudeControl();
  bool? custom = await Vibration.hasCustomVibrationsSupport();
  if ((amp != null && amp) && (custom != null && custom)) {
    Vibration.vibrate(duration: 45, amplitude: 125);
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
