import 'package:flutter/material.dart';
import 'Login_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MainState();
}
class _MainState extends State<MainPage>{
  appBar(){
    return new AppBar(
      title: new Text("Hello Notes"),
      actions: <Widget>[
      ],
    );
  }
  drawer(){
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          Container(
            height:70.0,
            child:DrawerHeader(
              child: Text("FunDoo Notes",style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),

    );
  }
  bottomNaviBar(){
    return BottomAppBar(
      elevation: 20.0,
      child: new RaisedButton(
        color: Colors.white,
        child: new Text("Add Note"),
        onPressed: ()=>print("hhh"),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      bottomNavigationBar:bottomNaviBar(),
    );
  }

  Future <Login_Page> signOut()  async{
    await FirebaseAuth.instance.signOut().then((_){
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/LandingPage');
  }).catchError((e)=>print(e));
}
}

