import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mapazimslupsk/Pages/StopsList.dart';

class HomePage extends StatefulWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  final BannerAd myBanner = BannerAd(
    //prawdziwa:
    adUnitId: 'ca-app-pub-5463602893614505/2279336291',

    //testowa:
    //adUnitId: 'ca-app-pub-3940256099942544/6300978111',

    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );




  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  StreamSubscription<Position> positionStream;
  double szerokosc, dlugosc, r1, r2, odleglosc, dLng, dLat, tmp;
  var now = DateTime.now();
  String nazwa = 'brak';
  List<int> x = [0,0,0,0,0,0,0,0,0,0,0,0];
  int y;
  double i3;
  List lat = [0,0,0,0];
  List lng = [0,0,0,0];
  List id = [0,0,0,0];
  List<double> od = [0,0,0,0];

  void nearStops(sz, dl) {
    i3 = 1;

    FirebaseFirestore.instance.collection('Przystanki').get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {

        dLat = (sz - doc.get('loc').latitude).abs();
        dLng = (dl - doc.get('loc').longitude).abs();
        odleglosc = sqrt((dLat*dLat) + (dLng*dLng));

        for(int i = 0; i < 4; i++){
          if(odleglosc <= od[i] || od[i] == 0){
            setState(() {
              id[i] = 2;
            });
            tmp = od[i];
            od[i] = odleglosc;
            if(i != 3){
              od[i+1] = tmp;
            }
            for(int i2 = i + 2; i2 < 4; i2++){
              tmp = od[i2];
              od[i2] = od[i2 - 1];
              od[i2 - 1] = tmp;
            }
          }
        }

        i3++;

      })
    });
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
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);

    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );

    positionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best).listen((Position position) async {
      setState(() {
        szerokosc = position.latitude;
        dlugosc = position.longitude;
      });
      nearStops(szerokosc, dlugosc);
    });

    FirebaseFirestore.instance.collection('Przystanki').get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        if(szerokosc >= doc.get('loc').latitude - 0.00015 && szerokosc <= doc.get('loc').latitude + 0.00015 && dlugosc >= doc.get('loc').longitude - 0.00015 && dlugosc <= doc.get('loc').longitude + 0.00015){
          x[int.parse(doc.id.toString())] = 1;
        }else{
          x[int.parse(doc.id.toString())] = 0;
        }
        y = 0;
        for(int i = 1; i < x.length; i++){
          if(x[i] == 1){
            y = i;
          }
        }
        if(y != 0){
          FirebaseFirestore.instance.collection('Przystanki').doc(y.toString()).get().then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              setState(() {
                nazwa = documentSnapshot.get('name');
              });
            }
          });
        }else{
          setState(() {
            nazwa = 'brak';
          });
        }
      })
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Przystanki',
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Aktualny:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                nazwa,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              /*
              Text(
                'Najbliższe przystanki:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 275,
                width: 200,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: id.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      color: Colors.amber,
                      child: Center(child: Text(id[index].toString())),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                ),
              ),

               */
              SizedBox(height: 20),
              /*
              OutlinedButton(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/stopsList',
                    );
                  },
                  child: Text('Wybierz przystanek')
              ),
              */
              SizedBox(height: 20,),
              Expanded(child: Container()),
              Center(child: adContainer),
              Text('1.7.1'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream.cancel();
      positionStream = null;
    }
    super.dispose();
  }
}
