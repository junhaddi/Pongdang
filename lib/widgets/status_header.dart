import 'package:flutter/material.dart';

class StatusHeader extends StatelessWidget {
  final String emoji;
  final DateTime date;

  StatusHeader({
    this.emoji,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            emoji,
            style: TextStyle(
              fontSize: 80.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            '${date.year}년 ${date.month}월',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
