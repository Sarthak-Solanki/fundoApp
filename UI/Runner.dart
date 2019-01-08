import 'Login_Page.dart';
import 'MainPage.dart';
import 'SignUpPage.dart';
import 'TakeNotes.dart';
import 'package:flutter/material.dart';
import 'AddLabel.dart';
import 'LabelPage.dart';
void main()=> runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Login_Page(),
      routes: <String, WidgetBuilder>{
        '/LandingPage': (BuildContext context) => new MyApp(),
        '/SignUp': (BuildContext context) => new SignUpPage(),
        '/MainPage': (BuildContext context) => new MainPage(),
        '/NotePage':  (BuildContext context) => new TakeNotes(),
        '/CreateLabel':(BuildContext context)=> new AddLabels(),
        '/LabelList':(BuildContext context)=>new LabelPage()
      },
    );
  }

}