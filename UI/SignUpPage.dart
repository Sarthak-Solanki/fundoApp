import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login_Page.dart';
class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignUpPage();

}
class _SignUpPage extends State<SignUpPage>{
  static String _email;
  static String _password;
  static final formKey = new GlobalKey<FormState>();

  var TFname = new TextFormField(
    decoration: new InputDecoration(labelText: "email",
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green))
    ),
    onSaved: (value)=>_email=value,
  );
  var TFpass =new   TextFormField(
    decoration: new InputDecoration(labelText: "Password > 6 characters ",
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
    ),
    onSaved: (value)=>_password=value,
    obscureText: true,
  );
  static registerUser(context) async{
    final form = formKey.currentState;
    form.save();
    try{FirebaseUser user  =await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
    if (user.isEmailVerified  ){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> Login_Page()));
    }
    }
    catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child: new Form(
              key:formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TFname,
                  TFpass,
                  //signUp(context),
                  RaisedButton(
                    color: Colors.blue.shade300,
                    child: new Text("Sign Up"),
                    onPressed: (){
                      registerUser(context);
                    },
                  ),
                ],
              )
          )
      ),


    );

  }



}