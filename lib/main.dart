import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pongdang/screens/index_screen.dart';
import 'package:pongdang/screens/walkthrough_screen.dart';
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
    return DynamicTheme(
      defaultBrightness: (prefs.getBool('isDark') ?? false
          ? Brightness.dark
          : Brightness.light),
      data: (brightness) {
        return brightness == Brightness.light
            ? ThemeData(
                // 기본모드 테마
                primarySwatch: Colors.grey,
                primaryColor: Colors.white,
                brightness: Brightness.light,
                accentColor: Colors.black,
                fontFamily: 'NanumBarunGothic',
              )
            : ThemeData(
                // 다크모드 테마
                primarySwatch: Colors.grey,
                primaryColor: Colors.black,
                brightness: Brightness.dark,
                accentColor: Colors.white,
                fontFamily: 'NanumBarunGothic',
              );
      },
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: '퐁당퐁당',
          theme: theme,
          debugShowCheckedModeBanner: false,
          routes: <String, WidgetBuilder>{
            '/index': (BuildContext context) => IndexScreen(),
          },
          home: _handleCurrentScreen(),
        );
      },
    );
  }

  // 앱 실행 시 스크린 라우팅
  Widget _handleCurrentScreen() {
    bool isWalkthroughSeen = (prefs.getBool('walkthroughSeen') ?? false);
    if (isWalkthroughSeen) {
      return IndexScreen();
    } else {
      return WalkthroughScreen(prefs: prefs);
    }
  }
}
