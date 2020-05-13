import 'package:flutter/material.dart';
import 'package:isa_telci/Screens/HomeScreen.dart';
import 'package:isa_telci/test.dart';
import 'package:provider/provider.dart';

import 'Provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<MyProvider>(
      create: (_) => MyProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(),
    );
  }
}
