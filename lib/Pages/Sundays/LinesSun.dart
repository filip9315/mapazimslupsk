import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class LinesSunPage extends StatefulWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  _LinesSunPageState createState() => _LinesSunPageState();
}

class _LinesSunPageState extends State<LinesSunPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Niedziele i święta', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Niedziele i swieta').orderBy('l').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
                itemExtent: 136.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  String itemTitle = snapshot.data.documents[index].get('l').toString() ?? '';
                  int x = snapshot.data.documents[index].get('l');
                  String kr1 = snapshot.data.documents[index].get('kr1').toString() ?? '';
                  String kr2 = snapshot.data.documents[index].get('kr2').toString() ?? '';
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
        color: Color.fromARGB(96, 246, 198, 133),
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          children: [
            ListTile(
              title: Text(widget.itemTitle, style: TextStyle(fontSize: 38, color: Colors.black),),
            ),
            ButtonBar(
              children: [
                FlatButton(
                  onPressed: (){
                    linia = widget.x;
                    Navigator.pushNamed(context, '/stopsSun', arguments: {'linia': linia, 'kierunek': 1});
                  },
                  child: Text(widget.kr1, style: TextStyle(color: Colors.black54),),
                ),
                FlatButton(
                  onPressed: (){
                    linia = widget.x;
                    Navigator.pushNamed(context, '/stopsSun', arguments: {'linia': linia, 'kierunek': 2});
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