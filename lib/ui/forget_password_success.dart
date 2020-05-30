import 'package:flutter/material.dart';
import 'package:kaatane/admin/login2/login_page4.dart';

class ForgetPasswordSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Icon(Icons.check_circle, size: 100, color: Colors.teal,),
          SizedBox(height: 20,),
          Text("Password reset link has been sent to your Email..."),
          SizedBox(height: 30,),
          RaisedButton(onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                LoginPage4()), (Route<dynamic> route) => false);
          }, child: Text("Login"),),
        ],),
      ),
    );
  }
}
