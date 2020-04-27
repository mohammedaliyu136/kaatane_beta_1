import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/cart_bloc.dart';
import '../model/meal.dart';
import 'widgets/buttom_cart.dart';
import 'widgets/cart_quantity_btn.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    var cart = bloc.cart;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    //Meal meal = cart.keys.toList()[index];
                    Meal meal = cart[index];
                    print(cart.values.toList()[index].name);
                    //int count = cart[giftIndex];
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
                                      cart.values.toList()[index].name,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Positioned(
                                        right: 8,
                                        child: GestureDetector(
                                          child: Icon(
                                            Icons.clear,
                                            color: Color.fromRGBO(128, 0, 128, 1),
                                          ),
                                          onTap: () {
                                            print("kkkkkkk");
                                            bloc.clear(cart.keys.toList()[index]);
                                          },
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text("N${cart.values.toList()[index].price}"),
                          SizedBox(
                            height: 8.0,
                          ),
                          Quantity_Cart_btn(cart.values.toList()[index]),
                          SizedBox(
                            height: 8.0,
                          ),
                          Divider(
                            thickness: 1,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(color: Colors.white, child: Column(children: <Widget>[
              SizedBox(height: 8.0,),
              ListTile(leading: Text("Your Orders", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),)),
              ListTile(leading: Text("Bill Total"), trailing: Text("₦${bloc.total}"),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(height: 1, child: Container(color: Colors.grey[350],),),
              ),
              ListTile(leading: Text("No Delivery")),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(height: 1, child: Container(color: Colors.grey[350],),),
              ),
              ListTile(leading: Text("Grand Total"), trailing: Text("₦${bloc.total}"),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Buttom_Cart(),
              ),
              SizedBox(height: 8.0,),
            ],),)
          ],
        ),
      ),
      /**
      bottomNavigationBar: new Container(
        height: 170.0,
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 34.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Your Orders",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0)),
                ],
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Bill Total:",
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "N${bloc.total}",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Buttom_Cart(),
            ],
          ),
        ),
      ),**/
    );
  }
}
