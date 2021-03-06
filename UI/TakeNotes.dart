import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'crud.dart';
import 'MainPage.dart';
import 'package:share/share.dart';
import 'LabelPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class TakeNotes extends StatefulWidget {
  final int index;
  String color;
  bool isPin ;
  bool isArchive;
  List l;
  //List selectedLabel;
  TakeNotes({Key key,this.l,this.index,this.color,this.isPin,this.isArchive}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TakeNotesState();
  }
}
class ColorSelect{
  ColorSelect({this.colorselect,this.icon});
  final Color colorselect;
  final Icon icon;
}

List<ColorSelect> choices = <ColorSelect>[
  new ColorSelect(colorselect: Colors.yellowAccent.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.white,)),
  new ColorSelect(colorselect: Colors.yellowAccent.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.yellow.shade200,)),
  new ColorSelect(colorselect: Colors.red.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.red.shade200,)),
  new ColorSelect(colorselect: Colors.blue.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.blue.shade200,)),
  new ColorSelect(colorselect: Colors.pink.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.pink.shade200,)),
  new ColorSelect(colorselect: Colors.green.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.green.shade200,)),
  new ColorSelect(colorselect: Colors.yellowAccent.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.orange.shade200,)),
  new ColorSelect(colorselect: Colors.yellowAccent.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.grey.shade200,)),
  new ColorSelect(colorselect: Colors.yellowAccent.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.cyan.shade200,)),
  new ColorSelect(colorselect: Colors.yellowAccent.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.indigo.shade200,)),
  new ColorSelect(colorselect: Colors.yellowAccent.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.deepPurple.shade200,)),
];
class TakeNotesState extends State<TakeNotes> {
  LabelPageState lb = new LabelPageState();
  crudMethod crudObj = new crudMethod();
  static String Title;
  static String Note;
  static File _image;
  static File image;
  static Color color;
  static File clickimage;
  static File Galleryimage;
  var imageUrl;
  String downloadUrl;
  StorageReference ref = FirebaseStorage.instance.ref().child('Noteimge.jpg');
  // static List selectedLabel;
  List labelData;
  Icon pinIcon = Icon(Icons.pined);
  Icon archiveIcon = Icon(Icons.archive);
  final _scaffoldKey  = new GlobalKey<ScaffoldState>();
  VoidCallback _showPersBottomSheetCallBack;
  VoidCallback _showPlusButtonCallBack;
  static TextEditingController _titleController;
  static TextEditingController _noteController;
//var _scaffoldKey = new GlobalKey<ScaffoldState>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  List v;
  void initState(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    if(widget.index!=-1){
      if(widget.l[widget.index].data['Url']!=null)
        downloadUrl = widget.l[widget.index].data['Url'];
      crudObj.fetchNoteData().then((result){
        widget.l = result.documents;
        List z = widget.l;
        widget.l = null;
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
          widget.l = pList +unpList;
        }
        else{
          widget.l = z;
        }

        convertLabel();
        if(widget.index!=-1)
        {
          _titleController = new TextEditingController(text: widget.l[widget.index].data['Title']);
          Title = widget.l[widget.index].data['Title'];
        }
        if(widget.index!=-1)
        {
          _noteController = new TextEditingController(text: widget.l[widget.index].data['Note']);
          Note = widget.l[widget.index].data['Note'];
        }

        setState(() {

        });
      });
      if(widget.color!=null){
        String valueString = widget.color.split('(0x')[1].split(')')[0]; // kind of hacky..
        int value = int.parse(valueString, radix: 16);
        color = new Color(value);
      }
      _showPersBottomSheetCallBack = _showBottomSheet;
      _showPlusButtonCallBack = _showPlusBottomSheet;
    }
    else{
      _titleController = new TextEditingController(text: "");
      _noteController = new TextEditingController(text: "");

    }
    super.initState();

  }
  _selectDate(context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate:DateTime.now(),
      initialDate: DateTime.now(),
      lastDate:DateTime(3000),
    );
    if(picked!=null&&picked!=_date){
      // String _date;
      setState(() {
        _date = picked;
      });
      //print('Date Selected$_date');
    }
  }
  diff(){
    var get = new DateTime(_date.year,_date.month,_date.day,_time.hour,_time.minute);
    var remaining = get.difference(DateTime.now());
    final days = remaining.inDays;
    final hours = remaining.inHours - remaining.inDays * 24;
    final minutes = remaining.inMinutes - remaining.inHours * 60;
    final seconds = remaining.inSeconds - remaining.inMinutes * 60;
    List s = new List();
    s.add(days);
    s.add(hours);
    s.add(minutes);
    return s;
  }
  _selectTime(context) async{
    final TimeOfDay picked = await showTimePicker(context: context, initialTime:TimeOfDay.now());
    if(picked!=null&& picked!=_time){
      setState(() {
        _time = picked;
      });
    }
  }
  Future onSelectNotification(String payload) {
    showDialog(
        context: context,
        builder: (_)=> AlertDialog(
          title: Text("ALERT"),
          content: Text("CONTENT: $payload"),
        ));
  }
  showNotification(v) async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description');
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    var scheduledNotificationDateTime =
    new DateTime.now().add(Duration(days: v[0],hours: v[1],minutes: v[2]));
    await flutterLocalNotificationsPlugin.schedule(0, Title, Note, scheduledNotificationDateTime, platform);
  }

  Future<bool> saveNupdate(){
    Map <dynamic,dynamic> keepData = <String,dynamic>{"Note" : Note,"Url":downloadUrl ,"Title": Title,"Color":color.toString(),"Pin":widget.isPin,"isArchive":widget.isArchive};
    if(widget.index==-1){
      crudObj.addData(keepData).then((result){
        Navigator.of(context).pop();
        Flushbar()
          ..shadowColor = Colors.grey.shade300
          ..backgroundColor = Colors.white
          ..messageText = new Text("Note Created",style: TextStyle(color: Colors.black),)
          ..duration = Duration(seconds: 2)
          ..leftBarIndicatorColor = Colors.blue[300]
          ..show(context);
      }).catchError((e){
        print(e);
      });
    }
    else{
      crudObj.updateData(widget.l[widget.index].documentID, keepData);
      Navigator.of(context).pop();
      Flushbar()
        ..shadowColor = Colors.grey.shade300
        ..backgroundColor = Colors.white
        ..messageText = new Text("Note updated",style: TextStyle(color: Colors.black),)
        ..duration = Duration(seconds: 2)
        ..leftBarIndicatorColor = Colors.blue[300]
        ..show(context);
    }

  }
  convertLabel(){
    if(widget.l!=null){
      if(widget.l[widget.index].data['Label']!=null){
        String st = widget.l[widget.index].data['Label'];
        labelData = st.split(",");
        setState(() {

        });
      }}
  }
  appBar(context) {
    if(widget.isPin==true){
      pinIcon = Icon(Icons.pined);
    }
    else{
      pinIcon = Icon(Icons.unpinned);
    }
    if(widget.isArchive==true){
      archiveIcon = Icon(Icons.unarchive);
    }
    else {
      archiveIcon = Icon(Icons.archive);
    }
    return new AppBar(
      backgroundColor: color,//color as Color,
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      actions: <Widget>[
        new IconButton(icon: pinIcon, onPressed: (){
          if(pinIcon.toString()==Icon(Icons.unpinned).toString()){
            widget.isPin = true;
            pinIcon = Icon(Icons.pined);
            setState(() {
            });
          }
          else{
            widget.isPin = false;
            pinIcon = Icon(Icons.unpinned);
            setState(() {
            });
          }
        }
        ),
        new IconButton(icon: Icon(Icons.delete), onPressed: (){
          crudObj.deleteData(widget.l[widget.index].documentID);
          Navigator.of(context).pop();
        }),
        new IconButton(icon: Icon(Icons.add_alert), onPressed: (){
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Reminder'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      new FlatButton(onPressed:()=> _selectDate(context),
                          child: new Text("Set Date",textAlign: TextAlign.left,)),
                      new FlatButton(onPressed:()=> _selectTime(context),
                          child: new Text("Set Time",textAlign: TextAlign.left,))
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Regret'),
                    onPressed: () {
                      v = diff();
                          showNotification(v);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }),
        /*new IconButton(icon: Icon(Icons.save), onPressed: (){
          Map <dynamic,dynamic> keepData = <String,dynamic>{"Note" : Note,"Url":downloadUrl ,"Title": Title,"Color":color.toString(),"Pin":widget.isPin,"isArchive":widget.isArchive};
          if(widget.index==-1){
            crudObj.addData(keepData).then((result){
              //Navigator.of(context).pop();

              final snackbar = SnackBar(
                content: Text('Note is added!'),
              );
              _scaffoldKey.currentState.showSnackBar(snackbar);

            }).catchError((e){
              print(e);
               Navigator.of(context).pop();

            });
          }
          else{
            crudObj.updateData(widget.l[widget.index].documentID, keepData);
            Navigator.of(context).pop();

          }
        },),
        */new IconButton(icon: archiveIcon,
            onPressed: (){
              if(MainState.directory=="Archive"){
                widget.isArchive = false;
                archiveIcon = Icon(Icons.archive);
                Map <dynamic,dynamic> keepData = <String,dynamic>{"Note" : Note, "Title": Title,"Color":color.toString(),"Pin":widget.isPin,"isArchive":widget.isArchive};
                crudObj.updateData(widget.l[widget.index].documentID, keepData);
                crudObj.unArchive(widget.l[widget.index].documentID);
                Navigator.of(context).pop();
                Flushbar()
                  ..shadowColor = Colors.grey.shade300
                  ..backgroundColor = Colors.white
                  ..messageText = new Text("Note unArchive!!",style: TextStyle(color: Colors.black),)
                  ..duration = Duration(seconds: 2)
                  ..leftBarIndicatorColor = Colors.blue[300]
                  ..show(context);
              }
              else {
                widget.isArchive = true;
                archiveIcon = Icon(Icons.unarchive);
                Map <dynamic,dynamic> keepData = <String,dynamic>{"Note" : Note, "Title": Title,"Color":color.toString(),"Pin":widget.isPin,"isArchive":widget.isArchive};
                crudObj.updateData(widget.l[widget.index].documentID, keepData);
                crudObj.toArchive(widget.l[widget.index].documentID);
                // Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/MainPage');
                Flushbar()
                  ..shadowColor = Colors.grey.shade300
                  ..backgroundColor = Colors.white
                  ..messageText = new Text("Note archived!!",style: TextStyle(color: Colors.black),)
                  ..duration = Duration(seconds: 2)
                  ..leftBarIndicatorColor = Colors.blue[300]
                  ..show(context);
              }
            }
        ),
      ],
    );
  }
  gallery() async{
    print("picker is called");
    Galleryimage  = await ImagePicker.pickImage(source: ImageSource.gallery);
    _image = Galleryimage;
    _image!=null?uploadImage(_image):Dialog(child: new Text("No image is selected"),);
    setState(() {
    });

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
      setState(() {
      });
    });
  }
  camera() async{
    clickimage =  await ImagePicker.pickImage(source: ImageSource.camera);
    image = clickimage;
    setState(() {
    });
  }
  void _showPlusBottomSheet(){
    showModalBottomSheet (context: context,builder: (builder){return new Container(
      height: 250.0,
      width: 400.0,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new FlatButton.icon(onPressed: camera, icon: Icon(Icons.camera_alt),label: new Text("Take Photo")),
          new FlatButton.icon(onPressed: gallery, icon: Icon(Icons.image),     label: new Text("Choose Image")),
          new FlatButton.icon(onPressed: null, icon: Icon(Icons.brush),     label: new Text("Drawing")),
          new FlatButton.icon(onPressed: null, icon: Icon(Icons.mic_none),  label: new Text("Recording")),
          new FlatButton.icon(onPressed: null, icon: Icon(Icons.check_box), label: new Text("Tick Boxes")),
        ],
      ),
    );
    });
  }
  void _showBottomSheet(){
    showModalBottomSheet(context: context, builder:(builder){
      return new Container(
          color: color, //Color(0xffef9a9a) as Color,
          //  color,
          height: 250.0,
          width: 400.0,
          child: new Column(
            children: <Widget>[
              new Container(
                  alignment: Alignment.topLeft,
                  child: new FlatButton.icon(onPressed: (){
                    crudObj.deleteData(widget.l[widget.index].documentID);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Flushbar()
                      ..shadowColor = Colors.grey.shade300
                      ..backgroundColor = Colors.white
                      ..messageText = new Text("Note deleted",style: TextStyle(color: Colors.black),)
                      ..duration = Duration(seconds: 2)
                      ..leftBarIndicatorColor = Colors.blue[300]
                      ..show(context);
                  }, icon: Icon(
                      MainState.directory!="Delete"? Icons.delete_outline:Icons.restore_from_trash
                  ), label: new Text("      Delete",style:TextStyle(fontSize: 15.0,),))
              ),
              new Container(
                alignment: Alignment.topLeft,
                child: new FlatButton.icon(onPressed:Note.isEmpty?null: (){
                  final RenderBox box = context.findRenderObject();
                  Share.share(Note,
                      sharePositionOrigin:
                      box.localToGlobal(Offset.zero) &
                      box.size);
                }, icon: Icon(Icons.share), label: new Text("      Send",style: TextStyle(fontSize: 15.0),)),
              ),
              new Container(
                alignment: Alignment.topLeft,
                child: new FlatButton.icon(onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>new LabelPage (l:widget.l,index:widget.index,color: color.toString())));
                },
                    icon: Icon(Icons.label), label: new Text("      Label",style: TextStyle(fontSize: 15.0),)),
              ),
              new SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: new Row(
                  children: <Widget>[
                    new InkWell(
                      onTap: () {
                        color = choices[0].icon.color;
                        _select() ;
                        Navigator.of(context).pop();
                        _showBottomSheet();
                      },
                      child: new Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(color: Colors.black, width: 0.05),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        color = choices[1].icon.color;
                        _select();
                        Navigator.of(context).pop();
                        _showBottomSheet();
                      },
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.yellow.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        color = choices[2].icon.color;
                        _select() ;
                        Navigator.of(context).pop();
                        _showBottomSheet();
                      },
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.red.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    new InkWell(
                      onTap: (){
                        color = choices[3].icon.color;
                        _select() ;
                        Navigator.of(context).pop();
                        _showBottomSheet();
                      },
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.blue.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        color = choices[4].icon.color;
                        _select() ;
                        Navigator.of(context).pop();
                        _showBottomSheet();
                      },
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.pink.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        color= choices[5].icon.color;
                        _select() ;
                        Navigator.of(context).pop();
                        _showBottomSheet();
                      },
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.green.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    new InkWell(
                      onTap: (){
                        color = choices[6].icon.color;
                        _select() ;
                        Navigator.of(context).pop();
                        _showBottomSheet();
                      },
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.orange.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    new InkWell(
                      onTap: (){
                        color = choices[7].icon.color;
                        _select();
                        Navigator.of(context).pop();
                        _showBottomSheet();
                      },
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.grey.shade300,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        color = choices[8].icon.color;
                        _select();
                        Navigator.of(context).pop();
                        _showBottomSheet();
                      },
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.cyan.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),new InkWell(
                      onTap: (){
                        color = choices[9].icon.color;
                        _select();
                        Navigator.of(context).pop();
                        _showBottomSheet();
                      },
                      child: new Container(
                        width:40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.indigo.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        color= choices[10].icon.color;
                        _select() ;
                        Navigator.of(context).pop();
                        _showBottomSheet();
                      },
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.deepPurple.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
  }
  void _select(){
    setState(() {
    });
  }
  /*static labelsUpdate(selectedLabels){
    selectedLabel = selectedLabels;
  }*/
  Body() {
    return new Column(
      children: <Widget>[
        new TextField(
          //if()
          controller: TakeNotesState._titleController,
          style: new TextStyle(fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontSize: 22.4),
          maxLines: null,
          onChanged:(_titleController){
            Title = _titleController;
          },
          decoration: new InputDecoration(labelText: "Title",
              contentPadding: EdgeInsets.all(10.0)),
        ),

        // new Expanded(
        /*new Container(
            height:image==null&&_image==null?0.0:300.0,
            child: new Center(
              child: _image == null ? new Text(""): new Image.file(_image),
              //    ),)],
            ),
          ),*/
        //),
        downloadUrl==null?Container():Container(height:300.0,child: GestureDetector(
          onLongPress:(
              downloadUrl = null
          ),
          child: Image.network(downloadUrl),
        )),
        new Expanded(
          child: new TextField(
            controller: TakeNotesState._noteController,

            style: new TextStyle(fontWeight: FontWeight.w400,
                color: Colors.black87,
                fontSize: 18.4),
            maxLines: null,
            onChanged: (_noteController){
              Note = _noteController;
            },
            decoration: new InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10.0),
            ),
          ),
        ),/*
        new Wrap(
          children: <Widget>[*/
        new Container(
            height: 24.0,
            child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: labelData==null?0:labelData.length,
                itemBuilder: (context,index){
                  return new Row(
                    children: <Widget>[
                      new Container(
                        width: 3.0,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Container(
                          color: Colors.grey.shade200,
                          child: Center(
                              child: new RaisedButton(
                                onPressed:(){
                                  //LabelPageState.news();
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>new LabelPage (l:widget.l,index:widget.index)));
                                },
                                child:labelData[index]!=""?new Text(labelData[index]):null,)
                          ),
                        ),
                      ),
                    ],
                  );
                })),
        /* ],
        ),*/

      ],
    );
  }
  static Future<bool> dialogTrigger(BuildContext context) async{
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Job Done", style: TextStyle(fontSize: 15.0),),
            content: Text('Added'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                textColor: Colors.black,
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: saveNupdate,
      child: new Scaffold(
        key: _scaffoldKey,
        backgroundColor:color,//color as Color,
        appBar: MainState.directory!="Delete"?appBar(context):new AppBar(elevation: 0.0,backgroundColor: color,iconTheme: IconThemeData(color:Colors.black),),
        body: Body(),
        bottomNavigationBar: BottomAppBar(
          color:color,
          elevation: 0.0,
          child:new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MainState.directory!="Delete"? new IconButton(icon: Icon(Icons.add_box),
                onPressed: _showPlusButtonCallBack,
              ):new Icon(Icons.add_box,color: Colors.grey.shade300,),
              MainState.directory!="Delete"?new IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: _showPersBottomSheetCallBack,
              ):new IconButton(icon: Icon(Icons.more_vert), onPressed: (){
                showModalBottomSheet(context: context, builder:(builder){
                  return new Container(
                      color: color, //Color(0xffef9a9a) as Color,
                      //  color,
                      height: 150.0,
                      width: 400.0,
                      child: new Column(
                        children: <Widget>[
                          new Container(
                              alignment: Alignment.topLeft,
                              child: new FlatButton.icon(onPressed: (){
                                crudObj.deleteData(widget.l[widget.index].documentID);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Flushbar()
                                  ..shadowColor = Colors.grey.shade300
                                  ..backgroundColor = Colors.white
                                  ..messageText = new Text("Note added to trash",style: TextStyle(color: Colors.black),)
                                  ..duration = Duration(seconds: 2)
                                  ..leftBarIndicatorColor = Colors.blue[300]
                                  ..show(context);
                              }, icon: Icon(Icons.delete_outline
                              ), label: new Text("      Delete",style:TextStyle(fontSize: 15.0,),))
                          ),
                          new Container(
                            alignment: Alignment.topLeft,
                            child: new FlatButton.icon(onPressed:(){
                              crudObj.restoreData(widget.l[widget.index].documentID);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                                icon: Icon(Icons.restore), label: new Text("      Restore",style: TextStyle(fontSize: 15.0),)),
                          ),
                        ],
                      ));
                });
              })
            ],
          ),
        ),
      ),
    );
  }
  }
