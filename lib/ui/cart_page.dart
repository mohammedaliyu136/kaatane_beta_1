import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaatane/admin/STRINGVALUE.dart';
import 'package:provider/provider.dart';

import '../bloc/cart_bloc.dart';
import '../model/meal.dart';
import 'widgets/buttom_cart.dart';
import 'widgets/cart_quantity_btn.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}
class _CartPageState extends State<CartPage>  {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int delivery_fee = 0;
  final couponCodeController = TextEditingController();

  FocusNode myNode;
  bool cart_sum = true;
  bool coupon_loading = false;
  bool coupon_error = false;


  void _listener(){
    if(myNode.hasFocus){
      // keyboard appeared
      print("keyboard appeared");
      setState(() {
        cart_sum=false;
      });
    }else{
      // keyboard dismissed
      print("keyboard dismissed");
      setState(() {
        cart_sum=true;
      });
    }
  }


  showAlertLogouDialog(BuildContext context, bloc) {

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
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: TextField(
        controller: couponCodeController,
        keyboardType: TextInputType.text,
        focusNode: myNode,
        decoration: InputDecoration(
          labelText: "Enter coupon Code",
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(128, 0, 128, 1),
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
              width: 2.0,
            ),
          ),
        ),

      ),
      content: Row(
        children: [
          Expanded(
            child: RaisedButton(

              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(50.0),
                //side: BorderSide(color: Colors.red)
              ),
              /*
              onPressed: ()async{
                setState(() {
                  coupon_loading = true;
                });
                //notifyListeners();
                Firestore.instance.collection('coupon').where('code', isEqualTo: couponCodeController.text).getDocuments().then((value){
                  for (var i = 0; i < value.documents.length; i++) {
                    print(i);
                    print(value.documents[i]['code']);
                    if(value.documents[i]['quantity']>0 && value.documents[i]['owner']=="admin"){
                      //break;
                      bloc.setCoupon(value.documents[i]);
                      Navigator.of(context).pop();
                    }else if(value.documents[i]['quantity']>0 && value.documents[i]['owner']==bloc.restaurantDocument.documentID){
                      bloc.setCoupon(value.documents[i]);
                      Navigator.of(context).pop();
                    }
                  }

                  setState(() {
                    coupon_error = true;
                    coupon_loading = false;
                  });
                  //notifyListeners();
                });
              },*/
              onPressed: ()async{
                await bloc.couponSearch(context, couponCodeController);
                Navigator.of(context).pop();
              },
              /*onPressed: () async {
                Firestore.instance.collection('coupon').where('code', isEqualTo: couponCodeController.text).getDocuments().then((value){
                  /*if(value.documents.length==1 && value.documents[0]["quantity"]>0){
                    bloc.setCoupon(value.documents[0]);
                    Navigator.of(context).pop();
                    if(value.documents[i]['quantity']>0 && value.documents[i]['owner']=="admin"){
                      //break;
                      bloc.setCoupon(value.documents[0]);
                    }else if(value.documents[i]['quantity']>0 && value.documents[i]['owner']==bloc.restaurantDocument.documentID){
                      bloc.setCoupon(value.documents[0]);
                    }
                  }else{
                    if(value.documents.length>1){

                    }
                  }*/
                  for (var i = 0; i < value.documents.length; i++) {
                    print(i);
                    print(value.documents[i]['code']);
                    if(value.documents[i]['quantity']>0 && value.documents[i]['owner']=="admin"){
                      //break;
                      bloc.setCoupon(value.documents[i]);
                      Navigator.of(context).pop();
                    }else if(value.documents[i]['quantity']>0 && value.documents[i]['owner']==bloc.restaurantDocument.documentID){
                      bloc.setCoupon(value.documents[i]);
                      Navigator.of(context).pop();
                    }
                  }
                });
              },*/
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("APPLY CODE", style: TextStyle(color: Colors.white, fontSize: 16),),
              ),),
          ),
        ],
      ),
      actions: [
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
    var cart = bloc.cart;
    var mContext = context;
    myNode = new FocusNode()..addListener(_listener);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(YOUR_ORDER_LABEL_TEXT),
      ),
      body: bloc.cart.length>0?bloc.coupon_loading?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
            SizedBox(height: 20,),
            Text("Searching for coupon...", style: TextStyle(fontSize: 20,),),
          ],
        ),
      ):Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    //Meal meal = cart.keys.toList()[index];
                    Meal meal = cart[index];
                    print(cart.values.toList()[index].name);
                    //int count = cart[giftIndex];
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Stack(
                                  children: <Widget>[
                                    Text(
                                      cart.values.toList()[index].name,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Positioned(
                                        right: 8,
                                        child: GestureDetector(
                                          child: Icon(
                                            Icons.clear,
                                            color: Color.fromRGBO(128, 0, 128, 1),
                                          ),
                                          onTap: () {
                                            bloc.clear(cart.keys.toList()[index]);
                                          },
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              Quantity_Cart_btn(cart.values.toList()[index]),
                              Spacer(),
                              Text("₦${NumberFormat.currency(symbol: "", decimalDigits: 0).format(cart.values.toList()[index].price)}"),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Divider(
                            thickness: 1,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            cart_sum?Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: Color.fromRGBO(128, 0, 128, 1),
                  boxShadow: [
                    BoxShadow(color:Colors.grey.withOpacity(0.3),spreadRadius:2, blurRadius: 7, offset: Offset(0,3)),
                  ]
              ),
              child: Column(children: <Widget>[
                bloc.coupon_error?SizedBox(height: 10.0,):SizedBox(height: 0.0,),
              bloc.coupon_error?Text("Sorry, Coupon not found.", style: TextStyle(color:Colors.white),):Text(""),
              ListTile(
                  leading: Text(Order_SUMMARY_LABEL_TEXT, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),),
                  trailing: bloc.applied_coupon?Text("Coupon Applied", style: TextStyle(color: Colors.white),):ButtonTheme(
                    minWidth: 5.0,
                    buttonColor: Colors.white,
                    child: RaisedButton(child: Text("Add Coupon", style:TextStyle(color:  Color.fromRGBO(128, 0, 128, 1), fontSize: 12)),onPressed: (){
                      showAlertLogouDialog(mContext, bloc);
                      print("---------------");
                      print("---------------");
                      print("---------------");
                    },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                        //side: BorderSide(color: Colors.red)
                    ),),
                  ),
              ),
              ListTile(leading: Text(BILL_TOTAL_LABEL_TEXT, style: TextStyle(color: Colors.white),), trailing: Text("₦${NumberFormat.currency(symbol: "", decimalDigits: 0).format(bloc.total-int.parse(bloc.delivery_fee))}", style: TextStyle(color: Colors.white),),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(height: 1, child: Container(color: Colors.white,),),
              ),

              bloc.restaurantDocument['delivery']?ListTile(
                leading: Text(HOW_TO_GET_YOUR_ORDER_LABEL_TEXT, style: TextStyle(color: Colors.white),),
                title: DropdownButton<bool>(
                  dropdownColor: Color.fromRGBO(128, 0, 128, 1),
                  items: [
                    DropdownMenuItem<bool>(
                      child: Text(PICKUP_LABEL_TEXT, style: TextStyle(color: Colors.white),),
                      value: false,
                    ),
                    DropdownMenuItem<bool>(
                      child: Text(DELIVERY_LABEL_TEXT, style: TextStyle(color: Colors.white),),
                      value: true,
                    ),
                  ],
                  onChanged: (bool deliver) {
                    if(deliver){
                      bloc.delivery_fee = bloc.restaurantDocument['delivery_fee'];
                      bloc.del_or_pick = true;
                      bloc.applied_coupon?bloc.setCoupon(bloc.couponDocument):print('');
                      bloc.not();
                    }else{
                      bloc.delivery_fee = '0';
                      bloc.del_or_pick = false;
                      bloc.applied_coupon?bloc.setCoupon(bloc.couponDocument):print('');
                      bloc.not();
                    }
                  },
                  value: bloc.del_or_pick,
                  hint: Text(CHOOSE_LABEL_TEXT, style: TextStyle(color: Colors.white),),
                  //value: _value,
                ),//Text("How to get ur order: "),
                trailing: bloc.del_or_pick?Text("₦"+bloc.delivery_fee, style: TextStyle(color: Colors.white),):Text(""),
              ):ListTile(leading: Text(NO_DELIVERY_LABEL_TEXT, style: TextStyle(color: Colors.white),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(height: 1, child: Container(color: Colors.grey[350],),),
              ),
              ListTile(leading: Text(GRAND_TOTAL_LABEL_TEXT, style: TextStyle(color: Colors.white),),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("₦${NumberFormat.currency(symbol: "", decimalDigits: 0).format(bloc.total)}", style: bloc.applied_coupon?TextStyle(color: Colors.white,decoration: TextDecoration.lineThrough):TextStyle(color: Colors.white),),
                    Text("  ", style: TextStyle(color: Colors.white),),
                    bloc.applied_coupon?Text("₦${NumberFormat.currency(symbol: "", decimalDigits: 0).format(bloc.discount_amount)}", style: TextStyle(color: Colors.white),):Text(""),
                  ],
                ),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Buttom_Cart(_scaffoldKey),
                  )),
                ],
              ),
              SizedBox(height: 4.0,),
            ],),):Container()
          ],
        ),
      ):Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/empty_cart.png", height: 200,),
          SizedBox(height: 10,),
          Center(child: Text(YOUR_BASKET_IS_EMPTY_LABEL_TEXT, style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(128, 0, 128, 1), fontSize: 23),)),
          SizedBox(height: 10,),
          Center(child: Text(MAKE_YOUR_BASKET_HAPPY_LABEL_TEXT)),
          SizedBox(height: 200,),
        ],
      ),
      /**
      bottomNavigationBar: new Container(
        height: 170.0,
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 34.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Your Orders",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0)),
                ],
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Bill Total:",
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "N${bloc.total}",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Buttom_Cart(),
            ],
          ),
        ),
      ),**/
    );
  }
}
