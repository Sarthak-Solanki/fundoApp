import 'package:flutter/material.dart';
import 'crud.dart';
import 'TakeNotes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class LabelPage extends StatefulWidget{
  @override
  List l;
  int index;
  String color;
  LabelPage({Key key,this.l,this.index,this.color}):super(key:key);
  State<StatefulWidget> createState() {
    return new LabelPageState();// TODO: implement createState
  }
}
class LabelPageState extends State<LabelPage>{
  crudMethod crudObj = new crudMethod();
  @override
  static List labels;// = new List();
  List selectedLabels;
  List tempLabels; //= new List();
  var _searchview = new TextEditingController();
  bool _firstSearch  = true;
  String _query = "";
  List _filterList = new List();
  var _focusnode = new FocusNode();
  List<bool> value = new List();
  List note;
  List datalabel;
  void initState() {
    labels = new List();
    tempLabels = new List();
    crudObj.fetchData().then((result){
      labels = result.documents;
      crudObj.fetchNoteData().then((result){
        note = result.documents;
        if(note[widget.index].data["Label"]!=null){
          String st = widget.l[widget.index].data['Label'];
          datalabel = st.split(",");
          value = news(datalabel);
          for(int i = 0;i<labels.length;i++){
            if(value[i]==true){
              tempLabels.add(labels[i]);
            }
          }
          setState(() {

          });
        }
        else{
          value = news(null);
          setState(() {
          });
        }
      });
    });
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
        new IconButton(icon: Icon(Icons.close,color: Colors.black,), onPressed: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          tempLabels = null;
          labels =null;
        }),
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
        new IconButton(icon: Icon(Icons.check,color: Colors.black,), onPressed: (){
          //TakeNotesState.labelsUpdate(tempLabels);
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          String st ="";
          for(int i = 0;i<tempLabels.length;i++){
            st = st +tempLabels[i].data['Label'];
            if(i<tempLabels.length-1){
              st = st+",";
            }
          }
          Map <dynamic,dynamic> newValues = <String,dynamic>{"Note" : widget.l[widget.index].data['Note'], "Title": widget.l[widget.index].data['Title'],"Color":widget.color,'Label':st};
          crudObj.updateData(widget.l[widget.index].documentID, newValues);
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>new TakeNotes(index: widget.index,)));
          tempLabels = null;
          labels =null;
        })
      ],
    );
  }
  List news(label){
    selectedLabels = label;
    int count = 0;
    int i;
    if(datalabel!=null){
      for(int j = 0;j<labels.length;j++){
        count=0;
        for(i = 0;i<datalabel.length;i++){
          if(datalabel[i]==labels[j].data["Label"]){
            count++;
            //value.add(true);
          }
          /*else {
            value.add(false);
          }*/
        }
        if(count>0){
          value.add(true);
        }
        else{
          value.add(false);
        }
      }
      for(int i = count;i<labels.length;i++){
        value.add(false);
      }

      return value;
    }
    else{
      for(int i = 0;i<labels.length;i++){
        value.add(false);
      }
      return value;
    }
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
                    /*for(int i = 0;i<value.length;i++){
                      if(value[index]==true){
                        tempLabels.add(labels[index]);
                      }
                    }*/
                    if(value[index] == false){
                      value[index] = true;
                      tempLabels.add(labels[index]);
                    }
                    else {
                      value[index] = false;
                      if(tempLabels.contains(labels[index])){
                        tempLabels.remove(labels[index]);
                      }
                      // val = false;
                    }});
                })

            );
          });
    }
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(child:
    new Scaffold(
        appBar: appBar(),
        body: _firstSearch?body(context,labels):_performSearch(context, labels)
    ),
        onWillPop: ()async=>false);
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