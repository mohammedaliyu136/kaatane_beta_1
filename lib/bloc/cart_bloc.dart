import 'dart:async';
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
import 'package:kaatane/model/my_order_model.dart';
import 'package:kaatane/ui/meals_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/meal.dart';
import '../ui/Order_Submitted_page.dart';
import '../ui/loading_page.dart';
import '../utils/paystack.dart';
//import 'package:js/js.dart';

class CartBloc with ChangeNotifier {

  FirebaseUser _userFirebase;
  FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  OrderModel currentOrder;
  OrderHelper _orderHelper = OrderHelper();

  bool isLoading = false;
  bool isLoggedIn = false;
  bool isTerminated = false;
  bool showSnackBar = false;
  String message = "";
  get userFirebase => _userFirebase;

  String restaurant = '';
  DocumentSnapshot restaurantDocument;
  DocumentSnapshot couponDocument;
  bool coupon_error = false;
  bool coupon_loading = false;
  String delivery_fee = '0';
  bool del_or_pick=false;

  Map<String, Meal> _cart = {};

  int _total = 0;
  int _count_total = 0;
  int get count_total => _count_total;
  int get total => delivery_fee.trim()!=''?_total+int.parse(delivery_fee):_total;

  String _fullName="";
  String _email="";
  String _phone="";
  String _note="";
  String _address="";
  bool applied_coupon = false;
  double discount_amount = 0;
  String get fullName => _fullName;
  String get email => _email;
  String get phone => _phone;
  String get note => _note;
  String get address => _address;

  set fullName (String name)=> _fullName=name;
  set email (String email)=> _email=email;
  set phone (String phone)=> _phone=phone;
  set note (String note)=> _note=note;
  set address (String address)=> _address=address;

  Map<String, Meal> get cart => _cart;

  void addToCart(Meal meal) {
    _count_total+=1;
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
    _count_total=0;
    delivery_fee = '0';
    del_or_pick=false;
    applied_coupon=false;
    discount_amount=0;
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
    _count_total+=1;
    calculateTotal(index, "add");
    notifyListeners();
  }
  void subQuantity(index) {
    if (_cart[index].quantity>1) {
      _cart[index].subQuantity();
      _count_total-=1;
      calculateTotal(index, "sub");
      notifyListeners();
    }
  }

