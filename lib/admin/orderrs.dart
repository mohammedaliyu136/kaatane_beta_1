import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Orderrs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order"),),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('order').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return new Text('Loading...');
                    default:
                      return new ListView(
                        children: snapshot.data.documents.map((DocumentSnapshot document) {
                          return Column(
                            children: <Widget>[
                              new ListTile(title: Text(document['name']), trailing: Icon(Icons.border_outer),),
                              new ListTile(title: Text(document['order_id']), trailing: Text(document['total'])),
                              new ListTile(title: Text(document['time_stamp'].toString())),
                              new ListTile(title: Text(document['message'])),
                              new ListTile(title: Text(document['meals'][0]['food_title']+" Qty: "+document['meals'][0]['qty'],), trailing: Text(document['meals'][0]['price']),),
                              new ListTile(title: Text(document['meals'][1]['food_title']+" Qty: "+document['meals'][1]['qty'],), trailing: Text(document['meals'][1]['price']),),
                            ],
                          );
                        }).toList(),
                      );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
