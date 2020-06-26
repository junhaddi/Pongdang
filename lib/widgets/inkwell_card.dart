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
      padding: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(50.0),
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
