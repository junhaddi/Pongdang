import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pongdang/models/header.dart';
import 'package:pongdang/models/history.dart';
import 'package:pongdang/util.dart';
import 'package:pongdang/widgets/status_graph.dart';
import 'package:pongdang/widgets/status_header.dart';

class StatusScreen extends StatefulWidget {
  final List<History> historys;

  StatusScreen({this.historys});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final SwiperController _swiperController = SwiperController();
  Color _backgroundColor;
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
    if (widget.historys.isEmpty) {
      _backgroundColor = Util.getColor(0.0);
      _headerList
          .add(Header(image: Util.getImage(0.0), dateTime: DateTime.now()));
    } else {
      setState(() {
        if (_headerList[0].image == Util.getImage(4.0)) {
          _backgroundColor = Util.getColor(4.0);
        } else if (_headerList[0].image == Util.getImage(3.0)) {
          _backgroundColor = Util.getColor(3.0);
        } else if (_headerList[0].image == Util.getImage(2.0)) {
          _backgroundColor = Util.getColor(2.0);
        } else if (_headerList[0].image == Util.getImage(1.0)) {
          _backgroundColor = Util.getColor(1.0);
        }
        _level[0]['value'] = _historyList[0][0];
        _level[1]['value'] = _historyList[0][1];
        _level[2]['value'] = _historyList[0][2];
        _level[3]['value'] = _historyList[0][3];
      });

      // 그래프 애니메이션 효과
      Timer(Duration(milliseconds: 1), () {
        setState(() {
          _level[0]['width'] = _historyList[0][4];
          _level[2]['width'] = _historyList[0][6];
          _level[1]['width'] = _historyList[0][5];
          _level[3]['width'] = _historyList[0][7];
        });
      });
    }
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
                  loop: _headerList.length > 1,
                  children: _headerList
                      .map(
                        (Header header) => StatusHeader(
                          image: header.image,
                          date: header.dateTime,
                        ),
                      )
                      .toList(),
                  onIndexChanged: (value) {
                    setState(() {
                      if (_headerList[value].image == Util.getImage(4.0)) {
                        _backgroundColor = Util.getColor(4.0);
                      } else if (_headerList[value].image ==
                          Util.getImage(3.0)) {
                        _backgroundColor = Util.getColor(3.0);
                      } else if (_headerList[value].image ==
                          Util.getImage(2.0)) {
                        _backgroundColor = Util.getColor(2.0);
                      } else if (_headerList[value].image ==
                          Util.getImage(1.0)) {
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
                Align(
                  alignment: Alignment.topRight,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
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
                ),
                _headerList.length > 1
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(48.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white.withOpacity(0.4),
                              ),
                              iconSize: 24.0,
                              onPressed: () {
                                _swiperController.previous();
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(),
                _headerList.length > 1
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(48.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white.withOpacity(0.4),
                              ),
                              iconSize: 24.0,
                              onPressed: () {
                                _swiperController.next();
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(),
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
                    image: Util.getImage(1.0),
                    color: Util.getColor(1.0),
                    width: _level[0]['width'],
                    value: _level[0]['value'],
                  ),
                  StatusGraph(
                    image: Util.getImage(2.0),
                    color: Util.getColor(2.0),
                    width: _level[1]['width'],
                    value: _level[1]['value'],
                  ),
                  StatusGraph(
                    image: Util.getImage(3.0),
                    color: Util.getColor(3.0),
                    width: _level[2]['width'],
                    value: _level[2]['value'],
                  ),
                  StatusGraph(
                    image: Util.getImage(4.0),
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

  void _getHistoryDate() {
    if (widget.historys.isNotEmpty) {
      List<double> level = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      DateTime minDateTime = widget.historys[0].dateTime;
      minDateTime = DateTime(minDateTime.year, minDateTime.month);
      widget.historys.asMap().forEach((index, element) {
        DateTime dateTime = element.dateTime;
        dateTime = DateTime(dateTime.year, dateTime.month);
        if (element.level == 1.0) {
          level[0]++;
        } else if (element.level == 2.0) {
          level[1]++;
        } else if (element.level == 3.0) {
          level[2]++;
        } else if (element.level == 4.0) {
          level[3]++;
        }
        if (index != widget.historys.length - 1) {
          DateTime afterDateTime = widget.historys[index + 1].dateTime;
          afterDateTime = DateTime(afterDateTime.year, afterDateTime.month);
          if (dateTime.isAfter(afterDateTime)) {
            double maxVal = level.reduce(max);
            String image;
            if (maxVal == level[3]) {
              image = Util.getImage(4.0);
            } else if (maxVal == level[2]) {
              image = Util.getImage(3.0);
            } else if (maxVal == level[1]) {
              image = Util.getImage(2.0);
            } else if (maxVal == level[0]) {
              image = Util.getImage(1.0);
            }
            _headerList.add(Header(image: image, dateTime: dateTime));
            level[4] = (level[0] / maxVal) * 220 + 12;
            level[5] = (level[1] / maxVal) * 220 + 12;
            level[6] = (level[2] / maxVal) * 220 + 12;
            level[7] = (level[3] / maxVal) * 220 + 12;
            _historyList.add(level);
            level = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
            minDateTime = dateTime;
          }
        } else {
          double maxVal = level.reduce(max);
          String image;
          if (maxVal == level[3]) {
            image = Util.getImage(4.0);
          } else if (maxVal == level[2]) {
            image = Util.getImage(3.0);
          } else if (maxVal == level[1]) {
            image = Util.getImage(2.0);
          } else if (maxVal == level[0]) {
            image = Util.getImage(1.0);
          }
          _headerList.add(Header(image: image, dateTime: dateTime));
          level[4] = (level[0] / maxVal) * 220 + 12;
          level[5] = (level[1] / maxVal) * 220 + 12;
          level[6] = (level[2] / maxVal) * 220 + 12;
          level[7] = (level[3] / maxVal) * 220 + 12;
          _historyList.add(level);
          level = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
          minDateTime = dateTime;
        }
      });
    }
  }
}
