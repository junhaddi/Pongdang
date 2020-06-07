import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pongdang/models/history.dart';
import 'package:pongdang/util.dart';
import 'package:pongdang/widgets/check_dialog.dart';
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
                    onDaySelected: (day, events) {
                      if (day.isBefore(DateTime.now().add(Duration(days: 1)))) {
                        // 음주 기록 저장
                        _showCheckDialog(
                          day,
                          events.isEmpty ? 0.0 : events[0].toDouble(),
                          _historys,
                          _events,
                          widget.prefs,
                        );
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
                        color: Colors.orangeAccent,
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
                              '퐁당퐁당 개발진이 여러분의 음주습관 개선을 응원합니다.\n항상 건강하시고 행복하세요 :)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        color: Colors.black12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0, top: 24.0, bottom: 20.0),
                              child: Text(
                                '이번달 음주 횟수(${12}회)',
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
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 2.0,
                                                  ),
                                                ],
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

  Future<void> _showCheckDialog(
      DateTime dateTime,
      double rating,
      List<History> historys,
      Map<DateTime, List> events,
      SharedPreferences prefs) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CheckDialog(
          dateTime: dateTime,
          rating: rating,
          historys: historys,
          events: events,
          prefs: prefs,
        );
      },
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
