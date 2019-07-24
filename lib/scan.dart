import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:QR_Test_Tubes/databits.dart';
import 'package:QR_Test_Tubes/datainfo.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ScanScreen extends StatefulWidget {@override  _ScanState createState() => new _ScanState(); }
class _ScanState extends State<ScanScreen> {
  String barcode = "";
  var tcVisibility = false;
  var tcVisibility1 = false;
  var isLoading = false;
  List _comments = new List();

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
                    Padding( padding: const EdgeInsets.all(8.0), child:Row(children: <Widget>[Text('Probe ID: ',style: TextStyle(fontSize: 20)),Spacer(),Text('${dataInfo.id}',style: TextStyle(fontSize: 16)),],),),
                    Padding( padding: const EdgeInsets.all(8.0), child: Row(children: <Widget>[Text('Author: ',style: TextStyle(fontSize: 20)),Spacer(),AutoSizeText('${dataInfo.author}',maxLines:1,),],),),
                    Padding( padding: const EdgeInsets.all(8.0), child:Row(children: <Widget>[Text('Creation date: ',style: TextStyle(fontSize: 20)),Spacer(),Text('${dataInfo.created_at}',style: TextStyle(fontSize: 16)),],),),
                    Padding( padding: const EdgeInsets.all(8.0), child:Row(children: <Widget>[Text('Number of layers: ',style: TextStyle(fontSize: 20)),Spacer(),Text('${dataInfo.nr_layers}',style: TextStyle(fontSize: 16)),],),),
                    Padding( padding: const EdgeInsets.all(8.0), child:Row(children: <Widget>[Text('Thickness: ',style: TextStyle(fontSize: 20)),Spacer(),Text('${dataInfo.thickness}',style: TextStyle(fontSize: 16)),],),),
                    Padding( padding: const EdgeInsets.all(8.0), child:Row(children: <Widget>[Text('Description: ',style: TextStyle(fontSize: 20)),Spacer(),],),),
                    Container(padding: const EdgeInsets.all(12),child: ConstrainedBox(constraints: BoxConstraints(maxHeight: 300.0,), child: new Scrollbar(
                          child:SingleChildScrollView(scrollDirection: Axis.vertical, reverse: true,
                              child: AutoSizeText('${dataInfo.description}',maxLines: 6,style: TextStyle(fontSize: 16)),  ),),), ),
                    Padding( padding: const EdgeInsets.all(8.0), child:Row(children: <Widget>[Text('Comments: ',style: TextStyle(fontSize: 20)),],),),

                    ListView.separated(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,padding: const EdgeInsets.all(22.0), itemCount: _comments.length,
                      itemBuilder: (BuildContext context, int index){return Container(child:Center(child:Column(children: <Widget>[
                        Row(children: <Widget>[Text('Created at: ',style: TextStyle(fontSize: 20)),Spacer(),Text('${_comments[index].created_at}',style: TextStyle(fontSize: 16)),],),
                        Row(children: <Widget>[Text('Author: ',style: TextStyle(fontSize: 20)),Spacer(),Text('${_comments[index].author}',style: TextStyle(fontSize: 16)),],),
                        Row(children: <Widget>[Text('Comment: ',style: TextStyle(fontSize: 20)),Spacer(),],),
                        Container(padding: const EdgeInsets.all(12),child: ConstrainedBox(constraints: BoxConstraints(maxHeight: 300.0,), child: new Scrollbar(
                              child:SingleChildScrollView(scrollDirection: Axis.vertical, reverse: true,
                                  child: AutoSizeText('${_comments[index].comment}',maxLines: 6,style: TextStyle(fontSize: 16)),  ),),), ),
                          ],),),);}, separatorBuilder: (BuildContext context, int index) => const Divider(),),

                    Padding(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),onPressed: () {Navigator.of(context).pushNamed('/comment',);},
                      child: const Text('Add comment')),), ],), ),)  ),),

        Container(child: new Row(children: <Widget>[
          Padding( padding: EdgeInsets.symmetric(horizontal: 44.0, vertical: 16.0),
            child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),
            onPressed:() {Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);},
            child: const Text('HOME SCREEN')),),

          Padding(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),onPressed: scan,
            child: const Text('START SCAN')),),],),),   ], ),  ));  }

  Future fetchData() async{
    setState(() { tcVisibility1 = true; isLoading =true;});
    var url = 'http://webek3.fuw.edu.pl/zps2g14/get_probe_info.py' +'?id=$barcode';
    final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() { isLoading = false; tcVisibility= false;});
        final jsonResponse = json.decode(response.body);
        bool success = jsonResponse['success'];
        if (success = true) {
        print(response.body);
          DataBits list = new DataBits.fromJson(jsonResponse);
            dataInfo.id = list.id;  dataInfo.author = list.author;
            dataInfo.created_at = list.created_at;  dataInfo.description = list.description;
            dataInfo.thickness = list.thickness;  dataInfo.nr_layers = list.nr_layers;
            _comments = list.comments ;
          }
        else {showDialog(context: context,builder: (BuildContext context) => _popupscreen1(context),);}  }
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

    Widget _popupscreen1(BuildContext context) {
    return new AlertDialog( backgroundColor: Colors.grey[600],
        title: Center(child:Text('Error'),),
        titleTextStyle: TextStyle(fontSize: 20, ),titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),contentTextStyle: TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: Text('Missing entry.'),
        actions: <Widget>[new FlatButton(onPressed: () {Navigator.of(context).pop(); },
          child: const Text('Got it'),),],);    }

    Widget _popupscreen2(BuildContext context) {
    return new AlertDialog( backgroundColor: Colors.grey[600],
        title: Center(child:Text('Error'),),
        titleTextStyle: TextStyle(fontSize: 20, ),titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),contentTextStyle: TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: Text('Could not reach database. Try again or contact administrator.'),
        actions: <Widget>[new FlatButton(onPressed: () {Navigator.of(context).pop(); },
          child: const Text('Got it'),),],);    }



}
