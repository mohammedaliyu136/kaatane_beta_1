import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';

import 'delivery_area.dart';
import 'drawer.dart';
import 'login2/login_page3.dart';
import 'privacy_policy.dart';
import 'term_of_use.dart';

class Settings extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), centerTitle: true,),
      //drawer: drawer(context, "settings"),
      body: ListView(children: <Widget>[
        ListTile(title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text("Set Delivery Area", style: TextStyle(fontSize: 18)),
        ), trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeliveryArea()),
            );
          },
        ),
        SizedBox(height: 1, child: Container(color: Colors.grey[300],),),
        ListTile(title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text("Privacy Policy", style: TextStyle(fontSize: 18)),
        ), trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPolicy()),
            );
          },
        ),
        SizedBox(height: 1, child: Container(color: Colors.grey[300],),),
        ListTile(title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text("Term of Use", style: TextStyle(fontSize: 18)),
        ), trailing: Icon(Icons.arrow_forward_ios),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TermOfUse()),
          );
        },
        ),
        SizedBox(height: 1, child: Container(color: Colors.grey[300],),),
        ListTile(
          onTap: (){
            _auth.signOut();
            bloc.isTerminated=false;
            //_signInWithEmailAndPassword();
            Provider.of<CartBloc>(context).isLoading = false;
            _fcm.subscribeToTopic(bloc.restaurantDocument.documentID);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                LoginPage3()), (Route<dynamic> route) => false);
          },
          title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text("Logout", style: TextStyle(fontSize: 18)),
        ), trailing: Icon(Icons.arrow_forward_ios),),
      ],),
    );
  }
}
