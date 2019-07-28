import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:QR_Test_Tubes/theme_switcher_widgets.dart';
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
  Scaffold(appBar: AppBar(centerTitle: true,title: Text('Settings'),),
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
    Container(padding: const EdgeInsets.all(32),
          child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),  onPressed: showChooser,
          child: Text('Theme',style: TextStyle(fontSize: 20) ),),),
    Container(padding: const EdgeInsets.all(32),
          child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),
          onPressed:() {Navigator.of(context).pushNamedAndRemoveUntil('/log_in', (Route<dynamic> route) => false);},
          child: Text('Log out',style: TextStyle(fontSize: 20) ),),),     ],),),);},),);  }

  void showChooser() {showDialog<void>(context: context,builder: (context) {
    return BrightnessSwitcherDialog(onSelectedTheme: (brightness) {DynamicTheme.of(context).setBrightness(brightness);},);});}

  void changeBrightness() {DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark
    ? Brightness.light : Brightness.dark);}

  @override

  Widget build(BuildContext context) {
  return Scaffold(appBar: AppBar(centerTitle: true,title: Text('QR tubes'),
        actions: <Widget> [IconButton(icon: Icon(Icons.settings), onPressed: _settings),],),
    body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
      Container(padding: const EdgeInsets.all(32),
        child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),
          onPressed: () {Navigator.of(context).pushNamed('/scan',);},
          child: Text('QR CODE SCANNER',style: TextStyle(fontSize: 20) ),),),
      Container(padding: const EdgeInsets.all(32),
        child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),
          onPressed: () {Navigator.of(context).pushNamed('/generate',);},
          child: Text('CREATE NEW QR CODE',style: TextStyle(fontSize: 20) ),),),
      Container(padding: const EdgeInsets.all(32),
        child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),
          onPressed: () {Navigator.of(context).pushNamed('/list_all',);},
          child: Text('DATABASE',style: TextStyle(fontSize: 20) ),),),      ],),),);} }
