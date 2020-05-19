import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account_bloc.dart';
import 'login_page2.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser mUser;

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    _auth.currentUser().then((user){
    });
  }

  @override
  Widget build(BuildContext context) {

    //Center(child: Text("uid: "+ mUser.uid),),
    //Center(child: Text("email: "+mUser.email),),
    //Center(child: Text("displayName: "+mUser.displayName),),
    var bloc = Provider.of<AccountManager>(context);
    mUser=bloc.userFirebase;
    return Scaffold(
      appBar: AppBar(title: Text("Detail"), centerTitle: true,),
      body: Column(
        children: <Widget>[
          Text(Provider.of<AccountManager>(context).userFirebase.email),
          RaisedButton(
            onPressed: (){
              _auth.signOut();
              Navigator.pop(context);
              //Navigator.push(
                //context,
                //MaterialPageRoute(builder: (context) => LoginPage2()),
              //);
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
