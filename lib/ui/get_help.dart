import 'package:flutter/material.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';

class GetHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Get help"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          ListTile(
            title: Text("Call us now", style: TextStyle(fontSize: 14, color:Color.fromRGBO(90,90,90,1)),),
            trailing: Icon(Icons.arrow_forward_ios, color: Color.fromRGBO(90,90,90,1), size: 12,),
            onTap: () async {
              await FlutterPhoneState.startPhoneCall("0803490202");
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(height: 1, child: Container(color: Color.fromRGBO(223,223,223,1),),),
          ),
          ListTile(
            title: Text("Kaatane@intija.com", style: TextStyle(fontSize: 14, color:Color.fromRGBO(90,90,90,1)),),
            trailing: Icon(Icons.arrow_forward_ios, color: Color.fromRGBO(90,90,90,1), size: 12,),
            onTap: (){},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(height: 1, child: Container(color: Color.fromRGBO(223,223,223,1),),),
          ),
        ],),
      ),
    );
  }
}
