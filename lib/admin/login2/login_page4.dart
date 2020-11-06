import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/ui/forget_password_success.dart';
import 'package:kaatane/ui/restaurant_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../STRINGVALUE.dart';
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
  bool status = true;
  bool show_tolbar = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode myNodeEmail;
  FocusNode myNodePassword;

  void _listenerEmail(){
    if(myNodeEmail.hasFocus){
      // keyboard appeared
      print("keyboard appeared");
      setState(() {
        show_tolbar=false;
      });
    }else{
      // keyboard dismissed
      print("keyboard dismissed");
      setState(() {
        show_tolbar=true;
      });
    }
  }
  void _listenerPassword(){
    if(myNodePassword.hasFocus){
      // keyboard appeared
      print("keyboard appeared");
      setState(() {
        show_tolbar=false;
      });
    }else{
      // keyboard dismissed
      print("keyboard dismissed");
      setState(() {
        show_tolbar=true;
      });
    }
  }

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
    myNodeEmail = new FocusNode()..addListener(_listenerEmail);
    myNodePassword = new FocusNode()..addListener(_listenerPassword);
  }


  @override
  Widget build(BuildContext context) {
    bool isLoading =Provider.of<CartBloc>(context).isLoading;
    bool isTerminated =Provider.of<CartBloc>(context).isTerminated;

    return Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/images/login_bg_2.png"),
          fit: BoxFit.fill,
        ),),
      child: !isLoading?Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: BackButton(onPressed: ()=>Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              RestaurantPage()), (Route<dynamic> route) => false),
            color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: show_tolbar?50:0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 350,
                  //color: Colors.white,
                  child: Column(children: <Widget>[
                    //SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text(WELCOME_LABEL_TEXT, style: TextStyle(fontSize: 25),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 15,),
                        Text(SIGN_IN_LABEL_TEXT, style: TextStyle(),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(children: <Widget>[
                        isTerminated?Expanded(child: Text(Provider.of<CartBloc>(context).message,style:TextStyle(color: Colors.red,), )):Container()
                      ],),
                    ),
                    TextFormField(
                      controller: _emailController,
                      focusNode: myNodeEmail,
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
                        prefixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              status=!status;
                            });
                          },
                          icon: Icon(Icons.person, color: Color.fromRGBO(128, 0, 128, 1), size: 18,),//visibility_off
                        ),
                      ),
                      //onSaved: (input)=>bloc.email=input,
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: myNodePassword,
                      obscureText: status?true:false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(242,242,242,1),
                        hintText: PASSWORD_HINT_TEXT,
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
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              status=!status;
                            });
                          },
                          icon: Icon(status?Icons.visibility_off:Icons.visibility),//visibility_off
                        ),
                        prefixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              status=!status;
                            });
                          },
                          icon: Icon(Icons.lock, color: Color.fromRGBO(128, 0, 128, 1), size: 18,),//visibility_off
                        ),
                      ),
                      //onSaved: (input)=>bloc.email=input,
                    ),
                  ],),
                ),
                SizedBox(height: 10),
                Row(children: [
                  Spacer(),
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
                      child: Text(FORGET_PASSWORD_LABEL_TEXT, style: TextStyle(fontSize: 14, color:Color.fromRGBO(109,0,109,1),),)
                  )
                ],),
                SizedBox(height: 30),
                Container(
                  width: 350,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: RaisedButton(
                        color: Color.fromRGBO(109,0,109,1),
                        onPressed: () async {
                          setState(() {
                            isLoading=true;
                          });

                          Provider.of<CartBloc>(context).signInWithEmailAndPassword(context, _emailController.text.trim(), _passwordController.text.trim());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(LOGIN_LABEL_TEXT, style: TextStyle(color: Colors.white, fontSize: 16),),
                        ),)),
                    ],
                  ),
                )
              ],
            ),
          ),),
      ):Scaffold(
        body: Center(
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
                    child: !err?Text(PLEASE_WAIT_LABEL_TEXT,
                      style: TextStyle(fontSize: 20,
                          color: Color.fromRGBO(128, 0, 128, 1)),):Text(PLEASE_WAIT_LABEL_TEXT,
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
