import 'package:flutter/material.dart';


class LoadingPage extends StatelessWidget {
  LoadingPage(this.method);
  var method;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
              SizedBox(height: 30,),
              Text("Processing your order, please wait")
            ],
          ),
        ),
      ),
    );
  }
}
