import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';
import 'STRINGVALUE.dart';
import 'SnackBars.dart';

import 'login2/account_bloc.dart';


class EditCoupon extends StatefulWidget {
  DocumentSnapshot _Document;
  EditCoupon(this._Document);
  @override
  _EditCouponState createState() => _EditCouponState(_Document);
}

class _EditCouponState extends State<EditCoupon> {
  DocumentSnapshot _Document;
  _EditCouponState(this._Document);

  final codeController = TextEditingController();
  final percentageController = TextEditingController();
  final quantityController = TextEditingController();
  final capController = TextEditingController();
  bool _validate = false;

  @override
  void initState() {
    // TODO: implement initState
    codeController.text=_Document["code"];
    percentageController.text=_Document["percentage"].toString();
    quantityController.text=_Document["quantity"].toString();
    capController.text=_Document["cap"].toString();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    codeController.dispose();
    percentageController.dispose();
    quantityController.dispose();
    capController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    bool isLoading =Provider.of<CartBloc>(context).isLoading;
    String restaurant =Provider.of<CartBloc>(context).restaurant;
    return Scaffold(
      appBar: AppBar(title: Text(ADD_NEW_CATEGORY_LABEL_TEXT), centerTitle: true,),
      body: !isLoading?ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 0,
                  color: Colors.grey[350],
                ),
                SizedBox(height: 10,),
                //Text("Upload Image", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white),),
                SizedBox(height: 20,),
                TextField(
                  maxLength: 20,
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: "Enter code",
                    errorText: _validate ? ERROR_LABEL_TEXT : null,
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
                SizedBox(height: 20,),
                TextField(
                  maxLength: 20,
                  controller: percentageController,
                  decoration: InputDecoration(
                    labelText: "Enter percentage",
                    errorText: _validate ? ERROR_LABEL_TEXT : null,
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
                SizedBox(height: 20,),
                TextField(
                  maxLength: 20,
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: "Enter quantity",
                    errorText: _validate ? ERROR_LABEL_TEXT : null,
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
                SizedBox(height: 20,),
                TextField(
                  maxLength: 20,
                  controller: capController,
                  decoration: InputDecoration(
                    labelText: "Enter maximum amount",
                    errorText: _validate ? ERROR_LABEL_TEXT : null,
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
                SizedBox(height: 40,),
                Row(children: <Widget>[
                  Expanded(child: RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(SAVE_LABEL_TEXT, style: TextStyle(fontSize: 19),),
                    ),
                    onPressed: (){
                      if(codeController.text.isEmpty||percentageController.text.isEmpty||quantityController.text.isEmpty||capController.text.isEmpty){
                        setState(() {
                          _validate = true;
                        });
                        return false;
                      }else{
                        setState(() {
                          _validate = false;
                        });
                        String doc_id = _Document.documentID;
                        Firestore.instance.document('coupon/$doc_id')
                            .updateData({
                          'code': (codeController.text).toLowerCase(),
                          'percentage':int.parse(percentageController.text),
                          'quantity':int.parse(quantityController.text),
                          'cap':int.parse(capController.text),
                          'restaurant_ids':[restaurant],
                          'owner': restaurant,
                          'status': true
                        });
                        Provider.of<CartBloc>(context).showSnackBar=true;
                        Navigator.pop(context);

                      }
                      //Navigator.push(
                      //context,
                      //MaterialPageRoute(builder: (context) => AddMeal()),
                      //);
                    },
                  )),
                ],),
                SizedBox(height: 20,),
                Row(children: <Widget>[
                  Expanded(child: RaisedButton(
                    color: Color.fromRGBO(128, 0, 128, 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text("Delete", style: TextStyle(fontSize: 19),),
                    ),
                    onPressed: (){
                      if(codeController.text.isEmpty||percentageController.text.isEmpty||quantityController.text.isEmpty||capController.text.isEmpty){
                        setState(() {
                          _validate = true;
                        });
                        return false;
                      }else{
                        setState(() {
                          _validate = false;
                        });
                        String doc_id = _Document.documentID;
                        Firestore.instance.document('coupon/$doc_id')
                            .delete();
                        Provider.of<CartBloc>(context).showSnackBar=true;
                        Navigator.pop(context);

                      }
                      //Navigator.push(
                      //context,
                      //MaterialPageRoute(builder: (context) => AddMeal()),
                      //);
                    },
                  )),
                ],),
              ],
            ),
          ),
        ],
      ):Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
        SizedBox(height: 20,),
        Text(Provider.of<AccountManager>(context).message, style: TextStyle(fontSize: 20,),),
      ],
    ),
    ),
    );
  }
}
