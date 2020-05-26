import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pongdang/screens/index_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs: prefs));
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  MyApp({this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '퐁당퐁당',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colors.white,
        brightness: Brightness.light,
        accentColor: Colors.black,
        fontFamily: 'NanumBarunGothic',
      ),
      debugShowCheckedModeBanner: false,
      home: IndexScreen(prefs: prefs),
    );
  }
}
