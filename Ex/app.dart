import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(new MaterialApp(home: new MyApp()));

class MyApp extends StatefulWidget {
	@override
	_MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
	FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

	@override
	void initState() {
		super.initState();
		flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
		var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
		var iOS = new IOSInitializationSettings();
		var initSetttings = new InitializationSettings(android, iOS);
		flutterLocalNotificationsPlugin.initialize(initSetttings,
				onSelectNotification: onSelectNotification);
	}

	Future onSelectNotification(String payload) {
		debugPrint("payload : $payload");
		showDialog(
			context: context,
			builder: (_) => new AlertDialog(
				title: new Text('Notification'),
				content: new Text('$payload'),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: new AppBar(
				title: new Text('Flutter Local Notification'),
			),
			body: new Center(
				child: new RaisedButton(
					onPressed: _scheduleNotification,
					child: new Text(
						'Demo',
						style: Theme.of(context).textTheme.headline,
					),
				),
			),
		);
	}

	Future _scheduleNotification() async {
		var scheduledNotificationDateTime =
		new DateTime.now().add(new Duration(seconds: 5));
		var vibrationPattern = new Int64List(4);
		vibrationPattern[0] = 0;
		vibrationPattern[1] = 1000;
		vibrationPattern[2] = 5000;
		vibrationPattern[3] = 2000;

		var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
				'your other channel id',
				'your other channel name',
				'your other channel description',
				icon: 'secondary_icon',
				sound: 'slow_spring_board',
				largeIcon: 'sample_large_icon',
				largeIconBitmapSource: BitmapSource.Drawable,
				vibrationPattern: vibrationPattern,
				color: const Color.fromARGB(255, 255, 0, 0));
		var iOSPlatformChannelSpecifics =
		new IOSNotificationDetails(sound: "slow_spring_board.aiff");
		var platformChannelSpecifics = new NotificationDetails(
				androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
		await flutterLocalNotificationsPlugin.schedule(
				0,
				'scheduled title',
				'scheduled body',
				scheduledNotificationDateTime,
				platformChannelSpecifics);
	}

	showNotification() async {
		var android = new AndroidNotificationDetails(
				'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
				priority: Priority.High,importance: Importance.Max
		);
		var iOS = new IOSNotificationDetails();
		var platform = new NotificationDetails(android, iOS);
		await flutterLocalNotificationsPlugin.show(
				0, 'New Video is out', 'Flutter Local Notification', platform,
				payload: 'Nitish Kumar Singh is part time Youtuber');
	}
}