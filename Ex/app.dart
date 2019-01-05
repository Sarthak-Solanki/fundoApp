import 'package:flutter/material.dart';
import 'label_form.dart';
import 'note_form.dart';
import 'label_view.dart';

class Keeper extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return new MaterialApp(
			title: 'Keeper',
			theme: new ThemeData(
				primaryColor: Colors.amber.shade500,
				accentColor: Colors.blueGrey.shade500,
				primaryTextTheme: const TextTheme(
					headline: const TextStyle(
						color: Colors.white
					)
				)
			),
			routes: <String, WidgetBuilder> {
				NoteForm.routeName : (BuildContext context) => new NoteForm(),
				LabelView.routeName : (BuildContext context) => new LabelView(title: 'Notes'),
				LabelForm.routeName : (BuildContext context) => new LabelForm()
			}
		);
	}
}
void main()=> runApp(new Keeper());
