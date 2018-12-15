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
  void updateData(id,newValues){
    Firestore.instance.collection('KeepData').document(id).updateData(newValues).catchError((e)=>print("Update error $e"));

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
