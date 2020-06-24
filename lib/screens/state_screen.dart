import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Swiper.children(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '🥰',
                          style: TextStyle(
                            fontSize: 80.0,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '2020년 5월',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LinearPercentIndicator(
                        width: 100.0,
                        lineHeight: 16.0,
                        percent: 0.1,
                        trailing: Text('2'),
                        leading: Text(
                          '🥰',
                          style: TextStyle(
                            fontSize: 32.0,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        progressColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.blue,
            ),
            Container(
              color: Colors.lightGreen,
            ),
            Container(
              color: Colors.amberAccent,
            ),
          ],
        ),
      ),
    );
  }
}
