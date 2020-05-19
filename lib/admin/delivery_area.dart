import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeliveryArea extends StatefulWidget {
  @override
  _DeliveryAreaState createState() => _DeliveryAreaState();
}

class _DeliveryAreaState extends State<DeliveryArea> {

  final  areaController = TextEditingController();
  String cityController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delivery Area's"), centerTitle: true,),
      body: Column(children: <Widget>[
        Expanded(child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Add New Area", style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
          SizedBox(height: 1, child: Container(color: Colors.purple,),),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<String>(
                  items: [
                    DropdownMenuItem<String>(
                      child: Text('Yola'),
                      value: 'Yola',
                    ),
                    DropdownMenuItem<String>(
                      child: Text('Jimeta'),
                      value: 'Jimeta',
                    ),
                    DropdownMenuItem<String>(
                      child: Text('Girei'),
                      value: 'Girei',
                    ),
                  ],
                  onChanged: (String value) {
                    setState(() {
                      cityController = value;
                    });
                  },
                  value: cityController,
                  hint: Text('Choose City'),
                  //value: _value,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0),
            child: Row(children: <Widget>[
              Expanded(child: Container(
                child: TextField(
                  controller: areaController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    //border: InputBorder.none,
                      hintText: "Enter area",
                      hintStyle: TextStyle(color: Colors.grey[400])
                  ),
                ),
              )),
              SizedBox(width: 15,),
              RaisedButton(onPressed: (){
                Firestore.instance.collection('delivery_area').document()
                    .setData({
                  'city': cityController,
                  'area': areaController.text,
                  'active': true,
                  'restaurant_id': '1',
                });
                cityController="";
                areaController.text="";
              },child: Text("Add Area"),)
            ],),
          ),
          SizedBox(height: 40,),

          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Delivery Area's List", style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
          SizedBox(height: 1, child: Container(color: Colors.purple,),),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('delivery_area').orderBy('area').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return new Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
                        SizedBox(height: 20,),
                        Text("Loading, please wait...", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ],
                    ),
                  );
                  default:
                    return new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return new ListTile(title: Text(document['area']),
                          trailing: Checkbox(value: document['active'],
                              onChanged: (value){
                                var doc_id = document.documentID;
                                Firestore.instance.document('delivery_area/$doc_id')
                                    .updateData({
                                  'active': document['active']?false:true,
                                });
                              }),

                        );
                      }).toList(),
                    );
                }
              },
            ),
          )
        ],)),

      ],),
    );
  }
}
