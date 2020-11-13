import 'package:flutter/material.dart';

class MenuItemData {
  const MenuItemData({
    @required this.title,
    this.route,
    this.icon,
    this.children = const [],
  });

  final String title;
  final String route;
  final IconData icon;
  final List<MenuItemData> children;
}
