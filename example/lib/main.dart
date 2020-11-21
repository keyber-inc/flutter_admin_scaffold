import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_admin_scaffold_example/sample_pages/dashboard_page.dart';
import 'package:flutter_admin_scaffold_example/sample_pages/second_level_item_1_page.dart';
import 'package:flutter_admin_scaffold_example/sample_pages/second_level_item_2_page.dart';
import 'package:flutter_admin_scaffold_example/sample_pages/third_level_item_1_page.dart';
import 'package:flutter_admin_scaffold_example/sample_pages/third_level_item_2_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MaterialColor themeBlack = MaterialColor(
    _themeBlackPrimaryValue,
    <int, Color>{
      50: Color(_themeBlackPrimaryValue),
      100: Color(_themeBlackPrimaryValue),
      200: Color(_themeBlackPrimaryValue),
      300: Color(_themeBlackPrimaryValue),
      400: Color(_themeBlackPrimaryValue),
      500: Color(_themeBlackPrimaryValue),
      600: Color(_themeBlackPrimaryValue),
      700: Color(_themeBlackPrimaryValue),
      800: Color(_themeBlackPrimaryValue),
      900: Color(_themeBlackPrimaryValue),
    },
  );
  static const int _themeBlackPrimaryValue = 0xFF222222;
  static const Color themeTextPrimary = Color(0xFF9D9D9D);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sample',
      theme: ThemeData(
        primarySwatch: themeBlack,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: themeBlack,
            ),
        primaryTextTheme: Theme.of(context).textTheme.apply(
              bodyColor: themeTextPrimary,
            ),
        primaryIconTheme: IconThemeData(
          color: themeTextPrimary,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) {
        final page = _getPageWidget(settings);
        if (page != null) {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => page,
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(
                  opacity: anim,
                  child: child,
                );
              });
        }
        return null;
      },
    );
  }

  Widget _getPageWidget(RouteSettings settings) {
    final uri = Uri.parse(settings.name);
    switch (uri.path) {
      case '/':
        return DashboardPage();
      case '/secondLevelItem1':
        return SecondLevelItem1Page();
      case '/secondLevelItem2':
        return SecondLevelItem2Page();
      case '/thirdLevelItem1':
        return ThirdLevelItem1Page();
      case '/thirdLevelItem2':
        return ThirdLevelItem2Page();
    }
    return null;
  }
}

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    Key key,
    @required this.route,
    @required this.body,
  }) : super(key: key);

  final Widget body;
  final String route;

  final List<MenuItem> _sideBarItems = const [
    MenuItem(
      title: 'Dashboard',
      route: '/',
      icon: Icons.dashboard,
    ),
    MenuItem(
      title: 'Top Level',
      icon: Icons.file_copy,
      children: [
        MenuItem(
          title: 'Second Level Item 1',
          route: '/secondLevelItem1',
        ),
        MenuItem(
          title: 'Second Level Item 2',
          route: '/secondLevelItem2',
        ),
        MenuItem(
          title: 'Third Level',
          children: [
            MenuItem(
              title: 'Third Level Item 1',
              route: '/thirdLevelItem1',
            ),
            MenuItem(
              title: 'Third Level Item 2',
              route: '/thirdLevelItem2',
              icon: Icons.image,
            ),
          ],
        ),
      ],
    ),
  ];

  final List<MenuItem> _adminMenuItems = const [
    MenuItem(
      title: 'User Profile',
      icon: Icons.account_circle,
      route: '/',
    ),
    MenuItem(
      title: 'Settings',
      icon: Icons.settings,
      route: '/',
    ),
    MenuItem(
      title: 'Logout',
      icon: Icons.logout,
      route: '/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sample'),
        actions: [
          PopupMenuButton(
            child: const Icon(Icons.account_circle),
            itemBuilder: (context) {
              return _adminMenuItems.map((MenuItem item) {
                return PopupMenuItem<MenuItem>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(item.icon),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
            onSelected: (item) {
              print(
                  'actions: onSelected(): title = ${item.title}, route = ${item.route}');
              Navigator.of(context).pushNamed(item.route);
            },
          ),
        ],
      ),
      sideBar: SideBar(
        backgroundColor: Color(0xFFEEEEEE),
        activeBackgroundColor: Colors.black26,
        borderColor: Color(0xFFE7E7E7),
        iconColor: Colors.black87,
        activeIconColor: Colors.blue,
        textStyle: TextStyle(
          color: Color(0xFF337ab7),
          fontSize: 13,
        ),
        activeTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
        items: _sideBarItems,
        selectedRoute: route,
        onSelected: (item) {
          print(
              'sidebar: onTap(): title = ${item.title}, route = ${item.route}');
          if (item.route != null && item.route != route) {
            Navigator.of(context).pushNamed(item.route);
          }
        },
      ),
      body: body,
    );
  }
}
