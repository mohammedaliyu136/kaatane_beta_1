import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';

//import 'drawer.dart';
import 'login2/account_bloc.dart';
import 'login2/edit_profile.dart';
import 'login2/login_page4.dart';
import 'order_ui_utils.dart';
import 'drawer.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser mUser;

  final  nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_auth.signOut();
  }

  showAlertLogouDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed:  () {
        _auth.signOut();
        Provider.of<CartBloc>(context).isTerminated=false;
        Provider.of<CartBloc>(context).isLoggedIn=false;
        //_signInWithEmailAndPassword();
        Provider.of<CartBloc>(context).isLoading = false;
        FirebaseMessaging _fcm = FirebaseMessaging();
        _fcm.subscribeToTopic(Provider.of<CartBloc>(context).restaurantDocument.documentID);
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            LoginPage4()), (Route<dynamic> route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure you want to logout?"),
      //content: Text("Your current order will be lost"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    var restaurant = bloc.restaurant;
    mUser=bloc.userFirebase;
    return WillPopScope(
      onWillPop: (){
        showAlertLogouDialog(context);
      },
      child: DefaultTabController(
          length: 3,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()),//EditProfile
                    );
                  },
                ),
              ],
              bottom: TabBar(
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 4.0, color: Colors.white),
                    //insets: EdgeInsets.symmetric(horizontal:16.0)
                ),
                tabs: [
                  Tab(text: "New"),
                  Tab(text: "Ongoing"),
                  Tab(text: "Past"),
                ],
              ),
              title: Text('Our Orders'),
              centerTitle: true,
            ),
            drawer: drawer(context, "orders", bloc),
            body: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('order_$restaurant').orderBy('time_stamp', descending: false).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting: return new Text('Loading...');
                      default:
                        return snapshot.data.documents.length!=0?
                        TabBarView(
                          children: <Widget>[
                            new ListView(
                              children: snapshot.data.documents.map((DocumentSnapshot document) {
                                if(document['status']==1){
                                  return new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(child: new_order2(context, document, _scaffoldKey), elevation: 7,),
                                  );
                                }else{
                                  return Container();
                                }
                              }).toList(),
                            ),
                            new ListView(
                              children: snapshot.data.documents.map((DocumentSnapshot document) {
                                if(document['status']==2){
                                  return new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(child: ongoing_order(context, document, _scaffoldKey), elevation: 7,),
                                  );
                                }else{
                                  return Container();
                                }
                              }).toList(),
                            ),
                            new ListView(
                              children: snapshot.data.documents.map((DocumentSnapshot document) {
                                if(document['status']==3){
                                  return new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(child: past_order(context, document), elevation: 7,),
                                  );
                                }else{
                                  return Container();
                                }
                              }).toList(),
                            ),
                          ],
                        ):new Text("There are no new Orders");

                    }
                  },
                ),
            //drawer: drawer(context, "orders"),
          ),
        ),
    );
  }
}
