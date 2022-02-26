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
  FirebaseAnalytics analytics = FirebaseAnalytics();
  int _currentIndex = 0;
  void _onItemTapped(int index) {
    FirebaseAnalytics().logEvent(name: 'Tab', parameters: {'number': index.toString()});
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
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus),
              label: ''
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: ''
            ),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color.fromARGB(255, 51, 95, 239),
        ),
      );
  }
}
