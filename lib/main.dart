import 'package:flutter/material.dart';
import 'package:testwidgets1_0/home_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:testwidgets1_0/theme_switcher_widgets.dart';
import 'package:testwidgets1_0/scan.dart';
import 'package:testwidgets1_0/generate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (brightness) => ThemeData(
                primarySwatch: Colors.indigo,
                brightness: brightness,
              ),
          themedWidgetBuilder: (context, theme) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: theme,
              home: HomeScreen(title: 'QR Test Tubes Managment'),
              initialRoute: '/',
              routes: {
                '/home': (BuildContext context) => HomeScreen(),
                //'/signup': (BuildContext context) => SignUpPage(),
                '/scan': (BuildContext context) => ScanScreen(),
                '/generate': (BuildContext context) => GenerateScreen(),
                      },
            );});}}
