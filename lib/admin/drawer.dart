import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/ui/meals_page.dart';
import 'package:provider/provider.dart';

import 'category.dart';
import 'discount.dart';
import 'login2/edit_profile.dart';
import 'meals.dart';
import 'orders.dart';
import 'profile.dart';
import 'settings.dart';

drawer(context, page, bloc){
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfile()),
            );
          },
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 20),
              child: bloc.restaurantDocument['image']=='https://google.com'?
              Center(child: Icon(Icons.person_pin, size: 200,)):
              Center(child: Image.network(bloc.restaurantDocument['image'], height: 200,)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,),
              child: Text(bloc.restaurantDocument['name'], style: TextStyle(fontSize: 25),),
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
                Icon(Icons.receipt, size: 28),
                SizedBox(width: 20),
                Text('Client Side', style: TextStyle(fontSize: 18),),
              ],
            ),
          ),
          onTap: () {
            Firestore.instance.collection('category').where('restaurant_id', isEqualTo: Provider.of<CartBloc>(context).restaurantDocument.documentID).getDocuments().then(
                    (val){
                  List<DocumentSnapshot> ctegory_list = val.documents;
                  List<Widget> tabBarList = [];
                  ctegory_list.forEach((element) {
                    tabBarList.add(Tab(text: element['title']));

                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MealPage(Provider.of<CartBloc>(context).restaurantDocument, ctegory_list, tabBarList)),
                  );
                }
            );

            //Navigator
            //  .of(context)
            //.pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => Orders()));
          },
        ),
        SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.receipt, size: 28, color: "orders"==page?Colors.purple:Colors.black,),
                SizedBox(width: 20),
                Text('All Orders', style: TextStyle(fontSize: 18,  color: "orders"==page?Colors.purple:Colors.black,),),
              ],
            ),
          ),
          onTap: () {
            //Navigator
              //  .of(context)
                //.pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => Orders()));
          },
        ),
        SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.fastfood, size: 28, color: "meal"==page?Colors.purple:Colors.black,),
                SizedBox(width: 20),
                Text('Meals', style: TextStyle(fontSize: 18, color: "meal"==page?Colors.purple:Colors.black),),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Meals()),
            );
          },
        ),
        SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.category, size: 28,),
                SizedBox(width: 20),
                Text('Categories', style: TextStyle(fontSize: 18, ),),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Category()),
            );
          },
        ),
        SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.ac_unit, size: 28, color: "discount"==page?Colors.purple:Colors.black,),
                SizedBox(width: 20),
                Text('Discounts', style: TextStyle(fontSize: 18, color: "discount"==page?Colors.purple:Colors.black,),),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Discount()),
            );
          },
        ),
        SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.settings_input_svideo, size: 28, color: "settings"==page?Colors.purple:Colors.black,),
                SizedBox(width: 20),
                Text('Settings', style: TextStyle(fontSize: 18, color: "settings"==page?Colors.purple:Colors.black,),),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
          },
        ),
      ],
    ),
  );
}