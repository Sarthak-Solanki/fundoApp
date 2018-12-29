import '/Users/bridgeit/Desktop/fun_do_note_app/UI/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';
void main(){
  List z = MainState.l;

  var d =  z[1].data["Color"];
  //int value =
  Color c = new Color(d);
  int value = c.value;
  print(value);
  expect(value,true);

}