import 'package:test/test.dart';
import '/Users/bridgeit/Desktop/fun_do_note_app/UI/Login_Page.dart';
import 'package:flutter/material.dart';

void main(){
 // Login_Page l = new Login_Page();
  test("test signin",(){
var result =LoginPageState.validateAndSubmit();
print(result);
expect(result, "test@test.com");

  });
}