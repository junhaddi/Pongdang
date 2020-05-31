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
  int headerYear = DateTime.now().year;
  int headerMonth = DateTime.now().month;

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppBar(
              elevation: 0.0,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$headerMonth월 $headerYear',
                  style: TextStyle(
                    fontSize: 32.0,
                  ),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PopupMenuButton<String>(
                    tooltip: '메뉴 표시',
                    onSelected: (value) {
                      print(value);
                    },
                    itemBuilder: (BuildContext context) {
                      return ['앙', '기', '모', '찌'].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TableCalendar(
              calendarController: _calendarController,
              events: _events,
              headerVisible: false,
              calendarStyle: CalendarStyle(
                highlightSelected: false,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(dowTextBuilder: (date, locale) {
                return Util.getWeekday(date.weekday);
              }),
              builders: CalendarBuilders(
                todayDayBuilder: (context, date, events) {
                  return Center(
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
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
                setState(() {
                  headerYear = _calendarController.focusedDay.year;
                  headerMonth = _calendarController.focusedDay.month;
                });
              },
              onDaySelected: (day, events) {
                // 음주 기록 저장
                _showCheckDialog(
                  day,
                  events.isEmpty ? 0.0 : events[0].toDouble(),
                  _historys,
                  _events,
                  widget.prefs,
                );
              },
            ),
            Divider(),
            Expanded(
              child: _historys.isEmpty
                  ? Column(
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
                          '퐁당퐁당 개발진이 여러분의 음주습관 개선을 응원합니다.\n항상 건강하시고 행복하세요',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    )
                  : ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView(
                        children: _historys.reversed
                            .map(
                              (History history) => InkWellCard(
                                onTap: () {
                                  setState(() {
                                    _calendarController
                                        .setSelectedDay(history.dateTime);
                                  });
                                },
                                child: ListTile(
                                  leading: Container(
                                    width: 8.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Util.getColor(history.level),
                                    ),
                                  ),
                                  title: Text(
                                    history.title,
                                  ),
                                  subtitle: Text(
                                    history.subtitle,
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
            subtitle: '${dateMap['subtitle']}',
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
