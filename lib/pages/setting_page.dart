import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:pongdang/custom_icons_icons.dart';
import 'package:pongdang/models/divider_list_tile.dart';
import 'package:pongdang/widgets/custom_app_bar.dart';
import 'package:pongdang/widgets/custom_dialog.dart';
import 'package:pongdang/widgets/divider_list_group.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  SharedPreferences _prefs;
  String _nickName = '';
  bool _isDarkMode;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getNickName();
    _isDarkMode = DynamicTheme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '설정',
      ),
      body: ListView(
        children: <Widget>[
          DividerListGroup(
            title: '일반',
            child: [
              DividerListTile(
                title: '$_nickName님',
                subtitle: '별명 변경',
                icon: Icons.account_circle,
                onTap: () {
                  _textEditingController.text = _nickName;
                  _changeNickName();
                },
              ),
            ],
          ),
          DividerListGroup(
            title: '테마',
            child: [
              DividerListTile(
                title: '다크모드',
                trailing: Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _changeBrightness();
                      _isDarkMode = value;
                    });
                  },
                ),
                icon: CustomIcons.moon,
              ),
            ],
          ),
          DividerListGroup(
            title: '기타',
            child: [
              DividerListTile(
                title: '리뷰 남기기',
                icon: Icons.thumb_up,
                onTap: () {
                  // TODO Android, iOS 기기에 따라 스토어 링크 이동
                },
              ),
              DividerListTile(
                title: '의견 보내기',
                icon: Icons.mail,
                onTap: () {
                  // TODO rkdwnsgk05@gmail.com 메일 작성 페이지 이동
                },
              ),
              DividerListTile(
                title: '앱 공유하기',
                icon: Icons.share,
                onTap: () {
                  final RenderBox box = context.findRenderObject();
                  String text = '플레이스토어, 앱스토어 링크';
                  Share.share(text,
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _getNickName() async {
    _prefs = await SharedPreferences.getInstance();
    _nickName = _prefs.getString('nickName') ?? '';
  }

  Future<void> _changeNickName() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          child: Form(
            key: _formKey,
            child: Container(
              width: 200.0,
              height: 160.0,
              child: Center(
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
            ),
          ),
          event: () {
            if (_formKey.currentState.validate()) {
              setState(() {
                _nickName = _textEditingController.text;
                _prefs.setString('nickName', _textEditingController.text);
                Navigator.of(context).pop();
              });
            }
          },
        );
      },
    );
  }

  void _changeBrightness() {
    DynamicTheme.of(context)
        .setBrightness(_isDarkMode ? Brightness.light : Brightness.dark);
  }
}
