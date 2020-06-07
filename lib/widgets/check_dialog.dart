import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pongdang/models/history.dart';
import 'package:pongdang/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckDialog extends StatefulWidget {
  final DateTime dateTime;
  final double rating;
  final List<History> historys;
  final Map<DateTime, List> events;
  final SharedPreferences prefs;

  CheckDialog({
    this.dateTime,
    this.rating,
    this.historys,
    this.events,
    this.prefs,
  });

  @override
  _CheckDialogState createState() => _CheckDialogState();
}

class _CheckDialogState extends State<CheckDialog> {
  double rating;

  @override
  void initState() {
    super.initState();
    rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Text(
            '${widget.dateTime.month}월 ${widget.dateTime.day}일(${Util.getWeekday(widget.dateTime.weekday)})',
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
          Text(rating == 0
              ? '한방울도 마시지 않았어요'
              : rating == 1
                  ? '기분좋게 한두잔 마셨어요'
                  : rating == 2
                      ? '시간 가는 줄 모르고 마셨어요'
                      : rating == 3 ? '취할 정도로 전투적으로 마셨어요' : '필름 끊길 정도로 마셨어요'),
          SizedBox(
            height: 20.0,
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
                onPressed: () {
                  String title = '${widget.dateTime.year % 100}.'
                      '${widget.dateTime.month < 10 ? '0' : ''}'
                      '${widget.dateTime.month}.'
                      '${widget.dateTime.day < 10 ? '0' : ''}'
                      '${widget.dateTime.day}'
                      '(${Util.getWeekday(widget.dateTime.weekday)})';
                  widget.historys.add(
                    History(
                      dateTime: widget.dateTime,
                      title: title,
                      level: rating,
                    ),
                  );
                  widget.events.addAll({
                    widget.dateTime: [rating]
                  });
                  widget.historys
                      .sort((a, b) => a.dateTime.compareTo(b.dateTime));
                  List<String> dateHistorys =
                      widget.prefs.getStringList('dateHistorys') ?? [];
                  dateHistorys.add(
                    jsonEncode({
                      'dateTime': widget.dateTime.millisecondsSinceEpoch,
                      'title': title,
                      'level': rating,
                    }),
                  );
                  widget.prefs.setStringList('dateHistorys', dateHistorys);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
