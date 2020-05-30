import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/ui/forget_password_success.dart';
import 'package:kaatane/ui/restaurant_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account_bloc.dart';
import 'detail.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage4 extends StatefulWidget {

  @override
  _LoginPage2State createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage4> {
  FirebaseUser userFirebase;
  bool err = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  getUsernamePassword()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = pref.getString('username') ?? '';
      _passwordController.text = pref.getString('password') ?? '';
    });
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsernamePassword();
  }


  @override
  Widget build(BuildContext context) {
    bool isLoading =Provider.of<CartBloc>(context).isLoading;
    bool isTerminated =Provider.of<CartBloc>(context).isTerminated;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(onPressed: ()=>Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          RestaurantPage()), (Route<dynamic> route) => false),
        color: Color.fromRGBO(128, 0, 128, 1),),
        backgroundColor: Colors.white,
        elevation: 0,),
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
                        Text('Welcome Back!', style: TextStyle(fontSize: 25),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text('Sign in to Continue', style: TextStyle(),),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(children: <Widget>[
                        isTerminated?Expanded(child: Text(Provider.of<CartBloc>(context).message,style:TextStyle(color: Colors.red,), )):Container()
                      ],),
                    ),

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
                              onChanged: (val){
                                Provider.of<CartBloc>(context).isTerminated=false;
                                Provider.of<CartBloc>(context).not();
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
                          ),
                          GestureDetector(
                              onTap: ()async{
                                setState(() {
                                  err = false;
                                });
                                Provider.of<CartBloc>(context).isLoading=true;
                                Provider.of<CartBloc>(context).not();
                                _auth.sendPasswordResetEmail(email: _emailController.text.trim())
                                    .catchError((error){
                                      setState(() {
                                        err = true;
                                      });
                                      if(_emailController.text.trim()==""){
                                        Provider.of<CartBloc>(context).message = "Please enter your email address";
                                      }else{
                                        Provider.of<CartBloc>(context).message = error.message;
                                      }
                                      Provider.of<CartBloc>(context).isLoading = false;
                                      Provider.of<CartBloc>(context).isTerminated = true;
                                })
                                    .then((value){
                                      if(!err){
                                        Provider.of<CartBloc>(context).isLoading = false;
                                        Provider.of<CartBloc>(context).isTerminated =false;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ForgetPasswordSuccess()),
                                        );
                                      }
                                });
                              },
                              child: Text('forgot password?')
                          )

                        ],),
                    ),
                  ],),
                ),
                SizedBox(height: 1,child: Container(color: Colors.grey[300],),),
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
                  child: !err?Text("please wait...",
                    style: TextStyle(fontSize: 20,
                        color: Color.fromRGBO(128, 0, 128, 1)),):Text("please wait...",
                    style: TextStyle(fontSize: 20,
                        color: Color.fromRGBO(128, 0, 128, 1)),),
                )),
          ],
        ),
      ),
    );
  }
}
