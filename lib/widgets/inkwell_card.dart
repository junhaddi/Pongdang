import 'package:flutter/material.dart';

class InkWellCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  InkWellCard({
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
