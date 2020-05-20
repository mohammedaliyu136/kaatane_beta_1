import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaatane/admin/login2/edit_profile.dart';
import 'package:kaatane/admin/login2/login_page3.dart';
import 'package:kaatane/admin/orders.dart';
import 'package:kaatane/admin/SnackBars.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/meal.dart';
import '../ui/Order_Submitted_page.dart';
import '../ui/loading_page.dart';
import '../utils/paystack.dart';
//import 'package:js/js.dart';

class CartBloc with ChangeNotifier {

  FirebaseUser _userFirebase;
  FirebaseMessaging _fcm = FirebaseMessaging();
  bool isLoading = false;
  bool isTerminated = false;
  bool showSnackBar = false;
  String message = "";
  get userFirebase => _userFirebase;

  String restaurant = '';
  DocumentSnapshot restaurantDocument;
  String delivery_fee = '0';

  Map<String, Meal> _cart = {};

  int _total = 0;
  int get total => _total+int.parse(delivery_fee);

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

  Map<String, Meal> get cart => _cart;

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

    /**
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
    }); **/

    var _0cart = [];

    _cart.forEach((key, value) {
      _0cart.add({'food_title':value.name, 'price':value.price.toString(), 'qty':value.quantity.toString()});
    });


    Firestore.instance.collection("order_$restaurant").document()
        .setData({
      'name': _fullName,
      'meals':_0cart,
      'status':1,
      'status_text':'',
      'time_stamp':Timestamp.now(),
      'total':total,
      'message':_note,
      'order_id':reference,
      'delivery':false,
      'delivered':false,
      'restaurant_id': restaurant,
      'restaurant_name': restaurantDocument['name'],
        }).then((value){
      _fcm.subscribeToTopic(reference);
      isLoading=false;
      notifyListeners();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Order_Submitted()
          ),
          ModalRoute.withName("")
      );
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

  void setUserFirebase(user) => _userFirebase==user;

  Future<void> signInWithEmailAndPassword(context, email, password) async {
    isLoading=true;
    if(isEmailValid(email, password)){
      try{
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email,
            password: password)
            .then((currentUser){
          print("000000000000000000000000000000");
          print("000000000000000000000000000000");
          print("000000000000000000000000000000");
          print(currentUser.user.displayName);
          //setUsernamePassword(email, password);
          _userFirebase=currentUser.user;
          isLoading=false;
          Firestore.instance.collection('Restaurant').where('user_id', isEqualTo: _userFirebase.uid).getDocuments().then((value){
            restaurant=value.documents[0].documentID;
            restaurantDocument = value.documents[0];
            _fcm.subscribeToTopic(restaurantDocument.documentID);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Orders()),//EditProfile
            );
          });


        })
            .catchError((err) {
          print(err.message);
          isTerminated=true;
          isLoading=false;
          message=err.message;
          notifyListeners();
        });
      }catch(e){
        print("000000000000000000000000000000");
        print("000000000000000000000000000000");
        print("000000000000000000000000000000");
        print(e.message);
        isTerminated=true;
        isLoading=false;
      }
      isTerminated=true;
    }else{
      isLoading=false;
      isTerminated=true;
      message="Email/Password entered is invalid";
      notifyListeners();
    }
    isLoading=false;

  }

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://kaatane-5c28c.appspot.com');
  Future<String> uploadImage(var imageFile ) async {
    String filePath = 'images/${DateTime.now()}.png';

    StorageUploadTask _uploadTask = _storage.ref().child(filePath).putFile(imageFile);

    notifyListeners();

    _uploadTask.events.forEach(
            (event){
          var progressPercent = event != null
              ? event.snapshot.bytesTransferred / event.snapshot.totalByteCount
              : 0;
          progressPercent=(progressPercent*100).round();
          message = "Uploading "+progressPercent.toString()+"% done.";
          notifyListeners();
        }
    );

    var dowurl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    var url = dowurl.toString();
    notifyListeners();

    return url;
  }

  isEmailValid(email, password){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

    if(emailValid && password!=null && password.trim!=''){
      return true;
    }else{
      return false;
    }
  }

  getUsernamePassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _emaila = prefs.getString('email');
    String _passworda = prefs.getString('password');
    if(_emaila!=null && _passworda!=null){
      return [_emaila, _passworda];
    }else{
      return null;
    }
  }
  setUsernamePassword(_email, _password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _email);
    await prefs.setString('passord', _password);
  }

  not(){
    notifyListeners();
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
