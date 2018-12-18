import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login_Page.dart';
class crudMethod{
  var keepData;
  Future<void> addData(keepData) async{
    //this.keepData = keepData;
    Firestore.instance.document('${LoginPageState.email}/myData').collection("Note").add(keepData).catchError((e)=> print(e));
  }
  void updateData(id,newValues){
    //Firestore.instance.collection(LoginPageState.email).document(id).updateData(newValues).catchError((e)=>print("Update error $e"));
    Firestore.instance.collection(LoginPageState.email).
    document('myData').collection('Note').
    document(id).updateData(newValues).catchError((e)=>print("Update error $e"));
  }
  Future<void> deleteData(id) async{
    var test =  await Firestore.instance.document('${LoginPageState.email}/myData').collection('Note').document(id).get();
    Map m = test.data;
    Firestore.instance.document('${LoginPageState.email}/myData').collection("Delete").add(m).catchError((e)=> print(e));

    Firestore.instance.collection(LoginPageState.email).document('myData').collection('Note').document(id).delete().catchError((e)=> print(e));

  }
  void fetchData() async{
    var f = await Firestore.instance.collection(LoginPageState.email).document('myData').collection('KeepData').getDocuments();
  }
}