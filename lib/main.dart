import 'package:math_expressions/math_expressions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context)
              .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
        ),
      ),
    );
  }
}

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
  static const List<List<String>> keys = [
    ["7", "8", "9"],
    ["4", "5", "6"],
    ["1", "2", "3"]
  ];

  static const List<String> symbols = ['x', '-', '+', '%', '.', '÷'];

  Parser p = Parser();
  ContextModel cm = ContextModel();

  addDigit(String digit) {
    if (!answer) {
      setState(() {
        answer = true;
      });
    }
    if (input.isEmpty && symbols.contains(digit)) {
      setState(() {});
    } else if (symbols.contains(digit) &&
        symbols.contains(input.characters.last)) {
      setState(() {});
    } else {
      setState(() {
        input += digit;
      });
    }
    preOperate();
  }

  preOperate() {
    var x = input;
    x = x.replaceAll('x', '*');
    x = x.replaceAll('÷', '/');
    Expression exp = p.parse(x);
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    setState(() {
      output = eval.toString().replaceAll('.0', '');
      operation = exp
          .toString()
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll('.0', '');
      upper = output;
    });
  }

  operate() {
    var x = input;
    setState(() {
      answer = !answer;
    });
    x = x.replaceAll('x', '*');
    x = x.replaceAll('÷', '/');
    print(x);
    Expression exp = p.parse(x);
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    setState(() {
      output = eval.toString().replaceAll('.0', '');
      operation = exp
          .toString()
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll('.0', '');
      upper = operation;
      input = output;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NeumorphicBackground(
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
                    IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
                    const Text(
                      'Calculator',
                      style: TextStyle(fontSize: 22),
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.dark_mode)),
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
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                minFontSize: 18,
                                maxLines: 3,
                                textAlign: TextAlign.right,
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
                                  duration: Duration(milliseconds: 0),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    final offsetAnimation = Tween<Offset>(
                                            begin: Offset(0.0, 1.0),
                                            end: Offset(0.0, 0.0))
                                        .animate(animation);
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                  child: answer
                                      ? AutoSizeText(
                                          input,
                                          key: ValueKey(1),
                                          style: const TextStyle(
                                              fontSize: 45, letterSpacing: 2),
                                          minFontSize: 22,
                                          maxLines: 3,
                                          textAlign: TextAlign.right,
                                        )
                                      : AutoSizeText(
                                          output,
                                          key: ValueKey(2),
                                          style: const TextStyle(
                                              fontSize: 45, letterSpacing: 2),
                                          minFontSize: 22,
                                          maxLines: 3,
                                          textAlign: TextAlign.right,
                                        ),
                                )),
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
                          NeumorphicButton(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const SizedBox(
                              width: 35,
                              height: 50,
                              child: Center(
                                  child: Text(
                                'c',
                                style: TextStyle(fontSize: 30),
                              )),
                            ),
                            onPressed: () {
                              setState(() {
                                input = '';
                                upper = '';
                                output = '';
                                operation = '';
                              });
                            },
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(20)),
                              color: Colors.grey,
                              depth: 10,
                              intensity: 0.7,
                              surfaceIntensity: 0.35,
                              lightSource: LightSource.topLeft,
                            ),
                          ),
                          NeumorphicButton(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const SizedBox(
                              width: 35,
                              height: 50,
                              child: Center(
                                  child: Icon(
                                MaterialCommunityIcons.plus_minus,
                                size: 28,
                              )),
                            ),
                            onPressed: () {},
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(20)),
                              color: Colors.grey,
                              depth: 10,
                              intensity: 0.7,
                              surfaceIntensity: 0.35,
                              lightSource: LightSource.topLeft,
                            ),
                          ),
                          NeumorphicButton(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const SizedBox(
                              width: 35,
                              height: 50,
                              child: Center(
                                  child: Text(
                                '%',
                                style: TextStyle(fontSize: 25),
                              )),
                            ),
                            onPressed: () {
                              addDigit('%');
                            },
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(20)),
                              color: Colors.grey,
                              depth: 10,
                              intensity: 0.7,
                              surfaceIntensity: 0.35,
                              lightSource: LightSource.topLeft,
                            ),
                          ),
                          NeumorphicButton(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const SizedBox(
                              width: 35,
                              height: 50,
                              child: Center(
                                  child: Icon(MaterialCommunityIcons.division,
                                      size: 28, color: Colors.white)),
                            ),
                            onPressed: () {
                              addDigit('÷');
                            },
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(20)),
                              color: Colors.orange,
                              depth: 10,
                              intensity: 0.7,
                              surfaceIntensity: 0.35,
                              lightSource: LightSource.topLeft,
                            ),
                          ),
                        ],
                      ),
                      for (var i in keys)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (var j in i)
                              NeumorphicButton(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: SizedBox(
                                  width: 35,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    j,
                                    style: const TextStyle(fontSize: 25),
                                  )),
                                ),
                                onPressed: () {
                                  addDigit(j);
                                },
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.concave,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(20)),
                                  color: Colors.white,
                                  depth: 10,
                                  intensity: 0.7,
                                  surfaceIntensity: 0.35,
                                  lightSource: LightSource.topLeft,
                                ),
                              ),
                            NeumorphicButton(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: SizedBox(
                                width: 35,
                                height: 50,
                                child: Center(
                                    child: i.last == '9'
                                        ? const Icon(Icons.close,
                                            color: Colors.white)
                                        : i.last == '6'
                                            ? const Icon(Icons.remove,
                                                color: Colors.white)
                                            : const Icon(Icons.add,
                                                color: Colors.white)),
                              ),
                              onPressed: () {
                                addDigit(i.last == '9'
                                    ? 'x'
                                    : i.last == '6'
                                        ? "-"
                                        : "+");
                              },
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(20)),
                                color: Colors.orange,
                                depth: 10,
                                intensity: 0.7,
                                surfaceIntensity: 0.35,
                                lightSource: LightSource.topLeft,
                              ),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NeumorphicButton(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const SizedBox(
                              width: 125,
                              height: 50,
                              child: Center(
                                  child: Text(
                                "0",
                                style: TextStyle(fontSize: 25),
                              )),
                            ),
                            onPressed: () {
                              addDigit('0');
                            },
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(20)),
                              color: Colors.white,
                              depth: 10,
                              intensity: 0.7,
                              surfaceIntensity: 0.35,
                              lightSource: LightSource.topLeft,
                            ),
                          ),
                          NeumorphicButton(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const SizedBox(
                              width: 35,
                              height: 50,
                              child: Center(
                                  child: Text(
                                ".",
                                style: TextStyle(fontSize: 25),
                              )),
                            ),
                            onPressed: () {
                              addDigit('.');
                            },
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(20)),
                              color: Colors.white,
                              depth: 10,
                              intensity: 0.7,
                              surfaceIntensity: 0.35,
                              lightSource: LightSource.topLeft,
                            ),
                          ),
                          NeumorphicButton(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const SizedBox(
                              width: 35,
                              height: 50,
                              child: Center(
                                child: Text(
                                  '=',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ),
                            ),
                            onPressed: () {
                              operate();
                            },
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(20)),
                              color: Colors.orange,
                              depth: 10,
                              intensity: 0.7,
                              surfaceIntensity: 0.35,
                              lightSource: LightSource.topLeft,
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
