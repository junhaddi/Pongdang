import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pongdang/pages/calendar_page.dart';
import 'package:pongdang/pages/home_page.dart';
import 'package:pongdang/pages/setting_page.dart';
import 'package:pongdang/pages/timer_page.dart';
import 'package:pongdang/widgets/bottom_navy_bar.dart';
import 'package:pongdang/widgets/custom_dialog.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int _currentIndex = 0;
  PageController _pageController;
  DateTime _currentBackPressTime;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            HomePage(),
            CalendarPage(),
            TimerPage(),
            SettingPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('홈'),
            activeColor: Colors.redAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.event),
            title: Text('캘린더'),
            activeColor: Colors.blueAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.play_circle_filled),
            title: Text('타이머'),
            activeColor: Colors.deepPurpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('설정'),
            activeColor: Colors.orangeAccent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    DateTime currentTime = DateTime.now();
    if (_currentBackPressTime == null ||
        currentTime.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = currentTime;
      _showExitDialog(context);
      return false;
    }
    return true;
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          subtitle: '퐁당퐁당을 종료할까요?',
          child: Container(
            height: 200.0,
            // TODO AdMob Native 구현
          ),
          event: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
        );
      },
    );
  }
}
