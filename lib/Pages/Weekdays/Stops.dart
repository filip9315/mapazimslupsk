

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../ad_state.dart';

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
  int numerek = 1;
  int i = 0;
  String nrkurs = '';
  double lat;
  double lng;

  BannerAd banner;
  bool _loaded = false;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status){
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
        _loaded = true;
      });
    });
  }

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
                      color: Color.fromARGB(255, 8, 51, 82),
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
                                stream: FirebaseFirestore.instance.collection('Dni powszednie/' + linia['linia'].toString() + '/' + linia['kierunek'].toString() + '/p1/godziny').orderBy('l').snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return const Text('Loading...');
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                        crossAxisSpacing: 5.0,
                                        mainAxisSpacing: 5.0,
                                        maxCrossAxisExtent: 80,
                                        childAspectRatio: 2,
                                      ),
                                      itemCount: snapshot.data.docs.length, itemBuilder: (context, index) {
                                        int h = snapshot.data.docs[index].get('h');
                                        int m = snapshot.data.docs[index].get('m');
                                        String sub1;
                                        if (h < 10 && m > 9) {
                                          sub1 = '0' + h.toString() + ':' + m.toString();
                                        }
                                        if (h > 9 && m < 10) {
                                          sub1 = h.toString() + ':0' + m.toString();
                                        }
                                        if (h < 10 && m < 10) {
                                          sub1 = '0' + h.toString() + ':0' + m.toString();
                                        }
                                        if (h > 9 && m > 9) {
                                          sub1 = h.toString() + ':' + m.toString();
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
                                                  color: Color.fromARGB(255, 8, 51, 82)),
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
                stream: FirebaseFirestore.instance.collection('Dni powszednie/' + linia['linia'].toString() + '/' + linia['kierunek'].toString() + '/k' + numerek.toString() + '/p').orderBy('l').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      String itemTitle = snapshot.data.docs[index].get('n').toString() ?? '';
                      String id = snapshot.data.docs[index].get('id').toString() ?? '0';
                      bool czyOgraniczony = snapshot.data.docs[index].get('o');
                      int minu;
                      int godz;
                      int minuty;
                      String sub = '';
                      if (czyOgraniczony == false) {
                        godz = snapshot.data.docs[index].get('h');
                        minuty = snapshot.data.docs[index].get('m');

                        if (godz < 10 && minuty > 9) {
                          sub = '0' + godz.toString() + ':' + minuty.toString();
                        }
                        if (godz > 9 && minuty < 10) {
                          sub = godz.toString() + ':0' + minuty.toString();
                        }
                        if (godz < 10 && minuty < 10) {
                          sub = '0' + godz.toString() + ':0' + minuty.toString();
                        }
                        if (godz > 9 && minuty > 9) {
                          sub = godz.toString() + ':' + minuty.toString();
                        }
                      }

                      if(czyOgraniczony){
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                          child: Container(
                            height: 70,
                            width: 340,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(itemTitle + ' (' + id + ')', style: TextStyle(fontSize: 15, color: Colors.black45)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }else{
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(
                              16.0, 8.0, 16.0, 0.0),
                          child: Container(
                            height: 80,
                            width: 340,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(itemTitle, style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 8, 51, 82), fontWeight: FontWeight.w500)),
                                          SizedBox(height: 3,),
                                          Row(
                                            children: [
                                              Text(sub, style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 8, 51, 82))),
                                              SizedBox(width: 12,),
                                              Text('(' + id + ')', style: TextStyle(fontSize: 15, color: Colors.black45)),
                                            ],
                                          ),
                                        ]
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance.collection('Przystanki').get().then((QuerySnapshot querySnapshot) => {querySnapshot.docs.forEach((doc) {
                                          if (doc.get('id').toString() == itemTitle) {
                                            lat = doc.get('loc').latitude;
                                            lng = doc.get('loc').longitude;
                                            if (lat != null && lng != null) {
                                              Navigator.pushNamed(context, '/map', arguments: {'latitude': lat, 'longitude': lng});
                                            }
                                          }
                                        }),
                                        });
                                      },
                                      splashRadius: 20,
                                      icon: Icon(Icons.map_rounded),
                                    )
                                  ]
                              ),
                            ),
                          ),
                        );
                      }


                    });
                }),
            ),
            if (banner != null && _loaded)
              SizedBox (height:50, child: AdWidget(ad: banner))
            else
              const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
