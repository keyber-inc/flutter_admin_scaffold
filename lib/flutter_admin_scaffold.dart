import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/sidebar_item.dart';

class AdminScaffold extends StatefulWidget {
  AdminScaffold({
    Key key,
    this.appBar,
    this.sidebar,
    @required this.body,
    this.backgroundColor,
  }) : super(key: key);

  final AppBar appBar;
  final Sidebar sidebar;
  final Widget body;
  final Color backgroundColor;

  @override
  _AdminScaffoldState createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold>
    with SingleTickerProviderStateMixin {
  static const _mobileThreshold = 768.0;

  AnimationController _animationController;
  Animation _animation;
  bool _isMobile = false;
  bool _isOpenSidebar = false;
  bool _canDragged = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    setState(() {
      _isMobile = mediaQuery.size.width < _mobileThreshold;
      _isOpenSidebar = !_isMobile;
      _animationController.value = _isMobile ? 0 : 1;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isOpenSidebar = !_isOpenSidebar;
      if (_isOpenSidebar)
        _animationController.forward();
      else
        _animationController.reverse();
    });
  }

  void _onDragStart(DragStartDetails details) {
    final isClosed = _animationController.isDismissed;
    final isOpen = _animationController.isCompleted;
    _canDragged = (isClosed && details.globalPosition.dx < 60) || isOpen;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canDragged) {
      final delta = details.primaryDelta / widget.sidebar.width;
      _animationController.value += delta;
    }
  }

  void _dragCloseDrawer(DragUpdateDetails details) {
    final delta = details.primaryDelta;
    if (delta < 0) {
      _isOpenSidebar = false;
      _animationController.reverse();
    }
  }

  void _onDragEnd(DragEndDetails details) async {
    final minFlingVelocity = 365.0;

    if (details.velocity.pixelsPerSecond.dx.abs() >= minFlingVelocity) {
      final visualVelocity =
          details.velocity.pixelsPerSecond.dx / widget.sidebar.width;

      await _animationController.fling(velocity: visualVelocity);
      if (_animationController.isCompleted) {
        setState(() {
          _isOpenSidebar = true;
        });
      } else {
        setState(() {
          _isOpenSidebar = false;
        });
      }
    } else {
      if (_animationController.value < 0.5) {
        _animationController.reverse();
        setState(() {
          _isOpenSidebar = false;
        });
      } else {
        _animationController.forward();
        setState(() {
          _isOpenSidebar = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      child: widget.body,
    );
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: _buildAppBar(widget.appBar, widget.sidebar),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) => widget.sidebar == null
            ? Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: body,
                    ),
                  ),
                ],
              )
            : _isMobile
                ? Stack(
                    children: [
                      GestureDetector(
                        onHorizontalDragStart: _onDragStart,
                        onHorizontalDragUpdate: _onDragUpdate,
                        onHorizontalDragEnd: _onDragEnd,
                      ),
                      body,
                      if (_animation.value > 0)
                        Container(
                          color: Colors.black
                              .withAlpha((150 * _animation.value).toInt()),
                        ),
                      if (_animation.value == 1)
                        GestureDetector(
                          onTap: _toggleSidebar,
                          onHorizontalDragUpdate: _dragCloseDrawer,
                        ),
                      ClipRect(
                        child: SizedOverflowBox(
                          size: Size(widget.sidebar.width * _animation.value,
                              double.infinity),
                          child: widget.sidebar,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      widget.sidebar != null
                          ? ClipRect(
                              child: SizedOverflowBox(
                                size: Size(
                                    widget.sidebar.width * _animation.value,
                                    double.infinity),
                                child: widget.sidebar,
                              ),
                            )
                          : SizedBox(),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: body,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  AppBar _buildAppBar(AppBar appBar, Sidebar sidebar) {
    if (appBar == null) {
      return null;
    }

    final leading = sidebar != null
        ? IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _toggleSidebar,
          )
        : appBar.leading;
    final centerTitle = false;
    final shadowColor = Colors.transparent;

    return AppBar(
      leading: leading,
      automaticallyImplyLeading: appBar.automaticallyImplyLeading,
      title: appBar.title,
      actions: appBar.actions,
      flexibleSpace: appBar.flexibleSpace,
      bottom: appBar.bottom,
      elevation: appBar.elevation,
      shadowColor: shadowColor,
      shape: appBar.shape,
      backgroundColor: appBar.backgroundColor,
      brightness: appBar.brightness,
      iconTheme: appBar.iconTheme,
      actionsIconTheme: appBar.actionsIconTheme,
      textTheme: appBar.textTheme,
      primary: appBar.primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: appBar.excludeHeaderSemantics,
      titleSpacing: appBar.titleSpacing,
      toolbarOpacity: appBar.toolbarOpacity,
      bottomOpacity: appBar.bottomOpacity,
      toolbarHeight: appBar.toolbarHeight,
      leadingWidth: appBar.leadingWidth,
    );
  }
}

class Sidebar extends StatefulWidget {
  const Sidebar({
    Key key,
    @required this.itemDatas,
    @required this.selectedRoute,
    this.onSelected,
    this.width = 240.0,
    this.textStyle = const TextStyle(
      color: Color(0xFF337ab7),
      fontSize: 12,
    ),
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.activeBackgroundColor = const Color(0xFFE7E7E7),
    this.borderColor = const Color(0xFFE7E7E7),
  }) : super(key: key);

  final List<MenuItemData> itemDatas;
  final String selectedRoute;
  final void Function(MenuItemData itemData) onSelected;
  final double width;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color activeBackgroundColor;
  final Color borderColor;

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  double _sidebarWidth;

  @override
  void initState() {
    super.initState();
    _sidebarWidth = widget.width;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    _sidebarWidth = min(mediaQuery.size.width * 0.7, widget.width);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _sidebarWidth,
      child: Column(
        children: [
          Expanded(
            child: Material(
              color: widget.backgroundColor,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return SidebarItem(
                    itemDatas: widget.itemDatas,
                    index: index,
                    onSelected: widget.onSelected,
                    selectedRoute: widget.selectedRoute,
                    depth: 0,
                    textStyle: widget.textStyle,
                    backgroundColor: widget.backgroundColor,
                    activeBackgroundColor: widget.activeBackgroundColor,
                    borderColor: widget.borderColor,
                  );
                },
                itemCount: widget.itemDatas.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
