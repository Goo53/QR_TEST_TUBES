import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testwidgets1_0/home_screen.dart';
import 'package:testwidgets1_0/new_user.dart';
import 'package:path_provider/path_provider.dart';


class LogIn extends StatefulWidget {static String tag = 'login-page';@override _LogInState createState() => new _LogInState();}

class _LogInState extends State<LogIn> {
  @override
  final _email = TextEditingController() ;
  final _password = TextEditingController() ;

  Widget build(BuildContext context) {return Scaffold(appBar: AppBar(title: Text('QR test-tubes managment'),), body: _contentWidget(),  );}
  _contentWidget() {
  final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
  return Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
  Container(padding: const EdgeInsets.all(12),child:TextFormField(controller: _email,
      decoration: InputDecoration(hintText: 'Email', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),   ),),),
  Container(padding: const EdgeInsets.all(12),child:TextFormField(controller: _password,
      decoration: InputDecoration(hintText: 'Password', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),  ),),),

  Padding(padding: const EdgeInsets.all(16.0),
      child:  FlatButton(child:  Text("Log In", style: TextStyle(fontSize: 24)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      onPressed: () async{
          var url = 'http://webek3.fuw.edu.pl/zps2g14/login_user.py';
          var response = await http.post(url, body: {'login': _email.text ,'password': _password.text , });
          print('Response status: ${response.statusCode}'); print('Response body: ${response.body}');
          if (response.statusCode == 200) { Navigator.pushNamed(context, '/home');}
          else {showDialog(context: context,builder: (BuildContext context) => _popupscreen(context),);}  }, ),),

  Padding(padding: const EdgeInsets.all(16.0),
      child:  FlatButton(child:  Text("Create New User", style: TextStyle(fontSize: 24)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      onPressed:() {Navigator.pushNamed(context, '/new_user');} ),),
        ],);     }

  Widget _popupscreen(BuildContext context) {return new AlertDialog(title: Center(child:Text('Error'),),
      content: new Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[ Text('Either email or password was incorrect. Try again or contact administrator.'),
        Center(child:IconButton(icon: Icon(Icons.error),onPressed: null,),), ],),
        actions: <Widget>[new FlatButton(onPressed: () {Navigator.of(context).pop(); },),],);    }


}
