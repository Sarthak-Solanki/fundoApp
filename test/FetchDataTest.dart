import 'package:test/test.dart';

import '../UI/crud.dart';
void main(context){
  crudMethod cm = new crudMethod();
  test("test signin",(){
    var result =cm.fetch(context);
    print("Data is ${cm.fetch(context)}");
    print(result.toString());
    //expect(result, true);
  });

}