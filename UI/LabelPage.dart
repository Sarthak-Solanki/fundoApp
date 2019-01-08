import 'package:flutter/material.dart';
import 'crud.dart';
class LabelPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new LabelPageState();// TODO: implement createState
  }
}
class LabelPageState extends State<LabelPage>{
  crudMethod crudObj = new crudMethod();
  @override
  static List labels ;
  var _searchview = new TextEditingController();
  bool _firstSearch  = true;
  String _query = "";
  List _filterList = new List();

  var _focusnode = new FocusNode();
  List<bool> value = new List();
//bool val = false;
  void initState() {
    crudObj.fetchData().then((result){
      labels = result.documents;
      value = news();
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget _performSearch(context,l) {
    _filterList = new List();
    for (int i = 0; i < l.length; i++) {
     // var searchnote = l[i].data['Note'];
      var searchlabel = l[i].data['Label'];
      if (searchlabel.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(l[i]);
      }
    }
    return body(context,_filterList);
  }
  LabelPageState() {
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
  appBar(){
    return new AppBar(
      backgroundColor: Colors.white,
      elevation: 1.0,
      actions: <Widget>[
        new Flexible(
            child: new TextField(
              controller: _searchview,
              focusNode: _focusnode,
              autofocus:false,
              decoration: InputDecoration(
                fillColor: Colors.black54,
                hintText: "Search Your Label",
                hintStyle: new TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                ),
              ),
              textAlign: TextAlign.center,
            )),
      ],
    );
  }
  List news(){
    for(int i = 0;i<labels.length;i++){
      value.add(false);
    }
    return value;
  }
  body(context,labels){
    //news();
    if(labels!=null){
      return new  ListView.builder(
          shrinkWrap: true,
          itemCount: labels==null?0:labels.length,
          itemBuilder: (context,index){
            final item = labels[index].data['Label'];
            return  new ListTile(
                leading: new Icon(Icons.label),
                title: new Text(item),
                //onTap: () => print("s"),
                trailing: new Checkbox(value: value[index], onChanged: (bool v){
                  setState(() {
                    if(value[index] == false){
                      value[index] = true;
                      //  val = true;
                    }
                    else {
                      value[index] = false;
                      // val = false;
                    }});
                })

            );
          });
    }
  }
  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
      appBar: appBar(),
      body: _firstSearch?body(context,labels):_performSearch(context, labels)
    );
  }
}
class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: LabelPage(),
    );
  }
}
void main() => runApp(new Test());