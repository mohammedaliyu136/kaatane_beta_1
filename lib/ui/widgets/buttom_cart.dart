import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';
import '../../admin/SnackBars.dart';

import '../Delivery_info_page.dart';


class Buttom_Cart extends StatelessWidget {
  Buttom_Cart(this._scaffoldKey);
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    return RaisedButton(
      textColor: Colors.white,
      onPressed: () {
        if(bloc.cart.length>0 && !bloc.isLoggedIn){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Delivery_info()),
          );
        }else{
          cartISEmpty(_scaffoldKey);
        }
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
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "CHECHOUT",
            ),
          ),
        ),
      ),
    );
  }
}

