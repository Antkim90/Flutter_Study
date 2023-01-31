import 'package:bhr_test/screen_001.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BHR_Demo_Version',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const screen_001(),
    );
  }
}
