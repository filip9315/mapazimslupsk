import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapazimslupsk/Pages/StopsList.dart';

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
  String nazwa = 'brak', tmp2, haslo = '', przystanek1 = 'Wybierz przystanek', przystanek2 = 'Wybierz przystanek';
  List<int> x = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  var D = List.empty(growable: true);
  int y, id1, id2;

  void getText() {
    FirebaseFirestore.instance
        .collection('home')
        .doc('codzienne haslo')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          haslo = documentSnapshot.get('x');
        });
      }
    });
  }

  void calculateLines(){
    var A = List.empty(growable: true);
    var B = List.empty(growable: true);
    var C = List.empty(growable: true);
    setState(() {
      D.clear();
    });

    String nazwa1 = '', nazwa2 = '';
    bool zrobione = false, juz = false;
    int indeks1 = 0, indeks2 = 0, kierunek1 = 0, kierunek2 = 0;

    if(przystanek1 != 'Wybierz przystanek' && przystanek2 != 'Wybierz przystanek'){
      FirebaseFirestore.instance.collection('Przystanki').get().then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) async {
          
          if(doc.get('id') == id1){
            setState(() {
              A = doc.get('linie');
            });
          }
          if(doc.get('id') == id2){
            setState(() {
              B = doc.get('linie');
            });
          }
          if(A.length != 0 && B.length != 0 && !zrobione){
            print(A.length);
            print(B.length);
            for(int i=0; i<A.length; i++){
              for(int j=0; j<B.length; j++){
                if(A[i] == B[j]){
                  C.add(A[i]);
                }
              }
            }

            for(int i=0; i<C.length;i++){
              for(int j=1;j<=2;j++){
                FirebaseFirestore.instance.collection('Dni powszednie/' + C[i].toString() + '/' + j.toString() +'/k1/p').get().then((QuerySnapshot querySnapshot) => {
                  querySnapshot.docs.forEach((doc) async {

                    if(doc.get('id') == id1.toString()){
                      indeks1 = doc.get('l');
                      nazwa1 = doc.get('n');
                      kierunek1 = j;
                    }

                    if(doc.get('id') == id2.toString()){
                      indeks2 = doc.get('l');
                      nazwa2 = doc.get('n');
                      kierunek2 = j;
                    }
                    if(indeks1 < indeks2 && indeks1 != 0 && indeks2 != 0 && kierunek1 == kierunek2 && kierunek1 != 0 && kierunek2 != 0 && !D.contains(int.parse(C[i]))){
                      print(id1.toString());
                      print(id2.toString());
                      print(C[i].toString());
                      print(nazwa1 + ': ' + indeks1.toString() + ', ' + kierunek1.toString());
                      print(nazwa2 + ': ' + indeks2.toString() + ', ' + kierunek2.toString());
                      print(' ');
                      setState(() {
                        D.add(int.parse(C[i]));

                        int tmp = 0;
                        for(int i=0;i<D.length;i++){
                          for(int j=0;j<D.length-1;j++){
                            if(D[j] > D[j+1]){
                              tmp = D[j+1];
                              D[j+1] = D[j];
                              D[j] = tmp;
                            }
                          }
                        }

                      });

                    }
                  })
                });
                indeks1 = 0;
                indeks2 = 0;
                kierunek1 = 0;
                kierunek2 = 0;
              }
              await Future.delayed(Duration(milliseconds: 500));
            }

            zrobione = true;
          }
        }),
      });

    }
  }

  @override
  void initState() {
    getText();
    calculateLines();
    super.initState();
  }

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
                haslo,
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
              Center(
                child: Container(
                  height: 250,
                  width: 340,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Zaplanuj trasę',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 8, 51, 82)
                          )
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text('Z', style: TextStyle(color: Color.fromARGB(255, 8, 51, 82), fontSize: 16)),
                            Center(child: TextButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const StopsList()),
                                  );
                                  setState(() {
                                    przystanek1 = result.name;
                                    id1 = result.id;
                                    calculateLines();
                                  });
                                },
                                child: Text('$przystanek1', style: TextStyle(color: Color.fromARGB(255, 8, 51, 82))))
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('DO', style: TextStyle(color: Color.fromARGB(255, 8, 51, 82), fontSize: 16)),
                            Center(child: TextButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const StopsList()),
                                  );
                                  setState(() {
                                    przystanek2 = result.name;
                                    id2 = result.id;
                                    calculateLines();
                                  });
                                }, child: Text('$przystanek2', style: TextStyle(color: Color.fromARGB(255, 8, 51, 82))))
                            ),
                          ],
                        ),
                        LineSign(D),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(child: Container()),
              Text('1.7.5'),
            ],
          ),
        ),
      ),
    );
  }
}

class LineSign extends StatefulWidget {
  List D;

  LineSign( this.D );

  @override
  State<LineSign> createState() => _LineSignState();
}

class _LineSignState extends State<LineSign> {
  @override
  Widget build(BuildContext context) {

    if(widget.D.length > 0){
      return Expanded(
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            itemCount: widget.D.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 8, 51, 82),
                    ),
                    child: Center(
                      child: Text(widget.D[index].toString(), style: TextStyle(color: Colors.white, fontSize: 20),),
                    ),
                  ),
                  SizedBox(width: 10,)
                ],
              );
            }
        ),
      );
    }else{
      return Center(child: Text('Brak linii', style: TextStyle(color: Color.fromARGB(255, 8, 51, 82), fontSize: 16)));
    }




  }
}

