import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaatane/admin/STRINGVALUE.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import './../../model/days_and_time.dart';

import '../orders.dart';
import 'account_bloc.dart';
import '../SnackBars.dart';
import 'login_page3.dart';
import 'login_page4.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser mUser;
  DocumentSnapshot restaurantDocument;
  bool isDelivery = false;
  bool listBTN = false;
  bool isFirst = true;
  bool isModnday = true;
  DaysAndTime daysAndTime = new DaysAndTime();


  final  timeController = TextEditingController();
  final  nameController = TextEditingController();
  final  phonenumberController = TextEditingController();
  final  homeBasedDeliveryTimeController = TextEditingController();
  final  locationController = TextEditingController();
  final  deliveryFeeController = TextEditingController();
  String emailController = '';
  bool deliveryController;

  File imageFile;


  @override
  void initState() {
    super.initState();
  }


  setDateTimeDialog(BuildContext context) {
    //imageFile!=null?print(imageFile.path.toString()):print("is null");

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Camera"),
      onPressed:  () {
        //Navigator.of(context).pop();
        DatePicker.showDateTimePicker(context,
            showTitleActions: true,
            minTime: DateTime(2019, 6, 1),
            maxTime: DateTime(2019, 6, 7),
            onChanged: (date) {
              print('change $date');
            }, onConfirm: (date) {
              print('confirm $date');
            }, currentTime: DateTime.now());
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Galary"),
      onPressed:  () {
        _pickImage(ImageSource.gallery);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Opening"),
      content:Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("mon"),Spacer(),Text("tue"),Spacer(),Text("wen"),Spacer(),Text("thur")
            ],),
          Row(
            children: <Widget>[
              Checkbox(value: false, onChanged: (val){},),Spacer(),
              Checkbox(value: false, onChanged: (val){},),Spacer(),
              Checkbox(value: false, onChanged: (val){},),Spacer(),
              Checkbox(value: false, onChanged: (val){},),Spacer(),
              Checkbox(value: false, onChanged: (val){},),Spacer(),
            ],),
          Row(
            children: <Widget>[
              Text("fri"),Spacer(),Text("sat"),
            ],),
          Row(
            children: <Widget>[
              Checkbox(value: false, onChanged: (val){},),Spacer(),
              Checkbox(value: false, onChanged: (val){},),Spacer(),
              Checkbox(value: false, onChanged: (val){},),Spacer(),
              Checkbox(value: false, onChanged: (val){},),Spacer(),
              Checkbox(value: false, onChanged: (val){},),Spacer(),
            ],),
        ],),
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
    //imageFile!=null?print(imageFile.path.toString()):print("is null");

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(CAMERA_LABEL_TEXT),
      onPressed:  () {
        _pickImage(ImageSource.camera);
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(GALERY_LABEL_TEXT),
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
      title: Text(CHANGE_RESTAURANT_IMAGE_LABEL_TEXT),
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
    homeBasedDeliveryTimeController.text = restaurantDocument['home_based_delivery_time'];
    locationController.text = restaurantDocument['location'];
    deliveryFeeController.text = restaurantDocument['delivery_fee'];

    if(isFirst){
      setState(() {
        deliveryController = restaurantDocument['delivery'];
        listBTN = restaurantDocument['listed'];
        try{
          daysAndTime.setOpeningTime(restaurantDocument['openingTime']);
          daysAndTime.setClosingTime(restaurantDocument['closingTime']);
          daysAndTime.setDays(restaurantDocument['days']);
        }catch(err){
          daysAndTime.setOpeningTime('');
          daysAndTime.setClosingTime('');
          daysAndTime.setDays('0-0-0-0-0-0-0');
        }
        isFirst=false;
      });
    }
    FirebaseMessaging _fcm = FirebaseMessaging();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(PROFILE_LABEL_TEXT), centerTitle: true,),
      body: !isLoading?ListView(children: <Widget>[
        //SizedBox(height: 10.0,),
        GestureDetector(
            onTap: (){
              showAlertDialog(context, bloc.restaurantDocument);
            },
            child: Stack(
              children: [
                Center(child: Container(
                  height: 250,
                  //width: 250,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: imageFile!=null?new FileImage(imageFile):new NetworkImage(bloc.restaurantDocument['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),),
                bloc.restaurantDocument['listed']?Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:180.0, right:20),
                      child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color:Colors.white,),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CustomSwitch(
                              activeColor: Color.fromRGBO(128, 0, 128, 1),
                              value: listBTN,
                              onChanged: (value) {
                                setState(() {
                                  listBTN=value;
                                });
                                var doc_id = restaurantDocument.documentID;
                                Firestore.instance.document('Restaurant/$doc_id')
                                    .updateData({
                                  'listed':listBTN,
                                  'already_listed':true,
                                });
                                Firestore.instance.collection('Restaurant').where('user_id', isEqualTo: mUser.uid)
                                    .getDocuments().then((value){
                                  bloc.restaurantDocument = value.documents[0];
                                  bloc.not();
                                });
                              },
                            ),
                          ),
                      ),
                    ),
                  ],
                ):bloc.restaurantDocument['listed']==false&&(bloc.restaurantDocument['already_listed'] != null)?bloc.restaurantDocument['already_listed']?Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:180.0, right:20),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color:Colors.white,),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: CustomSwitch(
                            activeColor: Color.fromRGBO(128, 0, 128, 1),
                            value: listBTN,
                            onChanged: (value) {
                              setState(() {
                                listBTN=value;
                              });
                              var doc_id = restaurantDocument.documentID;
                              Firestore.instance.document('Restaurant/$doc_id')
                                  .updateData({
                                'listed':listBTN,
                                'already_listed':true,
                              });
                              Firestore.instance.collection('Restaurant').where('user_id', isEqualTo: mUser.uid)
                                  .getDocuments().then((value){
                                bloc.restaurantDocument = value.documents[0];
                                bloc.not();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ):Container():Container()
              ],
            )
        ),
        SizedBox(height: 20,),
        /*
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
                  hintText: RESTAURANT_NAME_LABEL_TEXT,
                  hintStyle: TextStyle(color: Colors.grey[400])
              ),
            ),
          ),
        ],),*/
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: nameController,
            keyboardType: TextInputType.text,
            maxLength: 25,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person, color: Colors.purple,),
              labelText: RESTAURANT_NAME_LABEL_TEXT,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(128, 0, 128, 1),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
        /*
        Row(children: <Widget>[
          SizedBox(width: 18,),
          Icon(Icons.phone, size: 25, color: Colors.purple,),
          SizedBox(width: 18,),
          Expanded(
            child: TextFormField(
              controller: phonenumberController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: RESTAURANT_PHONENUMBER_LABEL_TEXT,
                  hintStyle: TextStyle(color: Colors.grey[400])
              ),
            ),
          ),
        ],),*/
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: phonenumberController,
            keyboardType: TextInputType.number,
            maxLength: 12,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone, color: Colors.purple,),
              labelText: RESTAURANT_PHONENUMBER_LABEL_TEXT,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(128, 0, 128, 1),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
        /*
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
                  hintText: RESTAURANT_ADDRESS_LABEL_TEXT,
                  hintStyle: TextStyle(color: Colors.grey[400])
              ),
            ),
          ),
        ],),*/
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: locationController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_on, color: Colors.purple,),
              labelText: RESTAURANT_ADDRESS_LABEL_TEXT,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(128, 0, 128, 1),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(children: <Widget>[
            SizedBox(width: 10,),
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
                      setState(() {
                        deliveryController=value;
                      });
                    },
                  )
                ],
              ),
            ),
          ],),
        ),
        SizedBox(height: 20,),
        /*
        Row(children: <Widget>[
          SizedBox(width: 18,),
          //Icon(Icons.add_shopping_cart, size: 25, color: Colors.purple,),
          Image.asset("assets/images/delivery_fee_icon.png", width: 35,),
          SizedBox(width: 18,),
          Expanded(
            child: TextFormField(
              controller: deliveryFeeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: DELIVERY_FEE_LABEL_TEXT,
                  hintStyle: TextStyle(color: Colors.grey[400])
              ),
            ),
          ),
        ],),*/
        deliveryController?Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: deliveryFeeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.airport_shuttle, color: Colors.purple,),
              labelText: DELIVERY_FEE_LABEL_TEXT,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(128, 0, 128, 1),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ):Container(),

        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text("Opening and closing time & day", style: TextStyle(fontSize: 18),),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  onTap: (){
                    setState(() {
                      daysAndTime.setDay(1);
                    });
                  },
                  child: Container(child: Center(child: Text("M", style: TextStyle(fontSize: 18, color: Colors.white),)), height: 30, width: 30, decoration: BoxDecoration( color: daysAndTime.mon?Color.fromRGBO(128, 0, 128, 1):Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),)),
              GestureDetector(
                  onTap: (){
                    setState(() {
                      daysAndTime.setDay(2);
                    });
                  },
                  child: Container(child: Center(child: Text("T", style: TextStyle(fontSize: 18, color: Colors.white),)), height: 30, width: 30, decoration: BoxDecoration( color: daysAndTime.tue?Color.fromRGBO(128, 0, 128, 1):Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),)),
              GestureDetector(
                  onTap: (){
                    setState(() {
                      daysAndTime.setDay(3);
                    });
                  },
                  child: Container(child: Center(child: Text("W", style: TextStyle(fontSize: 18, color: Colors.white),)), height: 30, width: 30, decoration: BoxDecoration( color: daysAndTime.wen?Color.fromRGBO(128, 0, 128, 1):Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),)),
              GestureDetector(
                  onTap: (){
                    setState(() {
                      daysAndTime.setDay(4);
                    });
                  },
                  child: Container(child: Center(child: Text("T", style: TextStyle(fontSize: 18, color: Colors.white),)), height: 30, width: 30, decoration: BoxDecoration( color: daysAndTime.thu?Color.fromRGBO(128, 0, 128, 1):Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),)),
              GestureDetector(
                  onTap: (){
                    setState(() {
                      daysAndTime.setDay(5);
                    });
                  },
                  child: Container(child: Center(child: Text("F", style: TextStyle(fontSize: 18, color: Colors.white),)), height: 30, width: 30, decoration: BoxDecoration( color: daysAndTime.fri?Color.fromRGBO(128, 0, 128, 1):Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),)),
              GestureDetector(
                  onTap: (){
                    setState(() {
                      daysAndTime.setDay(6);
                    });
                  },
                  child: Container(child: Center(child: Text("S", style: TextStyle(fontSize: 18, color: Colors.white),)), height: 30, width: 30, decoration: BoxDecoration( color: daysAndTime.sat?Color.fromRGBO(128, 0, 128, 1):Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),)),
              GestureDetector(
                  onTap: (){
                    setState(() {
                      daysAndTime.setDay(7);
                    });
                  },
                  child: Container(child: Center(child: Text("S", style: TextStyle(fontSize: 18, color: Colors.white),)), height: 30, width: 30, decoration: BoxDecoration( color: daysAndTime.sun?Color.fromRGBO(128, 0, 128, 1):Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),)),
            ],),
        ),
        SizedBox(height: 20,),
        //TextField(controller: timeController,),
        /*
        Row(
          children: <Widget>[
            Expanded(child:
            //TextField(controller: timeController,)
            GestureDetector(
              onTap: (){
                Future<TimeOfDay> selectedTime = showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context,
                );
                print("====================");
                print("====================");
                selectedTime.then((value) => print("${value.hour}:${value.minute}"));
              },
              child: TextField(
                controller: timeController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.access_time, color: Colors.purple,),
                  labelText: "Opening",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(128, 0, 128, 1),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black54,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            )
            ),
            SizedBox(width: 10,),
            Expanded(child:
            TextField(
              controller: timeController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.access_time, color: Colors.purple,),
                labelText: "Closing",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(128, 0, 128, 1),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black54,
                    width: 2.0,
                  ),
                ),
              ),
            )
            ),
          ],),*/
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(children: <Widget>[
            Expanded(child: GestureDetector(
              onTap: (){
                Future<TimeOfDay> selectedTime = showTimePicker(
                  //initialTime: TimeOfDay.now(),
                  initialTime: daysAndTime.openingTime.trim()==""?TimeOfDay.now():TimeOfDay.fromDateTime(DateTime.parse("1969-07-20 ${daysAndTime.openingTime.split(" ")[0]}:04Z")),
                  context: context,
                );
                print("====================");
                print("====================");
                //selectedTime.then((value) => print("${value.hour}:${value.minute} ${value.period.index==0?'AM':'PM'}"));
                selectedTime.then((value) => setState(() {
                  String st = "${value.hour<10?'0'+value.hour.toString():value.hour}:${value.minute<10?'0'+value.minute.toString():value.minute} ${value.period.index==0?'AM':'PM'}";
                  daysAndTime.setOpeningTime(st);
                }));
              },
              child: Container(decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black54,
                    width: 2
                ),),  height: 50, child: Row(children: <Widget>[SizedBox(width: 10,),Icon(Icons.access_time,color: Colors.purple,),SizedBox(width: 10,), Text(daysAndTime.openingTime.trim()==''?"Opening":daysAndTime.openingTime,)],),),
            )),
            SizedBox(width: 10,),
            Text("to", style: TextStyle(fontSize: 20),),
            SizedBox(width: 10,),
            Expanded(child: GestureDetector(
              onTap: (){
                Future<TimeOfDay> selectedTime = showTimePicker(
                  //initialTime: TimeOfDay.now(),
                  initialTime: daysAndTime.closingTime.trim()==""?TimeOfDay.now():TimeOfDay.fromDateTime(DateTime.parse("1969-07-20 ${daysAndTime.closingTime.split(" ")[0]}:04Z")),
                  context: context,
                );
                print("====================");
                print("====================");
                //selectedTime.then((value) => print("${value.hour}:${value.minute} ${value.period.index==0?'AM':'PM'}"));
                selectedTime.then((value) => setState(() {
                  String st = "${value.hour<10?'0'+value.hour.toString():value.hour}:${value.minute<10?'0'+value.minute.toString():value.minute} ${value.period.index==0?'AM':'PM'}";
                  daysAndTime.setClosingTime(st);
                }));
              },
              child: Container(decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black54,
                    width: 2
                ),),  height: 50, child: Row(children: <Widget>[SizedBox(width: 10,),Icon(Icons.access_time,color: Colors.purple,),SizedBox(width: 10,), Text(daysAndTime.closingTime.trim()==''?"Closing":daysAndTime.closingTime,)],),),
            )),

          ],),
        ),
        /*
        (restaurantDocument['is_home_based'] != null)?TextField(
          controller: homeBasedDeliveryTimeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.airport_shuttle, color: Colors.purple,),
            labelText: "How many hours will it take to deliver",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(128, 0, 128, 1),
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black54,
                width: 2.0,
              ),
            ),
          ),
        ):Container(),
        */
        /*
        SizedBox(height: 20,),
        GestureDetector(
          onTap: (){
            setDateTimeDialog(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text("date"),
          ),
        ),*/
        SizedBox(height: 40,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(child: RaisedButton(
                  color: Color.fromRGBO(128, 0, 128, 1),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                      side: BorderSide(color: Color.fromRGBO(128, 0, 128, 1))
                  ),
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
                        'openingTime': daysAndTime.openingTime,
                        'closingTime': daysAndTime.closingTime,
                        'home_based_delivery_time': (restaurantDocument['is_home_based'] != null)?homeBasedDeliveryTimeController.text:"",
                        'days': daysAndTime.getDays(),
                        'listed':listBTN,
                        'already_listed':true,
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
                            //openingTime closingTime days
                            Firestore.instance.document('Restaurant/$doc_id')
                                .updateData({
                              'name': nameController.text,
                              'phone_number': phonenumberController.text,
                              'location': locationController.text,
                              'delivery': deliveryController,
                              'delivery_fee': deliveryFeeController.text.trim()==''?'0':deliveryFeeController.text,
                              'image':url,
                              'openingTime': daysAndTime.openingTime,
                              'closingTime': daysAndTime.closingTime,
                              'home_based_delivery_time': (restaurantDocument['is_home_based'] != null)?homeBasedDeliveryTimeController.text:"",
                              'days': daysAndTime.getDays(),
                              'listed':listBTN,
                              'already_listed':true,

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
        ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                      side: BorderSide(color: Color.fromRGBO(128, 0, 128, 1))
                  ),
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
                    child: Text("Send password reset link", style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),)),
              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: 350,
            child: Row(
              children: <Widget>[
                Expanded(child: RaisedButton(
                  color: Colors.red,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.red)
                  ),
                  onPressed: () async {
                    _auth.signOut();
                    bloc.isTerminated=false;
                    bloc.isLoggedIn=false;
                    //_signInWithEmailAndPassword();
                    Provider.of<CartBloc>(context).isLoading = false;
                    _fcm.subscribeToTopic(bloc.restaurantDocument.documentID);
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.setBool('isLoggedin', false);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        LoginPage4()), (Route<dynamic> route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),)),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],):Center(
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
