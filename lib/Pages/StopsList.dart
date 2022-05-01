import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ScreenArguments {
  final String name;
  final int id;

  ScreenArguments(this.name, this.id);
}


class StopsList extends StatefulWidget {
  const StopsList({Key key}) : super(key: key);

  @override
  _StopsListState createState() => _StopsListState();
}

class _StopsListState extends State<StopsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      Text('Przystanki:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 8, 51, 82))),
                      Expanded(child: Container(),),
                      TextButton(onPressed: (){Navigator.pop(context, 'Wybierz przystanek');}, child: Text('Anuluj', style: TextStyle(color: Color.fromARGB(255, 8, 51, 82))))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Przystanki').orderBy('name').snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return const Text('Loading...');
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemExtent: 80.0,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index){
                        String itemTitle = snapshot.data.docs[index].get('name').toString() ?? '';
                        int itemId = snapshot.data.docs[index].get('id');
                        return CardItem(itemTitle: itemTitle, itemId: itemId,);
                      }
                    );
                  }
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CardItem extends StatefulWidget {
  String itemTitle;
  int itemId;
  CardItem({ this.itemTitle, this.itemId });

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {

  var linia;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Card(
        color: Colors.white,
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
        child: InkWell(
          splashColor: Colors.black.withAlpha(30),
          onTap: () {
            Navigator.pop(context, ScreenArguments(widget.itemTitle, widget.itemId));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(widget.itemTitle, style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 8, 51, 82)),),
                subtitle: Text(widget.itemId.toString(), style: TextStyle(fontSize: 12, color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}