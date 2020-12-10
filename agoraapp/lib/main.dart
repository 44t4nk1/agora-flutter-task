import 'package:flutter/material.dart';

import './pages/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agora Challenege App',
      home: IndexPage(),
    );
  }
}
