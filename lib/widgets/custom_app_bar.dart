import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leading;

  CustomAppBar({
    this.title,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0.0,
      title: Text(title),
      bottom: PreferredSize(
        child: Container(
          color: Color.fromRGBO(105, 105, 105, 1.0),
          height: 0.3,
        ),
        preferredSize: null,
      ),
      leading: leading,
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}
