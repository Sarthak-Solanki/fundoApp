import 'package:flutter/material.dart';

class TakeNotes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TakeNotesState();
  }
}


class _TakeNotesState extends State<TakeNotes> {
  static Body(){
    return new Column(
      children: <Widget>[
        new TextField(
          style: new TextStyle(fontWeight: FontWeight.w400,color: Colors.black87,fontSize: 22.4),
          maxLines: null,
          decoration: new InputDecoration(labelText: "Title",
              contentPadding: EdgeInsets.all(10.0)),
        ),
        SizedBox(height: 10.0,),
        new Expanded(
          child: new TextField(
            style: new TextStyle(fontWeight: FontWeight.w400,color: Colors.black87,fontSize:18.4),
            maxLines: null,
            decoration: new InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10.0),
            ),
          ),
        ),
      ],
    );
  }
  static appBar(){
    return new AppBar(
      backgroundColor: Colors.white,
      bottomOpacity: 0.0,
      actions: <Widget>[
        new IconButton(icon: new Icon(Icons.arrow_drop_down), onPressed: null)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: appBar(),
        body: Body(),
    );
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: TakeNotes(),
    );
  }
}

main() => runApp(new Test());
