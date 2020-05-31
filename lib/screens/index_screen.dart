import 'dart:convert';

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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TableCalendar(
              calendarController: _calendarController,
              events: _events,
              availableCalendarFormats: const {
                CalendarFormat.month: '한달',
                CalendarFormat.twoWeeks: '2주',
                CalendarFormat.week: '주간',
              },
              calendarStyle: CalendarStyle(
                highlightSelected: false,
              ),
              headerStyle: HeaderStyle(
                formatButtonShowsNext: false,
                titleTextBuilder: (date, locale) {
                  return '${date.month}월 ${date.year}';
                },
                titleTextStyle: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blueAccent[700],
                  borderRadius: BorderRadius.circular(50.0),
                ),
                formatButtonTextStyle: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(Icons.arrow_back_ios),
                rightChevronIcon: Icon(Icons.arrow_forward_ios),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(dowTextBuilder: (date, locale) {
                return Util.getWeekday(date.weekday);
              }),
              builders: CalendarBuilders(
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
                                baseBorderRadius: BorderRadius.circular(4.0),
                                baseMarginValue: EdgeInsets.only(
                                  left: 4.0,
                                  right: 4.0,
                                ),
                                onTap: () {
                                  setState(() {
                                    _calendarController
                                        .setSelectedDay(history.dateTime);
                                  });
                                },
                                child: ListTile(
                                  title: Text(
                                    history.title,
                                  ),
                                  trailing: Container(
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Util.getColor(history.level),
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
