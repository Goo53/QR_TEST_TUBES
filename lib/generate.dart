import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:testwidgets1_0/home_screen.dart';
import 'package:testwidgets1_0/appdata.dart';
import 'dart:convert';

class ProbeId {
  static final ProbeId _probeId = new ProbeId._internal();
  String text;
  factory ProbeId(){return _probeId;}
  ProbeId._internal();
}
final probeId = ProbeId();

class GenerateScreen extends StatefulWidget {@override State<StatefulWidget> createState() => GenerateScreenState();}

class GenerateScreenState extends State<GenerateScreen> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  int _newid;
  String _inputErrorText;
  final _thicknessController = TextEditingController() ;
  final _layersController = TextEditingController() ;
  final _descriptionController = TextEditingController() ;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = true;
  var visibility = false;


  @override
  var now = new DateTime.now();

  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('QR Code Generator'),),
      body: _contentWidget(),  );}

  Future<void> _captureAndSharePng() async {
    try { RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    var image = await boundary.toImage(); ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List(); final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/image.png').create();  await file.writeAsBytes(pngBytes);
    final channel = const MethodChannel('channel:me.alfian.share/share'); channel.invokeMethod('shareFile', 'image.png');  }
    catch(e) {print(e.toString());}}

  _contentWidget() {

  final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
  return Form(key: _formKey, autovalidate: _autoValidate, child: Center(child: ListView(shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
    Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('Author: ',style: TextStyle(fontSize: 16) ),
        Expanded(child:  Text(appData.text ,style: TextStyle(fontSize: 16)),),],),),

    Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('Creation date: ',style: TextStyle(fontSize: 16) ),
        Expanded(child:  Text('$now' ,style: TextStyle(fontSize: 16)),),],),),

    Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('Thickness: ',style: TextStyle(fontSize: 16) ),
        Expanded(child:  TextFormField( controller: _thicknessController, validator: validateThickness,
            keyboardType: TextInputType.number, inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
            decoration: const InputDecoration(hintText: 'e.g. 2.3 [nm]',),)),],),),

    Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('Number of layers: ',style: TextStyle(fontSize: 16) ),
        Expanded(child:  TextFormField(controller: _layersController, validator: validateLayers,
            keyboardType: TextInputType.number, inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
            decoration: const InputDecoration(hintText: 'e.g. 35',),)),],),),

    Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('Description: ',style: TextStyle(fontSize: 16) ),
        Expanded(child:  TextFormField(controller: _descriptionController, validator: validateDescription,
            decoration: const InputDecoration(hintText: 'Place your comment here',),)),],),),

    Padding(padding: const EdgeInsets.all(16.0),
        child:  FlatButton(
        child:  Text("SUBMIT", style: TextStyle(fontSize: 24)),
          onPressed: () async{ if(_formKey.currentState.validate()) {
            var url = 'http://webek3.fuw.edu.pl/zps2g14/post_probe_info.py';
            var response = await http.post(url, body: {'author': appData.text ,'thickness': _thicknessController.text , 'nr_layers': _layersController.text ,'description': _descriptionController.text ,});
            print('Response status: ${response.statusCode}');
            print('Response body: ${response.body}');
            if (response.statusCode == 200) { String responseBody = response.body; var responseJSON = json.decode(responseBody);
              bool success = responseJSON['success']; int _newid = responseJSON['id']; probeId.text = _newid.toString(); print(probeId.text);
              if ( success == true) { showDialog( barrierDismissible: false, context: context,builder: (BuildContext context) => _popupscreen1(context),); }
              else{showDialog(context: context,builder: (BuildContext context) => _popupscreen3(context),);}  }
            else {showDialog(context: context,builder: (BuildContext context) => _popupscreen2(context),);}  }; }, ),),    ],),),);      }

    Widget _popupscreen1(BuildContext context,) {
    return new WillPopScope(
    onWillPop: () async => false,
    child: new AlertDialog( backgroundColor: Colors.grey[600],
      title: Center(child:Text('Data upload Complete!'),),
      titleTextStyle: TextStyle(fontSize: 24, ),titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      contentTextStyle: TextStyle(fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: new Container(width: 290.0, height: 260.0, decoration: new BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.all(new Radius.circular(32.0)),  ),
    child: new Padding( padding: const EdgeInsets.all(18.0), child:Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(child:Text('Before closing this window, remember to print your QR code:'),),
          Center(child:RepaintBoundary(key: globalKey, child: Container(
          padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white,borderRadius:  BorderRadius.all( Radius.circular(32.0)), ),
            child:QrImage(data: probeId.text, size: 100 ,),),),), ],),),),
    actions: <Widget>[ StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
      IconButton(icon: Icon(Icons.print),onPressed: () { _captureAndSharePng(); setState(() {visibility = true;});},),
      Visibility(visible: visibility, child:FlatButton(onPressed: ()
        {Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);},
        child: const Text('Return to Home Page'),),), ],); }),],   ), );    }

    Widget _popupscreen2(BuildContext context) {
    return new AlertDialog( backgroundColor: Colors.grey[600],
        title: Center(child:Text('Data upload rejected. Please try again'),),
        titleTextStyle: TextStyle(fontSize: 20, ),titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),contentTextStyle: TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: Center(child:Text('Could not upload data'),),
        actions: <Widget>[new FlatButton(onPressed: () {Navigator.of(context).pop(); },
          child: const Text('Got it'),),],);    }

    Widget _popupscreen3(BuildContext context) {
    return new AlertDialog( backgroundColor: Colors.grey[600],
        title: Center(child:Text('Error'),),
        titleTextStyle: TextStyle(fontSize: 20, ),titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),contentTextStyle: TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: Center(child:Text('Data incorrect. Check it again'),),
        actions: <Widget>[new FlatButton(onPressed: () {Navigator.of(context).pop(); },
          child: const Text('Got it'),),],);    }

    String validateThickness(String value) {
        if (value.length < 1)  {return 'Cannot be empty';}
        else  {return null;  }}
    String validateLayers(String value) {
        if (value.length < 1)  {return 'Digits only';}
        else  {return null;  }}
    String validateDescription(String value) {
        if (value.length < 1)  {return 'Enter description';}
        else  {return null;  }}

}
