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
         new IconButton(icon: new Icon(Icons.arrow_drop_down), onPressed: signOut),

      ],
    );
  }
  drawer(){
    return new Drawer(
      child: new ListView(
         padding: const EdgeInsets.only(top: 0.0),
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(""),
              accountEmail: Text(LoginPageState.email),
              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.brown,
                child: new Text(""),
              ),
              otherAccountsPictures: <Widget>[
                new GestureDetector(
                  onTap: () => print(""),
                  child: new Semantics(
                    label: 'Switch Account',
                    child: new CircleAvatar(
                      backgroundColor: Colors.brown,
                      child: new Text('SA'),
                    ),
                  ),
                )
	            ]
            ),
            new ListTile(
              leading: new Icon(Icons.lightbulb_outline),
              title: new Text('Notes'),
              //onTap: () => _onListTileTap(context),
            ),
            new Divider(),
            new ListTile(
              leading: new Text('Label'),
              trailing: new Text('Edit'),
              //onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.label),
              title: new Text('Expense'),
              //onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.label),
              title: new Text('Inspiration'),
              //onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.label),
              title: new Text('Personal'),
             // onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.label),
              title: new Text('Work'),
              //onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.add),
              title: new Text('Create new label'),
              //onTap: () => _onListTileTap(context),
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.archive),
              title: new Text('Archive'),
              //onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.delete),
              title: new Text('Trash'),
              //onTap: () => _onListTileTap(context),
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.settings),
              title: new Text('Settings'),
              //onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.help),
              title: new Text('Help & feedback'),
              //onTap: () => _onListTileTap(context),
            )
          ]
    ),);
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

