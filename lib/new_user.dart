import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:testwidgets1_0/login.dart';

class NewUser extends StatefulWidget {static String tag = 'new-user';@override _NewUserState createState() => new _NewUserState();}

class _NewUserState extends State<NewUser> {
  @override
  final _newemail = TextEditingController() ;
  final _newpassword = TextEditingController() ;
  final _newpassword1 = TextEditingController() ;
  Widget build(BuildContext context) {return Scaffold(appBar: AppBar(title: Text('QR test-tubes managment'),), body: _contentWidget(),  );}

  _contentWidget() {
  final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
  return Column(mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
  Container(padding: const EdgeInsets.all(12),child:TextFormField(controller: _newemail,
      decoration: InputDecoration(hintText: 'Email', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),   ),),),
  Container(padding: const EdgeInsets.all(12),child:TextFormField(controller: _newpassword,
      decoration: InputDecoration(hintText: 'Password', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),  ),),),
  Container(padding: const EdgeInsets.all(12),child:TextFormField(controller: _newpassword1,
      decoration: InputDecoration(hintText: 'Repeat password', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),  ),),),

  Padding(padding: const EdgeInsets.all(16.0),
      child:  FlatButton(child:  Text("Send", style: TextStyle(fontSize: 24)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      onPressed: () async{
          if (_newpassword.text == _newpassword1.text) {
          var url = 'http://webek3.fuw.edu.pl/zps2g14/add_new_user.py';
          var response = await http.post(url, body: {'email': _newemail.text ,'password': _newpassword.text , });
          print('Response status: ${response.statusCode}'); print('Response body: ${response.body}');
          if (response.statusCode == 200) {Navigator.pushNamed(context, '/log_in'); }
          else {showDialog(context: context,builder: (BuildContext context) => _popupscreen(context),);}  }
          else{showDialog(context: context,builder: (BuildContext context) => _popupscreen1(context),);}  } ),),
        ],);     }

  Widget _popupscreen(BuildContext context) {return new AlertDialog(title: Center(child:Text('Error'),),
      content: new Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[ Text('Could not reach database. Check your connection and try again'),
        Center(child:IconButton(icon: Icon(Icons.error),onPressed: null,),), ],),
        actions: <Widget>[new FlatButton(onPressed: () {Navigator.of(context).pop(); },),],);    }
  Widget _popupscreen1(BuildContext context) {return new AlertDialog(title: Center(child:Text('Error'),),
      content: new Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[ Text('Either email or password was incorrect. Try again or contact administrator.'),
        Center(child:IconButton(icon: Icon(Icons.error),onPressed: null,),), ],),
        actions: <Widget>[new FlatButton(onPressed: () {Navigator.of(context).pop(); },),],);    }

}