import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login_Page.dart';
import 'MainPage.dart';
class crudMethod{
  var keepData;
  Future<void> addData(keepData) async{
    //this.keepData = keepData;
    Firestore.instance.document('${LoginPageState.email}/myData').collection("Note").add(keepData).catchError((e)=> print(e));
  }
  void updateData(id,newValues){
    if(MainState.directory=="Note"){
      Firestore.instance.collection(LoginPageState.email).
      document('myData').collection('Note').
      document(id).updateData(newValues).catchError((e)=>print("Update error $e"));}
    else if(MainState.directory=="Archive"){
      Firestore.instance.collection(LoginPageState.email).
      document('myData').collection(MainState.directory).
      document(id).updateData(newValues).catchError((e)=>print("Update error $e"));}
    else{
      Firestore.instance.collection(LoginPageState.email).
      document('myData').collection('Note').
      document(id).updateData(newValues).catchError((e)=>print("Update error $e"));
    }

  }

  void toArchive(id) async{
    var test =  await Firestore.instance.document('${LoginPageState.email}/myData').collection('Note').document(id).get();
    Map m = test.data;
    Firestore.instance.document('${LoginPageState.email}/myData').collection("Archive").add(m).catchError((e)=> print(e));
    Firestore.instance.collection(LoginPageState.email).document('myData').collection('Note').document(id).delete().catchError((e)=> print(e));
  }
  void unArchive(id) async{
    var test =  await Firestore.instance.document('${LoginPageState.email}/myData').collection('Archive').document(id).get();
    Map m = test.data;
    Firestore.instance.document('${LoginPageState.email}/myData').collection("Note").add(m).catchError((e)=> print(e));
    Firestore.instance.collection(LoginPageState.email).document('myData').collection('Archive').document(id).delete().catchError((e)=> print(e));
  }
  Future<void> deleteData(id) async{
    if(MainState.directory=='Note') {
      var test = await Firestore.instance.document(
          '${LoginPageState.email}/myData').collection('Note')
          .document(id)
          .get();
      Map m = test.data;
      Firestore.instance.document('${LoginPageState.email}/myData').collection(
          "Delete").add(m).catchError((e) => print(e));
      Firestore.instance.collection(LoginPageState.email).document('myData')
          .collection('Note').document(id).delete()
          .catchError((e) => print(e));
    }
    else if(MainState.directory == "Delete"){
      print("delete");
      Firestore.instance.collection(LoginPageState.email).document('myData').collection(MainState.directory).document(id).delete().catchError((e)=> print(e));
    }
    else if(MainState.directory=="Archive"){
      print("archive");
      var test =  await Firestore.instance.document('${LoginPageState.email}/myData').collection('Archive').document(id).get();
      Map m = test.data;
      Firestore.instance.document('${LoginPageState.email}/myData').collection("Delete").add(m).catchError((e)=> print(e));
      Firestore.instance.collection(LoginPageState.email).document('myData').collection('Archive').document(id).delete().catchError((e)=> print(e));
    }
    else{
      var test = await Firestore.instance.document(
          '${LoginPageState.email}/myData').collection('Note')
          .document(id)
          .get();
      Map m = test.data;
      Firestore.instance.document('${LoginPageState.email}/myData').collection(
          "Delete").add(m).catchError((e) => print(e));
      Firestore.instance.collection(LoginPageState.email).document('myData')
          .collection('Note').document(id).delete()
          .catchError((e) => print(e));

    }
  }
  void restoreData(id) async{
    var test =  await Firestore.instance.document('${LoginPageState.email}/myData').collection('Delete').document(id).get();
    Map m = test.data;
    Firestore.instance.collection(LoginPageState.email).document('myData').collection('Delete').document(id).delete().catchError((e)=> print(e));
    Firestore.instance.collection(LoginPageState.email).document('myData').collection('Note').add(m).catchError((e)=> print(e));

  }
  void addLabel(data){
    Firestore.instance.document('${LoginPageState.email}/myData').collection(
        "Label").add(data).catchError((e)=> print(e));
  }
  void deleteLabel(id){
    Firestore.instance.collection(LoginPageState.email).document('myData').collection('Label').document(id).delete().catchError((e)=> print(e));
  }
  fetchData() async{
    return await Firestore.instance.collection(LoginPageState.email).document('myData').collection('Label').getDocuments();
  }
  fetchNoteData() async{
    if(MainState.directory==null){
      MainState.directory='Note';
    }
    return await Firestore.instance.collection(LoginPageState.email).document('myData').collection(MainState.directory).getDocuments();
  }
  updatelabel(newValues,id){
    Firestore.instance.collection(LoginPageState.email).
    document('myData').collection('Label').
    document(id).updateData(newValues).catchError((e)=>print("Update error $e"));
  }


}


