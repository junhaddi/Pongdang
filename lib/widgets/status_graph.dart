import 'package:flutter/material.dart';

class StatusGraph extends StatelessWidget {
  final String emoji;
  final Color color;
  final double width;
  final double value;

  StatusGraph({
    this.emoji,
    this.color,
    this.width,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                emoji,
                style: TextStyle(
                  fontSize: 32.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: AnimatedContainer(
                  width: width,
                  height: 12.0,
                  duration: Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '${value.floor()}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
