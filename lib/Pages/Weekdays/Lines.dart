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
        title: Text('Dni powszednie', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
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
              itemExtent: 136.0,
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
      child: Card(
        color: Colors.white,
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
        child: Column(
          children: [
            ListTile(
              title: Text(widget.itemTitle, style: TextStyle(fontSize: 38, color: Colors.black),),
            ),
            ButtonBar(
              children: [
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),),
                  splashColor: Color.fromARGB(100, 180, 180, 180),
                  onPressed: (){
                    linia = widget.x;
                    Navigator.pushNamed(context, '/stops', arguments: {'linia': linia, 'kierunek': 1});
                  },
                  child: Text(widget.kr1, style: TextStyle(color: Colors.black54),),
                ),
                FlatButton(
                  onPressed: (){
                    linia = widget.x;
                    Navigator.pushNamed(context, '/stops', arguments: {'linia': linia, 'kierunek': 2});
                  },
                  child: Text(widget.kr2, style: TextStyle(color: Colors.black54)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}