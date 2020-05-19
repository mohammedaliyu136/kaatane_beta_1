import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';

import '../orders.dart';
import 'account_bloc.dart';
import 'login_page3.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser mUser;
  DocumentSnapshot restaurantDocument;

  final  nameController = TextEditingController();
  final  phonenumberController = TextEditingController();
  final  locationController = TextEditingController();
  String emailController = '';
  bool deliveryController;

  Future<void> sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }


  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    mUser=bloc.userFirebase;
    emailController = mUser.email;
    restaurantDocument=bloc.restaurantDocument;
    nameController.text = restaurantDocument['name'];
    phonenumberController.text = restaurantDocument['phone_number'];
    locationController.text = restaurantDocument['location'];
    deliveryController = restaurantDocument['delivery'];
    FirebaseMessaging _fcm = FirebaseMessaging();
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(children: <Widget>[
          SizedBox(height: 10.0,),
          Center(child: Icon(Icons.person_pin, size: 200,)),
          SizedBox(height: 10,),
          Row(children: <Widget>[
            SizedBox(width: 18,),
            Padding(
              padding: const EdgeInsets.only(bottom:25.0),
              child: Icon(Icons.person, size: 25, color: Colors.purple,),
            ),
            SizedBox(width: 18,),
            Expanded(
              child: TextFormField(
                maxLength: 25,
                controller: nameController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Fullname",
                    hintStyle: TextStyle(color: Colors.grey[400])
                ),
              ),
            ),
          ],),
          SizedBox(height: 20,),
          SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
          SizedBox(height: 20,),
          Row(children: <Widget>[
            SizedBox(width: 18,),
            Icon(Icons.phone, size: 25, color: Colors.purple,),
            SizedBox(width: 18,),
            Expanded(
              child: TextFormField(
                controller: phonenumberController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter phonenumber",
                    hintStyle: TextStyle(color: Colors.grey[400])
                ),
              ),
            ),
          ],),
          SizedBox(height: 20,),
          SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
          SizedBox(height: 20,),
          Row(children: <Widget>[
            SizedBox(width: 18,),
            Padding(
              padding: const EdgeInsets.only(bottom:25.0),
              child: Icon(Icons.location_on, size: 25, color: Colors.purple,),
            ),
            SizedBox(width: 18,),
            Expanded(
              child: TextFormField(
                maxLength: 30,
                controller: locationController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Location",
                    hintStyle: TextStyle(color: Colors.grey[400])
                ),
              ),
            ),
          ],),
          SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
          SizedBox(height: 20,),
          Row(children: <Widget>[
            SizedBox(width: 18,),
            Icon(Icons.drive_eta, size: 25, color: Colors.purple,),
            SizedBox(width: 18,),
            Expanded(
              child: Row(
                children: <Widget>[
                  Text("Will you deliver?"),
                  SizedBox(width: 10,),
                  CustomSwitch(
                    activeColor: Colors.green,
                    value: deliveryController,
                    onChanged: (value) {
                      deliveryController=value;
                    },
                  )
                ],
              ),
            ),
          ],),

          SizedBox(height: 40,),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(child: RaisedButton(
                  color: Colors.green,
                  onPressed: () async {
                    //_signInWithEmailAndPassword();
                    var doc_id = restaurantDocument.documentID;
                    Firestore.instance.document('Restaurant/$doc_id')
                        .updateData({
                      'name': nameController.text,
                      'phone_number': phonenumberController.text,
                      'location': locationController.text,
                      'delivery': deliveryController,
                    });
                    Firestore.instance.collection('Restaurant').where('user_id', isEqualTo: mUser.uid)
                        .getDocuments().then((value){
                          bloc.restaurantDocument = value.documents[0];
                          bloc.not();
                        });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Orders()),
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
          Container(
            child: Row(
              children: <Widget>[
                Expanded(child: RaisedButton(
                  color: Colors.green,
                  onPressed: () async {
                    //_signInWithEmailAndPassword();
                    sendPasswordResetEmail(emailController).then(
                            (done){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Orders()),
                          );
                        }
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Send a reset link to my Email", style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),)),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            width: 350,
            child: Row(
              children: <Widget>[
                Expanded(child: RaisedButton(
                  color: Colors.red,
                  onPressed: () async {
                    _auth.signOut();
                    bloc.isTerminated=false;
                    //_signInWithEmailAndPassword();
                    Provider.of<CartBloc>(context).isLoading = false;
                    _fcm.subscribeToTopic(bloc.restaurantDocument.documentID);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        LoginPage3()), (Route<dynamic> route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),)),
              ],
            ),
          ),
        ],),
      ),
    );
  }
}
