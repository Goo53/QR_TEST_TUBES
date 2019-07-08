import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testwidgets1_0/home_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testwidgets1_0/appdata.dart';
import 'package:testwidgets1_0/databits.dart';
import 'package:testwidgets1_0/datainfo.dart';


class ScanScreen extends StatefulWidget {@override  _ScanState createState() => new _ScanState(); }
class _ScanState extends State<ScanScreen> {
  String barcode = "";
  //List list = List();
  var tcVisibility = false;
  var tcVisibility1 = false;
  var isLoading = false;

  @override initState() {super.initState();  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: new AppBar(
    title: new Text('QR Code Scanner'),),
    body: new Center(
      child: new ListView(children: <Widget>[
        Visibility(visible: tcVisibility, child:AlertDialog(backgroundColor: Colors.grey[600],
          title: Center(child:Text('Scan results:'),),
          titleTextStyle: TextStyle(fontSize: 20, ),titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),contentTextStyle: TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: Center(child:Text('Probe ID: $barcode'),),
          actions: <Widget>[new Center(child:FlatButton(onPressed: fetchData,
          child: const Text('Search in database'),),),],),),

        Visibility(visible: tcVisibility1, child:Container(margin: const EdgeInsets.all(10.0), alignment: Alignment.center,
              decoration: BoxDecoration( color: Colors.grey[500], shape: BoxShape.rectangle, borderRadius: new BorderRadius.all(new Radius.circular(32.0)),),
              child:
                isLoading ?
                  Center(child:CircularProgressIndicator(),)
                : Padding( padding: const EdgeInsets.all(18.0), child:Center(child:Column(children: <Widget>[
                    Padding( padding: const EdgeInsets.all(8.0), child:Row(children: <Widget>[Text('Probe ID: ',style: TextStyle(fontSize: 20)),Expanded(child:Text('${dataInfo.id}',style: TextStyle(fontSize: 16)),),],),),
                    Padding( padding: const EdgeInsets.all(8.0), child: Row(children: <Widget>[Text('Author: ',style: TextStyle(fontSize: 20)),Expanded(child:Text('${dataInfo.author}',style: TextStyle(fontSize: 16)),),],),),
                    Padding( padding: const EdgeInsets.all(8.0), child:Row(children: <Widget>[Text('Creation date: ',style: TextStyle(fontSize: 20)),Expanded(child:Text('${dataInfo.created_at}',style: TextStyle(fontSize: 16)),),],),),
                    Padding( padding: const EdgeInsets.all(8.0), child:Row(children: <Widget>[Text('Description: ',style: TextStyle(fontSize: 20)),Expanded(child:Text('${dataInfo.description}',style: TextStyle(fontSize: 16)),),],),),
                    Padding( padding: const EdgeInsets.all(8.0), child:Row(children: <Widget>[Text('Number of layers: ',style: TextStyle(fontSize: 20)),Expanded(child:Text('${dataInfo.nr_layers}',style: TextStyle(fontSize: 16)),),],),),
                    Padding( padding: const EdgeInsets.all(8.0), child:Row(children: <Widget>[Text('Thickness: ',style: TextStyle(fontSize: 20)),Expanded(child:Text('${dataInfo.thickness}',style: TextStyle(fontSize: 16)),),],),),
                    Padding( padding: const EdgeInsets.all(8.0), child:Row(children: <Widget>[Text('Comments: ',style: TextStyle(fontSize: 20)),Expanded( flex: 1, child:new SingleChildScrollView(child: new Text('${dataInfo.comments}',style: TextStyle(fontSize: 16)),),),],),),        ],), ),)  ),),

        Container( child: new Row(children: <Widget>[
          Padding( padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
            child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),
            onPressed:() {Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);},
            child: const Text('HOME SCREEN')),),

          Padding(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),onPressed: scan,
            child: const Text('START CAMERA SCAN')),),],),),   ], ),  ));  }

  Future fetchData() async{
    setState(() { tcVisibility1 = true; isLoading =true;});
    var url = 'http://webek3.fuw.edu.pl/zps2g14/get_probe_info.py' +'?id=$barcode';
    final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() { isLoading = false; tcVisibility= false;});
        final jsonResponse = json.decode(response.body);
          DataBits list = new DataBits.fromJson(jsonResponse);
            dataInfo.id = list.id;  dataInfo.author = list.author;
            dataInfo.created_at = list.created_at;  dataInfo.description = list.description;
            dataInfo.thickness = list.thickness;  dataInfo.nr_layers = list.nr_layers;
            dataInfo.comments = list.comments;
          }
      else {showDialog(context: context,builder: (BuildContext context) => _popupscreen2(context),);}   }

  Future scan() async {
    try {String barcode = await BarcodeScanner.scan();
      setState(() {this.barcode = barcode; tcVisibility = true; tcVisibility1 = false;}); }
    on PlatformException catch (e) {
    if (e.code == BarcodeScanner.CameraAccessDenied) {
      setState(() {this.barcode = 'The user did not grant the camera permission!';  });  }
    else {setState(() => this.barcode = 'Unknown error: $e');  }  }
    on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');  }
    catch (e) {setState(() => this.barcode = 'Unknown error: $e');  }   }


    Widget _popupscreen2(BuildContext context) {
    return new AlertDialog( backgroundColor: Colors.grey[600],
        title: Center(child:Text('Error'),),
        titleTextStyle: TextStyle(fontSize: 20, ),titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),contentTextStyle: TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: Text('Missing entry or could not reach database. Try again or contact administrator.'),
        actions: <Widget>[new FlatButton(onPressed: () {Navigator.of(context).pop(); },
          child: const Text('Got it'),),],);    }



}
