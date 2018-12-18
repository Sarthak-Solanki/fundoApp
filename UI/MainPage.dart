import 'package:flutter/material.dart';
import 'Login_Page.dart';
import 'TakeNotes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crud.dart';
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MainState();
}
class MainState extends State<MainPage>{
  crudMethod crudObj = new crudMethod();
  static List l;
  var snapshot = Firestore.instance.collection(LoginPageState.email).document('myData').collection('Note').snapshots();
  int size;
  static String directory;
  int num = 2;
  String title;
  String note;
  var Stagg;
  var iconView = Icon(Icons.dehaze);
  appBar(){
    return new AppBar(
      //title: new Text("Hello Notes"),
      actions: <Widget>[
        new IconButton(icon: iconView, onPressed:
            (){
          if(iconView.toString() == Icon(Icons.dehaze).toString()){
            num = 4;
            iconView = Icon(Icons.border_all);
            setState(() {
            });
            //break;
          }
          else {
            iconView = Icon(Icons.dehaze);
            num = 2;
            setState(() {
            });
          }
          setState(() {
          });

            }),
        new IconButton(icon: new Icon(Icons.arrow_drop_down), onPressed: signOut),
      ],
    );
  }
  makeContainer(){
    new Container(
      height: 24.0,
      child: new Column(
        children: <Widget>[
          new Icon(Icons.close),
          new Icon(Icons.delete),
        ],
      ),
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
                onTap: (){
                  directory = "Note";
                  snapshot  = Firestore.instance.collection(LoginPageState.email).document('myData').collection('Note').snapshots();
                  setState(() {
                  });
                }
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
                onTap: (){
                  directory = "Delete";
                  snapshot  = Firestore.instance.collection(LoginPageState.email).document('myData').collection('Delete').snapshots();
                  setState(() {

                  });
                }
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
  bottomNaviBar(context){
    return BottomAppBar(
      elevation: 20.0,
      child: new RaisedButton(
          color: Colors.white,
          child: new Text("Add Note"),
          onPressed: () {
            // crudObj.fetchData();
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TakeNotes(index: -1) ));
          }
      ),
    );
  }
 // body(context){


    // createStaggered();}

  createStaggered(context){
    return new StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: l.length,
      itemBuilder: (BuildContext context, int index) =>
          GestureDetector(
            onTap: () {
              var route = new MaterialPageRoute(builder: (BuildContext context)=>new TakeNotes(index: index));
              Navigator.of(context).push(route);
            },
            onLongPress: (){
            },
            child: Container(
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.3,color: Colors.grey.shade200),
                color: TakeNotesState.value,
                borderRadius: BorderRadius.circular(8.0),
              ),

              child: new Column(
                children: <Widget>[
                  new Text(l[index ].data['Title'],style: TextStyle(fontWeight: FontWeight.bold,)),
                  new Text("\n"),
                  new Text(l[index].data['Note']),
                ],
              ),
            ),
          ),
      staggeredTileBuilder: (int index) => 
      new StaggeredTile.fit(num),
      padding: EdgeInsets.all(7.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      drawer: drawer(),
      body:new StreamBuilder<QuerySnapshot>(
          stream: snapshot,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Center(
                child: CircularProgressIndicator(),);
            }else{
              l = snapshot.data.documents;//data.documents;
              return new Container(
                child: createStaggered(context),
              );}
          }
      ),

      bottomNavigationBar:bottomNaviBar(context),
    );
  }

  Future <Login_Page> signOut()  async{
    await FirebaseAuth.instance.signOut().then((_){
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/LandingPage');
    }).catchError((e)=>print(e));
  }
}

