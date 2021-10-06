import 'package:flutter/material.dart';
import 'package:policesfs/Screen/RegisteredUsersDetails.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Police SFS',
        theme: ThemeData(
            //primarySwatch: Colors.red,
            ),
        home: Userdetails());
  }
}
