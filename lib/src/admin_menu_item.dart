import 'package:flutter/material.dart';

class AdminMenuItem {
  const AdminMenuItem({
    required this.title,
    this.route,
    this.icon,
    this.children = const [],
  });

  final String title;
  final String? route;
  final IconData? icon;
  final List<AdminMenuItem> children;
}
