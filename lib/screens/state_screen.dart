import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateScreen extends StatefulWidget {
  final SharedPreferences prefs;

  StateScreen({this.prefs});

  @override
  _StateScreenState createState() => _StateScreenState();
}

class _StateScreenState extends State<StateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
