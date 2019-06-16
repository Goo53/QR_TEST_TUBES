import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:testwidgets1_0/theme_switcher_widgets.dart';
import 'package:testwidgets1_0/scan.dart';
import 'package:testwidgets1_0/generate.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomeScreenState createState() => _HomeScreenState();   }

class _HomeScreenState extends State<HomeScreen> {
  void _settings(){
  Navigator.of(context).push(
    MaterialPageRoute<void>( builder: (BuildContext context) { return
  Scaffold(appBar: AppBar(title: Text('Settings'),),
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
    Container(padding: const EdgeInsets.all(32),
          child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),  onPressed: showChooser,
          child: Text('Theme',style: TextStyle(fontSize: 20) ),),),
    Container(padding: const EdgeInsets.all(32),
          child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),  onPressed: null,
          child: Text('Log out',style: TextStyle(fontSize: 20) ),),),
    Container(padding: const EdgeInsets.all(32),
          child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),  onPressed: null,
          child: Text('Whatever',style: TextStyle(fontSize: 20) ),),),
    Container(padding: const EdgeInsets.all(32),
          child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)), onPressed: null,
          child: Text('Whatever',style: TextStyle(fontSize: 20) ),),),  ],),),);},),);  }

  void showChooser() {showDialog<void>(context: context,builder: (context) {
    return BrightnessSwitcherDialog(onSelectedTheme: (brightness) {DynamicTheme.of(context).setBrightness(brightness);},);});}

  void changeBrightness() {DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark
    ? Brightness.light : Brightness.dark);}

  @override
  Widget build(BuildContext context) {
  return Scaffold(appBar: AppBar(title: Text('QR test-tubes managment'),
        actions: <Widget> [IconButton(icon: Icon(Icons.settings), onPressed: _settings),],),
    body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
      Container(padding: const EdgeInsets.all(32),
        child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),
          onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => ScanScreen()),);},
          child: Text('QR CODE SCANNER',style: TextStyle(fontSize: 20) ),),),
      Container(padding: const EdgeInsets.all(32),
        child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),
          onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => GenerateScreen()),);},
          child: Text('CREATE NEW QR CODE',style: TextStyle(fontSize: 20) ),),),
      Container(padding: const EdgeInsets.all(32),
        child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),
          onPressed: null,child: Text('SEARCH',style: TextStyle(fontSize: 20) ),),),      ],),),);} }
