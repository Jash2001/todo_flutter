import 'package:flutter/material.dart';
import 'App Screens/screen1.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'To Do App', debugShowCheckedModeBanner: false, home: Events());
  }
}
