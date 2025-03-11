import 'package:flutter/material.dart';

import 'package:sumapp/views/actuality_view.dart';
import 'package:sumapp/views/actuality_date_view.dart';
import 'package:sumapp/views/news_view.dart';

// drawer: NavDrawer(), dans le widget Scaffold

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFFDB90C)),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.sunny),
            title: Text('What’s news today?'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => newsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time_filled),
            title: Text('Actualité du jour'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Actualite()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Actualité par date'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ActualityDateView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
