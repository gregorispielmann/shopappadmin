import 'package:flutter/material.dart';
import 'package:shopappadmin/screens/LoginScreen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App Admin',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}