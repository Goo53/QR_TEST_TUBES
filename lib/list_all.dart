import 'package:QR_Test_Tubes/tubeslist.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:QR_Test_Tubes/databits.dart';
import 'package:QR_Test_Tubes/datainfo.dart';
import 'package:auto_size_text/auto_size_text.dart';


class ListAll extends StatefulWidget {@override State<StatefulWidget> createState() => ListAllState();}

class ListAllState extends State<ListAll> {

  List tubeslist = new List();
  List _comments = new List();
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
  }}

  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(centerTitle: true,title: Text('Database'),),
      body:
      Visibility(visible: tcVisibility1, child:Container( alignment: Alignment.center,
            child:
              isLoading ?
                Center(child:CircularProgressIndicator(),)
              :
                ListView.separated(shrinkWrap: true,padding: const EdgeInsets.all(22.0), itemCount: tubeslist.length,
                  itemBuilder: (BuildContext context, int index){return InkWell(
                    child:Container(child:Center(child:Column(children: <Widget>[
                      Row(children: <Widget>[Text('Created at: ',style: TextStyle(fontSize: 20)),Spacer(),Text('${tubeslist[index].created_at}',style: TextStyle(fontSize: 16)),],),
                      Row(children: <Widget>[Text('Author: ',style: TextStyle(fontSize: 20)),Spacer(),AutoSizeText('${tubeslist[index].author}',maxLines:1,),],),
                      Row(children: <Widget>[Text('ID: ',style: TextStyle(fontSize: 20)),Spacer(),AutoSizeText('${tubeslist[index].id}',maxLines:1,style: TextStyle(fontSize: 16)),],),
                      Row(children: <Widget>[Text('Description: ',style: TextStyle(fontSize: 20)),Spacer(),],),
                      Container(padding: const EdgeInsets.all(12),child: ConstrainedBox(constraints: BoxConstraints(maxHeight: 300.0,), child: new Scrollbar(
                            child:SingleChildScrollView(scrollDirection: Axis.vertical, reverse: true,
                                child: AutoSizeText('${tubeslist[index].description}',maxLines: 6,style: TextStyle(fontSize: 16)),  ),),), ),
                                 ],),),),
                    onTap: () async {
                        var url = 'http://webek3.fuw.edu.pl/zps2g14/get_probe_info.py' +'?id=${tubeslist[index].id}';
                        final response = await http.get(url);
                          if (response.statusCode == 200) {
                            final jsonResponse = json.decode(response.body);
                            bool success = jsonResponse['success'];
                            if (success = true) {
                            print(response.body);
                              DataBits list = new DataBits.fromJson(jsonResponse);
                                dataInfo.id = list.id;  dataInfo.author = list.author;
                                dataInfo.created_at = list.created_at;  dataInfo.description = list.description;
                                dataInfo.thickness = list.thickness;  dataInfo.nr_layers = list.nr_layers;
                                _comments = list.comments ;
                                showDialog(context: context,builder: (BuildContext context) => _probeinfo(context),);
                              }
                            else {showDialog(context: context,builder: (BuildContext context) => _popupscreen1(context),);}  }
                          else {showDialog(context: context,builder: (BuildContext context) => _popupscreen2(context),);}   },

                  );}, separatorBuilder: (BuildContext context, int index) => const Divider(),),
        )) );}

        Widget _probeinfo(BuildContext context) {
        return new AlertDialog( backgroundColor: Colors.grey[600],
            title: Center(child:Text('Probe ID: ${dataInfo.id}'),),
            titleTextStyle: TextStyle(fontSize: 20, ),titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),contentTextStyle: TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: Container(constraints: BoxConstraints.expand(width: 350.0,  height: 400.0), child:
              Scrollbar(child:SingleChildScrollView(child:Column(children: <Widget>[
                Row(children: <Widget>[Text('Author: ',style: TextStyle(fontSize: 20)),Spacer(),AutoSizeText('${dataInfo.author}',maxLines:1,style: TextStyle(fontSize: 16)),],),
                Row(children: <Widget>[Text('Date: ',style: TextStyle(fontSize: 20)),Spacer(),Text('${dataInfo.created_at}',style: TextStyle(fontSize: 16)),],),
                Row(children: <Widget>[Text('Number of layers: ',style: TextStyle(fontSize: 20)),Spacer(),Text('${dataInfo.nr_layers}',style: TextStyle(fontSize: 16)),],),
                Row(children: <Widget>[Text('Thickness: ',style: TextStyle(fontSize: 20)),Spacer(),Text('${dataInfo.thickness}',style: TextStyle(fontSize: 16)),],),
                Row(children: <Widget>[Text('Description: ',style: TextStyle(fontSize: 20)),Spacer(),],),
                Container(padding: const EdgeInsets.all(12),child: ConstrainedBox(constraints: BoxConstraints(maxHeight: 300.0,), child: new Scrollbar(
                      child:SingleChildScrollView(scrollDirection: Axis.vertical, reverse: true,
                          child: AutoSizeText('${dataInfo.description}',maxLines: 6,style: TextStyle(fontSize: 16)),  ),),), ),
                Row(children: <Widget>[Text('Comments: ',style: TextStyle(fontSize: 20)),],),

                ListView.separated(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,padding: const EdgeInsets.all(8.0), itemCount: _comments.length,
                  itemBuilder: (BuildContext context, int index){return Container( padding: const EdgeInsets.all(10.0),child:Center(child:Column(children: <Widget>[
                    Center(child:Text('${_comments[index].created_at}',style: TextStyle(fontSize: 18)),),
                    Row(children: <Widget>[Text('Author: ',style: TextStyle(fontSize: 16)),Spacer(),AutoSizeText('${_comments[index].author}',maxLines:1,style: TextStyle(fontSize: 16)),],),
                    Row(children: <Widget>[Text('Comment: ',style: TextStyle(fontSize: 16)),Spacer()],),
                    Container(padding: const EdgeInsets.all(12),child: ConstrainedBox(constraints: BoxConstraints(maxHeight: 300.0,), child: new Scrollbar(
                          child:SingleChildScrollView(scrollDirection: Axis.vertical, reverse: true,
                              child: AutoSizeText('${_comments[index].comment}',maxLines: 6,style: TextStyle(fontSize: 16)),  ),),), ),
                      ],),),);}, separatorBuilder: (BuildContext context, int index) => const Divider(),),

                Padding(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: RaisedButton(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(32.0)),onPressed: () {Navigator.of(context).pushNamed('/comment',);},
                  child: const Text('Add comment')),), ],),),), ),
            actions: <Widget>[new FlatButton(onPressed: () {Navigator.of(context).pop(); },
              child: const Text('Got it'),),],);    }

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
