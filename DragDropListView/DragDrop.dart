import 'package:flutter/material.dart';
import 'package:dragable_flutter_list/dragable_flutter_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() {
  runApp(new TestApp());
}

class TestApp extends StatelessWidget {
  TestApp({Key key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new MyHomePage(
        title: 'Flutter Demo Home Page',
        key: key,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List items = new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance.collection('test@test.com').document('myData').collection('Note').getDocuments().then((qs){
      List v = qs.documents;
      for(int i = 0;i<v.length;i++){
          items.add(v[i].data['Note']);
        }
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new DragAndDropList(
        items.length,
        itemBuilder: (BuildContext context, index) {
          return new SizedBox(
            child: new Card(
              child: new ListTile(
                title: new Text(items[index]),
              ),
            ),
          );
        },
        onDragFinish: (before, after) {
          print('on drag finish $before $after');
          String data = items[before];
          items.removeAt(before);
          items.insert(after, data);
        },
        canDrag: (index) {
          print('can drag $index');
          return index != 3; //disable drag for index 3
        },
        canBeDraggedTo: (one, two) => true,
        dragElevation: 8.0,
      ),
    );
  }
}