import 'package:flutter/material.dart';
import 'package:kaatane/admin/STRINGVALUE.dart';
import 'package:provider/provider.dart';

import '../bloc/cart_bloc.dart';
import 'payment_method_page.dart';

class Delivery_info extends StatefulWidget {
  @override
  Delivery_infoState createState() {
    return Delivery_infoState();
  }
}

class Delivery_infoState extends State<Delivery_info> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(DELIVERY_INFORMATION),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 14.0,
              left: 18.0,
              right: 18.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Full Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  SizedBox(height: 5,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    //decoration: InputDecoration(labelText: FULL_NAME_LABEL, focusColor: Color.fromRGBO(128, 0, 128, 1)),
                    autofocus: false,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(242,242,242,1),
                      hintText: 'Enter your name',
                      hintStyle: TextStyle(color: Color.fromRGBO(126,131,137,0.53)),
                      contentPadding: const EdgeInsets.only(left: 21.0, bottom: 13.0, top: 13.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return FULL_NAME_ERROR_MESSAGE_LABEL;
                      }
                      return null;
                    },

                    onSaved: (input)=>bloc.fullName=input,
                  ),
                  SizedBox(height: 15,),
                  Text("Email Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  SizedBox(height: 5,),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(242,242,242,1),
                      hintText: 'Enter email address',
                      hintStyle: TextStyle(color: Color.fromRGBO(126,131,137,0.53)),
                      contentPadding: const EdgeInsets.only(left: 21.0, bottom: 13.0, top: 13.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                    onSaved: (input)=>bloc.email=input,
                  ),
                  SizedBox(height: 15,),
                  Text("Phone Number", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  SizedBox(height: 5,),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(242,242,242,1),
                      hintText: 'Enter phone number',
                      hintStyle: TextStyle(color: Color.fromRGBO(126,131,137,0.53)),
                      contentPadding: const EdgeInsets.only(left: 21.0, bottom: 13.0, top: 13.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return PHONE_NUMBER_ERROR_MESSAGE_LABEL;
                      }
                      return null;
                    },
                    onSaved: (input)=>bloc.phone=input,
                  ),
                  SizedBox(height: 15,),
                  bloc.del_or_pick?Text("Delivery Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),):Container(),
                  bloc.del_or_pick?SizedBox(height: 5,):Container(),
                  bloc.del_or_pick?TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(242,242,242,1),
                      hintText: 'Enter delivery address',
                      hintStyle: TextStyle(color: Color.fromRGBO(126,131,137,0.53)),
                      contentPadding: const EdgeInsets.only(left: 21.0, bottom: 13.0, top: 13.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                    maxLines: null,
                    validator: (value) {
                      if (value.isEmpty) {
                        return DELIVERY_ADDRESS_ERROR_MESSAGE_LABEL;
                      }
                      return null;
                    },
                    onSaved: (input)=>bloc.address=input,
                  ):Container(),
                  bloc.del_or_pick?SizedBox(height: 15,):Container(),
                  Text("Additional Note", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  SizedBox(height: 5,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(242,242,242,1),
                      hintText: 'Please enter additional note to the restaurant if you have any',
                      hintStyle: TextStyle(color: Color.fromRGBO(126,131,137,0.53)),
                      contentPadding: const EdgeInsets.only(left: 21.0, bottom: 13.0, top: 13.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                    maxLines: 3,
                    onSaved: (input)=>bloc.note=input,
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Row(
                      children: <Widget>[
                        /**
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Color.fromRGBO(128, 0, 128, 1),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(38.0),
                                side: BorderSide(color: Color.fromRGBO(128, 0, 128, 1))),
                            onPressed: () {
                              //Navigator.push(
                                //context,
                                //MaterialPageRoute(builder: (context) => Order_payment_method()),
                              //);
                              if(_formKey.currentState.validate()){
                                _formKey.currentState.save();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Order_payment_method()),
                                    );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text("Proceed"),
                            ),
                          ),
                        ),**/
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: RaisedButton(
                              textColor: Colors.white,
                              onPressed: () {
                                if(_formKey.currentState.validate()){
                                  _formKey.currentState.save();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Order_payment_method()),
                                  );
                                }
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(128, 0, 128, 1),
                                  /*
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [Colors.black, Color.fromRGBO(128, 0, 128, 1)]),*/
                                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                ),
                                child: Container(
                                  //constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      CHECKOUT_LABEL_TEXT,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
