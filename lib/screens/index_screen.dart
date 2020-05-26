import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pongdang/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexScreen extends StatefulWidget {
  final SharedPreferences prefs;

  IndexScreen({this.prefs});

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  DateTime _currentBackPressTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Center(
          child: Text('홈'),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    DateTime currentTime = DateTime.now();
    if (_currentBackPressTime == null ||
        currentTime.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = currentTime;
      _showExitDialog(context);
      return false;
    }
    return true;
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          subtitle: '퐁당퐁당을 종료할까요?',
          child: Container(
            height: 200.0,
          ),
          event: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
        );
      },
    );
  }
}
