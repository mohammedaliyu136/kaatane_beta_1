import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';
import 'STRINGVALUE.dart';
import 'SnackBars.dart';

class Discount extends StatefulWidget {
  @override
  _DiscountState createState() => _DiscountState();
}


class _DiscountState extends State<Discount> {
  bool status = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(DISCOUNT_TITLE_LABEL_TEXT), centerTitle: true,),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('meal').where('restaurant_id', isEqualTo:Provider.of<CartBloc>(context).restaurant).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
                  SizedBox(height: 20,),
                  Text(LOADING_PLEASE_WAIT_LABEL_TEXT, style: TextStyle(fontSize: 20, color: Colors.white),),
                ],
              ),
            );
            default:
              return new ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return Column(
                    children: <Widget>[
                      new ListTile(title: Text(document['title']),
                          trailing: CustomSwitch(
                            activeColor: Color.fromRGBO(128, 0, 128, 1),
                            value: document['discount'],
                            onChanged: (value) {
                              var doc_id = document.documentID;
                              Firestore.instance.document('meal/$doc_id')
                                  .updateData({
                                'discount': document['discount']?false:true,
                              }).then((value){
                                discountChange(_scaffoldKey);
                              });
                            },
                          ),
                      ),
                      SizedBox(height: 1, child: Container(color: Colors.grey[350],),)
                    ],
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
