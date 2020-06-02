import 'package:flutter/material.dart';

class InkWellCard extends StatelessWidget {
  final BorderRadius baseBorderRadius = BorderRadius.circular(8.0);
  final VoidCallback onTap;
  final Widget child;

  InkWellCard({
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: baseBorderRadius),
        child: InkWell(
          borderRadius: baseBorderRadius,
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
