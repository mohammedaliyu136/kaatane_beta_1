import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../bloc/cart_bloc.dart';
import '../../model/meal.dart';

class Add_To_Cart_btn2 extends StatelessWidget {
  Add_To_Cart_btn2(this.mealDocument);
  //final Meal meal;
  final DocumentSnapshot mealDocument;

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    Meal meal = Meal(id: mealDocument.documentID, name: mealDocument['title'], img_url: mealDocument['img_url'], price: mealDocument['price']);
    return RaisedButton(
      textColor: Colors.white,
      //color: Color.fromRGBO(128, 0, 128, 1),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Color.fromRGBO(128, 0, 128, 1))
      ),
      onPressed: () {
        bloc.addToCart(meal);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: <Widget>[
            Text("Add to Cart"),
            SizedBox(width: 4.0,),
            Icon(
              Icons.add_shopping_cart,
              size: 18.0,
            )
          ],
        ),
      ),
    );
  }
}

class Add_To_Cart_btn extends StatelessWidget {
  Add_To_Cart_btn(this.mealDocument, this.bloc);
  final DocumentSnapshot mealDocument;
  var bloc;
  @override
  Widget build(BuildContext context) {
    var blocc = Provider.of<CartBloc>(context);
    //Meal meal = Meal(id: mealDocument.documentID, name: mealDocument['title'], img_url: mealDocument['img_url'], price: mealDocument['price']);

    return RaisedButton(
      textColor: Colors.white,
      onPressed: () {
        blocc.addToCart(Meal(id: mealDocument.documentID, name: mealDocument['title'], img_url: mealDocument['img_url'], price: int.parse(mealDocument['normal_price'])));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: const EdgeInsets.all(0.0),
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.black, Color.fromRGBO(128, 0, 128, 1)]),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          //constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 18),
            child: Wrap(
              children: <Widget>[
                Text("Add to Cart"),
                SizedBox(width: 4.0,),
                Icon(
                  Icons.add_shopping_cart,
                  size: 18.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
