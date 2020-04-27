import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../bloc/cart_bloc.dart';

Future<CheckoutResponse> pay(context) async {
  var bloc = Provider.of<CartBloc>(context);
  var total = bloc.total;
  var _reference = _getReference();

  Charge charge = Charge()
    ..amount = total.toInt()*100 // In base currency
    ..email = 'customer@email.com'
    ..card = _getCardFromUI();

  charge.reference = _reference;

  CheckoutResponse response = await PaystackPlugin.checkout(
    context,
    method: CheckoutMethod.card, //_method,
    charge: charge,
    fullscreen: false,
    logo: MyLogo(),
  );
  print('Response = $response');
  //return response;
  if(response.message=="Success"){
    bloc.postOrder("card", context, _reference);
  }

  //response = {message: Success, card: PaymentCard{_cvc: 884, expiryMonth: 11, expiryYear: 21, _type: VERVE, _last4Digits: 7804 , _number: null}, account: null, reference: ChargedFromAndroid_1579028228949, status: true, method: CheckoutMethod.card, verify: true}
}
PaymentCard _getCardFromUI() {
  // Using just the must-required parameters.
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;
  return PaymentCard(
    number: _cardNumber,
    cvc: _cvv,
    expiryMonth: _expiryMonth,
    expiryYear: _expiryYear,
  );
}
String _getReference() {
  String platform;
  if (Platform.isIOS) {
    platform = 'iOS';
  } else {
    platform = 'Android';
  }

  return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
}

class MyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color.fromRGBO(128, 0, 128, 1),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      child: Text(
        "Kaatane",
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

 data(refNumber, context){
   var bloc = Provider.of<CartBloc>(context);
   var ref_number=refNumber;
   var name=bloc.fullName;
   var address="kkkkkkk";
   var phone=bloc.phone;
   var note=bloc.note;
   var restaurant = bloc.restaurant;
   var meals = bloc.cart;

   var listOfMealIDS = [];
   var listOfMealQty = [];


     for( var i = 0 ; i<meals.length; i++ ) {
       listOfMealIDS.add(meals.values.toList()[i].id);
       listOfMealQty.add(meals.values.toList()[i].quantity);
     }
   var str_listOfMealIDS = listOfMealIDS.join(",");
   var str_listOfMealQty = listOfMealQty.join(",");

       //listOfMeal.add({"name": meals.values.toList()[i].name,
        // "price": meals.values.toList()[i].price,
        // "discount": 0,
        // "restaurant": "1",
        // "status": "Ordered",
        // "quantity": meals.values.toList()[i].quantity,
        // "is_completed": false
       //});
     //}

  var str ={
            "meal": str_listOfMealIDS,
            "order_quantity":str_listOfMealQty,
            "ref_number": ref_number,
            "status": "Ordered",
            "personName": name,
            "personAddress": address,
            "personPhone": phone,
            "note": note,
            "restaurant": restaurant.toString(),
            "location":"YJ"
          };
   //{"personName":"Mohammed ","personPhone":"5555","personAddress":"fgg","meal":"2,45,46","order_quantity":"1,1,1",
   //"restaurant":"2","status":"Ordered","note":"","ref_number":"trx_f2ztamr0","location":"Yola"}
  return str;
}
