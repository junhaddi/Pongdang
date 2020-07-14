import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pongdang/models/header.dart';
import 'package:pongdang/util.dart';
import 'package:pongdang/widgets/status_graph.dart';
import 'package:pongdang/widgets/status_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusScreen extends StatefulWidget {
  final SharedPreferences prefs;

  StatusScreen({this.prefs});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final SwiperController _swiperController = SwiperController();
  Color _backgroundColor = Colors.blue;
  List<Header> _headerList = [];
  List _historyList = [];
  List _level = [
    {'value': 0.0, 'width': 12.0},
    {'value': 0.0, 'width': 12.0},
    {'value': 0.0, 'width': 12.0},
    {'value': 0.0, 'width': 12.0},
  ];

  @override
  void initState() {
    super.initState();
    _getHistoryDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Stack(
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  decoration: BoxDecoration(color: _backgroundColor),
                ),
                Swiper.children(
                  controller: _swiperController,
                  loop: false,
                  children: _headerList
                      .map(
                        (Header header) => StatusHeader(
                          emoji: header.emoji,
                          date: header.dateTime,
                        ),
                      )
                      .toList(),
                  onIndexChanged: (value) {
                    setState(() {
                      if (_headerList[value].emoji == Util.getEmoji(4.0)) {
                        _backgroundColor = Util.getColor(4.0);
                      } else if (_headerList[value].emoji ==
                          Util.getEmoji(3.0)) {
                        _backgroundColor = Util.getColor(3.0);
                      } else if (_headerList[value].emoji ==
                          Util.getEmoji(2.0)) {
                        _backgroundColor = Util.getColor(2.0);
                      } else if (_headerList[value].emoji ==
                          Util.getEmoji(1.0)) {
                        _backgroundColor = Util.getColor(1.0);
                      }
                      _level[0]['value'] = _historyList[value][0];
                      _level[1]['value'] = _historyList[value][1];
                      _level[2]['value'] = _historyList[value][2];
                      _level[3]['value'] = _historyList[value][3];
                      _level[0]['width'] = _historyList[value][4];
                      _level[1]['width'] = _historyList[value][5];
                      _level[2]['width'] = _historyList[value][6];
                      _level[3]['width'] = _historyList[value][7];
                    });
                  },
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      iconSize: 32.0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Column(
                children: <Widget>[
                  StatusGraph(
                    emoji: Util.getEmoji(1.0),
                    color: Util.getColor(1.0),
                    width: _level[0]['width'],
                    value: _level[0]['value'],
                  ),
                  StatusGraph(
                    emoji: Util.getEmoji(2.0),
                    color: Util.getColor(2.0),
                    width: _level[1]['width'],
                    value: _level[1]['value'],
                  ),
                  StatusGraph(
                    emoji: Util.getEmoji(3.0),
                    color: Util.getColor(3.0),
                    width: _level[2]['width'],
                    value: _level[2]['value'],
                  ),
                  StatusGraph(
                    emoji: Util.getEmoji(4.0),
                    color: Util.getColor(4.0),
                    width: _level[3]['width'],
                    value: _level[3]['value'],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getHistoryDate() async {
    setState(() {
      List<String> dateHistoryList =
          widget.prefs.getStringList('dateHistorys') ?? [];
      // 날짜 정렬
      dateHistoryList.sort((a, b) =>
          jsonDecode(b)['dateTime'].compareTo(jsonDecode(a)['dateTime']));
      if (dateHistoryList.isNotEmpty) {
        List<double> level = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
        DateTime minDateTime = DateTime.fromMillisecondsSinceEpoch(
            jsonDecode(dateHistoryList[0])['dateTime']);
        minDateTime = DateTime(minDateTime.year, minDateTime.month);
        dateHistoryList.forEach((element) {
          Map dateMap = jsonDecode(element);
          DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(dateMap['dateTime']);
          dateTime = DateTime(dateTime.year, dateTime.month);
          if (minDateTime.isAfter(dateTime)) {
            double maxVal = level.reduce(max);
            _headerList
                .add(Header(emoji: Util.getEmoji(maxVal), dateTime: dateTime));
            level[4] = (level[0] / maxVal) * 260 + 12;
            level[5] = (level[1] / maxVal) * 260 + 12;
            level[6] = (level[2] / maxVal) * 260 + 12;
            level[7] = (level[3] / maxVal) * 260 + 12;
            _historyList.add(level);
            level = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
            minDateTime = dateTime;
          } else {
            if (dateMap['level'] == 1.0) {
              level[0]++;
            } else if (dateMap['level'] == 2.0) {
              level[1]++;
            } else if (dateMap['level'] == 3.0) {
              level[2]++;
            } else if (dateMap['level'] == 4.0) {
              level[3]++;
            }
          }
        });
      }
    });
  }
}
