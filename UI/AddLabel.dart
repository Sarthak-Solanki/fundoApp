import 'package:flutter/material.dart';
import 'crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AddLabels extends StatefulWidget {
	List labels = [""];
 //QuerySnapshot labels;
	AddLabels({Key key,this.labels}):super(key:key);

	@override
	State<StatefulWidget> createState() => new LabelFormState();
}

class LabelFormState extends State<AddLabels> {
	crudMethod crudObj = new crudMethod();
	final _scaffoldKey = new GlobalKey<ScaffoldState>();
	final formKey = new GlobalKey<FormState>();
	String error;
	String updateError;
	List<Widget> labelList = [];
	List offlineLabel;

	@override
  void initState() {
    offlineLabel = widget.labels;
		_buildLabels(null);
 // TODO: implement initState
    super.initState();
  }
	final TextEditingController _controller = new TextEditingController();
	TextEditingController _updateController = new TextEditingController();

	@override
	Widget build(BuildContext context) {
		Scaffold scaffold = new Scaffold(
				key: _scaffoldKey,
				appBar: new AppBar(
					leading: new IconButton(
						icon: const Icon(Icons.close),
						color: Colors.white,
						onPressed: () => _closeLabelForm(context),
					),
					title: new Text('Edit Labels',
							style: const TextStyle(
									color: Colors.white
							)
					),
					backgroundColor: Colors.blueGrey.shade500,
				),
				body: new Container(
						child: new ListView(
								children: labelList
						)
				)
		);
		return scaffold;
	}


	/*addLabel(){
		for(int i = 0;i<widget.labels.length;i++){
			Map <dynamic,dynamic> labelData = <String,dynamic>{"Label":widget.labels[i]};
			crudObj.addLabel(labelData);
		}
	}*/
	_closeLabelForm(BuildContext context) {
		//addLabel();
		setState(() {

		});
		Navigator.of(context).pop();
	}

	List<Widget> _buildLabels(int editIndex) {
	 	labelList = [];
		labelList.add(
				new ListTile(
					leading: new IconButton(
							icon: const Icon(Icons.close),
							color: Colors.grey,
							onPressed: _clearText
					),
					title: new Theme(
							data: new ThemeData(
									primaryColor: Colors.blueGrey.shade500
							), // Setting the underline with appBar color
							child: new TextField(
								controller: _controller,
								style: new TextStyle(
										fontSize: 18.0,
										color: Colors.grey.shade700
								),
								decoration: new InputDecoration(
									errorText: error,
									labelText: 'Enter label Name',
									labelStyle: new TextStyle(
											color: Colors.blueGrey.shade700
									),
								),
							)
					),
					trailing: new IconButton(
							icon: const Icon(Icons.check),
							color: Colors.green,
							onPressed: _onSave
					),
				)
		);
 if(offlineLabel!=null&&widget.labels!=null){

		for(int index=0; index<offlineLabel.length;index++) {
			if(editIndex != null && editIndex == index){
				if(updateError == null || updateError.isEmpty)
					_updateController = new TextEditingController(text: offlineLabel[index].data['Label']);
				labelList.add(
						new ListTile(
							leading: new IconButton(
									icon: const Icon(Icons.close),
									onPressed: () => _onCancelAt(index)
							),
							title: new Theme(
								data: new ThemeData(
										primaryColor: Colors.blueGrey.shade500
								),
								child: new TextField(
										controller: _updateController,
										autofocus: true,
										style: new TextStyle(
											fontSize: 18.0,
											color: Colors.grey.shade700,
										),
										decoration: new InputDecoration(
												border: null,
												errorText: updateError,
												counterText: offlineLabel[index].data['Label']
										)
								),
							),
							trailing: new IconButton(
									icon: const Icon(Icons.check),
									color: Colors.green,
									onPressed: () => _onUpdateAt(index)
							),
						)
				);
			}else{
				labelList.add(
						new ListTile(
							leading: new IconButton(
									icon: const Icon(Icons.delete),
									onPressed: () => _removeLabelAt(index)
							),
							title: new Text(offlineLabel[index].data['Label']),
							trailing: new IconButton(
									icon: const Icon(Icons.edit),
									onPressed: () => _editLabelAt(index)
							),
						)
				);
			}
		}
 }
		return labelList;

	}


	_clearText() {
		setState((){
			_controller.clear();
			error = null;
			_buildLabels(null);
		});
	}

	_onSave() {
		//setState(() {
			if(_controller.text.isNotEmpty) {
					Map <dynamic,dynamic> labelData = <String,dynamic>{"Label":_controller.text};
					//offlineLabel.add(labelData);
					crudObj.addLabel(labelData);
					//widget.labels = crudObj.fetchData();
				crudObj.fetchData().then((result){
					widget.labels = result.documents;
					offlineLabel = widget.labels;
				_controller.clear();
				error = null;
				_buildLabels(null);
				setState(() {

				});
				});

			} else{
				error = 'Enter valid name!';
				_buildLabels(null);
			}
			setState(() {

			});
		//});
	}

	_removeLabelAt(int index) {
		//setState((){
			//if(offlineLabel.length > 1) {
			crudObj.deleteLabel(offlineLabel[index].documentID);
			crudObj.fetchData().then((result){
				offlineLabel = result.documents;
				_buildLabels(null);
				setState(() {
				});

			});
		//	} else {
			//	_scaffoldKey.currentState.showSnackBar(
				//		new SnackBar(
					//		content: new Text('Cannot Delete!'),
						//)
				//);
			//}
		//});
	}

	_editLabelAt(index) {
		setState((){
			_updateController.clear();
			updateError = null;
			_buildLabels(index);
		});
	}

	_onUpdateAt(index) {
		setState(() {
			if(_updateController.text.isNotEmpty){
				offlineLabel[index].data['Label'] = _updateController.text;
				Map <dynamic,dynamic> labelData = <String,dynamic>{"Label":_updateController.text};

				crudObj.updatelabel(labelData, offlineLabel[index].documentID);
				_updateController.clear();
				_buildLabels(null);
			} else {
				updateError = 'Enter valid name!';
				_buildLabels(index);
			}
		});
	}

	_onCancelAt(index) {
		setState(() {
			_buildLabels(null);
		});
	}
}