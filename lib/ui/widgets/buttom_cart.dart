import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../Delivery_info_page.dart';


class Buttom_Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: RaisedButton(
          color: Color.fromRGBO(128, 0, 128, 1),
          textColor: Colors.white,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(38.0),
              side: BorderSide(color: Color.fromRGBO(128, 0, 128, 1),)),
          onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Delivery_info()),
              );
            },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "CHECHOUT",
            ),
          ),
        ))
      ],
    );
  }
}
