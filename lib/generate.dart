import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:testwidgets1_0/home_screen.dart';


var uuid = new Uuid();

class GenerateScreen extends StatefulWidget {@override State<StatefulWidget> createState() => GenerateScreenState();}

class GenerateScreenState extends State<GenerateScreen> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  final _thicknessController = TextEditingController() ;
  final _layersController = TextEditingController() ;
  final _descriptionController = TextEditingController() ;
  final _authorController = TextEditingController() ;
  // controllers -> capture TextFormField input


  @override
  var _newid = uuid.v1();
  var now = new DateTime.now();
  // each time we click 'CREATE NEW QR CODE' we are creating new unique time-based ID
  // which is printed later on and is also base of our QR code
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('QR Code Generator'),),
      body: _contentWidget(),

    );}

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');  }
  catch(e) {print(e.toString());}}
  _contentWidget() {
  final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
  return  Center(child: ListView(shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
      Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('ID: ',style: TextStyle(fontSize: 16) ),
          Expanded(child:  Text("$_newid " ,style: TextStyle(fontSize: 16)),),],),),

      Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('Creation date: ',style: TextStyle(fontSize: 16) ),
          Expanded(child:  Text("$now" ,style: TextStyle(fontSize: 16)),),],),),

      Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('Thickness: ',style: TextStyle(fontSize: 16) ),
          Expanded(child:  TextFormField( controller: _thicknessController,
            decoration: const InputDecoration(hintText: 'e.g. 2.3 [nm]',),)),],),),

      Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('Number of layers: ',style: TextStyle(fontSize: 16) ),
          Expanded(child:  TextFormField(controller: _layersController,
            decoration: const InputDecoration(hintText: 'e.g. 35',),)),],),),

      Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('Description: ',style: TextStyle(fontSize: 16) ),
          Expanded(child:  TextFormField(controller: _descriptionController,
            decoration: const InputDecoration(hintText: 'Place your comment here',),)),],),),

      Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('Author: ',style: TextStyle(fontSize: 16) ),
          Expanded(child:  TextFormField(controller: _authorController,
            decoration: const InputDecoration(hintText: 'e.g. Goose',),)),],),),

      Center(child:RepaintBoundary(key: globalKey,child:
          QrImage(data: _newid, size: 0.2 * bodyHeight,onError: (ex) {print("[QR] ERROR - $ex");setState((){
            _inputErrorText = "Error! Maybe your input value is too long?";});},),),),
      Center(child:IconButton(icon: Icon(Icons.print),onPressed: _captureAndSharePng,),),

      Padding(padding: const EdgeInsets.all(16.0),
          child:  FlatButton(
          child:  Text("SUBMIT", style: TextStyle(fontSize: 24)),
          onPressed: () async{
            var url = 'http://webek3.fuw.edu.pl/zps2g14/post_probe_info.py';
            var response = await http.post(url, body: {'author': _authorController.text ,'thickness': _thicknessController.text , 'nr_layers': _layersController.text ,'description': _descriptionController.text ,});
            print('Response status: ${response.statusCode}');
            print('Response body: ${response.body}');
            if (response.statusCode == 200) {
              showDialog(context: context,builder: (BuildContext context) => _popupscreen1(context),);
            } else {showDialog(context: context,builder: (BuildContext context) => _popupscreen2(context),);}
          }, ),),    ],),);      }

    Widget _popupscreen1(BuildContext context) {
    return new AlertDialog(
      title: const Text('Data upload Complete!'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Before shutting this screen remember to print your QR code:'),
          Center(child:IconButton(icon: Icon(Icons.print),onPressed: _captureAndSharePng,),), ],),
      actions: <Widget>[new FlatButton(onPressed: () {Navigator.pushNamed(context, '/home'); },
          child: const Text('Return to Home Page'),),],);    }

    Widget _popupscreen2(BuildContext context) {
    return new AlertDialog(
        title: const Text('Data upload rejected. Please try again'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Error'),
          Text('Could not upload data'),],),
        actions: <Widget>[new FlatButton(onPressed: () {Navigator.of(context).pop(); },
          child: const Text('Got it'),),],);    }

}
