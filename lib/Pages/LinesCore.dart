import 'package:flutter/material.dart';
import 'package:mapazimslupsk/Pages/Saturdays/LinesSat.dart';
import 'package:mapazimslupsk/Pages/Sundays/LinesSun.dart';
import 'package:mapazimslupsk/Pages/Weekdays/Lines.dart';

class LinesCorePage extends StatefulWidget {
  @override
  _LinesCorePageState createState() => _LinesCorePageState();
}

class _LinesCorePageState extends State<LinesCorePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: TabBar(
              unselectedLabelColor: Color.fromARGB(255, 66, 66, 73),
                indicatorColor: Color.fromARGB(255, 66, 66, 73),
                labelColor: Color.fromARGB(255, 66, 66, 73),
                tabs: [
                  Tab(text: 'Dni powszednie',),
                  Tab(text: 'Soboty',),
                  Tab(text: 'Niedziele i święta',),
                ],
            ),
          body: TabBarView(
            children: [
              LinesPage(),
              LinesSatPage(),
              LinesSunPage(),
            ],
          ),
        ),
      ),
    );
  }
}
