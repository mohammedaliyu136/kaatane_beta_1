import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/admin/login2/login_page3.dart';
import 'package:kaatane/admin/login2/login_page4.dart';
import 'package:kaatane/admin/privacy_policy.dart';
import 'package:kaatane/admin/settings.dart';
import 'package:kaatane/admin/term_of_use.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/model/my_order_model.dart';
import 'package:provider/provider.dart';

import 'my_order.dart';

getdata(context)async{
  List<OrderModel> list = await Provider.of<CartBloc>(context).getMyOrders();
  return list;
}

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
              padding: const EdgeInsets.only(top: 30.0, bottom: 20),
              child: Icon(Icons.person_pin, size:200, color: Colors.transparent,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0,),
              child: Text("Kaatane Client", style: TextStyle(fontSize: 25, color: Colors.transparent)),
            )
          ],),
        ),

        SizedBox(height: 20),
        SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.reorder, size: 28),
                SizedBox(width: 20),
                Text('My Orders', style: TextStyle(fontSize: 18),),
              ],
            ),
          ),
          onTap: ()async{
            List<OrderModel> list = await getdata(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyOrder(list)),//EditProfile
            );
          },
        ),
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
              MaterialPageRoute(builder: (context) => LoginPage4()),
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