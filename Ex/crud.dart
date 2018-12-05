import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<void> addData(keepData) async{
    if(isLogin()){
    Firestore.instance.collection('KeepData').add(keepData).catchError((e){print("eroee is************** $e");});
    }
  }
}