/*
class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: TakeNotes(),
    );
  }
}
main() => runApp(new Test());
*/



































/*child: PopupMenuButton<ColorSelect>(
            //child: new Icon(Icons.radio_button_unchecked,color: Colors.yellowAccent,),
            itemBuilder: ((BuildContext context){
              return choice.map((ColorSelect select){
                return new PopupMenuItem<ColorSelect>(

                    child: new Icon(Icons.radio_button_unchecked,color:select.icon.color,));
              }).toList();
            }
            ),
        ),*/


/*colorChange(int i){
    return choice[i].icon.color;
  }  */
/* Bottom(){
    return new Container(
        child: PopupMenuButton(
          initialValue: choices[0],
          //onSelected: _select,
          child: new Icon(Icons.arrow_drop_up,color: Colors.yellowAccent,),
          itemBuilder: ((BuildContext context) =><PopupMenuEntry<ColorSelect>>[
            new PopupMenuItem(
              child:new Column(
              children:[
                new SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: new Row(
                  children: <Widget>[
                    ,
                  ],c
                ),
              )
              ],
              ),),
          ]
          ),
        ),
        );

  }
 */
/*print("Datassssssss******************************* $keepData");
            print("successfully updated");
          }).catchError((e){
            print("##########################################$e");
          });*/



//FLATBUTTON ICON CHANGED TO ICONS.BUTTON ===>




// WAS EARLY LIKE THIS>>
/*new FlatButton.icon(
            onPressed: (){
          Map <String,String> keepData = <String,String>{"Note" : Note, "Title": Title};
          if(widget.index==-1){
          crudObj.addData(keepData).then((result){
            print("success");
            Navigator.of(context).pop();
          }).catchError((e){
            print(e);
          });
          }
          else{
           crudObj.updateData(widget.l[widget.index].documentID, keepData);
            Navigator.of(context).pop();
          }
        }, icon: Icon(Icons.save),label: new Text("")),
      */




/*_showBottomSheet(){
    setState(() {
      _showPersBottomSheetCallBack = null;
    });
    _scaffoldKey.currentState.showBottomSheet((context){

    }).closed.whenComplete((){
      if(mounted){
        setState(() {
          _showPersBottomSheetCallBack = _showBottomSheet;
        });
      }
    });
  }*/