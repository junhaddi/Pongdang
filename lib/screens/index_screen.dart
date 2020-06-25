import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pongdang/util.dart';
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
  Map<DateTime, List> _events = {};
  Color bottomColor = Util.getColor(0.0);

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _getHistoryDate();
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
                  TableCalendar(
                    calendarController: _calendarController,
                    events: _events,
                    calendarStyle: CalendarStyle(
                      highlightSelected: false,
                    ),
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      formatButtonVisible: false,
                      titleTextBuilder: (date, locale) {
                        return '${date.year}.${date.month < 10 ? '0' : ''}${date.month}';
                      },
                      titleTextStyle: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      leftChevronIcon: Icon(Icons.arrow_back_ios),
                      rightChevronIcon: Icon(Icons.arrow_forward_ios),
                      leftChevronMargin: EdgeInsets.all(12.0),
                      rightChevronMargin: EdgeInsets.all(12.0),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      dowTextBuilder: (date, locale) {
                        return Util.getWeekday(date.weekday);
                      },
                    ),
                    builders: CalendarBuilders(
                      todayDayBuilder: (context, date, events) {
                        return Center(
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
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
                      _updateBottomColor();
                    },
                    onDaySelected: (day, events) {
                      DateTime date = DateTime.now().add(Duration(days: 1));
                      if (day.isBefore(
                          DateTime(date.year, date.month, date.day))) {
                        // 음주 기록 저장
                        _showCheckDialog(
                            day, events.isEmpty ? 0.0 : events[0].toDouble());
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
                  Container(
                    width: 20.0,
                    height: 3.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
              Expanded(
                child: AnimatedContainer(
                  width: double.infinity,
                  color: bottomColor,
                  duration: Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  child: Column(
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
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
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
        _events.addAll({
          day: [dateMap['level']],
        });
      });
    });
  }

  void _updateBottomColor() {
    setState(() {
      List level = [0, 0, 0, 0];
      _events.forEach((key, value) {
        if (_calendarController.focusedDay.year == key.year &&
            _calendarController.focusedDay.month == key.month) {
          if (value[0] == 1.0) {
            level[0]++;
          } else if (value[0] == 2.0) {
            level[1]++;
          } else if (value[0] == 3.0) {
            level[2]++;
          } else {
            level[3]++;
          }
        }
      });
      int maxVal = level[0];
      for (int i = 1; i < 4; i++) {
        if (maxVal < level[i]) {
          maxVal = level[i];
        }
      }
      if (maxVal == 0) {
        bottomColor = Util.getColor(0.0);
      } else if (maxVal == level[3]) {
        bottomColor = Util.getColor(4.0);
      } else if (maxVal == level[2]) {
        bottomColor = Util.getColor(3.0);
      } else if (maxVal == level[1]) {
        bottomColor = Util.getColor(2.0);
      } else {
        bottomColor = Util.getColor(1.0);
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
                                _events.addAll({
                                  day: [rating]
                                });
                                dateHistorys.add(
                                  jsonEncode({
                                    'dateTime': day.millisecondsSinceEpoch,
                                    'title': title,
                                    'level': rating,
                                  }),
                                );
                              } else {
                                // 음주 기록 변경
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
                              _updateBottomColor();
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
          }),
        );
      },
    ).then((value) {
      setState(() {});
    });
  }
}
