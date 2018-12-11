import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class crudMethod{
  //final documentref = Firestore.instance.document(path)

  bool isLogin(){
    FirebaseAuth.instance.signInWithEmailAndPassword(email: "test@test.com", password: "test1234");
    if(FirebaseAuth.instance.currentUser()!=null){
      return true;

    }
    else {
      print("************************************SDSADDSDSDSSADDSADS************");
      return false;
    }
  }
  var keepData;
  Future<void> addData(keepData) async{
    //if(isLogin()){
      Firestore.instance.collection('KeepData').add(keepData).catchError((e){print("eroee is************** $e");});
    //}
  }

}
class test1 extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new DataFetch();
  }

}


class DataFetch extends State<test1> {


  static List l;

 static body(context){
   return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('KeepData').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return new Text("Please wait");
          //else{
          l = snapshot.data.documents;
          String title = snapshot.data.documents[0].data['title'];
          String note = snapshot.data.documents[0].data['note'];
          print("Lenght is ${l.length}");
          //print(note);
           new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                child: new Center(
                  child:  Text(snapshot.data.documents.length.toString()),
                ),
              ),
            ],
          );
          //}
        }
    );
    print(l.length);
     //return l.length;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:body(context),
    );
  }

}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      // theme: kThemeData,
      home: test1(),
    );
  }
}
main()=> runApp(new App());

/*var mytext;
    Firestore.instance.collection('KeepData').document('LT6v9xuv9mH-6kmKJbL').get().then((snapshot){
    mytext = snapshot.data['note'];
    print("this is data$mytext");
    });
    return mytext;
    *//*
 //print(result.data['title']);*/
