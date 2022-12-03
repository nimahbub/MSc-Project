import 'package:flutter/material.dart';

import 'util/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leaf Desease Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LeafDeseaseDetectionApp(),
    );
  }
}
