import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'restaurant_page.dart';
import 'desktop_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _counter = 3;
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
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _counter--;
        if (_counter == 0) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/kaatane_splash_bg.png"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(70.0),
                child: Image.asset("assets/images/kaatane_white.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future initData() async {
    await Future.delayed(Duration(seconds: 4));
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => RestaurantPage()));
  }
  void navigateToErrorScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => DesktopPage()));
  }
}
