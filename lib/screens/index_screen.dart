import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pongdang/models/history.dart';
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
  String _subtitle = '날짜를 눌러서 음주한 날을 기록하세요!';

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
                              color: Colors.grey,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                ),
                              ],
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
                        if (events.isNotEmpty) {
                          children.add(
                            Center(
                              child: Container(
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Util.getColor(events[0]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2.0,
                                    ),
                                  ],
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
                      _updateDrink();
                    },
                    onDaySelected: (day, events) {
                      if (day.isBefore(DateTime.now().add(Duration(days: 1)))) {
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
                child: _historys.isEmpty
                    ? Container(
                        width: double.infinity,
                        color: Colors.lightGreen,
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
                      )
                    : Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              stops: [
                                0.1,
                                0.4,
                                0.6,
                                0.9
                              ],
                              colors: [
                                Colors.yellow,
                                Colors.red,
                                Colors.indigo,
                                Colors.teal
                              ]),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            topLeft: Radius.circular(30.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0, top: 24.0, bottom: 20.0),
                              child: Text(
                                _subtitle,
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ScrollConfiguration(
                                behavior: MyBehavior(),
                                child: ListView(
                                  children: _historys.reversed
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
      _historys.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    });
  }

  void _updateDrink() {
    setState(() {
      int drinkDay = 0;
      _historys.forEach((element) {
        if (_calendarController.focusedDay.year == element.dateTime.year &&
            _calendarController.focusedDay.month == element.dateTime.month) {
          drinkDay += 1;
        }
      });
      _subtitle = '이번달 음주 횟수($drinkDay회)';
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
                                    (a, b) => a.dateTime.compareTo(b.dateTime));
                                dateHistorys.add(
                                  jsonEncode({
                                    'dateTime': day.millisecondsSinceEpoch,
                                    'title': title,
                                    'level': rating,
                                  }),
                                );
                              } else {
                                // 음주 기록 변경
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
                              _updateDrink();
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

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
