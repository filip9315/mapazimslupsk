import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class StopsPage extends StatefulWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  _StopsPageState createState() => _StopsPageState();
}

class _StopsPageState extends State<StopsPage> {
  var linia;
  var kierunek;
  int godzina;
  int minuta;
  int poczatkowy;
  int koncowy;
  int kurs;
  int czasOdzyskany;
  bool ograniczony;
  int numerek;
  int i = 0;
  String nrkurs = '';
  double lat;
  double lng;

  @override
  Widget build(BuildContext context) {
    linia = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    label: Text(''),
                  ),
                  Container(
                    child: Text('Linia nr ' +
                        linia['linia'].toString() +
                        ', kurs: ' +
                        nrkurs +
                        ''),
                  ),
                  Container(
                    child: FlatButton(
                      color: Color.fromARGB(255, 51, 95, 239),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      onPressed: () {
                        showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                  child: Scaffold(
                                body: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Dni powszednie/' +
                                            linia['linia'].toString() +
                                            '/' +
                                            linia['kierunek'].toString() +
                                            '/p1/godziny')
                                        .orderBy('l')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData)
                                        return const Text('Loading...');
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GridView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithMaxCrossAxisExtent(
                                              crossAxisSpacing: 5.0,
                                              mainAxisSpacing: 5.0,
                                              maxCrossAxisExtent: 80,
                                              childAspectRatio: 2,
                                            ),
                                            itemCount:
                                                snapshot.data.docs.length,
                                            itemBuilder: (context, index) {
                                              int h = snapshot.data.docs[index]
                                                  .get('h');
                                              int m = snapshot.data.docs[index]
                                                  .get('m');
                                              String sub1;
                                              if (h < 10 && m > 9) {
                                                sub1 = '0' +
                                                    h.toString() +
                                                    ':' +
                                                    m.toString();
                                              }
                                              if (h > 9 && m < 10) {
                                                sub1 = h.toString() +
                                                    ':0' +
                                                    m.toString();
                                              }
                                              if (h < 10 && m < 10) {
                                                sub1 = '0' +
                                                    h.toString() +
                                                    ':0' +
                                                    m.toString();
                                              }
                                              if (h > 9 && m > 9) {
                                                sub1 = h.toString() +
                                                    ':' +
                                                    m.toString();
                                              }
                                              int czas;
                                              return Container(
                                                  height: 100.0,
                                                  width: 200.0,
                                                  child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                      ),
                                                      child: Text(
                                                        sub1,
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          numerek = index + 1;
                                                          godzina = h;
                                                          minuta = m;
                                                          czasOdzyskany = czas;
                                                          nrkurs = sub1;
                                                        });
                                                      }));
                                            }),
                                      );
                                    }),
                              ));
                            });
                      },
                      child: Text('Godziny',
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Dni powszednie/' +
                          linia['linia'].toString() +
                          '/' +
                          linia['kierunek'].toString() +
                          '/k' +
                          numerek.toString() +
                          '/p')
                      .orderBy('l')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('Loading...');
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          String itemTitle =
                              snapshot.data.docs[index].get('n').toString() ??
                                  '';
                          bool czyOgraniczony =
                              snapshot.data.docs[index].get('o');
                          int minu;
                          int godz;
                          int minuty;
                          String sub;
                          if (czyOgraniczony == true) {
                            sub = 'Nie obsługiwany o tej godzinie';
                          } else {
                            godz = snapshot.data.docs[index].get('h');
                            minuty = snapshot.data.docs[index].get('m');

                            if (godz < 10 && minuty > 9) {
                              sub = '0' +
                                  godz.toString() +
                                  ':' +
                                  minuty.toString();
                            }
                            if (godz > 9 && minuty < 10) {
                              sub = godz.toString() + ':0' + minuty.toString();
                            }
                            if (godz < 10 && minuty < 10) {
                              sub = '0' +
                                  godz.toString() +
                                  ':0' +
                                  minuty.toString();
                            }
                            if (godz > 9 && minuty > 9) {
                              sub = godz.toString() + ':' + minuty.toString();
                            }
                          }
                          if (index == 10) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 8.0, 16.0, 0.0),
                              child: Column(
                                children: [
                                  Card(
                                      elevation: 0.0,
                                      child: Column(children: [
                                        ListTile(
                                          title: Text(
                                            itemTitle,
                                            style: TextStyle(
                                                fontSize: 23,
                                                color: Colors.black45),
                                          ),
                                          subtitle: Text(sub),
                                        ),
                                        ButtonBar(
                                          children: [
                                            FlatButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('Przystanki')
                                                    .get()
                                                    .then((QuerySnapshot
                                                            querySnapshot) =>
                                                        {
                                                          querySnapshot.docs
                                                              .forEach((doc) {
                                                            if (doc.get('o') ==
                                                                false) {
                                                              if (doc.get(
                                                                      'name') ==
                                                                  itemTitle +
                                                                      ' ' +
                                                                      linia['kierunek']
                                                                          .toString()) {
                                                                lat = doc
                                                                    .get('loc')
                                                                    .latitude;
                                                                lng = doc
                                                                    .get('loc')
                                                                    .longitude;
                                                                if (lat !=
                                                                        null &&
                                                                    lng !=
                                                                        null) {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      '/map',
                                                                      arguments: {
                                                                        'latitude':
                                                                            lat,
                                                                        'longitude':
                                                                            lng
                                                                      });
                                                                }
                                                              }
                                                            } else {
                                                              if (linia['kierunek'] ==
                                                                      2 &&
                                                                  linia['linia'] ==
                                                                      3) {
                                                                if (doc.get(
                                                                        'name') ==
                                                                    itemTitle +
                                                                        ' 3') {
                                                                  lat = doc
                                                                      .get(
                                                                          'loc')
                                                                      .latitude;
                                                                  lng = doc
                                                                      .get(
                                                                          'loc')
                                                                      .longitude;
                                                                  if (lat !=
                                                                          null &&
                                                                      lng !=
                                                                          null) {
                                                                    Navigator.pushNamed(
                                                                        context,
                                                                        '/map',
                                                                        arguments: {
                                                                          'latitude':
                                                                              lat,
                                                                          'longitude':
                                                                              lng
                                                                        });
                                                                  }
                                                                }
                                                              }
                                                              if (doc.get(
                                                                      'name') ==
                                                                  itemTitle) {
                                                                lat = doc
                                                                    .get('loc')
                                                                    .latitude;
                                                                lng = doc
                                                                    .get('loc')
                                                                    .longitude;
                                                                if (lat !=
                                                                        null &&
                                                                    lng !=
                                                                        null) {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      '/map',
                                                                      arguments: {
                                                                        'latitude':
                                                                            lat,
                                                                        'longitude':
                                                                            lng
                                                                      });
                                                                }
                                                              }
                                                            }
                                                          }),
                                                        });
                                              },
                                              child: Text('Pokaż na mapie'),
                                            )
                                          ],
                                        ),
                                      ])),
                                  Icon(
                                    Icons.arrow_downward,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 8.0, 16.0, 0.0),
                              child: Column(
                                children: [
                                  Card(
                                      elevation: 0.0,
                                      child: Column(children: [
                                        ListTile(
                                          title: Text(
                                            itemTitle,
                                            style: TextStyle(
                                                fontSize: 23,
                                                color: Colors.black45),
                                          ),
                                          subtitle: Text(sub),
                                        ),
                                        ButtonBar(
                                          children: [
                                            FlatButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('Przystanki')
                                                    .get()
                                                    .then((QuerySnapshot
                                                            querySnapshot) =>
                                                        {
                                                          querySnapshot.docs
                                                              .forEach((doc) {
                                                            if (doc.get('o') ==
                                                                false) {
                                                              if (doc.get(
                                                                      'name') ==
                                                                  itemTitle +
                                                                      ' ' +
                                                                      linia['kierunek']
                                                                          .toString()) {
                                                                lat = doc
                                                                    .get('loc')
                                                                    .latitude;
                                                                lng = doc
                                                                    .get('loc')
                                                                    .longitude;
                                                                if (lat !=
                                                                        null &&
                                                                    lng !=
                                                                        null) {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      '/map',
                                                                      arguments: {
                                                                        'latitude':
                                                                            lat,
                                                                        'longitude':
                                                                            lng
                                                                      });
                                                                }
                                                              }
                                                            } else {
                                                              if (linia['kierunek'] ==
                                                                      2 &&
                                                                  linia['linia'] ==
                                                                      3) {
                                                                if (doc.get(
                                                                        'name') ==
                                                                    itemTitle +
                                                                        ' 3') {
                                                                  lat = doc
                                                                      .get(
                                                                          'loc')
                                                                      .latitude;
                                                                  lng = doc
                                                                      .get(
                                                                          'loc')
                                                                      .longitude;
                                                                  if (lat !=
                                                                          null &&
                                                                      lng !=
                                                                          null) {
                                                                    Navigator.pushNamed(
                                                                        context,
                                                                        '/map',
                                                                        arguments: {
                                                                          'latitude':
                                                                              lat,
                                                                          'longitude':
                                                                              lng
                                                                        });
                                                                  }
                                                                }
                                                              }
                                                              if (doc.get(
                                                                      'name') ==
                                                                  itemTitle) {
                                                                lat = doc
                                                                    .get('loc')
                                                                    .latitude;
                                                                lng = doc
                                                                    .get('loc')
                                                                    .longitude;
                                                                if (lat !=
                                                                        null &&
                                                                    lng !=
                                                                        null) {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      '/map',
                                                                      arguments: {
                                                                        'latitude':
                                                                            lat,
                                                                        'longitude':
                                                                            lng
                                                                      });
                                                                }
                                                              }
                                                            }
                                                          }),
                                                        });
                                              },
                                              child: Text('Pokaż na mapie'),
                                            )
                                          ],
                                        ),
                                      ])),
                                  Icon(
                                    Icons.arrow_downward,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            );
                          }
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
