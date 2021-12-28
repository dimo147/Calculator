import 'package:calculator/settings.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:calculator/func.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String input = '';
  String output = '';
  String operation = '';
  String upper = '';
  bool answer = false;

  @override
  void initState() {
    super.initState();
    AdaptiveTheme.of(context).modeChangeNotifier.addListener(() {
      setState(() {});
    });
  }

  addDigit(String digit) {
    if (!answer) {
      setState(() {
        answer = true;
      });
    }
    if (input.isEmpty && symbols.contains(digit) ||
        symbols.contains(digit) && symbols.contains(input.characters.last)) {
      setState(() {});
    } else {
      setState(() {
        input = addComma(input + digit)
            .replaceAll('*', 'x')
            .replaceAll('/', '÷')
            .replaceAll(' ', '');
      });
    }
    preOperate();
  }

  preOperate() {
    double eval = operator(input)[0];

    setState(() {
      output =
          addComma(isInteger(eval) ? eval.toString() : eval.toStringAsFixed(0));
      upper = output;
    });
  }

  operate() {
    setState(() {
      answer = !answer;
    });

    var x = operator(input);
    double eval = x[0];
    String exp = x[1];

    setState(() {
      output =
          addComma(isInteger(eval) ? eval.toString() : eval.toStringAsFixed(0));
      operation = addComma(exp
          .toString()
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll('.0', '')
          .replaceAll('*', 'x')
          .replaceAll('/', '÷'));
      upper = operation;
      input = output;
    });
  }

  clear() {
    setState(() {
      input = '';
      upper = '';
      output = '';
      operation = '';
    });
  }

  backSpace() {
    if (!answer) {
      setState(() {
        answer = true;
      });
    }
    if (input.isNotEmpty && input.characters.length >= 2) {
      input = addComma(input.substring(0, input.length - 1));
    } else {
      clear();
    }
    preOperate();
  }

  @override
  Widget build(BuildContext context) {
    double buttonHeight = MediaQuery.of(context).size.width / 7;

    Color primary = AdaptiveTheme.of(context).theme.primaryColor;
    Color secondary = AdaptiveTheme.of(context).theme.accentColor;
    Color back = AdaptiveTheme.of(context).theme.backgroundColor;
    Color? shadowDark = AdaptiveTheme.of(context).brightness == Brightness.dark
        ? Colors.black87
        : Colors.grey[400];
    Color? shadowLight = AdaptiveTheme.of(context).brightness == Brightness.dark
        ? Colors.grey[900]
        : Colors.white;
    Color? text = AdaptiveTheme.of(context).theme.textTheme.button!.color;

    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.settings, color: text)),
                    Text(
                      'Calculator',
                      style: TextStyle(fontSize: 22, color: text),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          AdaptiveTheme.of(context).brightness ==
                                  Brightness.dark
                              ? AdaptiveTheme.of(context).setLight()
                              : AdaptiveTheme.of(context).setDark();
                        });
                      },
                      icon: Icon(
                        AdaptiveTheme.of(context).brightness == Brightness.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        color: text,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: constraints.maxHeight / 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: AutoSizeText(
                                upper,
                                style: TextStyle(
                                  fontSize: 30,
                                  letterSpacing: 2,
                                  color: text!.withOpacity(0.5),
                                ),
                                minFontSize: 18,
                                maxLines: 3,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: constraints.maxHeight / 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 0),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  final offsetAnimation = Tween<Offset>(
                                          begin: const Offset(0.0, 1.0),
                                          end: const Offset(0.0, 0.0))
                                      .animate(animation);
                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                                child: answer
                                    ? AutoSizeText(
                                        input,
                                        key: const ValueKey(1),
                                        style: TextStyle(
                                          fontSize: 45,
                                          letterSpacing: 2,
                                          color: text,
                                        ),
                                        minFontSize: 22,
                                        maxLines: 3,
                                        textAlign: TextAlign.left,
                                      )
                                    : AutoSizeText(
                                        output,
                                        key: const ValueKey(2),
                                        style: TextStyle(
                                          fontSize: 45,
                                          letterSpacing: 2,
                                          color: text,
                                        ),
                                        minFontSize: 22,
                                        maxLines: 3,
                                        textAlign: TextAlign.left,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Button(
                            backColor: secondary,
                            onPress: () {
                              clear();
                            },
                            text: const Text(
                              'C',
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Button(
                            backColor: secondary,
                            onPress: () {
                              backSpace();
                            },
                            text: const Icon(
                              MaterialCommunityIcons.backspace,
                              size: 28,
                              color: Colors.black,
                            ),
                          ),
                          Button(
                            backColor: secondary,
                            onPress: () {
                              addDigit('%');
                            },
                            text: const Text(
                              '%',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Button(
                            backColor: primary,
                            onPress: () {
                              addDigit('÷');
                            },
                            text: const Icon(
                              MaterialCommunityIcons.division,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      for (var i in keys)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (var j in i)
                              Button(
                                backColor: back,
                                onPress: () {
                                  addDigit(j);
                                },
                                text: Text(
                                  j,
                                  style: TextStyle(fontSize: 25, color: text),
                                ),
                              ),
                            Button(
                              backColor: primary,
                              onPress: () {
                                addDigit(
                                  i.last == '9'
                                      ? 'x'
                                      : i.last == '6'
                                          ? "-"
                                          : "+",
                                );
                              },
                              text: i.last == '9'
                                  ? const Icon(Icons.close, color: Colors.white)
                                  : i.last == '6'
                                      ? const Icon(Icons.remove,
                                          color: Colors.white)
                                      : const Icon(Icons.add,
                                          color: Colors.white),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NeumorphicButton(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              height: buttonHeight,
                              child: Center(
                                  child: Text(
                                "0",
                                style: TextStyle(fontSize: 25, color: text),
                              )),
                            ),
                            onPressed: () {
                              addDigit('0');
                            },
                            style: NeumorphicStyle(
                              shadowLightColor: shadowLight,
                              shadowDarkColor: shadowDark,
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(20)),
                              color: back,
                              depth: 10,
                              intensity: 0.7,
                              surfaceIntensity: 0.35,
                              lightSource: LightSource.topLeft,
                            ),
                          ),
                          Button(
                            backColor: back,
                            onPress: () {
                              addDigit('.');
                            },
                            text: Text(
                              ".",
                              style: TextStyle(
                                fontSize: 25,
                                color: text,
                              ),
                            ),
                          ),
                          Button(
                            backColor: primary,
                            onPress: () {
                              operate();
                            },
                            text: const Text(
                              '=',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}