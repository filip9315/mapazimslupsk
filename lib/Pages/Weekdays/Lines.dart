import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class LinesPage extends StatefulWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  _LinesPageState createState() => _LinesPageState();
}

class _LinesPageState extends State<LinesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dni powszednie', style: TextStyle(color: Color.fromARGB(255, 8, 51, 82), fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Dni powszednie').orderBy('l').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemExtent: 60,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
                String itemTitle = snapshot.data.docs[index].get('l').toString() ?? '';
                int x = snapshot.data.docs[index].get('l');
                String kr1 = snapshot.data.docs[index].get('kr1').toString() ?? '';
                String kr2 = snapshot.data.docs[index].get('kr2').toString() ?? '';
                return CardItem(itemTitle: itemTitle, kr1: kr1, kr2: kr2, x: x,);
              }
            );
          }),
      );
  }
}

class CardItem extends StatefulWidget {
  String itemTitle;
  String kr1;
  String kr2;
  int x;
  CardItem({ this.itemTitle, this.kr1, this.kr2, this.x });

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {

  var linia;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 233, 245, 249),
        ),
        child: Row(
          children: [
            SizedBox(width: 15,),
            Text(widget.itemTitle, style: TextStyle(fontSize: 28, color: Color.fromARGB(255, 8, 51, 82)),),
            Expanded(child: Container()),
            Container(
              width: 120,
              height: 37,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.grey[350]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                ),
                onPressed: (){
                  linia = widget.x;
                  Navigator.pushNamed(context, '/stops', arguments: {'linia': linia, 'kierunek': 1});
                },
                child: Text(widget.kr1, style: TextStyle(color: Color.fromARGB(255, 8, 51, 82)),),
              ),
            ),
            SizedBox(width: 10,),
            Container(
              width: 120,
              height: 37,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.grey[350]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                ),
                onPressed: (){
                  linia = widget.x;
                  Navigator.pushNamed(context, '/stops', arguments: {'linia': linia, 'kierunek': 2});
                },
                child: Text(widget.kr2, style: TextStyle(color: Color.fromARGB(255, 8, 51, 82)),),
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      )
    );
  }
}