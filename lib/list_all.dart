import 'package:QR_Test_Tubes/tubeslist.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:QR_Test_Tubes/home_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:QR_Test_Tubes/appdata.dart';
import 'package:QR_Test_Tubes/databits.dart';
import 'package:QR_Test_Tubes/datainfo.dart';
import 'package:QR_Test_Tubes/add_comment.dart';


class ListAll extends StatefulWidget {@override State<StatefulWidget> createState() => ListAllState();}

class ListAllState extends State<ListAll> {

  List tubeslist = new List();
  var tcVisibility1 = false;
  var isLoading =false;

  @override
  void initState()  { super.initState(); listenForTubes();  }

  void listenForTubes() async {
     setState(() { tcVisibility1 = true; isLoading =true;});
     var url = 'http://webek3.fuw.edu.pl/zps2g14/list_all.py';
     final response = await http.get(url);
       if (response.statusCode == 200) {
         setState(() { isLoading =false;});
         final jsonResponse = json.decode(response.body);
         print(response.body);
         TubesList list = TubesList.fromJson(jsonResponse);
         tubeslist = list.tubesList;
    //stream.listen((TubesList tube) => setState(() => tubeslist.add(tube)));
  }}

  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(centerTitle: true,title: Text('Database'),),
      body:
      Visibility(visible: tcVisibility1, child:Container(margin: const EdgeInsets.all(10.0), alignment: Alignment.center,
            decoration: BoxDecoration( color: Colors.grey[500], shape: BoxShape.rectangle, borderRadius: new BorderRadius.all(new Radius.circular(32.0)),),
            child:
              isLoading ?
                Center(child:CircularProgressIndicator(),)
              :
                ListView.separated(shrinkWrap: true,padding: const EdgeInsets.all(22.0), itemCount: tubeslist.length,
                  itemBuilder: (BuildContext context, int index){return Container(child:Center(child:Column(children: <Widget>[
                    Row(children: <Widget>[Text('Created at: ',style: TextStyle(fontSize: 20)),Expanded(child:Text('${tubeslist[index].created_at}',style: TextStyle(fontSize: 16)),),],),
                    Row(children: <Widget>[Text('Author: ',style: TextStyle(fontSize: 20)),Expanded(child:Text('${tubeslist[index].author}',style: TextStyle(fontSize: 16)),),],),
                    Row(children: <Widget>[Text('Description: ',style: TextStyle(fontSize: 20)),Expanded(child:Text('${tubeslist[index].description}',style: TextStyle(fontSize: 16)),),],),
                    ],),),);}, separatorBuilder: (BuildContext context, int index) => const Divider(),),
        ))  );}

}
