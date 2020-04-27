import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/meal.dart';
import '../ui/Order_Submitted_page.dart';
import '../ui/loading_page.dart';
import '../utils/paystack.dart';
//import 'package:js/js.dart';

class CartBloc with ChangeNotifier {

  int restaurant = 0;

  Map<int, Meal> _cart = {};

  double _total = 0.0;
  double get total => _total;

  String _fullName="";
  String _email="";
  String _phone="";
  String _note="";
  String get fullName => _fullName;
  String get email => _email;
  String get phone => _phone;
  String get note => _note;

  set fullName (String name)=> _fullName=name;
  set email (String email)=> _email=email;
  set phone (String phone)=> _phone=phone;
  set note (String note)=> _note=note;

  Map<int, Meal> get cart => _cart;

  void addToCart(Meal meal) {
    if (_cart.containsKey(meal.id)) {
      //_cart[index] += 1;
      _cart[meal.id].addQuantity();
    } else {
      _cart[meal.id] = meal;
    }
    calculateTotal(meal.id, "add");
    notifyListeners();
  }

  void clearAll() {
    _cart={};
    _total=0;
    notifyListeners();
  }

  void clear(index) {
    if (_cart.containsKey(index)) {
      calculateTotal(index, "clear");
      _cart.remove(index);
      notifyListeners();
    }
  }
  void addQuantity(index) {
    _cart[index].addQuantity();
    calculateTotal(index, "add");
    notifyListeners();
  }
  void subQuantity(index) {
    if (_cart[index].quantity>1) {
      _cart[index].subQuantity();
      calculateTotal(index, "sub");
      notifyListeners();
    }
  }

  void calculateTotal(index, op) {
      if(op=="add") {
        _total+=_cart[index].price;
      }else if(op=="clear"){
        _total-=(_cart[index].price*_cart[index].quantity);
      }else{
        _total-=_cart[index].price;
      }
  }
  postOrder(method, context, reference) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingPage(method)),
    );
    var url = "https://kaatane.herokuapp.com/api/place/order/";

    http.Response postResponse = await http.post( url , body: json.encode(data(reference, context)));
    delay().then((_) {
      if(postResponse.statusCode==200){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Order_Submitted()
            ),
            ModalRoute.withName("")
        );
      }else{

      }
    });

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

  delay() async {
    await Future.delayed(Duration(seconds: 4));
  }
}

class CartBloc2 with ChangeNotifier {
  Map<int, int> _cart = {};

  Map<int, int> get cart => _cart;

  void addToCart(index) {
    if (_cart.containsKey(index)) {
      _cart[index] += 1;
    } else {
      _cart[index] = 1;
    }
    notifyListeners();
  }

  void clear(index) {
    if (_cart.containsKey(index)) {
      _cart.remove(index);
      notifyListeners();
    }
  }
}
