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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = true;
  bool passwordVisible = false;
  bool passwordVisible1 = false;
  Widget build(BuildContext context) {return Scaffold(appBar: AppBar(title: Text('QR test-tubes managment'),), body: _contentWidget(),  );}

  _contentWidget() {
  final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
  return Form(key: _formKey, autovalidate: _autoValidate,  child:Column(mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
  Container(padding: const EdgeInsets.all(12),
      child:TextFormField(controller: _newemail, validator: validateEmail,
      decoration: InputDecoration(hintText: 'Email', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),   ),),),
  Container(padding: const EdgeInsets.all(12),
      child:TextFormField(controller: _newpassword, validator: validatePassword, obscureText: passwordVisible,
      decoration: InputDecoration(hintText: 'Password', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      suffixIcon: IconButton(icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off,),
        onPressed: () { setState(() {passwordVisible = !passwordVisible; }); },),  ),),),
  Container(padding: const EdgeInsets.all(12),
      child:TextFormField(controller: _newpassword1, validator: validatePassword1,obscureText: passwordVisible1,
      decoration: InputDecoration(hintText: 'Repeat password', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      suffixIcon: IconButton(icon: Icon(passwordVisible1 ? Icons.visibility : Icons.visibility_off,),
        onPressed: () { setState(() {passwordVisible1 = !passwordVisible1; }); },),  ),),),

  Padding(padding: const EdgeInsets.all(16.0),
      child:  FlatButton(child:  Text("Submit", style: TextStyle(fontSize: 24)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      onPressed: () async{
          if ( _formKey.currentState.validate()) {
          var url = 'http://webek3.fuw.edu.pl/zps2g14/add_new_user.py';
          var response = await http.post(url, body: {'email': _newemail.text ,'password': _newpassword.text , });
          print('Response status: ${response.statusCode}'); print('Response body: ${response.body}');
          if (response.statusCode == 200) {Navigator.pushNamed(context, '/log_in'); }
          else {showDialog(context: context,builder: (BuildContext context) => _popupscreen(context),);}  }
          else{showDialog(context: context,builder: (BuildContext context) => _popupscreen1(context),);}  }  ),),


    ],),);     }

  Widget _popupscreen(BuildContext context) {return new AlertDialog(title: Center(child:Text('Error'),),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: new Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[ Center(child:Text('Could not reach database. Check your connection and try again'),),
        Center(child:IconButton(icon: Icon(Icons.error),onPressed: null,),), ],),
        actions: <Widget>[new FlatButton(onPressed: () {Navigator.of(context).pop(); },),],);    }
  Widget _popupscreen1(BuildContext context) {return new AlertDialog(title: Center(child:Text('Error'),),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: new Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[ Center(child:Text('Data incorrect!'),),
        Center(child:IconButton(icon: Icon(Icons.error),onPressed: null,),), ],),
        actions: <Widget>[new FlatButton(onPressed: () {Navigator.of(context).pop(); },),],);    }

  String validateEmail(String value) {
      Pattern pattern =r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern); if (!regex.hasMatch(value)) {return 'Enter Valid Email';}
      else {return null;}  }
  String validatePassword(String value) {
      if (value.length < 3)  {return 'The Password Requires 3 Characters Or More';}
      else  {return null;  }}
  String validatePassword1(String value) {
      if (_newpassword.text != _newpassword1.text)  {return 'Passwords must be the same';}
      else  {return null;  }}

}
