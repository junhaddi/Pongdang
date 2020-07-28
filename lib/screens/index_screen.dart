import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pongdang/models/history.dart';
import 'package:pongdang/screens/status_screen.dart';
import 'package:pongdang/util.dart';
import 'package:pongdang/widgets/inkwell_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class IndexScreen extends StatefulWidget {
  final SharedPreferences prefs;

  IndexScreen({this.prefs});

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  CalendarController _calendarController;
  List<History> _historys = [];
  Map<DateTime, List> _events = {};
  Color _bottomColor;
  String _subtitle = '';
  String _focusDate = '';
  bool _isLiverBroken = false;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _getHistoryDate();
    Timer(Duration(milliseconds: 1), () {
      _update(false, DateTime.now());
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext ctx) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _focusDate,
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.equalizer,
                            size: 32.0,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => StatusScreen(
                                  historys: _historys,
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  TableCalendar(
                    calendarController: _calendarController,
                    events: _events,
                    headerVisible: false,
                    calendarStyle: CalendarStyle(
                      highlightSelected: false,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      dowTextBuilder: (date, locale) {
                        return Util.getWeekday(date.weekday);
                      },
                    ),
                    builders: CalendarBuilders(
                      todayDayBuilder: (context, date, events) {
                        double opacity =
                            date.month != _calendarController.focusedDay.month
                                ? 0.2
                                : 1.0;
                        return Center(
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(opacity),
                            ),
                            child: Center(
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      markersBuilder: (context, date, events, holidays) {
                        final children = <Widget>[];
                        double opacity =
                            date.month != _calendarController.focusedDay.month
                                ? 0.2
                                : 1.0;
                        if (events.isNotEmpty) {
                          children.add(
                            Center(
                              child: Container(
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Util.getColor(events[0])
                                      .withOpacity(opacity),
                                ),
                                child: Center(
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return children;
                      },
                    ),
                    onVisibleDaysChanged: (first, last, format) {
                      _update(false, DateTime.now());
                    },
                    onDaySelected: (day, events) {
                      DateTime date = DateTime.now().add(Duration(days: 1));
                      if (day.isBefore(
                          DateTime(date.year, date.month, date.day))) {
                        // 음주 기록 저장
                        _showCheckDialog(day, events.isEmpty ? 0.0 : events[0]);
                      } else {
                        _calendarController.setSelectedDay(DateTime.now());
                        Scaffold.of(ctx).removeCurrentSnackBar();
                        Scaffold.of(ctx).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blueGrey,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text('오늘 이후 날짜는 기록 할 수 없습니다'),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: AnimatedContainer(
                  width: double.infinity,
                  color: _bottomColor,
                  duration: Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  child: _historys.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '👏',
                              style: TextStyle(
                                fontSize: 48.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '날짜를 눌러서 음주한 날을 기록하세요!',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '퐁당퐁당 개발진이 여러분의 음주습관 개선을 응원합니다.\n항상 건강하시고 행복하세요  : )',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(16.0, 24.0, 24.0, 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _subtitle,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Image(
                                    image: AssetImage(
                                      _isLiverBroken
                                          ? 'assets/images/liver_2.png'
                                          : 'assets/images/liver_1.png',
                                    ),
                                    height: 40.0,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ScrollConfiguration(
                                behavior: MyBehavior(),
                                child: ListView(
                                  children: _historys
                                      .map(
                                        (History history) => InkWellCard(
                                          onTap: () {
                                            setState(() {
                                              _calendarController
                                                  .setSelectedDay(
                                                      history.dateTime);
                                            });
                                          },
                                          child: ListTile(
                                            leading: Container(
                                              width: 8.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Util.getColor(
                                                    history.level),
                                              ),
                                            ),
                                            title: Text(
                                              history.title,
                                            ),
                                            trailing: Text(
                                              Util.getEmoji(history.level),
                                              style: TextStyle(
                                                fontSize: 32.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _getHistoryDate() async {
    List<String> dateHistoryList =
        widget.prefs.getStringList('dateHistorys') ?? [];
    setState(() {
      // 음주 기록 불러오기
      dateHistoryList.forEach((element) {
        Map dateMap = jsonDecode(element);
        DateTime day = DateTime.fromMillisecondsSinceEpoch(dateMap['dateTime']);
        _historys.add(
          History(
            dateTime: day,
            title: '${dateMap['title']}',
            level: dateMap['level'],
          ),
        );
        _events.addAll({
          day: [dateMap['level']],
        });
      });
      _historys.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    });
  }

  void _update(bool isNotification, DateTime dateTime) {
    setState(() {
      List<int> level = [0, 0, 0, 0];
      int health = 0;
      DateTime date = DateTime.now().subtract(Duration(days: 7));
      _events.forEach((key, value) {
        // 간 건강 체크
        if (key.isAfter(DateTime(date.year, date.month, date.day))) {
          if (value[0] == 1.0) {
            health += 2;
          } else if (value[0] == 2.0) {
            health += 4;
          } else if (value[0] == 3.0) {
            health += 6;
          } else if (value[0] == 4.0) {
            health += 10;
          }
        }
        // 음주량 색상 통계
        if (_calendarController.focusedDay.year == key.year &&
            _calendarController.focusedDay.month == key.month) {
          if (value[0] == 1.0) {
            level[0]++;
          } else if (value[0] == 2.0) {
            level[1]++;
          } else if (value[0] == 3.0) {
            level[2]++;
          } else if (value[0] == 4.0) {
            level[3]++;
          }
        }
      });
      _subtitle = '술마신날(${_events.length})';
      _focusDate =
          '${_calendarController.focusedDay.year}년 ${_calendarController.focusedDay.month}월';
      _isLiverBroken = health >= 10;
      if (_isLiverBroken &&
          isNotification &&
          dateTime.isAfter(DateTime(date.year, date.month, date.day))) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              contentPadding: EdgeInsets.zero,
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        child: Image(
                          height: 200.0,
                          image: [
                            AssetImage('assets/images/reconfirm_1.gif'),
                            AssetImage('assets/images/reconfirm_2.gif'),
                            AssetImage('assets/images/reconfirm_3.gif'),
                          ][Random().nextInt(3)],
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        '잦은 음주',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        '간 손상이 의심됩니다',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ButtonBar(
                        buttonMinWidth: 80.0,
                        buttonHeight: 40.0,
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            child: Text('오케이'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      }

      int maxVal = level.reduce(max);
      if (maxVal == 0) {
        _bottomColor = Util.getColor(0.0);
      } else if (maxVal == level[3]) {
        _bottomColor = Util.getColor(4.0);
      } else if (maxVal == level[2]) {
        _bottomColor = Util.getColor(3.0);
      } else if (maxVal == level[1]) {
        _bottomColor = Util.getColor(2.0);
      } else if (maxVal == level[0]) {
        _bottomColor = Util.getColor(1.0);
      }
    });
  }

  Future<void> _showCheckDialog(DateTime day, double _rating) async {
    double rating = _rating;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  '${day.month}월 ${day.day}일(${Util.getWeekday(day.weekday)})',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  Util.getEmoji(rating),
                  style: TextStyle(
                    fontSize: 48.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Slider(
                  value: rating,
                  min: 0.0,
                  max: 4.0,
                  divisions: 4,
                  activeColor: Util.getColor(rating),
                  onChanged: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                ),
                Text(rating == 0.0
                    ? '한방울도 마시지 않았어요'
                    : rating == 1.0
                        ? '기분좋게 한두잔 마셨어요'
                        : rating == 2.0
                            ? '시간 가는 줄 모르고 마셨어요'
                            : rating == 3.0
                                ? '취할 정도로 잔뜩 마셨어요'
                                : '필름 끊길 정도로 마셨어요'),
                SizedBox(
                  height: 10.0,
                ),
                ButtonBar(
                  buttonMinWidth: 80.0,
                  buttonHeight: 40.0,
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('취소'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    RaisedButton(
                      color: Colors.green,
                      child: Text('확인'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: rating == _rating
                          ? null
                          : () {
                              bool isNotification = false;
                              String title = '${day.year % 100}.'
                                  '${day.month < 10 ? '0' : ''}'
                                  '${day.month}.'
                                  '${day.day < 10 ? '0' : ''}'
                                  '${day.day}'
                                  '(${Util.getWeekday(day.weekday)})';
                              List<String> dateHistorys =
                                  widget.prefs.getStringList('dateHistorys') ??
                                      [];
                              if (rating == 0.0) {
                                // 음주 기록 삭제
                                for (int i = 0; i < _historys.length; i++) {
                                  if (_historys[i]
                                      .dateTime
                                      .isAtSameMomentAs(day)) {
                                    _historys.removeAt(i);
                                  }
                                }
                                _events.removeWhere(
                                    (key, value) => key.isAtSameMomentAs(day));
                                dateHistorys.removeWhere((element) {
                                  Map dateMap = jsonDecode(element);
                                  return DateTime.fromMillisecondsSinceEpoch(
                                          dateMap['dateTime'])
                                      .isAtSameMomentAs(day);
                                });
                              } else if (_rating == 0.0) {
                                // 새로운 음주 기록 추가
                                isNotification = true;
                                _historys.add(
                                  History(
                                    dateTime: day,
                                    title: title,
                                    level: rating,
                                  ),
                                );
                                _events.addAll({
                                  day: [rating]
                                });
                                _historys.sort(
                                    (a, b) => b.dateTime.compareTo(a.dateTime));
                                dateHistorys.add(
                                  jsonEncode({
                                    'dateTime': day.millisecondsSinceEpoch,
                                    'title': title,
                                    'level': rating,
                                  }),
                                );
                              } else {
                                // 음주 기록 변경
                                isNotification = true;
                                _historys.forEach((element) {
                                  if (element.dateTime.isAtSameMomentAs(day)) {
                                    element.level = rating;
                                  }
                                });
                                _events.forEach((key, value) {
                                  if (key.isAtSameMomentAs(day)) {
                                    _events.update(key, (value) {
                                      return [rating];
                                    });
                                  }
                                });
                                dateHistorys.removeWhere((element) {
                                  Map dateMap = jsonDecode(element);
                                  return DateTime.fromMillisecondsSinceEpoch(
                                          dateMap['dateTime'])
                                      .isAtSameMomentAs(day);
                                });
                                dateHistorys.add(
                                  jsonEncode({
                                    'dateTime': day.millisecondsSinceEpoch,
                                    'title': title,
                                    'level': rating,
                                  }),
                                );
                              }
                              widget.prefs
                                  .setStringList('dateHistorys', dateHistorys);
                              Navigator.of(context).pop();
                              _update(isNotification, day);
                            },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            );
          }),
        );
      },
    ).then((value) {
      setState(() {});
    });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
