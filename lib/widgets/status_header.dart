import 'package:flutter/material.dart';

class StatusHeader extends StatelessWidget {
  final String image;
  final DateTime date;

  StatusHeader({
    this.image,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage(
              image,
            ),
            height: 80.0,
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
