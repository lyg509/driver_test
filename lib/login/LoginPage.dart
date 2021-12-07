import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  late String _email;
  late String _password;

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid Email: $_email, password: $_password');
    } else {
      print('Form is invalid Email: $_email, password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title:  Text('login demo'),
      ),
      body:  Container(
        padding: EdgeInsets.all(16),
        child:  Form(
          key: formKey,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
               TextFormField(
                decoration:  InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value!.isEmpty ? 'Email can\'t be empty' : null,
                onSaved: (value) => _email = value!,
              ),
               TextFormField(
                obscureText: true,
                decoration:  InputDecoration(labelText: 'Password'),
                validator: (value) =>
                value!.isEmpty ? 'Password can\'t be empty' : null,
                onSaved: (value) => _password = value!,
              ),
               // ignore: deprecated_member_use
               RaisedButton(
                onPressed: validateAndSave,
                child:  Text(
                  'Login',
                  style:  TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

