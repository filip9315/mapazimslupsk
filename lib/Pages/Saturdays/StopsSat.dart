import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class StopsSatPage extends StatefulWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  _StopsSatPageState createState() => _StopsSatPageState();
}

class _StopsSatPageState extends State<StopsSatPage> {
  var linia;
  var kierunek;
  int godzina = 10;
  int minuta = 25;
  int poczatkowy;
  int koncowy;
  int kurs;
  int czasOdzyskany;
  bool ograniczony;
  int numerek;

  @override
  Widget build(BuildContext context) {

    linia = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Linia nr ' + linia['linia'].toString()),
        backgroundColor: Colors.orangeAccent,
        elevation: 0.0,
        actions: [
          FlatButton(
              child: Text('Godziny'),
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context) {
                  return Container(
                      child: Scaffold(
                        body: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection(
                                'Soboty/' + linia['linia'].toString() + '/' + linia['kierunek'].toString() + '/p1/godziny').snapshots(),
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
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      int h = snapshot.data.documents[index].get('h');
                                      int m = snapshot.data.documents[index].get('m');
                                      String sub1;
                                      if(h < 10 && m > 9){
                                        sub1 = '0' + h.toString() + ':' + m.toString();
                                      }
                                      if (h > 9 && m < 10){
                                        sub1 = h.toString() + ':0' + m.toString();
                                      }
                                      if (h < 10 && m < 10){
                                        sub1 = '0' + h.toString() + ':0' + m.toString();
                                      }
                                      if (h > 9 && m > 9){
                                        sub1 = h.toString() + ':' + m.toString();
                                      }
                                      int czas;

                                      return Container(
                                          height: 100.0,
                                          width: 200.0,
                                          child: FlatButton(
                                              child: Text(sub1),
                                              color: Colors.orangeAccent,
                                              onPressed: () {
                                                setState(() {
                                                  numerek = index + 1;
                                                  godzina = h;
                                                  minuta = m;
                                                  czasOdzyskany = czas;
                                                });
                                              }
                                          )
                                      );
                                    }

                                ),
                              );
                            }),
                      )
                  );
                });
              })
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(
              'Soboty/' + linia['linia'].toString() + '/' + linia['kierunek'].toString() + '/k' + numerek.toString() + '/p'
          ).orderBy('l').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
                itemExtent: 136.0 + 24 + 16,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  String itemTitle = snapshot.data.documents[index].get('n').toString() ?? '';
                  bool czyOgraniczony = snapshot.data.documents[index].get('o');
                  int minu;
                  int godz;
                  int minuty;
                  String sub;
                  if (czyOgraniczony == true){
                    sub = 'Nie obsługiwany o tej godzinie';
                  }else{
                    godz = snapshot.data.documents[index].get('h');
                    minuty = snapshot.data.documents[index].get('m');

                    if(godz < 10 && minuty > 9){
                      sub = '0' + godz.toString() + ':' + minuty.toString();
                    }
                    if (godz > 9 && minuty < 10){
                      sub = godz.toString() + ':0' + minuty.toString();
                    }
                    if (godz < 10 && minuty < 10){
                      sub = '0' + godz.toString() + ':0' + minuty.toString();
                    }
                    if (godz > 9 && minuty > 9){
                      sub = godz.toString() + ':' + minuty.toString();
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                    child: Column(
                      children: [
                        Card(
                            elevation: 0.0,
                            child: Column(
                                children: [
                                  ListTile(
                                    title: Text(itemTitle, style: TextStyle(fontSize: 23, color: Colors.black45),),
                                    subtitle: Text(sub),
                                  ),
                                  ButtonBar(
                                    children: [
                                      FlatButton(
                                        onPressed: (){
                                        },
                                        child: Text('Pokaż na mapie'),
                                      )
                                    ],
                                  ),
                                ]
                            )
                        ),
                        Icon(Icons.arrow_downward,
                          color: Colors.black54,),
                      ],
                    ),
                  );
                });
          }
      ),
    );
  }
}