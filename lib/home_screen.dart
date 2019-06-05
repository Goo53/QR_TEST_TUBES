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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _settings(){
  Navigator.of(context).push(
    MaterialPageRoute<void>( builder: (BuildContext context) { return
  Scaffold(appBar: AppBar(title: Text('Settings'),),
  body: ListView(children: <Widget>[
    Container(padding: const EdgeInsets.all(32), child: Row(children: [Text('Change theme',style: TextStyle(fontSize:26.0,),),
      IconButton(icon: Icon(Icons.brightness_6,color: Colors.red[500]), onPressed: showChooser,),],),),
    Container(padding: const EdgeInsets.all(32), child: RaisedButton(
          onPressed: showChooser,
          child: Text('Theme',style: TextStyle(fontSize: 20) ),),),
    Container(padding: const EdgeInsets.all(32), child: Text('whatever', style: TextStyle(fontSize:28.0),),),
    Container(padding: const EdgeInsets.all(32), child: Text('log in/out', style: TextStyle(fontSize:28.0),),),
],),);},),);}

void showChooser() {showDialog<void>(context: context,builder: (context) {
  return BrightnessSwitcherDialog(onSelectedTheme: (brightness) {DynamicTheme.of(context).setBrightness(brightness);
},);});}

void changeBrightness() {DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark
    ? Brightness.light : Brightness.dark);}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget> [IconButton(icon: Icon(Icons.settings), onPressed: _settings),],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(padding: const EdgeInsets.all(32), child: RaisedButton(
                onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ScanScreen()),);},
                child: Text('QR CODE SCANNER',style: TextStyle(fontSize: 20) ),),),
            Container(padding: const EdgeInsets.all(32), child: RaisedButton(
                onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => GenerateScreen()),);},
                child: Text('CREATE NEW QR CODE',style: TextStyle(fontSize: 20) ),),),
            Container(padding: const EdgeInsets.all(32), child: RaisedButton(
                onPressed: null,
                child: Text('SEARCH',style: TextStyle(fontSize: 20) ),),),
            ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_drive_file), title: Text("Tab 1")),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), title: Text("Tab 2")),
        ],
      ),

    );
  }
}
