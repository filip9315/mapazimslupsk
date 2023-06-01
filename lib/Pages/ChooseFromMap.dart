import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api_key.dart';

class ScreenArguments {
  final String name;
  final int id;

  ScreenArguments(this.name, this.id);
}

class ChooseFromMap extends StatefulWidget {

  @override
  State<ChooseFromMap> createState() => _ChooseFromMapState();
}

class _ChooseFromMapState extends State<ChooseFromMap> {


  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  String nazwa;
  var przystanek;

  @override
  void initState(){
    przystanki();
    super.initState();
  }

  int x = 0, id = 0;
  double lat, lng;
  GeoPoint punkt;

  przystanki() async {
    FirebaseFirestore.instance.collection('Przystanki').get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        x++;
        nazwa = doc.get('name');
        id = doc.get('id');
        lat = doc.get("lat");
        lng = doc.get("lng");
        _add(nazwa, lat, lng, id);
      }),
    });
  }

  void _add(nazwa, lat, lng, id) {
    var markerIdVal = id.toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    int ID = id;

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: nazwa),
      onTap: (){
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          context: context,
          builder: (context) => Container(
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25),
                    topRight: const Radius.circular(25)
                )
              ),
              child: Center(
                child: Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Text(nazwa, style: TextStyle(color: Color.fromARGB(255, 8, 51, 82), fontSize: 24, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
                      Expanded(child: SizedBox()),
                      Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 8, 51, 82),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(100, 8, 51, 82),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: (){
                            Navigator.of(context)
                              ..pop()
                              ..pop(ScreenArguments(nazwa, ID));
                          },
                          child: Text('Wybierz', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      SizedBox(height: 10,)
                    ],
                  ),
                ),
              ),
            ),
          )
        );
      }
    );
    
    setState(() {
      markers[markerId] = marker;
    });
  }


  @override
  Widget build(BuildContext context) {
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
                  key: Key(map_key),
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller){
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(target: LatLng(54.464735557044776, 17.028093090979514),zoom: 14.0),
                  compassEnabled: true,
                  myLocationEnabled: true,
                  rotateGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  markers: Set<Marker>.of(markers.values),
                ),
              ),
            ],
          ),
        )
    );
  }
}
