import 'package:google_fonts/google_fonts.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:calculator/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
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
      initial: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Calculator',
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        theme: ThemeData(
          textTheme: GoogleFonts.rubikTextTheme(
            Theme.of(context)
                .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
          ),
        ),
      ),
    );
  }
}
