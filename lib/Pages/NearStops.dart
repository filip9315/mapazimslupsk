import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NearStopsPage extends StatefulWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  _NearStopsPageState createState() => _NearStopsPageState();
}

class _NearStopsPageState extends State<NearStopsPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  StreamSubscription<Position> positionStream;

  double szerokosc, dlugosc, r1, r2, odleglosc, dLng, dLat, tmp;
  var now = DateTime.now();
  String nazwa = 'brak', tmp2;
  List<int> x = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  int y;
  double i3, la, ln;
  List lat = [0, 0, 0, 0];
  List lng = [0, 0, 0, 0];
  List<String> id = ['', '', '', ''];
  List<double> od = [0, 0, 0, 0];
  bool disposed = false;

  void nearStops(sz, dl) {
    i3 = 1;

    FirebaseFirestore.instance
        .collection('Przystanki')
        .get()
        .then((QuerySnapshot querySnapshot) => {
          if(!disposed){
            querySnapshot.docs.forEach((doc) {
              dLat = (sz - doc.get('lat')).abs();
              dLng = (dl - doc.get('lng')).abs();
              odleglosc = sqrt((dLat * dLat) + (dLng * dLng));
              if (!id.contains(doc.get('name'))) {
                for (int i = 0; i < 4; i++) {
                  if (odleglosc < od[i] || od[i] == 0) {
                    //tmp2 = id[i];
                    tmp = od[i];
                    setState(() {
                      id[i] = doc.get('name');
                    });
                    od[i] = odleglosc;
                    if (i != 3) {
                      od[i + 1] = tmp;
                      //id[i + 1] = tmp2;
                    }
                    for (int i2 = i + 2; i2 < 4; i2++) {
                      tmp = od[i2];
                      tmp2 = id[i2];
                      od[i2] = od[i2 - 1];
                      od[i2 - 1] = tmp;
                      //id[i2] = id[i2 - 1];
                      //id[i2 - 1] = tmp2;
                    }
                    break;
                  }
                }
              }

              i3++;
            })
          }
          }
              );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    positionStream =
        Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best)
            .listen((Position position) async {
      //setState(() {
      szerokosc = position.latitude;
      dlugosc = position.longitude;
      //});
      nearStops(szerokosc, dlugosc);
    });

    FirebaseFirestore.instance
        .collection('Przystanki')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if (szerokosc >= doc.get('lat') - 0.00015 &&
                    szerokosc <= doc.get('lat') + 0.00015 &&
                    dlugosc >= doc.get('lng') - 0.00015 &&
                    dlugosc <= doc.get('lng') + 0.00015) {
                  x[int.parse(doc.id.toString())] = 1;
                } else {
                  x[int.parse(doc.id.toString())] = 0;
                }
                y = 0;
                for (int i = 1; i < x.length; i++) {
                  if (x[i] == 1) {
                    y = i;
                  }
                }
                if (y != 0) {
                  FirebaseFirestore.instance
                      .collection('Przystanki')
                      .doc(y.toString())
                      .get()
                      .then((DocumentSnapshot documentSnapshot) {
                    if (documentSnapshot.exists) {
                      setState(() {
                        nazwa = documentSnapshot.get('name');
                      });
                    }
                  });
                } else {
                  setState(() {
                    nazwa = 'brak';
                  });
                }
              })
            });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 18, 8, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Color.fromARGB(255, 8, 51, 82),
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Najbliższe przystanki:',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 51, 82)),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Container(
                height: 500,
                width: 340,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: id.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Container(
                        height: 80,
                        width: 340,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color.fromARGB(255, 233, 245, 249)),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(id[index],
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 8, 51, 82),
                                          fontSize: 20,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('Przystanki')
                                        .get()
                                        .then((QuerySnapshot querySnapshot) => {
                                              querySnapshot.docs.forEach((doc) {
                                                if (doc.get('name') == id[index]) {
                                                  la = doc.get('lat');
                                                  ln = doc.get('lng');
                                                  if (la != null &&
                                                      ln != null) {
                                                    Navigator.pushNamed(
                                                        context, '/map',
                                                        arguments: {
                                                          'latitude': la,
                                                          'longitude': ln
                                                        });
                                                  }
                                                }
                                              }),
                                            });
                                  },
                                  icon: Icon(
                                    Icons.map_rounded,
                                    color: Color.fromARGB(255, 8, 51, 82),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposed = true;
    if (positionStream != null) {
      positionStream.cancel();
      positionStream = null;
    }
    super.dispose();
  }
}
