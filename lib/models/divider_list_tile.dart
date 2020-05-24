import 'package:flutter/material.dart';

class DividerListTile {
  final String title;
  final String subtitle;
  final Widget trailing;
  final IconData icon;
  final VoidCallback onTap;

  DividerListTile({
    this.title,
    this.subtitle,
    this.trailing,
    this.icon,
    this.onTap,
  });
}
