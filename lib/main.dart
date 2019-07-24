import 'package:flutter/material.dart';
import 'package:QR_Test_Tubes/home_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:QR_Test_Tubes/scan.dart';
import 'package:QR_Test_Tubes/generate.dart';
import 'package:QR_Test_Tubes/login.dart';
import 'package:QR_Test_Tubes/new_user.dart';
import 'package:QR_Test_Tubes/add_comment.dart';
import 'package:QR_Test_Tubes/list_all.dart';

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
              title: 'QR Test Tubes',
              theme: theme,
              home: LogIn(),
              initialRoute: '/',
              routes: {
                '/home': (BuildContext context) => HomeScreen(),
                '/log_in': (BuildContext context) => LogIn(),
                '/new_user': (BuildContext context) => NewUser(),
                '/scan': (BuildContext context) => ScanScreen(),
                '/generate': (BuildContext context) => GenerateScreen(),
                '/comment' : (BuildContext context) => AddComment(),
                '/list_all': (BuildContext context) => ListAll(),
                      },
            );});}}
