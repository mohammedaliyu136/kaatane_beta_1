import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/model/meal.dart';
import 'package:provider/provider.dart';

class Add_To_Cart_btn extends StatelessWidget {
  Add_To_Cart_btn(this.meal);
  final Meal meal;
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    return RaisedButton(
      textColor: Colors.white,
      color: Color.fromRGBO(128, 0, 128, 1),
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
