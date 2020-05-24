import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pongdang/widgets/walkthrough_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalkthroughScreen extends StatefulWidget {
  final SharedPreferences prefs;

  WalkthroughScreen({this.prefs});

  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  final _formKey = GlobalKey<FormState>();
  final SwiperController _swiperController = SwiperController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Swiper.children(
        controller: _swiperController,
        loop: false,
        pagination: SwiperPagination(
          margin: EdgeInsets.only(bottom: 40.0),
          builder: DotSwiperPaginationBuilder(
            activeColor: Colors.blueAccent[700],
            color: Colors.grey,
            activeSize: 12.0,
            size: 8.0,
            space: 8.0,
          ),
        ),
        onIndexChanged: (value) {
          FocusScope.of(context).unfocus();
        },
        children: <Widget>[
          WalkThroughPage(
            title: '어서와요',
            description: '금딸을 다짐하신 당신!\n금딸캠프에 오신 것을 환영합니다.',
            buttonText: '안녕 :)',
            onTap: () {
              _swiperController.next();
            },
            child: Icon(
              Icons.weekend,
              size: 120.0,
              color: Colors.black,
            ),
          ),
          WalkThroughPage(
            title: '함께해요',
            description: '자신만의 금딸 목표일수를 세우고\n다른 사람들과 함께 목표를 달성해 보아요.',
            buttonText: '화이팅 :D',
            onTap: () {
              _swiperController.next();
            },
            child: Icon(
              Icons.check_box,
              size: 120.0,
              color: Colors.black,
            ),
          ),
          WalkThroughPage(
            title: '나눠봐요',
            description: '금딸하는 동안 겪은 경험담과 노하우를\n다른 사람들과 나누어 보아요.',
            buttonText: '오케이 ;)',
            onTap: () {
              _swiperController.next();
            },
            child: Icon(
              Icons.favorite,
              size: 120.0,
              color: Colors.black,
            ),
          ),
          Form(
            key: _formKey,
            child: WalkThroughPage(
              title: '시작해요',
              description: '포기하지 말고 목표 끝까지 화이팅해보아요!\n금딸캠프가 당신의 금딸을 응원합니다.',
              buttonText: '아자! 아자!',
              onTap: () {
                if (_formKey.currentState.validate()) {
                  widget.prefs.setBool('walkthroughSeen', true);
                  widget.prefs
                      .setString('nickName', _textEditingController.text);
                  Navigator.of(context).pushReplacementNamed('/index');
                }
              },
              child: Column(
                children: <Widget>[
                  Container(
                    width: 300.0,
                    child: TextFormField(
                      controller: _textEditingController,
                      enableInteractiveSelection: false,
                      maxLength: 8,
                      autovalidate: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.0,
                      ),
                      decoration: InputDecoration(
                        hintText: '별명',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '별명을 입력해 주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text('설정 페이지에서 언제든지 바꿀 수 있습니다'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
