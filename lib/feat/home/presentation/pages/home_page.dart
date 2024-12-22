import 'package:flutter/material.dart';
import 'package:task/feat/map/presentation/pages/map_page/map_page.dart';
import 'package:task/feat/table/presentation/pages/table_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Map Page'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, MapPage.routeName);
              },
            ),
            ListTile(
              title: const Text('Table Page'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, TablePage.routeName);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text('Go to Map Page'),
              onPressed: () => Navigator.pushNamed(context, MapPage.routeName),
            ),
            TextButton(
              child: const Text('Go to Table Page'),
              onPressed: () => Navigator.pushNamed(context, TablePage.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
