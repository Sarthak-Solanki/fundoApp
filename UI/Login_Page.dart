import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'SignUpPage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'MainPage.dart';

class Login_Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginPageState();
}

class LoginPageState extends State<Login_Page> {
  static String email;
  static String _password;
  static final formKey = new GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googlesignin = new GoogleSignIn();

  final FacebookLogin fbLogin = new FacebookLogin();

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googlesignin.signIn();
    GoogleSignInAuthentication gsa = await googleSignInAccount.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: gsa.idToken, accessToken: gsa.accessToken);
    print("User Name ${user.displayName}");
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MainPage()));
    return user;
  }

  static bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  static Future<void> validateAndSubmit(context) {
    if (validateAndSave()) {
      try {
        print("email:$email pwd: $_password");
        final user = FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: _password);
        return user.then((user) {
          //Navigator.of(context).pop();
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => MainPage()));
        }).catchError((e) => print("exp: $e"));
      } catch (e) {
        print(e);
      }
    }
  }

  imgLogin() {
    return new Center(
      child: new Image.asset(
        "assets/login.png",
        width: 80.0,
      ),
    );
  }

  TFemail() {
    return new TextFormField(
        decoration: new InputDecoration(
            labelText: "Email",
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green))),
        onSaved: (value) => email = value,
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null);
  }

  TFpassword() {
    return new TextFormField(
        decoration: new InputDecoration(
            labelText: "Password",
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green))),
        obscureText: true,
        onSaved: (value) => _password = value,
        validator: (value) =>
            value.isEmpty ? 'password can\'t be empty' : null);
  }

  Devider() {
    return const Divider(
      height: 7.0,
    );
  }

  BTlogin(context) {
    return new RaisedButton(
      color: Colors.greenAccent.shade400,
      child: new Text("Login"),
      onPressed: () => validateAndSubmit(context),
    );
  }

  ForgetPass() {
    return new Container(
      alignment: Alignment(1.0, 0.0),
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      child: InkWell(
          child: Text(
        "Forgot Password",
        style: new TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      )),
    );
  }

  var Devider50 = const Divider(
    height: 50.0,
  );

  methSignup(context) => new RaisedButton(
        color: Colors.blue.shade300,
        child: new Text("Sign Up"),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => SignUpPage())),
      );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Text("Login Page"),
        centerTitle: true,
      ),
      body: new Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: new Form(
            key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(child: imgLogin()),
                TFemail(),
                TFpassword(),
                Devider(),
                BTlogin(context),
                // BTsignUp,
                methSignup(context),
                SizedBox(
                  height: 5.0,
                ),
                ForgetPass(),
                Devider50,
                new Text("OR",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.w600)),
                Devider50,
                Container(
                  height: 40.0,
                  child: new Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.greenAccent,
                    color: Colors.red.shade400,
                    elevation: 7.0,
                    child: GestureDetector(
                        onTap: () => _signIn()
                            .then(
                                (FirebaseUser user) => print(user.displayName))
                            .catchError((e) => print(e)),
                        child: Center(
                            child: Text(
                          "Login With Google",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))),
                  ),
                ),

                SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 40.0,
                  child: new Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.greenAccent,
                    color: Colors.blueAccent.shade400,
                    elevation: 7.0,
                    child: GestureDetector(
                        onTap: () {
                          fbLogin.logInWithReadPermissions(['email']).then(
                              (result) {
                            switch (result.status) {
                              case FacebookLoginStatus.loggedIn:
                                {
                                  FirebaseAuth.instance
                                      .signInWithFacebook(
                                          accessToken: result.accessToken.token)
                                      .then((signedInUser) {
                                    print('Signed in');
                                  }).catchError((e) =>
                                          print("error ${e.toString()}"));
                                  print('signed in');
                                }
                                break;
                              case FacebookLoginStatus.error:
                                print("error2 ${result.errorMessage}");
                                break;
                              case FacebookLoginStatus.cancelledByUser:
                                print("CancelledByUser");
                                break;
                            }
                          }).catchError((e) => print("errorzas${e}"));
                        },
                        child: Center(
                            child: Text(
                          "Login With Facebook",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
