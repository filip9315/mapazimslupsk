import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  StreamSubscription<Position> positionStream;

  double szerokosc, dlugosc, r1, r2, odleglosc, dLng, dLat, tmp;
  var now = DateTime.now();
  String nazwa = 'brak', tmp2;
  List<int> x = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  int y;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Witaj',
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 8, 51, 82)),
              ),
              SizedBox(height: 5),
              Text(
                'Codziennie nowy tekst',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 30),
              Center(
                child: Container(
                  height: 120,
                  width: 340,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(255, 233, 245, 249)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Szukasz drogi?',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 8, 51, 82))),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Sprawdź najblizsze\nprzystanki',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 8, 51, 82)))
                          ],
                        ),
                        Expanded(child: Container()),
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: TextButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/nearStops');
                              },
                              icon: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 40,
                                  color: Color.fromARGB(255, 8, 51, 82),
                                ),
                              ),
                              label: Text('')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              SizedBox(
                height: 20,
              ),
              Expanded(child: Container()),
              Text('1.7.2'),
            ],
          ),
        ),
      ),
    );
  }
}
