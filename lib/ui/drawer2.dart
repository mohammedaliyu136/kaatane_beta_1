import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kaatane/admin/login2/login_page3.dart';
import 'package:kaatane/admin/login2/login_page4.dart';
import 'package:kaatane/admin/privacy_policy.dart';
import 'package:kaatane/admin/settings.dart';
import 'package:kaatane/admin/term_of_use.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/model/my_order_model.dart';
import 'package:provider/provider.dart';

import 'about_page.dart';
import 'get_help.dart';
import 'my_order.dart';
import 'vendor_signup.dart';

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
      shrinkWrap: true,
      children: <Widget>[
        Image.asset("assets/images/drawer/drawer_img.png",),
        SizedBox(height: 10),

        ListTile(
          title: Row(
            children: <Widget>[
              //Icon(Icons.reorder, size: 28),
              SizedBox(width: 10),
              Image.asset("assets/images/drawer/orders.png", width: 23.0, height: 23.0,),
              SizedBox(width: 20),
              Text('Orders',style: TextStyle(fontSize: 15, color: Color.fromRGBO(137,137,137,1)),),
            ],
          ),
          onTap: ()async{
            List<OrderModel> list = await getdata(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyOrder(list)),//EditProfile
            );
          },
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              SizedBox(width: 10),
              Image.asset("assets/images/drawer/login.png", width: 23.0, height: 23.0,),
              SizedBox(width: 20),
              Text('Login',style: TextStyle(fontSize: 15, color: Color.fromRGBO(137,137,137,1)),),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage4()),
            );
          },
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              SizedBox(width: 10),
              Image.asset("assets/images/drawer/add_user.png", width: 23.0, height: 23.0,),
              SizedBox(width: 20),
              Text('Vendor Registration',style: TextStyle(fontSize: 15, color: Color.fromRGBO(137,137,137,1)),),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VendorSignup()),
            );
          },
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              SizedBox(width: 10),
              Image.asset("assets/images/drawer/get_help.png", width: 23.0, height: 23.0,),
              SizedBox(width: 20),
              Text('Get help',style: TextStyle(fontSize: 15, color: Color.fromRGBO(137,137,137,1)),),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GetHelp()),
            );
          },
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              SizedBox(width: 10),
              Image.asset("assets/images/drawer/Info.png", width: 23.0, height: 23.0,),
              SizedBox(width: 20),
              Text('About', style: TextStyle(fontSize: 15, color: Color.fromRGBO(137,137,137,1)),),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
          },
        ),


      ],
    ),
  );
}