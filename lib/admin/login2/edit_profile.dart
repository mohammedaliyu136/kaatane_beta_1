import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';

import '../orders.dart';
import 'account_bloc.dart';
import '../SnackBars.dart';
import 'login_page3.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser mUser;
  DocumentSnapshot restaurantDocument;


  final  nameController = TextEditingController();
  final  phonenumberController = TextEditingController();
  final  locationController = TextEditingController();
  final  deliveryFeeController = TextEditingController();
  String emailController = '';
  bool deliveryController;

  File imageFile;

  Future<void> sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }


  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    imageFile = selected;

    _cropImage();
  }

  Future<void> _cropImage() async {
      int persent = 100;
      await imageFile.length()
          .then((value) {
        if(value/1000000>0.5){
          return persent = 50;
        }
      });
    File cropped = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        compressQuality: persent,
        aspectRatioPresets: [CropAspectRatioPreset.ratio3x2,],
        // ratioX: 1.0,
        // ratioY: 1.0,
        maxWidth: 512,
        maxHeight: 512,
        //toolbarColor: Colors.purple,
        //toolbarWidgetColor: Colors.white,
        //toolbarTitle: 'Crop It'
        androidUiSettings: AndroidUiSettings(
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );


    setState(() {
      imageFile = cropped ?? imageFile;
    });
  }

  showAlertDialog(BuildContext context, DocumentSnapshot document) {

    var title = document['title'];
    //imageFile.path;
    print(")))))))))))))))))))");
    print(")))))))))))))))))))");
    print(")))))))))))))))))))");
    //imageFile!=null?print(imageFile.path.toString()):print("is null");

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Camera"),
      onPressed:  () {
        _pickImage(ImageSource.camera);
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Galary"),
      onPressed:  () {
        var doc_id=document.documentID;
        var img_url = document['img_url'];
        _pickImage(ImageSource.gallery);
        //Firestore.instance.document('Restaurant/$doc_id').delete();
        profileImageUpdated(_scaffoldKey);
        Navigator.of(context).pop();
        //FirebaseStorage.instance.getReferenceFromUrl(document['img_url']).then((value) => value.delete().then((value){
        //}));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Change restaurant profile"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    bool isLoading =Provider.of<CartBloc>(context).isLoading;
    mUser=bloc.userFirebase;
    emailController = mUser.email;
    restaurantDocument=bloc.restaurantDocument;
    nameController.text = restaurantDocument['name'];
    phonenumberController.text = restaurantDocument['phone_number'];
    locationController.text = restaurantDocument['location'];
    deliveryFeeController.text = restaurantDocument['delivery_fee'];
    deliveryController = restaurantDocument['delivery'];
    FirebaseMessaging _fcm = FirebaseMessaging();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Profile"), centerTitle: true,),
      body: !isLoading?Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(children: <Widget>[
          SizedBox(height: 10.0,),
          GestureDetector(
              onTap: (){
                showAlertDialog(context, bloc.restaurantDocument);
              },
              child: Center(child: Container(
                height: 250,
                //width: 250,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: imageFile!=null?new FileImage(imageFile):new NetworkImage(bloc.restaurantDocument['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),)
          ),
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
                    activeColor: Color.fromRGBO(128, 0, 128, 1),
                    value: deliveryController,
                    onChanged: (value) {
                      deliveryController=value;
                    },
                  )
                ],
              ),
            ),
          ],),
          SizedBox(height: 20,),
          SizedBox(height: 3, child: Container(color: Colors.grey[300],),),
          SizedBox(height: 20,),
          Row(children: <Widget>[
            SizedBox(width: 18,),
            Icon(Icons.add_shopping_cart, size: 25, color: Colors.purple,),
            SizedBox(width: 18,),
            Expanded(
              child: TextFormField(
                controller: deliveryFeeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Delivery Fee",
                    hintStyle: TextStyle(color: Colors.grey[400])
                ),
              ),
            ),
          ],),

          SizedBox(height: 40,),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(child: RaisedButton(
                  color: Color.fromRGBO(128, 0, 128, 1),
                  onPressed: () async {
                    //_signInWithEmailAndPassword();
                    var doc_id = restaurantDocument.documentID;

                    //FirebaseStorage.instance.getReferenceFromUrl(document['img_url']).then((value) => value.delete().then((value){
                    //}));
                    Provider.of<CartBloc>(context).isLoading = true;
                    if(imageFile==null){
                      Firestore.instance.document('Restaurant/$doc_id')
                          .updateData({
                        'name': nameController.text,
                        'phone_number': phonenumberController.text,
                        'location': locationController.text,
                        'delivery': deliveryController,
                        'delivery_fee': deliveryFeeController.text.toString(),
                      });
                      Firestore.instance.collection('Restaurant').where('user_id', isEqualTo: mUser.uid)
                          .getDocuments().then((value){
                        bloc.restaurantDocument = value.documents[0];
                        bloc.not();
                      });
                      Provider.of<CartBloc>(context).isLoading = false;
                      Provider.of<CartBloc>(context).showSnackBar=true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Orders()),
                      );
                    }else{
                      String img = bloc.restaurantDocument['image'];
                      Provider.of<CartBloc>(context).uploadImage(imageFile ).then(
                              (url){
                                print("@@@@@@@@@@@@@@@@");
                                print("@@@@@@@@@@@@@@@@");
                                print("@@@@@@@@@@@@@@@@");
                                print("@@@@@@@@@@@@@@@@");
                                print("@@@@@@@@@@@@@@@@"+deliveryFeeController.text);
                                print(url);
                            Firestore.instance.document('Restaurant/$doc_id')
                                .updateData({
                              'name': nameController.text,
                              'phone_number': phonenumberController.text,
                              'location': locationController.text,
                              'delivery': deliveryController,
                              'delivery_fee': deliveryFeeController.text.trim()==''?'0':deliveryFeeController.text,
                              'image':url
                            });
                            Firestore.instance.collection('Restaurant').where('user_id', isEqualTo: mUser.uid)
                                .getDocuments().then((value){
                              bloc.restaurantDocument = value.documents[0];
                              bloc.not();
                            });
                            FirebaseStorage.instance.getReferenceFromUrl(img).then((value) => value.delete().then((value){
                            }));
                            Provider.of<CartBloc>(context).isLoading = false;
                            Provider.of<CartBloc>(context).showSnackBar=true;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Orders()),
                            );
                          }
                      );
                    }
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
                  color: Color.fromRGBO(128, 0, 128, 1),
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
          SizedBox(height: 20),
        ],),
      ):Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
            SizedBox(height: 20,),
            Text(Provider.of<CartBloc>(context).message, style: TextStyle(fontSize: 20,),),
          ],
        ),
      ),
    );
  }
}
