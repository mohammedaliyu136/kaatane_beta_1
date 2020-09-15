import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/utils/keys.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';

class StoreRedirectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);


    return Scaffold(
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Spacer(),
            Image.asset("assets/images/update_icon.png"),
            Text("New update is available", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color.fromRGBO(128, 0, 128, 1)),),
            SizedBox(height: 20,),
            Text("The current version of this app is no longer supported. We apologize for any inconvenience we may have caused you.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Update now"),
                  ),onPressed: (){
                    LaunchReview.launch(androidAppId: "ng.com.intija.kaatane",
                        iOSAppId: "585027354");
                  },),
                ),
              ],
            ),
            SizedBox(height: 40,),
          ],),
        ),
      )
    );
  }
}
