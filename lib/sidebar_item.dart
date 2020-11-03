import 'package:flutter/material.dart';

import 'flutter_admin_scaffold.dart';

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    @required this.itemDatas,
    @required this.index,
    this.onSelected,
    this.selectedRoute,
    this.depth = 0,
    @required this.textStyle,
    @required this.backgroundColor,
    @required this.activeBackgroundColor,
    @required this.borderColor,
  });

  final List<MenuItemData> itemDatas;
  final int index;
  final void Function(MenuItemData itemData) onSelected;
  final String selectedRoute;
  final int depth;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color activeBackgroundColor;
  final Color borderColor;
  bool get isLast => index == itemDatas.length - 1;

  @override
  Widget build(BuildContext context) {
    if (depth > 0 && isLast) {
      return _buildTiles(context, itemDatas[index]);
    }
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderColor,
          ),
        ),
      ),
      child: _buildTiles(context, itemDatas[index]),
    );
  }

  Widget _buildTiles(BuildContext context, MenuItemData itemData) {
    if (itemData.children.isEmpty) {
      return ListTile(
        contentPadding: _getTilePadding(depth),
        leading: _buildIcon(itemData.icon),
        title: _buildTitle(itemData.title),
        selected: _isSelected(selectedRoute, [itemData]),
        tileColor: backgroundColor,
        selectedTileColor: activeBackgroundColor,
        onTap: () {
          if (onSelected != null) {
            onSelected(itemData);
          }
        },
      );
    }

    int index = 0;
    final childrenTiles = itemData.children.map((item) {
      return SidebarItem(
        itemDatas: itemData.children,
        index: index++,
        onSelected: onSelected,
        selectedRoute: selectedRoute,
        depth: depth + 1,
        textStyle: textStyle,
        backgroundColor: backgroundColor,
        activeBackgroundColor: activeBackgroundColor,
        borderColor: borderColor,
      );
    }).toList();

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: _getTilePadding(depth),
        leading: _buildIcon(itemData.icon),
        title: _buildTitle(itemData.title),
        initiallyExpanded: _isSelected(selectedRoute, [itemData]),
        children: childrenTiles,
      ),
    );
  }

  bool _isSelected(String route, List<MenuItemData> itemDatas) {
    for (final itemData in itemDatas) {
      if (itemData.route == route) {
        return true;
      }
      if (itemData.children.isNotEmpty) {
        return _isSelected(route, itemData.children);
      }
    }
    return false;
  }

  Widget _buildIcon(IconData icon) {
    return icon != null
        ? Icon(
            icon,
            size: 22,
          )
        : SizedBox();
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: textStyle,
    );
  }

  EdgeInsets _getTilePadding(int depth) {
    return EdgeInsets.only(
      left: 10.0 + 10.0 * depth,
      right: 10.0,
    );
  }
}
