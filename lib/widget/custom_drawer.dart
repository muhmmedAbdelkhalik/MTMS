import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Center(child: Text('MTMS Task', style: TextStyle(color: Colors.white))),
          ),
          ListTile(title: const Text('Item 1'), onTap: () {}),
          ListTile(title: const Text('Item 2'), onTap: () {}),
          ListTile(title: const Text('Item 3'), onTap: () {}),
          ListTile(title: const Text('Item 4'), onTap: () {}),
        ],
      ),
    );
  }
}
