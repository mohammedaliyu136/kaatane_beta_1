import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../model/restaurant.dart';

class Contact extends StatelessWidget {
  Contact(this.restaurant);
  final Restaurant restaurant;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(Icons.phone, size: 18.0),
        SizedBox(width: 3.0),
        Text(restaurant.phone_number,  style: TextStyle(
          color: Colors.black,
        )),
        SizedBox(width: 8.0),
        Text("No delivery")
      ],
    );
  }
}
