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
import 'package:kaatane/ui/store_redirect_page.dart';
import 'package:kaatane/utils/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/meal.dart';
import '../ui/Order_Submitted_page.dart';
import '../ui/loading_page.dart';
import '../utils/paystack.dart';
//import 'package:js/js.dart';

class CartBloc with ChangeNotifier {

  AppVersion appVersion;

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


    Firestore.instance.collection("order_$restaurant").document()
        .setData({
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

      //save order to local database
      currentOrder = OrderModel(
          restaurant_name:restaurantDocument['name'],
          restaurant_id:restaurantDocument.documentID,
          order_id:reference,
          order_time:Timestamp.now().toDate().toString(),
          order_total:total.toString(),
          order_meals:meals,
          order_rated:'no'
      );
      _orderHelper.insertOrder(currentOrder);
      List<OrderModel> list = await _orderHelper.getAllOrder();

      isLoading=false;
      restaurant = '';
      delivery_fee = '0';

      _cart = {};

      _total = 0;

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

  getVersionFromFirebase()async{
    Firestore.instance.collection('server').where('app_version', isEqualTo: "app_version").getDocuments().then((value){
      //"app_version"
      //min_version
      //update_now
      appVersion = AppVersion(appVersion:value.documents[0]['app_version'], minVersion:value.documents[0]['min_version'], updateNOW:value.documents[0]['update_now']);
      notifyListeners();
    });
  }

  getVersion(context)async{
    int current_major_release = int.parse(current_version.split(".")[0]);
    double current_minor_release = double.parse("${current_version.split(".")[1]}.${current_version.split(".")[2]}");

    String firebase_version = appVersion.minVersion;
    bool firebase_update_now = appVersion.updateNOW;
    int firebase_major_release = int.parse(firebase_version.split(".")[0]);
    double firebase_minor_release = double.parse("${firebase_version.split(".")[1]}.${firebase_version.split(".")[2]}");

    if(current_major_release<firebase_major_release){
      await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => StoreRedirectPage()
          ),
          ModalRoute.withName("")
      );
    }else if(current_minor_release<firebase_minor_release && firebase_update_now){
      await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => StoreRedirectPage()
          ),
          ModalRoute.withName("")
      );
    }
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
class AppVersion{
  String appVersion;
  String minVersion;
  bool updateNOW;
  AppVersion({this.appVersion, this.minVersion, this.updateNOW});
}
