import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:async/async.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  var now;
  var diffDay;
  var diffTime;
//var diffYear;

List v;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
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
   /* print(_date);
    print(now);
    //_date = diffDay - _date;
    //_date.add(new Duration(minutes: _time.minute));
   */ var get = new DateTime(_date.year,_date.month,_date.day,_time.hour,_time.minute);
    //print(get);
    var remaining = get.difference(DateTime.now());
    final days = remaining.inDays;
    //print("days$days");
    final hours = remaining.inHours - remaining.inDays * 24;
    //print("hours $hours");
    final minutes = remaining.inMinutes - remaining.inHours * 60;
   // print("min $minutes");
    final seconds = remaining.inSeconds - remaining.inMinutes * 60;
    //print("sec $seconds");
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
    await flutterLocalNotificationsPlugin.schedule(0, 'Title ', 'Body', scheduledNotificationDateTime, platform);
  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Demo"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                          new FlatButton(onPressed:(){
                            now = DateTime.now();
                            _selectDate(context);

                          }, child: new Text("Set Date",textAlign: TextAlign.left,)),
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


          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
       // onPressed: showNotification,
        child: new Icon(Icons.notifications),
      ),
    );
  }
}







