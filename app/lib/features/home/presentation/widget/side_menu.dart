import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF8131FF),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: const Color.fromARGB(0, 0, 0, 0)),
            child: Text(
              "Stridely",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            trailing: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
