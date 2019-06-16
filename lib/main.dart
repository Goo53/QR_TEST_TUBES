import 'package:flutter/material.dart';
import 'package:testwidgets1_0/home_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:testwidgets1_0/theme_switcher_widgets.dart';
import 'package:testwidgets1_0/scan.dart';
import 'package:testwidgets1_0/generate.dart';
import 'package:testwidgets1_0/login.dart';
import 'package:testwidgets1_0/new_user.dart';

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
              title: 'QR test-tubes managment',
              theme: theme,
              home: LogIn(),
              initialRoute: '/',
              routes: {
                '/home': (BuildContext context) => HomeScreen(),
                '/log_in': (BuildContext context) => LogIn(),
                '/new_user': (BuildContext context) => NewUser(),
                '/scan': (BuildContext context) => ScanScreen(),
                '/generate': (BuildContext context) => GenerateScreen(),
                      },
            );});}}
