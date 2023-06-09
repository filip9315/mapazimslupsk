import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mapazimslupsk/Pages/Home.dart';
import 'package:mapazimslupsk/Pages/Map.dart';
import 'package:mapazimslupsk/Pages/LinesCore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class CorePage extends StatefulWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  _CorePageState createState() => _CorePageState();
}

class _CorePageState extends State<CorePage> {

  int _currentIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomePage(),
    LinesCorePage(),
    MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        elevation: 0.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: ''),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color.fromARGB(255, 8, 51, 82),
      ),
    );
  }
}
