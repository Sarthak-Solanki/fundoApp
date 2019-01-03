import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login_Page.dart';
import 'TakeNotes.dart';
import 'crud.dart';
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MainState();
}
class MainState extends State<MainPage>{
  crudMethod crudObj = new crudMethod();
  static List l;
  var snapshot =  Firestore.instance.collection(LoginPageState.email).document('myData').collection('Note').snapshots();
  int size;
  static String directory;
  //String value1 = TakeNotesState.value;
  int num = 2;
  String title;
  String note;
  var Stagg;
  var iconView = Icon(Icons.view_agenda,color: Colors.black,);
  appBar(){
    return new AppBar(
      //title: new Text("Hello Notes"),
      backgroundColor: Colors.grey.shade200,
      elevation: 0.0,
      actions: <Widget>[

        new IconButton(icon: iconView, onPressed:
            (){
          if(iconView.toString() == Icon(Icons.view_agenda,color: Colors.black,).toString()){
            num = 4;
            iconView = Icon(Icons.dashboard,color: Colors.black,);
            setState(() {
            });
            //break;
          }
          else {
            iconView = Icon(Icons.view_agenda,color: Colors.black,);
            num = 2;
            setState(() {
            });
          }
          setState(() {
          });

        }),
        new IconButton(icon: new Icon(Icons.arrow_left,color: Colors.black,semanticLabel:"Logout"), onPressed: signOut),

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
                  Navigator.pop(context);
                }
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.add),
              title: new Text('Create new label'),
              //onTap: () => _onListTileTap(context),
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.archive),
              title: new Text('Archive'),
              onTap: () {
                directory = "Archive";
                snapshot  = Firestore.instance.collection(LoginPageState.email).document('myData').collection('Archive').snapshots();
                setState(() {
                });
                Navigator.pop(context);
              },
            ),
            new ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Trash'),
                onTap: (){
                  directory = "Delete";
                  snapshot  = Firestore.instance.collection(LoginPageState.email).document('myData').collection('Delete').snapshots();
                  setState(() {
                  });
                  Navigator.pop(context);
                }
            ),
          ]
      ),);
  }
  bottomNaviBar(context){
    return BottomAppBar(
      color: Colors.grey.shade200,
      elevation: 20.0,
      child: new RaisedButton(
          color: Colors.grey.shade200,
          child: new Text("Take a note...",textAlign: TextAlign.start,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TakeNotes(index: -1,color:Colors.white.toString()) ));
          }
      ),
    );
  }
  getColor(int index){
    String valueString = l[index].data["Color"].split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    Color color = new Color(value);
    return color;
  }
  createStaggered(contex,l){
    return new StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: l.length,
      itemBuilder: (BuildContext context, int index) {
        if(l[index]!="Pinned"&&l[index]!="Other"){
          return GestureDetector(
            onTap: () {
              var route = new MaterialPageRoute(builder: (BuildContext context)=>
              new TakeNotes(l:l,index: index,color:l[index].data["Color"],isPin: l[index].data["Pin"],isArchive: l[index].data["isArchive"]));
              Navigator.of(context).push(route);
            },
            onLongPress: (){
            },
            child: Container(
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.3,color: Colors.grey.shade200),
                color: getColor(index),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: new Column(
                children: <Widget>[
                  new Text(l[index].data['Title'],style: TextStyle(fontWeight: FontWeight.bold,)),
                  new Text("\n"),
                  new Text(l[index].data['Note']),
                ],
              ),
            ),
          );
        }
        else{
            return new Container(
              alignment: Alignment.topLeft,
               child:new Text(l[index],
                  ),
          );
        }
      },
      staggeredTileBuilder: (int index) {
        if(l[index]=="Pinned"||l[index]=="Other"){
          return StaggeredTile.fit(4);
        } else {
          return StaggeredTile.fit(num);
        }

      },

      padding:EdgeInsets.all(7.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,


    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: appBar(),
      drawer: drawer(),
      body:new StreamBuilder<QuerySnapshot>(
          stream: snapshot,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Center(
                child: CircularProgressIndicator(),);
            }else {
              l = snapshot.data.documents; //data.documents;
              List z = l;
              l = null;
              List pList = new List();
              List unpList = new List();
              for (int i = 0; i < z.length; i++) {
                if (z[i].data['Pin'] == true) {
                  pList.add(z[i]);
                }
                else {
                  unpList.add(z[i]);
                }
              }
              // Tags Pinned = new Tags();
              if(pList.isEmpty==false){
                pList.insert(0,"Pinned");
                unpList.insert(0,"Other");
                l = pList +unpList;
              }
              else{
                l = z;
              }
              //l.add("Pinned");
              return new Container(
                child: createStaggered(context,l),
              );
            }
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