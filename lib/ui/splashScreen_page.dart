import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../PushNotificationsManager.dart';
import 'onboarding.dart';
import 'restaurant_page.dart';
import 'desktop_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isOpen = true;
  int _counter = 300;
  var cred = [];
  @override
  void initState() {
    new FirebaseNotifications().setUpFirebase();
    var cred = getUsernamePassword();
    print(cred);
    /**
    var paystackPublicKey = 'pk_test_277c53a98499bf6879daea5e6442e3ffdf45c573';
    String encoded = base64.encode(utf8.encode(paystackPublicKey)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    print(encoded);
    String decoded = utf8.decode(base64.decode(encoded));
    print(paystackPublicKey);
    print(decoded);
    Firestore.instance.collection('server').where('key_id', isEqualTo: '1').getDocuments().then((value){
      print(value.documents[0]['key']);
      print(utf8.decode(base64.decode(value.documents[0]['key'])));
    });
    */
    super.initState();
    initData().then((_) {
      if (kIsWeb) {
        var mediaQuery = MediaQuery.of(context);
        var orientation = mediaQuery.orientation;

        double deviceWidth = 0;

        if (orientation == Orientation.landscape) {
          deviceWidth = mediaQuery.size.height;
        } else {
          deviceWidth = mediaQuery.size.width;
        }

        if(deviceWidth > 600){
          navigateToErrorScreen();
        }else{
          navigateToHomeScreen();
        }


      }else{
        navigateToHomeScreen();
      }
    });
    //Timer.periodic(Duration(seconds: 1), (Timer timer) {
      //setState(() {
        //_counter--;
        //if (_counter == 0) {
        //  timer.cancel();
        //}
      ///});
    //});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/kaatane_splash_bg.png"),
                fit: BoxFit.cover)),
        child: Center(
          child: FlareActor("assets/flare/logo_loading.flr", alignment:Alignment.center, fit:BoxFit.contain, animation: "Untitled",),
        ),
      ),
    );
  }

  Future initData() async {
    await Future.delayed(Duration(seconds: 3));
  }

  void navigateToHomeScreen()async{
    isOpen = !isOpen;
    bool visitedFlag = await getVisitingFlag();
    var userNamePassword = await getUsernamePassword();
    print(userNamePassword);
    setVisitingFlag();
    if(!visitedFlag){
      //prefs.setBool('showOnBoarding', false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => OnBoardingPage()));
    }else{
      if(cred[2]){
        Provider.of<CartBloc>(context).signInWithEmailAndPassword(context, cred[0], cred[1]);
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => RestaurantPage()));
      }
    }
    //Navigator.pushReplacement(
      //  context, MaterialPageRoute(builder: (_) => RestaurantPage()));
  }
  void navigateToErrorScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => DesktopPage()));
  }

  setVisitingFlag()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('visited', true);
  }

  getVisitingFlag()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool alreadyVisited = pref.getBool('visited') ?? false;
    return alreadyVisited;
  }
  getUsernamePassword()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String _emailController = pref.getString('username') ?? '';
    String _passwordController = pref.getString('password') ?? '';
    bool _isLoggedin = pref.getBool('isLoggedin') ?? false;
    cred.add(_emailController);
    cred.add(_passwordController);
    cred.add(_isLoggedin);
    print("--------------------");
    print("--------------------");
    print("--------------------");
    return [_emailController, _passwordController, _isLoggedin];
  }
}
