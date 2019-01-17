import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login_Page.dart';
import 'TakeNotes.dart';
import 'AddLabel.dart';
import 'crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MainState();
}
class MainState extends State<MainPage>{
  crudMethod crudObj = new crudMethod();
  static  final scaffoldKey  = new GlobalKey<ScaffoldState>();
  static QuerySnapshot QSlabels ;
  List labels;
  List ls;
  var Galleryimage;
  String downloadUrl;
  StorageReference ref = FirebaseStorage.instance.ref().child('profileImg.jpg');
  var _image;
  @override
  void initState() {
    get();
    crudObj.fetchData().then((result){
      /*if(!result.hasData){
        return new Center(
          child: CircularProgressIndicator(),
        );
      }*/
      QSlabels =result;
      labels = QSlabels.documents;
      if(labels==null){
        labels.length==0;
      }
      setState(() {

      });
    });// TODO: implement initState
    super.initState();
  }
  get() async{
    QuerySnapshot ds = await Firestore.instance.document('${LoginPageState.email}/myData').collection("profileImg").getDocuments().then((reg){
      if(reg.documents.length!=0){
        ls = reg.documents;
        // if(ls!=null)
        downloadUrl = ls[0].data["Url"];
      }
    });

  }
  gallery() async{
    print("picker is called");
    get();
    Galleryimage  = await ImagePicker.pickImage(source: ImageSource.gallery);
    _image = Galleryimage;
    if(_image!=null&&ls!=null){
      delete(ls[0].documentID);
    }
    _image!=null?uploadImage(_image):Dialog(child: new Text("No image is selected"),);

    setState(() {
    });

  }
  static showSnackbar(s){
    final snackbar = SnackBar(
      content: Text(s),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);

  }
  delete(id){
    Firestore.instance.document('${LoginPageState.email}/myData').collection('profileImg').document(id).delete();
  }
  save(downloadUrl){
    Map <dynamic,dynamic> keepData = <String,dynamic>{"Url":downloadUrl };
    Firestore.instance.document('${LoginPageState.email}/myData').collection("profileImg").add(keepData).catchError((e)=> print(e));
  }
  uploadImage(image) async{
    StorageUploadTask uploadTask = ref.putFile(image);
    StorageTaskSnapshot takeSnapShot = await uploadTask.onComplete.then((img){
      setState(() {
      });
      imgUrl();
    });
  }
  Future imgUrl() async{
    String downloadAdd = await ref.getDownloadURL().then((img){
      downloadUrl = img;
      if(ls!=null){
        delete(ls[0].documentID);
      }
      save(downloadUrl);
      //downloadUrl = "";
      setState(() {
      });
    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static List l;
  var snapshot =  Firestore.instance.collection(LoginPageState.email).document('myData').collection('Note').snapshots();
  var _searchview = new TextEditingController();
  bool _firstSearch  = true;
  String _query = "";
  List _filterList = new List();
  static String directory;
  //String value1 = TakeNotesState.value;
  int num = 2;
  String title;
  String note;
  var Stagg;
  var iconView = Icon(Icons.view_agenda,color: Colors.black,);
  MainState() {
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        //Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }

  appBar(context){
    return new AppBar(
      backgroundColor: Colors.white,
      elevation: 1.0,
      actions: <Widget>[
        new Container(
          child: IconButton(
            icon: new Icon(Icons.menu,color: Colors.black54,),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
        ),
        new Expanded(
          child: new TextField(
            controller: _searchview,
            autofocus: false,
            // focusNode: ,
            decoration: InputDecoration(
              fillColor: Colors.black54,
              hintText: "Search Your Notes",
              hintStyle: new TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        new IconButton(icon: iconView, onPressed:
            (){
          if(iconView.toString() == Icon(Icons.view_agenda,color: Colors.black,).toString()){
            num = 4;
            iconView = Icon(Icons.dashboard,color: Colors.black,);
            setState(() {
            });
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
        //  new IconButton(icon: new Icon(Icons.arrow_left,color: Colors.black,semanticLabel:"Logout"), onPressed: signOut),
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

  drawer(context){
    crudObj.fetchData().then((result){
      QSlabels =result;
      labels = QSlabels.documents;
      setState(() {
      });
    });
    return new Drawer(
      child: new ListView(
          padding: const EdgeInsets.only(top: 0.0),
          children: <Widget>[
            new Container(height: 12.0,),
            new Text("Fundoo Notes",style: new TextStyle(color: Colors.yellow,fontSize: 24.4), ),
            new UserAccountsDrawerHeader(
                accountName: Text(""),
                accountEmail: Text(LoginPageState.email),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                ),
                currentAccountPicture: new GestureDetector(
                  onTap:(){
                    gallery();
                  },
                  child: new Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color:Colors.white,
                    ),
                    height: 500.0,
                    child: downloadUrl!=null?new Container(decoration: BoxDecoration(
                        image: DecorationImage(
                            image:NetworkImage(downloadUrl),
                            fit:BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0,color:Colors.black)
                        ]
                    )

                    ):  new CircularProgressIndicator(),
                  ),
                ),
                otherAccountsPictures: <Widget>[
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
            new Container(
              child:  new  ListView.builder(
                  shrinkWrap: true,
                  itemCount: labels==null?0:labels.length,
                  itemBuilder: (context,index){
                    final item = labels[index].data['Label'];
                    return  new ListTile(
                      leading: new Icon(Icons.label),
                      title: new Text(item),
                      onTap: () {
                        Firestore.instance.collection(LoginPageState.email).document('myData').collection('TempData').getDocuments().then((snapshot){
                          for(DocumentSnapshot ds in snapshot.documents){
                            ds.reference.delete();
                          }
                        });
                        var snap =  Firestore.instance.collection('test@test.com').document('myData').collection(MainState.directory).getDocuments().then((result){
                          List z = result.documents;
                          List n = new List();
                          print(index);
                          for(int i = 0;i<z.length;i++){
                            //print("z ${z[i].data['Label']}");
                            //print(" label ${labels[i].data['Label']}");
                            if(z[i].data['Label'].contains(labels[index].data['Label'])){
                              n.add(z[i]);
                            }
                          }
                          l =null;
                          l =new List();
                          l = n;
                          for(int i = 0;i<l.length;i++){
                            Map <dynamic,dynamic> keepData = <String,dynamic>{"Note" : l[i].data['Note'], "Title": l[i].data['Title'],"Color":l[i].data['Color'],"Pin":l[i].data['Color'],"isArchive":l[i].data['isArchive']};
                            Firestore.instance.document('${LoginPageState.email}/myData').collection("TempData").add(keepData).catchError((e)=> print(e));
                          }
                          snapshot = Firestore.instance.collection(LoginPageState.email).document('myData').collection('TempData').snapshots();
                          setState(() {

                          });
                          Navigator.of(context).pop();
                        });

                      },
                    );
                  }),
            ),
            new ListTile(
              leading: new Icon(Icons.add),
              title: new Text('Create new label'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddLabels(labels: labels,)));
              },
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
            new ListTile(
              leading: new Icon(Icons.power_settings_new),
              title: new Text("Sign Out"),
              onTap: (){
                signOut();
              },
            ),
          ]
      ),
    );
  }
  bottomNaviBar(context){
    return BottomAppBar(
      color: Colors.white,
      elevation: 0.0,
      child: new Container(
        child: new FlatButton(
            color: Colors.grey.shade100,
            child: new Text("Take a note..."),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TakeNotes(index: -1,color:Colors.white.toString()) ));
            }
        ),),
    );
  }
  getColor(int index){
    if(l[index].data["Color"]=="null"){
      l[index].data["Color"]= Colors.white.toString();
    }
    String valueString = l[index].data["Color"].split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    Color color = new Color(value);
    if(color==null){
      color  = Colors.white;
    }
    return color;
  }
  createStaggered(context,l){
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
  Widget _performSearch(context,l) {
    _filterList = new List();
    for (int i = 0; i < l.length; i++) {
      var searchnote = l[i].data['Note'];
      var searchtitle = l[i].data['Title'];
      if (searchnote.toLowerCase().contains(_query.toLowerCase())||searchtitle.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(l[i]);
      }
    }
    return createStaggered(context,_filterList);
  }
  Future<bool> _showDialog(context) {
    // flutter defined function
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are you sure you want to close this app?"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(onPressed: (){
              return  SystemNavigator.pop();

            }, child: new Text("Yes")),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit FunDoNotes'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => SystemNavigator.pop(),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: drawer(context),
        appBar: appBar(context),
        body:
        new Container(
            color: Colors.white,
            padding: EdgeInsets.all(8.0),
            child: new Container(
              decoration: new BoxDecoration(
                border: new Border.all(color: Colors.grey,width: 0.5),
                borderRadius: new BorderRadius.only(
                  topLeft:  const  Radius.circular(10.0),
                  topRight: const  Radius.circular(10.0),
                  bottomLeft: const  Radius.circular(10.0),
                  bottomRight: const  Radius.circular(10.0),
                ),
              ),
              padding: EdgeInsets.all(2.0),
              child:
              new StreamBuilder<QuerySnapshot>(
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
                        child:  _firstSearch ? createStaggered(context, l) : _performSearch(context,l),
                      );
                    }
                  }
              ),
              //
            )),

        bottomNavigationBar:bottomNaviBar(context),
      ),
    );
  }
  Future <Login_Page> signOut()  async{
    await FirebaseAuth.instance.signOut().then((_){
      // Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/LandingPage');
    }).catchError((e)=>print(e));
  }
}































/*makeLabel(context){
    return ListView.builder(
        itemCount: labels.length,
        itemBuilder: (context,index){
          final item = labels[index];

          return FlatButton(onPressed: ()=>print("Nothing"), child: new Text(item));

        });
  }*/