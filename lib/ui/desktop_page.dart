import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class DesktopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: GestureDetector(
        onTap: _launchURL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This Desktop version is still under development, use your phone or download the mobile app or"),
            Text("Go to the other version"),
          ],
        ),
      ),),
    );
  }
  _launchURL() async {
    const url = 'https://kaatane.com.ng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
