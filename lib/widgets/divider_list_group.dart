import 'package:flutter/material.dart';
import 'package:pongdang/models/divider_list_tile.dart';

class DividerListGroup extends StatelessWidget {
  final String title;
  final List<DividerListTile> child;

  DividerListGroup({
    this.title,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 16.0, bottom: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
          ),
        ),
        Column(
          children: child
              .map(
                (DividerListTile dividerListTile) => Container(
                  child: Ink(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Container(
                            width: 40.0,
                            alignment: Alignment.center,
                            child: Icon(dividerListTile.icon),
                          ),
                          title: dividerListTile.title == null
                              ? null
                              : Text(dividerListTile.title),
                          subtitle: dividerListTile.subtitle == null
                              ? null
                              : Text(dividerListTile.subtitle),
                          trailing: dividerListTile.trailing,
                          onTap: dividerListTile.onTap,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
