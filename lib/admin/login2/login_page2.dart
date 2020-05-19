import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'detail.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
class LoginPage2 extends StatefulWidget {
  LoginPage2({Key key}) : super(key: key);

  @override
  _LoginPage2State createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInWithEmailAndPassword() async {
    //_auth.signOut();

    print(_emailController.text+"****");
    print(_passwordController.text);
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: 'mohammedaliyu136@gmail.com',
      password: 'mohammed',
    ))
        .user;
    print("************************************");
    //_auth.signOut();
    print(user);
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Detail()),
      );
    } else {
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Center(child: Icon(Icons.fastfood, size: 100, color: Colors.white,)),
            ),
            Container(
              width: 350,
              color: Colors.white,
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Container(color: Color.fromRGBO(242, 242, 242, 1), height: 65, child: Center(
                        child: Text("Admin Login",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),)
                    ),)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.mail, color: Colors.deepOrange, size: 18,),
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
                      Icon(Icons.lock, color: Colors.deepOrange, size: 18,),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextFormField(
                          controller: _passwordController,
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
                      _signInWithEmailAndPassword();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16),),
                    ), color: Color.fromRGBO(255, 109, 0, 1),)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}