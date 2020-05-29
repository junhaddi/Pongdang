import 'package:flutter/material.dart';

class InkWellCard extends StatelessWidget {
  final BorderRadius baseBorderRadius;
  final EdgeInsets baseMarginValue;
  final VoidCallback onTap;
  final Widget child;

  InkWellCard({
    @required this.baseBorderRadius,
    @required this.baseMarginValue,
    @required this.onTap,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: baseMarginValue,
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
