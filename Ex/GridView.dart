import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Example01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Example 01'),
      ),
      body: new StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) => new Container(
            color: Colors.green,
            child: new Center(
              // child: new Text(Example01Tile.note.substring(0,(Example01Tile.note.length/10).toInt())+"...."),
              //child: new Text(Example01Tile.note.substring(0,(Example01Tile.note2.length/2).toInt())+"...."),
            )),
        staggeredTileBuilder: (int index) =>
        new StaggeredTile.count(2,4),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}
/*class Example01Tile extends StatelessWidget {
  static String note = "Sarthjabnsdkjhghhdsglkjfhdskjgjgkhgkjdfjhsdgfkgdsg ksdfgkjgdsfkgks";
  static String note2 = "Sarthjabnsdkjhghhdsglkjfhdskjgjgkhgkjdfjhsdgfkgdsg ksdfgkjgdsfkgkhdkshdkjhfdkjshfkhksfhskhfkjshfkjhsfkjhfkssljkdjsfhlsd";
  const Example01Tile(this.backgroundColor, this.flatButton);
  final Color backgroundColor;
  final FlatButton flatButton;
  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new FlatButton(
        child: null,
        onPressed: ()=>print("zz"),
      ),
    );
  }
}*/
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      // theme: kThemeData,
      home: Example01(),
    );
  }
}
main()=> runApp(new App());