import 'package:flutter/material.dart';

class BrightnessSwitcherDialog extends StatelessWidget {
  const BrightnessSwitcherDialog({Key key, this.onSelectedTheme})  : super(key: key);
  final ValueChanged<Brightness> onSelectedTheme;

@override
Widget build(BuildContext context) {
  return SimpleDialog(
  title: Center(child: Text('Select Theme'),),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
  children: <Widget>[
    RadioListTile<Brightness>(value: Brightness.light,
      groupValue: Theme.of(context).brightness,
      onChanged: (Brightness value) {onSelectedTheme(Brightness.light);},
      title: const Text('Light'),  ),
    RadioListTile<Brightness>(value: Brightness.dark,
      groupValue: Theme.of(context).brightness,
      onChanged: (Brightness value) {onSelectedTheme(Brightness.dark);},
      title: const Text('Dark'),  ),],);  }}
