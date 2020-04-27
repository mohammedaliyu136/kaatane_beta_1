import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:async';

import 'restaurant_page.dart';
import 'desktop_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isOpen = true;
  int _counter = 300;
  @override
  void initState() {
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
    await Future.delayed(Duration(seconds: 4));
  }

  void navigateToHomeScreen() {
    isOpen = !isOpen;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => RestaurantPage()));
  }
  void navigateToErrorScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => DesktopPage()));
  }
}
