import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class SamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sample'),
      ),
      sideBar: SideBar(
        items: const [
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
                  ),
                ],
              ),
            ],
          ),
        ],
        selectedRoute: '/',
        onSelected: (item) {
          if (item.route != null) {
            Navigator.of(context).pushNamed(item.route!);
          }
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: Color(0xff444444),
          child: Center(
            child: Text(
              'header',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: Color(0xff444444),
          child: Center(
            child: Text(
              'footer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Text(
            'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
        ),
      ),
    );
  }
}
