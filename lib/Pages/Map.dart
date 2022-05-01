import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}


class _MapPageState extends State<MapPage> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  String nazwa;
  var przystanek;

  @override
  void initState(){
    przystanki();
    //_add();
    super.initState();
  }

  int x = 0;
  double lat, lng;
  GeoPoint punkt;

  przystanki() async {
    FirebaseFirestore.instance.collection('Przystanki').get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        x++;
        nazwa = doc.get('name');
        lat = doc.get("lat");
        lng = doc.get("lng");
        _add(nazwa, lat, lng);
      }),
    });
  }

  void _add(nazwa, lat, lng) {
    var markerIdVal = nazwa;
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: markerIdVal),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    przystanek = ModalRoute.of(context).settings.arguments;

    if (przystanek != null){
      przystanek = ModalRoute.of(context).settings.arguments;

      return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.black,),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(),
                      ),
                      Center(child: Text('Mapa przystanków', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                      Expanded(
                        flex: 7,
                        child: Container(),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: GoogleMap(
                    key: Key('AIzaSyCP13gUdd7HcIv81vTl_PTGHDwyrj2z4R4'),
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController controller){
                      _controller.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(target: LatLng(przystanek['latitude'], przystanek['longitude']),zoom: 17.0),
                    compassEnabled: true,
                    myLocationEnabled: true,
                    markers: Set<Marker>.of(markers.values),
                  ),
                ),
              ],
            ),
          )
      );
    } else {
      return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Center(child: Text('Mapa przystanków', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                ),
                Expanded(
                  child: GoogleMap(
                    key: Key('AIzaSyCP13gUdd7HcIv81vTl_PTGHDwyrj2z4R4'),
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController controller){
                      _controller.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(target: LatLng(54.464735557044776, 17.028093090979514),zoom: 14.0),
                    compassEnabled: true,
                    myLocationEnabled: true,
                    markers: Set<Marker>.of(markers.values),
                  ),
                ),
              ],
            ),
          )
      );
    }


  }
}
