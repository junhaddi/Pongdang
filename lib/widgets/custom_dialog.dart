import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback event;
  final BorderRadius _baseBorderRadius = BorderRadius.circular(20.0);

  CustomDialog({
    this.title,
    this.subtitle,
    this.child,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: _baseBorderRadius,
      ),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: child,
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: title == null
                ? EdgeInsets.zero
                : EdgeInsets.only(
                    bottom: 20.0,
                  ),
            child: title == null
                ? null
                : Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          Padding(
            padding: subtitle == null
                ? EdgeInsets.zero
                : EdgeInsets.only(
                    bottom: 20.0,
                  ),
            child: subtitle == null
                ? null
                : Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
          ),
          ButtonBar(
            buttonMinWidth: 80.0,
            buttonHeight: 40.0,
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text('아니'),
                shape: RoundedRectangleBorder(
                  borderRadius: _baseBorderRadius,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                color: Colors.green,
                child: Text('응'),
                shape: RoundedRectangleBorder(
                  borderRadius: _baseBorderRadius,
                ),
                onPressed: event,
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
