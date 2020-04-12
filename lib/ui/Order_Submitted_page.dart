import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/model/meal.dart';
import 'package:provider/provider.dart';

import 'restaurant_page.dart';

class Order_Submitted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    bloc.clearAll();
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child:
                  Text("Order Placed!", style: TextStyle(fontSize: 28.0)),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              color: Color.fromRGBO(128, 0, 128, 1),
              textColor: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(28.0),
                  side: BorderSide(color: Color.fromRGBO(128, 0, 128, 1) )),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => RestaurantPage()), (route)=>false
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "BACK TO HOME",
                ),
              ),
            ),
          ),
        ));
  }
}
