import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';
import 'STRINGVALUE.dart';
import 'SnackBars.dart';
import 'add_coupon.dart';
import 'edit_coupon.dart';

class Coupon extends StatefulWidget {
  @override
  _CouponState createState() => _CouponState();
}


class _CouponState extends State<Coupon> {
  bool status = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Coupon"), centerTitle: true,),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('coupon').where('owner', isEqualTo:Provider.of<CartBloc>(context).restaurant).snapshots(),
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
                      new ListTile(
                          title: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditCoupon(document)),
                                );
                              },
                              child: Row(
                                children: [
                                  Text("${document['code']}"),
                                  Text(" x ", style:TextStyle(fontWeight: FontWeight.bold)),
                                  Text("${document['quantity']}"),
                                ],
                              )),
                          subtitle:Text("Max: ₦${document['cap']}"),
                          trailing: CustomSwitch(
                            activeColor: Color.fromRGBO(128, 0, 128, 1),
                            value: document['status'],
                            onChanged: (value) {
                              var doc_id = document.documentID;
                              Firestore.instance.document('coupon/$doc_id')
                                  .updateData({
                                'status': document['status']?false:true,
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
      floatingActionButton: FloatingActionButton(
        //backgroundColor: const Color(0xff03dac6),
        //foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCoupon()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
