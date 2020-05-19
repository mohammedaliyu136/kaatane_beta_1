import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//import 'drawer.dart';
import 'order_ui_utils.dart';

class Orders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "New"),
              Tab(text: "Ongoing"),
              Tab(text: "Past"),
            ],
          ),
          title: Text('Our Orders'),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('order').orderBy('time_stamp').where('status', isEqualTo: 1).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return new Text('Loading...');
                  default:
                    return snapshot.data.documents.length!=0?
                    new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(child: new_order2(context, document, ""), elevation: 7,),
                        );
                      }).toList(),
                    ):new Text("There are no new Orders");

                }
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('order').orderBy('time_stamp').where('status', isEqualTo: 2).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(child: ongoing_order(context, document, ""), elevation: 7,),
                        );
                      }).toList(),
                    );
                }
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('order').orderBy('time_stamp').where('status', isEqualTo: 3).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(child: past_order(context, document), elevation: 7,),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          ],
        ),
        //drawer: drawer(context, "orders"),
      ),
    );
  }
}
