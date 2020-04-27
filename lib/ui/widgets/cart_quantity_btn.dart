import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../bloc/cart_bloc.dart';

class Quantity_Cart_btn extends StatelessWidget {
  Quantity_Cart_btn(this.meal);
  var meal;
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    return Container(
      decoration: new BoxDecoration(
          //color: Colors.green,
          border: Border.all(color: Color.fromRGBO(128, 0, 128, 1),),
          borderRadius: new BorderRadius.circular(28.0)),
      child: Padding(

        padding: const EdgeInsets.symmetric(vertical:5.0, horizontal: 18.0),
        child: Wrap(
          children: <Widget>[
          GestureDetector(child: Icon(Icons.remove), onTap: (){
            bloc.subQuantity(meal.id);
          },),
          SizedBox(width: 10.0),
          Text(meal.quantity.toString(), style: TextStyle(fontSize: 18.0)),
            SizedBox(width: 10.0),
          GestureDetector(onTap: (){bloc.addQuantity(meal.id);}, child: Icon(Icons.add))
        ],),
      ),
    );
  }
}
