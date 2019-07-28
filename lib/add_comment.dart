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
import 'package:QR_Test_Tubes/appdata.dart';
import 'dart:convert';
import 'package:QR_Test_Tubes/datainfo.dart';
import 'package:auto_size_text/auto_size_text.dart';



class AddComment extends StatefulWidget {@override State<StatefulWidget> createState() => AddCommentState();}

class AddCommentState extends State<AddComment> {

  GlobalKey globalKey = new GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController() ;
  bool _autoValidate = true;


  @override

  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(centerTitle: true,title: Text('Add comment'),),
      body: _contentWidget(),  );}
      _contentWidget() {

  final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
  return Form(key: _formKey, autovalidate: _autoValidate, child: Center(child: ListView(shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
    Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('Author: ',style: TextStyle(fontSize: 16) ),Spacer(),
            AutoSizeText(appData.text ,maxLines:1,style: TextStyle(fontSize: 16)),],),),
    Container(padding: const EdgeInsets.all(12),child:  Row(children: <Widget>[Text('Probe ID: ',style: TextStyle(fontSize: 16) ),Spacer(),
            AutoSizeText('${dataInfo.id}' ,maxLines:1, style: TextStyle(fontSize: 16)),],),),
    Container(padding: const EdgeInsets.all(12),child: ConstrainedBox(constraints: BoxConstraints(maxHeight: 300.0,), child: new Scrollbar(
          child:SingleChildScrollView(scrollDirection: Axis.vertical, reverse: true,
              child: TextFormField(maxLines: null, controller: _commentController, validator: validateComment,
                decoration: const InputDecoration(hintText: 'Place your comment here',),),),),), ),

    Padding(padding: const EdgeInsets.all(16.0),
            child:  FlatButton(
            child:  Text("SUBMIT", style: TextStyle(fontSize: 24)),
              onPressed: () async{ if(_formKey.currentState.validate()) {
                var url = 'http://webek3.fuw.edu.pl/zps2g14/add_comment_to_probe.py';
                var response = await http.post(url, body: {'login': appData.text ,'probe_id': dataInfo.id.toString() , 'comment': _commentController.text ,});
                print('Response status: ${response.statusCode}');
                print('Response body: ${response.body}');
                if (response.statusCode == 200) { var responseJSON = json.decode(response.body);
                  bool success = responseJSON['success'];
                  if ( success == true) { showDialog( barrierDismissible: false, context: context,builder: (BuildContext context) => _popupscreen1(context),); }
                  else{showDialog(context: context,builder: (BuildContext context) => _popupscreen3(context),);}  }
                else {showDialog(context: context,builder: (BuildContext context) => _popupscreen2(context),);}  }; }, ),),    ],),),);      }

    Widget _popupscreen1(BuildContext context,) { return new WillPopScope( onWillPop: () async => false,
        child: new AlertDialog( backgroundColor: Colors.grey[600],
        title: Center(child:Text('Data upload Complete!'),),
        titleTextStyle: TextStyle(fontSize: 24, ),titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        contentTextStyle: TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: new Container(width: 290.0, height: 260.0, decoration: new BoxDecoration(
        shape: BoxShape.rectangle, borderRadius: new BorderRadius.all(new Radius.circular(32.0)),  ),
        child: new Padding( padding: const EdgeInsets.all(18.0), child:Column(crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          Center(child:Text('Do you wish to reprint QR code?'),),
          Center(child:RepaintBoundary(key: globalKey, child: Container(padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white,borderRadius:  BorderRadius.all( Radius.circular(32.0)), ),
            child:QrImage(data: dataInfo.id.toString(), size: 100 ,),),),), ],),),),
            actions: <Widget>[ StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
            IconButton(icon: Icon(Icons.print),onPressed: () { _captureAndSharePng(); },),
            FlatButton(onPressed: () {Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);},
            child: const Text('Return to Home Page'),), ],); }),],   ), );    }

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

    String validateComment(String value) {
        if (value.length < 1)  {return 'Cannot be empty';}
                    else  {return null;  }}

    Future<void> _captureAndSharePng() async {
        try { RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
        var image = await boundary.toImage(); ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
        Uint8List pngBytes = byteData.buffer.asUint8List(); final tempDir = await getTemporaryDirectory();
        final file = await new File('${tempDir.path}/image.png').create();  await file.writeAsBytes(pngBytes);
        final channel = const MethodChannel('channel:me.alfian.share/share'); channel.invokeMethod('shareFile', 'image.png');  }
        catch(e) {print(e.toString());}}


}
