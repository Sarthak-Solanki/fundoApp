import 'package:flutter/material.dart';
class TakeNotes extends StatefulWidget {
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
  Color _selectedChoice;
  final _scaffoldKey  = new GlobalKey<ScaffoldState>();
  VoidCallback _showPersBottomSheetCallBack;
  VoidCallback _showPlusButtonCallBack;
  void initState(){
    super.initState();
    _showPersBottomSheetCallBack = _showBottomSheet;
    _showPlusButtonCallBack = _showPlusBottomSheet;
  }
  _showPlusBottomSheet(){
    setState(() {
      _showPlusButtonCallBack = null;
    });
    _scaffoldKey.currentState.showBottomSheet((context){
      return new Container(
        height: 250.0,
        width: 400.0,
          child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new FlatButton.icon(onPressed: null, icon: Icon(Icons.camera_alt), label: new Text("Take Photo")),
            new FlatButton.icon(onPressed: null, icon: Icon(Icons.image), label: new Text("Choose Image")),
            new FlatButton.icon(onPressed: null, icon: Icon(Icons.brush), label: new Text("Drawing")),
            new FlatButton.icon(onPressed: null, icon: Icon(Icons.mic_none), label: new Text("Recording")),
            new FlatButton.icon(onPressed: null, icon: Icon(Icons.check_box), label: new Text("Tick Boxes")),
          ],
        ),
      );
    }).closed.whenComplete((){
      if(mounted){
        setState(() {
          _showPlusButtonCallBack = _showBottomSheet;
        });
      }
    });

  }
  _showBottomSheet(){
    setState(() {
      _showPersBottomSheetCallBack = null;
    });
    _scaffoldKey.currentState.showBottomSheet((context){
      return new Container(
        height: 300.0,
        child: new Column(
         children: <Widget>[
            new SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: new Row(
            children: <Widget>[
              new InkWell(
                onTap: () {
                  value = choices[0].icon.color;
                  _select(value) ;
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
                  value = choices[1].icon.color;
                  _select(value) ;
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
                  value = choices[2].icon.color;
                  _select(value) ;
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
                  value = choices[3].icon.color;
                  _select(value) ;
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
                  value = choices[4].icon.color;
                  _select(value) ;
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
                  value = choices[5].icon.color;
                  _select(value) ;
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
                  value = choices[6].icon.color;
                  _select(value) ;
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
                  value = choices[7].icon.color;
                  _select(value) ;
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
                  value = choices[8].icon.color;
                  _select(value) ;
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
                  value = choices[9].icon.color;
                  _select(value) ;
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
                  value = choices[10].icon.color;
                  _select(value) ;
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
    }).closed.whenComplete((){
      if(mounted){
        setState(() {
          _showPersBottomSheetCallBack = _showBottomSheet;
        });
      }
    });
  }
  void _select(Color choice){
    setState(() {
      _selectedChoice = choice;
    });
  }
  static Body() {
    return new Column(
      children: <Widget>[
        new TextField(
          style: new TextStyle(fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontSize: 22.4),
          maxLines: null,
          decoration: new InputDecoration(labelText: "Title",
              contentPadding: EdgeInsets.all(10.0)),
        ),
        SizedBox(height: 10.0,),
        new Expanded(
          child: new TextField(
            style: new TextStyle(fontWeight: FontWeight.w400,
                color: Colors.black87,
                fontSize: 18.4),
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
  appBar() {
    return new AppBar(
      backgroundColor: value,
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: Colors.black54,
      ),
    );
  }
  Color value = Colors.white;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor:value,
      appBar: appBar(),
      body: Body(),
      bottomNavigationBar: BottomAppBar(
        color:value,
        elevation: 0.0,
        child:new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new IconButton(icon: Icon(Icons.add_box),
                onPressed: _showPlusButtonCallBack,
            ),
               new IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: _showPersBottomSheetCallBack,
               ),
          ],
        ),
      ),
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