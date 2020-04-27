import 'package:flutter/material.dart';
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Delivery Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 24.0,
          left: 18.0,
          right: 18.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter your fullname', focusColor: Color.fromRGBO(128, 0, 128, 1)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },

                onSaved: (input)=>bloc.fullName=input,
              ),
              TextFormField(
                decoration:
                InputDecoration(labelText: 'Enter your email (optional)', focusColor: Color.fromRGBO(128, 0, 128, 1)),
                onSaved: (input)=>bloc.email=input,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter your phonenumber', focusColor: Color.fromRGBO(128, 0, 128, 1)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your phonenumber';
                  }
                  return null;
                },
                onSaved: (input)=>bloc.phone=input,
              ),
              TextFormField(
                decoration:
                InputDecoration(labelText: 'Enter your note to resataurant', focusColor: Color.fromRGBO(128, 0, 128, 1),),
                maxLines: null,
                onSaved: (input)=>bloc.note=input,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
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
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Colors.black, Color.fromRGBO(128, 0, 128, 1)]),
                            borderRadius: BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: Container(
                            //constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "CHECHOUT",
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
    );
  }
}
