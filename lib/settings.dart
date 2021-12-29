import 'package:calculator/func.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

bool vibrate = true;
bool sound = true;
String theme = 'default';
bool dark = false;

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    dark = AdaptiveTheme.of(context).mode.isDark;
    Color? text = AdaptiveTheme.of(context).theme.textTheme.button!.color;
    return Scaffold(
      body: Background(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.chevron_left,
                        color: text,
                        size: 28,
                      ),
                      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(color: text, fontSize: 25),
                    ),
                    Opacity(
                      opacity: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.chevron_left,
                          color: text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.colorize,
                color: text,
              ),
              title: Text(
                'Theme',
                style: TextStyle(color: text, fontSize: 18),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext bcontext) {
                    return AlertDialog(
                      content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile(
                                title: const Text('Default'),
                                value: "default",
                                groupValue: theme,
                                onChanged: (value) {
                                  setTheme(context, 'default');
                                  setState(() {
                                    theme = 'default';
                                  });
                                  Navigator.pop(context);
                                  save();
                                },
                              ),
                              RadioListTile(
                                title: const Text('Red'),
                                value: "red",
                                groupValue: theme,
                                onChanged: (value) {
                                  setTheme(context, 'red');
                                  setState(() {
                                    theme = 'red';
                                  });
                                  Navigator.pop(context);
                                  save();
                                },
                              ),
                              RadioListTile(
                                title: const Text('Green'),
                                value: "green",
                                groupValue: theme,
                                onChanged: (value) {
                                  setTheme(context, 'green');
                                  setState(() {
                                    theme = 'green';
                                  });
                                  Navigator.pop(context);
                                  save();
                                },
                              ),
                              RadioListTile(
                                title: const Text('Blue'),
                                value: "blue",
                                groupValue: theme,
                                onChanged: (value) {
                                  setTheme(context, 'blue');
                                  setState(() {
                                    theme = 'blue';
                                  });
                                  Navigator.pop(context);
                                  save();
                                },
                              ),
                              RadioListTile(
                                title: const Text('Purple'),
                                value: "purple",
                                groupValue: theme,
                                onChanged: (value) {
                                  setTheme(context, 'purple');
                                  setState(() {
                                    theme = 'purple';
                                  });
                                  Navigator.pop(context);
                                  save();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            SwitchListTile(
              secondary: Icon(
                Icons.dark_mode,
                color: text,
              ),
              title: Text(
                'Dark mode',
                style: TextStyle(color: text, fontSize: 18),
              ),
              onChanged: (value) {
                setState(() {
                  dark
                      ? AdaptiveTheme.of(context).setLight()
                      : AdaptiveTheme.of(context).setDark();
                  dark = !dark;
                });
                save();
              },
              value: dark,
              activeColor: Colors.green,
            ),
            SwitchListTile(
              secondary: Icon(
                Icons.vibration,
                color: text,
              ),
              title: Text(
                'Vibrate',
                style: TextStyle(color: text, fontSize: 18),
              ),
              onChanged: (value) {
                setState(() {
                  vibrate = !vibrate;
                });
                save();
              },
              value: vibrate,
              activeColor: Colors.green,
            ),
            SwitchListTile(
              secondary: Icon(
                Icons.touch_app,
                color: text,
              ),
              title: Text(
                'Click sound',
                style: TextStyle(color: text, fontSize: 18),
              ),
              onChanged: (value) {
                setState(() {
                  sound = !sound;
                });
                save();
              },
              value: sound,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
