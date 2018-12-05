import 'package:test/test.dart';

import '/Users/bridgeit/Desktop/fun_do_note_app/Ex/TakeNotes.dart';
import '/Users/bridgeit/Desktop/fun_do_note_app/Ex/crud.dart';
void main(){
  crudMethod cm = new crudMethod();
   test("test signin",(){
  var result =cm.isLogin();
  print(result);
  expect(result, true);
  });

}