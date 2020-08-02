import 'package:flutter/material.dart';

class Util {
  static Color getColor(double val) {
    Color color;
    if (val == 0.0) {
      color = Colors.blue[100];
    } else if (val == 1.0) {
      color = Colors.amberAccent;
    } else if (val == 2.0) {
      color = Colors.orange;
    } else if (val == 3.0) {
      color = Colors.redAccent;
    } else if (val == 4.0) {
      color = Colors.red[900];
    }
    return color;
  }

  static String getImage(double val) {
    String image;
    if (val == 0.0) {
      image = 'assets/images/level_1.png';
    } else if (val == 1.0) {
      image = 'assets/images/level_2.png';
    } else if (val == 2.0) {
      image = 'assets/images/level_3.png';
    } else if (val == 3.0) {
      image = 'assets/images/level_4.png';
    } else if (val == 4.0) {
      image = 'assets/images/level_5.png';
    }
    return image;
  }

  static String getWeekday(int val) {
    String week;
    if (val == 1) {
      week = '월';
    } else if (val == 2) {
      week = '화';
    } else if (val == 3) {
      week = '수';
    } else if (val == 4) {
      week = '목';
    } else if (val == 5) {
      week = '금';
    } else if (val == 6) {
      week = '토';
    } else if (val == 7) {
      week = '일';
    }
    return week;
  }
}
