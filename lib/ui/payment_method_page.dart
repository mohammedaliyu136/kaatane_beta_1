//@JS()
//library paystackWeb;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
//import 'package:js/js.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:kaatane/admin/STRINGVALUE.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../bloc/cart_bloc.dart';
import '../utils/paystack.dart';
import 'Order_Submitted_page.dart';

//@JS("payWithPaystackWeb")
//external Future<String> payWithPaystackWeb(amount, email, phone_number, key);

//@JS("get_response")
//external String get_response();

//@JS("get_status")
//external String get_status();

class Order_payment_method extends StatefulWidget {
  //Future<String> get value async => await payWithPaystackWeb(2000, "mohammedaliyu136@gmail.com", "08034902025");
  @override
  Order_payment_methodState createState() {
    return Order_payment_methodState();
  }
}

class Order_payment_methodState extends State<Order_payment_method> {
  //var paystackPublicKey = 'pk_test_277c53a98499bf6879daea5e6442e3ffdf45c573';
  @override
  void initState() {
    var payStackKey = "";
    //PaystackPlugin.initialize(publicKey: paystackPublicKey);
    Firestore.instance.collection('server').where('key_id', isEqualTo: '1').getDocuments().then((value){
      //print(value.documents[0]['key']);
      //print(utf8.decode(base64.decode(value.documents[0]['key'])));
      payStackKey = utf8.decode(base64.decode(value.documents[0]['key']));
      PaystackPlugin.initialize(publicKey: payStackKey);
    });
    /*
    Firestore.instance.collection('server').where('key_id', isEqualTo: '1').getDocuments().then((value){
      //print(value.documents[0]['key']);
      //print(utf8.decode(base64.decode(value.documents[0]['key'])));
      payStackKey = utf8.decode(base64.decode(value.documents[0]['key']));
      PaystackPlugin.initialize(publicKey: paystackPublicKey);
    });
     */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: new SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.lock, size: 15.0, color: Colors.grey[500]),
                  SizedBox(width: 5),
                  Text(
                    "SECURED BY PAYSTACK",
                    style: TextStyle(color: Colors.grey[500]),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Image.asset("assets/images/pay_online.png"),
                    Row(
                      children: <Widget>[
                        Text(HOW_WOULD_YOU_LIKE_TO_PAY_LABEL,
                            style:
                            TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (kIsWeb) {
                          // running on the web!
                          //payWithPaystackWeb(bloc.total, "customer@email.com", bloc.phone, paystackPublicKey);
                          //const oneSec = const Duration(seconds:1);
                          //new Timer.periodic(oneSec, (Timer t) {
                          //print("checking");
                          //if(get_status() == "done"){
                          //var response = json.decode(get_response());
                          //print(response);
                          //if(response['status']=="success" && response['message']=="Approved"){
                          // t.cancel();
                          //var reference = response['reference'];
                          //bloc.postOrder("card", context, reference);
                          //}
                          //}else if(get_status() == "closed"){
                          //t.cancel();
                          //}
                          //});

                        } else {
                          pay(context, bloc);
                        }

                      },
                      child: Container(
                        color: Colors.green[300],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Row(children: <Widget>[
                                  Text("Pay with ", style: TextStyle(color: Colors.white)),
                                  Text("Card",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                ])),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 1, thickness: 2),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        //var url = "https://kaatane.herokuapp.com/api/order/";
                        var uuid = Uuid();

                        bloc.postOrder("Pay on Delivery", context, uuid.v1());
                        //Navigator.push(
                        //context,
                        //MaterialPageRoute(builder: (context) => Order_Submitted()),
                        //);
                      },
                      child: Container(
                        color: Colors.green[300],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child:Row(children: <Widget>[
                                  Text("Pay on ", style: TextStyle(color: Colors.white)),
                                  Text("Delivery",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                ])
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

}
