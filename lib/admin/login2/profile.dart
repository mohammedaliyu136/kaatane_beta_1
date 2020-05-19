import 'package:flutter/material.dart';

import 'edit_profile.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(children: <Widget>[
          SizedBox(height: 50.0,),
          Center(child: Icon(Icons.person_pin, size: 200,)),
          SizedBox(height: 40,),
          Row(children: <Widget>[
            SizedBox(width: 18,),
            Icon(Icons.person, size: 25, color: Colors.purple,),
            SizedBox(width: 18,),
            Text("John Doe", style: TextStyle(fontSize: 22),),
          ],),
          SizedBox(height: 20,),
          SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
          SizedBox(height: 20,),
          Row(children: <Widget>[
            SizedBox(width: 18,),
            Icon(Icons.phone, size: 25, color: Colors.purple,),
            SizedBox(width: 18,),
            Text("+1 2345 6789", style: TextStyle(fontSize: 22),),
          ],),
          SizedBox(height: 20,),
          SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
          SizedBox(height: 20,),
          Row(children: <Widget>[
            SizedBox(width: 18,),
            Icon(Icons.mail, size: 25, color: Colors.purple,),
            SizedBox(width: 18,),
            Text("john.doe@gmail.com", style: TextStyle(fontSize: 22),),
          ],),
          SizedBox(height: 20,),
          SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
          SizedBox(height: 20,),
          Row(children: <Widget>[
            SizedBox(width: 18,),
            Icon(Icons.lock, size: 25, color: Colors.purple,),
            SizedBox(width: 18,),
            Text("*************", style: TextStyle(fontSize: 22),),
          ],),
          SizedBox(height: 40,),
          Container(
            width: 350,
            child: Row(
              children: <Widget>[
                Expanded(child: RaisedButton(
                  onPressed: () async {
                    //_signInWithEmailAndPassword();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Update Profile", style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),)),
              ],
            ),
          ),
          SizedBox(height: 20,),
        ],),
      ),
    );
  }
}
