import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account_bloc.dart';
import 'detail.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage3 extends StatefulWidget {

  @override
  _LoginPage2State createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage3> {
  FirebaseUser userFirebase;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    bool isLoading =Provider.of<CartBloc>(context).isLoading;
    bool isTerminated =Provider.of<CartBloc>(context).isTerminated;
    return Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/images/login_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: !isLoading?Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Center(child: Icon(Icons.fastfood, size: 100, color: Color.fromRGBO(128, 0, 128, 1),)),
                  ),
                  Container(
                    width: 350,
                    color: Colors.white,
                    child: Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(child: Container(color: Color.fromRGBO(242, 242, 242, 1), height: 65, child: Center(
                              child: Text("Admin Login",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(128, 0, 128, 1)),)
                          ),)),
                        ],
                      ),
                      Row(children: <Widget>[
                        isTerminated?Text(Provider.of<CartBloc>(context).message,style:TextStyle(color: Colors.red)):Container()
                      ],),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.mail, color: Color.fromRGBO(128, 0, 128, 1), size: 18,),
                            SizedBox(width: 20,),
                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please enter email';
                                  }
                                  return null;
                                },
                              ),
                            )

                          ],),
                      ),
                      SizedBox(height: 1,child: Container(color: Colors.grey[300],),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.lock, color: Color.fromRGBO(128, 0, 128, 1), size: 18,),
                            SizedBox(width: 20,),
                            Expanded(
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                              ),
                            )

                          ],),
                      ),
                    ],),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 350,
                    child: Row(
                      children: <Widget>[
                        Expanded(child: RaisedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading=true;
                            });

                            Provider.of<CartBloc>(context).signInWithEmailAndPassword(context, _emailController.text.trim(), _passwordController.text.trim());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16),),
                          ),)),
                      ],
                    ),
                  )
                ],
              ),
            ),),
        ):Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    color: Colors.white70,
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
                )),
                Container(
                    color: Colors.white70,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Login in, please wait...",
                        style: TextStyle(fontSize: 20,
                            color: Color.fromRGBO(128, 0, 128, 1)),),
                    )),
              ],
            ),
          ),
      ),
    );
  }
}
