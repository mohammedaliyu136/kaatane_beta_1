import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'cart_quantity_btn.dart';

class Cart_list_item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Text(
                      "Egg sauce",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Positioned(
                        right: 8, child: Icon(Icons.clear, color: Color.fromRGBO(128, 0, 128, 1),))
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Text("N300.0"),
          SizedBox(
            height: 8.0,
          ),
          //Quantity_Cart_btn(),
          SizedBox(
            height: 8.0,
          ),
          Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}
