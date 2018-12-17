import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login_Page.dart';
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
     Firestore.instance.document('${LoginPageState.email}/myData').collection("KeepData").add(keepData).catchError((e)=> print(e));
  }
  void updateData(id,newValues){
    //Firestore.instance.collection(LoginPageState.email).document(id).updateData(newValues).catchError((e)=>print("Update error $e"));
Firestore.instance.collection(LoginPageState.email).
document('myData').collection('KeepData').
  document(id).updateData(newValues).catchError((e)=>print("Update error $e"));
  }
  void deleteData(id){
    Firestore.instance.collection(LoginPageState.email).document('myData').collection('KeepData').document(id).delete().catchError((e)=> print(e));
  }
  void fetchData() async{
    //var data = Firestore.instance;
    //var collection = data.collection(LoginPageState.email);
    var f = await Firestore.instance.collection(LoginPageState.email).document('myData').collection('KeepData').getDocuments();
          //print(f.documents[0].data['Note']);
  }
}