  void calculateTotal(index, op) {
      if(op=="add") {
        _total+=_cart[index].price;
      }else if(op=="clear"){
        _total-=(_cart[index].price*_cart[index].quantity);
        _count_total-=_cart[index].quantity;
      }else{
        _total-=_cart[index].price;
        _count_total-=_cart[index].quantity;
      }
      if(_total>0 && applied_coupon){
        setCoupon(couponDocument);
      }
  }
  postOrder(method, context, reference) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingPage(method)),
    );
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    if(method=="card"){

    }

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
    var meals = "";

    _cart.forEach((key, value) {
      _0cart.add({'food_title':value.name, 'price':value.price.toString(), 'qty':value.quantity.toString()});
      meals+="${value.name}#${value.quantity}*";
    });

    final collRef = Firestore.instance.collection("order_$restaurant");
    DocumentReference docReference = collRef.document();

    //Firestore.instance.collection("order_$restaurant").document()
    docReference.setData({
      'name': _fullName,
      'meals':_0cart,
      'status':1,
      'status_text':'',
      'time_stamp':Timestamp.now(),
      'total':total,
      'message':_note,
      'phone_number':_phone,
      'email':_email.trim!=""?_email:"",
      'address':_address,
      'order_id':reference,
      'delivery': del_or_pick,
      'delivered':false,
      'restaurant_id': restaurant,
      'restaurant_name': restaurantDocument['name'],
      'isPaid': method=="card"?true:false,
        }).then((value)async{
      _fcm.subscribeToTopic(reference);

      print(docReference.documentID);

      //--------------------------------
      if(couponDocument!=null){
        var doc_id = couponDocument.documentID;
        await Firestore.instance.document('coupon/$doc_id')
            .updateData({
          'quantity':couponDocument["quantity"]>1?couponDocument["quantity"]-1:0,
          'status': couponDocument["quantity"]>1?true:false
        });
      }

      //save order to local database
      currentOrder = OrderModel(
          restaurant_name:restaurantDocument['name'],
          restaurant_id:restaurantDocument.documentID,
          order_id:reference,
          order_time:Timestamp.now().toDate().toString(),
          order_total:total.toString(),
          order_meals:meals,
          order_rated:'no',
          document_id: docReference.documentID
      );
      _orderHelper.insertOrder(currentOrder);
      List<OrderModel> list = await _orderHelper.getAllOrder();

      isLoading=false;
      restaurant = '';
      delivery_fee = '0';

      _cart = {};

      _total = 0;
      applied_coupon=false;
      discount_amount=0;

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
          _userFirebase=currentUser.user;
          setUsernamePassword(email, password, _userFirebase.uid);
          isLoading=false;
          isLoggedIn=true;
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

  couponSearch(context, couponCodeController){
    coupon_loading = true;
    bool done = false;
    notifyListeners();
    Firestore.instance.collection('coupon').where('code', isEqualTo: (couponCodeController.text).toLowerCase()).getDocuments().then((value) async {
      for (var i = 0; i < value.documents.length; i++) {
        print(i);
        print(value.documents[i]['code']);
        if(value.documents[i]['quantity']>0 && value.documents[i]['owner']=="admin" && value.documents[i]['status']){
          //break;
          setCoupon(value.documents[i]);
          done=true;
          //Navigator.of(context).pop();
        }else if(value.documents[i]['quantity']>0 && value.documents[i]['owner']==restaurantDocument.documentID && value.documents[i]['status']){
          setCoupon(value.documents[i]);
          done=true;
          //Navigator.of(context).pop();
        }
      }
      coupon_loading = false;
      notifyListeners();

      if(!done){
        coupon_error = true;
        await Future.delayed(const Duration(milliseconds: 2000));
        coupon_error = false;
        notifyListeners();
      }
    });
  }

  setCoupon(_couponDocument){
    int percentage = _couponDocument["percentage"];
    //int quantity = _couponDocument["quantity"];
    int cap = _couponDocument["cap"];
    int ntotal;

    if(total*(percentage/100)>cap){
      ntotal = total-cap;
    }else{
      print("-------${_total}");
      /*
      var total_no_delivery_fee = total-int.parse(delivery_fee);
       */
      //ntotal = (total_no_delivery_fee-total_no_delivery_fee*(percentage/100)).ceil();
      ntotal = _total - (_total*(percentage/100)).ceil();
      print("-------${ntotal}");
      print("-------${(percentage/100)}");
    }
    couponDocument=_couponDocument;
    applied_coupon=true;
    //discount_amount=(ntotal.toDouble()+int.parse(delivery_fee));
    discount_amount=(ntotal.toDouble());
    print("-------${discount_amount}");
    print("-------${delivery_fee}");
    print("-------ooo${ntotal}");
    notifyListeners();
  }

  FocusNode _myNode;
  get myNode => _myNode;
  keyboardListenerCartPage(){
    _myNode = new FocusNode()..addListener(this._listener());
  }
  _listener(){
    if(_myNode.hasFocus){
      // keyboard appeared
      print("keyboard opened............");
    }else{
      // keyboard dismissed
      print("keyboard closed............");
    }
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
  setUsernamePassword(_email, _password, _restaurantUID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('username', _email);
    pref.setString('password', _password);
    pref.setBool('isLoggedin', true);
  }

  getMyOrders()async{
    List<OrderModel> list = await _orderHelper.getAllOrder();
    return list;
  }

  Future<List<OrderModel>> getMyOrdersNotRated()async{
    List<OrderModel> list = await _orderHelper.getAllOrderNotRated();
    print(list.length);
    return list;
  }

  getCategories(document, context){
    isLoading=true;
    not();
    Firestore.instance.collection('category').where('restaurant_id', isEqualTo: document.documentID).getDocuments().then(
            (val)async{
          List<DocumentSnapshot> ctegory_list = val.documents;
          List<Widget> tabBarList = [];
          ctegory_list.forEach((element) {
            tabBarList.add(Tab(text: element['title']));

          });

          restaurantDocument=document;
          clearAll();
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MealPage(document, ctegory_list, tabBarList)),
          );

          isLoading=false;
          not();
            }
    );
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
