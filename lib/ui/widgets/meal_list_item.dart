import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'add_to_cart_btn.dart';
import 'contact.dart';

class Meal_list_item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(Icons.photo_album),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Egg sauce",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                height: 4.0,
              ),
              Text("Price: N300.0"),
              SizedBox(
                height: 4.0,
              ),
              //3Add_To_Cart_btn()
            ],
          ),
        ),
      ),
    );
  }
}
