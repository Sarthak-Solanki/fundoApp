import 'package:flutter/material.dart';
class TakeNotes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TakeNotesState();
  }
}
class ColorSelect{
  ColorSelect({this.colorselect,this.icon});
  final Color colorselect;
  final Icon icon;
}
List<ColorSelect> choices = <ColorSelect>[
  new ColorSelect(colorselect: Colors.yellowAccent.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.yellow.shade200,)),
  new ColorSelect(colorselect: Colors.red.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.red.shade200,)),
  new ColorSelect(colorselect: Colors.blue.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.blue.shade200,)),
  new ColorSelect(colorselect: Colors.pink.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.pink.shade200,)),
  new ColorSelect(colorselect: Colors.green.shade200,icon: new Icon(Icons.radio_button_unchecked,color: Colors.green.shade200,)),



];
class _TakeNotesState extends State<TakeNotes> {
 // double kBottomNavigationBarHeight = 200.0;
  Color _selectedChoice;
 // final ColorSelect choice;

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
    );
  }
  /*colorChange(int i){
    return choice[i].icon.color;
  }  */
    Color value;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor:value,
      appBar: appBar(),
      body: Body(),
      bottomNavigationBar: BottomAppBar(
        child: new Container(
        child: PopupMenuButton<ColorSelect>(
          initialValue: choices[0],
          //onSelected: _select,
          child: new Icon(Icons.arrow_drop_up,color: Colors.yellowAccent,),
          itemBuilder: ((BuildContext context) =><PopupMenuEntry<ColorSelect>>[
            new PopupMenuItem(
              child: new SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: new Row(
                  children: <Widget>[
                    new InkWell(
                      onTap: () {
                        value = choices[0].icon.color;
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
                      onTap: () => ColorSelect,
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.red.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),new InkWell(
                      onTap: () => print('hello'),
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
                      onTap: () => print('hello'),
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
                      onTap: () => print('hello'),
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
                      onTap: () => print('hello'),
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
                      onTap: () => print('hello'),
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.grey.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    new InkWell(
                      onTap: () => print('hello'),
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
                      onTap: () => print('hello'),
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.indigo.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    new InkWell(
                      onTap: () => print('hello'),
                      child: new Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.deepPurpleAccent.shade200,
                          border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
          ),
        ),
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