import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScanScreen extends StatefulWidget {@override  _ScanState createState() => new _ScanState(); }
class _ScanState extends State<ScanScreen> {
  String barcode = "";
  var tcVisibility = false;

  @override initState() {super.initState();  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: new AppBar(
    title: new Text('QR Code Scanner'),),
    body: new Center(
      child: new Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Visibility(visible: tcVisibility, child:AlertDialog(title: Center(child:Text('Scan results:'),),
            titleTextStyle: TextStyle(fontSize: 20, ),titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),contentTextStyle: TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: Center(child:Text(barcode),),
            actions: <Widget>[new Center(child:FlatButton(onPressed: () {Navigator.of(context).pop(); },
            child: const Text('Search in database'),),),],),),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),onPressed: scan,
          child: const Text('START CAMERA SCAN')),), ], ),  ));  }

  Future scan() async {
    try {String barcode = await BarcodeScanner.scan();
      setState(() {this.barcode = barcode; tcVisibility = true;}); }
    on PlatformException catch (e) {
    if (e.code == BarcodeScanner.CameraAccessDenied) {
      setState(() {this.barcode = 'The user did not grant the camera permission!';  });  }
    else {setState(() => this.barcode = 'Unknown error: $e');  }  }
    on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');  }
    catch (e) {setState(() => this.barcode = 'Unknown error: $e');  }   }
}
