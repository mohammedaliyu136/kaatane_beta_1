import 'package:flutter/material.dart';
import 'package:kaatane/admin/privacy_policy.dart';
import 'package:kaatane/admin/term_of_use.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          ListTile(
            title: Text("Term of use", style: TextStyle(fontSize: 14, color:Color.fromRGBO(90,90,90,1)),),
            trailing: Icon(Icons.arrow_forward_ios, color: Color.fromRGBO(90,90,90,1), size: 12,),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermOfUse()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(height: 1, child: Container(color: Color.fromRGBO(223,223,223,1),),),
          ),
          ListTile(
              title: Text("Privacy Policy", style: TextStyle(fontSize: 14, color:Color.fromRGBO(90,90,90,1)),),
              trailing: Icon(Icons.arrow_forward_ios, color: Color.fromRGBO(90,90,90,1), size: 12,),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                );
              },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(height: 1, child: Container(color: Color.fromRGBO(223,223,223,1),),),
          ),
          ListTile(
              title: Text("Facebook", style: TextStyle(fontSize: 14, color:Color.fromRGBO(90,90,90,1)),),
              trailing: Icon(Icons.arrow_forward_ios, color: Color.fromRGBO(90,90,90,1), size: 12,)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(height: 1, child: Container(color: Color.fromRGBO(223,223,223,1),),),
          ),
          ListTile(
              title: Text("Twitter", style: TextStyle(fontSize: 14, color:Color.fromRGBO(90,90,90,1)),),
              trailing: Icon(Icons.arrow_forward_ios, color: Color.fromRGBO(90,90,90,1), size: 12,)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(height: 1, child: Container(color: Color.fromRGBO(223,223,223,1),),),
          ),
          ListTile(
              title: Text("Instagram", style: TextStyle(fontSize: 14, color:Color.fromRGBO(90,90,90,1)),),
              trailing: Icon(Icons.arrow_forward_ios, color: Color.fromRGBO(90,90,90,1), size: 12,)
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
