import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
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
              availableCalendarFormats: const {
                CalendarFormat.month: '한달',
                CalendarFormat.twoWeeks: '2주',
                CalendarFormat.week: '주간',
              },
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
                String week;
                switch (date.weekday) {
                  case 1:
                    week = '월';
                    break;
                  case 2:
                    week = '화';
                    break;
                  case 3:
                    week = '수';
                    break;
                  case 4:
                    week = '목';
                    break;
                  case 5:
                    week = '금';
                    break;
                  case 6:
                    week = '토';
                    break;
                  case 7:
                    week = '일';
                    break;
                }
                return week;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
