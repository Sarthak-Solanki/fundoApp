import 'package:test/test.dart';
import '/Users/bridgeit/Desktop/fun_do_note_app/UI/MainPage.dart';
import 'package:flutter/material.dart';
import '../UI/crud.dart';
void main(){
   List z = MainState.l;
   print(z);
  var d =  MainState.l[0].data["Color"];
  //int value =
  Color c = new Color(d);
  int value = c.value;
  print(value);
  crudMethod cm = new crudMethod();
   test("test signin",(){
  });
}