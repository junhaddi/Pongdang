import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  SharedPreferences _prefs;
  DateTime _initDate;
  DateTime _srcDate;
  DateTime _dstDate;
  int _progressDay;
  int _dday;
  bool _isLoaded = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _getDate();
  }

  Widget build(BuildContext context) {
    if (_isLoaded) {
      _updateDate();
    }
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularPercentIndicator(
            radius: 280.0,
            lineWidth: 20.0,
            arcType: ArcType.FULL,
            arcBackgroundColor: Color(0xFFB8C7CB),
            progressColor: Colors.deepPurpleAccent,
            backgroundColor: Colors.transparent,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animateFromLastPercent: true,
            percent: _isLoaded
                ? max(
                    0.001,
                    min(
                        DateTime.now().difference(_srcDate).inMilliseconds /
                            _dstDate.difference(_srcDate).inMilliseconds,
                        1.0),
                  )
                : 0.0,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _isLoaded
                    ? Column(
                        children: <Widget>[
                          Text(
                            '$_progressDay일차',
                            style: TextStyle(
                              fontSize: 42.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_initDate.year}/${_initDate.month}/${_initDate.day}~',
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'D${_dday < 0 ? '+' : '-'}${_dday == 0 ? 'DAY' : _dday.abs()}',
                            style: TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        '시작하세요',
                        style: TextStyle(
                          fontSize: 42.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
            footer: RaisedButton(
              shape: CircleBorder(),
              color: Colors.deepPurpleAccent,
              padding: EdgeInsets.all(4.0),
              child: Icon(
                _isLoaded
                    ? _isSuccess ? Icons.check : Icons.priority_high
                    : Icons.play_arrow,
                size: 48.0,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              onPressed: () {
                if (_isLoaded) {
                  _updateDate();
                  if (_isSuccess) {
                    _showResetDialog(true);
                  } else {
                    _showReconfirmDialog();
                  }
                } else {
                  _showLoadDialog();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getDate() async {}

  void _updateDate() {}

  Future<void> _showLoadDialog() async {}

  Future<void> _showReconfirmDialog() async {}

  Future<void> _showResetDialog(bool isSuccess) async {}
}
