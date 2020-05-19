import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/admin/login2/login_page3.dart';
import 'package:kaatane/admin/privacy_policy.dart';
import 'package:kaatane/admin/settings.dart';
import 'package:kaatane/admin/term_of_use.dart';



drawer2(context){
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        GestureDetector(
          onTap: (){
          },
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 20),
              child: Icon(Icons.person_pin, size:200),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,),
              child: Text("Kaatane Client", style: TextStyle(fontSize: 25)),
            )
          ],),
        ),

        SizedBox(height: 50),
        SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.person, size: 28),
                SizedBox(width: 20),
                Text('Login', style: TextStyle(fontSize: 18),),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage3()),
            );
          },
        ),
        SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.event_note, size: 28),
                SizedBox(width: 20),
                Text('Privacy Policy', style: TextStyle(fontSize: 18),),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPolicy()),
            );
          },
        ),
        SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.event_note, size: 28),
                SizedBox(width: 20),
                Text('Terms and Conditions', style: TextStyle(fontSize: 18),),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TermOfUse()),
            );
          },
        ),
      ],
    ),
  );
}