import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../model/restaurant.dart';

class Contact extends StatelessWidget {
  Contact(this.restaurantDocument);
  final DocumentSnapshot restaurantDocument;
  @override
  Widget build(BuildContext context) {
    Restaurant restaurant = Restaurant(id: restaurantDocument.documentID, name: restaurantDocument['name'], img_url: restaurantDocument['img_url'], phone_number: restaurantDocument['phone_number'], location: restaurantDocument['location']);
    return Row(
      children: <Widget>[
        Icon(Icons.phone, size: 20.0),
        SizedBox(width: 3.0),
        Text(restaurant.phone_number,  style: TextStyle(
          color: Colors.black,
        )),
        //SizedBox(width: 8.0),
        Spacer(),
        restaurantDocument['delivery']?Text("Delivery available"):Text("No delivery")
      ],
    );
  }
}
