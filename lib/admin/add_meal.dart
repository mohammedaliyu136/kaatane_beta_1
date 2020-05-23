import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';

import 'order_ui_utils.dart';

import 'login2/account_bloc.dart';

class AddMeal extends StatefulWidget {
  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {

  //gs://kaatane-vendor2.appspot.com
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final  nameController = TextEditingController();
  String categoryController;
  final  normalPriceController = TextEditingController();
  final  discountPriceController = TextEditingController();
  final  briefDescriptionController = TextEditingController();
  List<DocumentSnapshot> ctegory_list;
  bool _validate = false;

  final firestoreInstance = Firestore.instance;
  String m_url;
  File imageFile;
  BuildContext mContex;


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
        aspectRatioPresets: [CropAspectRatioPreset.square,],
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
         //minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
          rectHeight: 200,
          rectWidth: 300
    )
    );

    imageFile = cropped ?? imageFile;
  }

  setImageDialog(BuildContext context) {

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
        _pickImage(ImageSource.gallery);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Set image for meal"),
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
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading =Provider.of<CartBloc>(context).isLoading;
    String restaurant =Provider.of<CartBloc>(context).restaurant;
    Firestore.instance.collection('category').where('restaurant_id', isEqualTo: restaurant).getDocuments().then(
            (sn){setState(() {
              ctegory_list = sn.documents;
            });}
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Add New Meal"), centerTitle: true,),
      body: !isLoading?Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(children: <Widget>[
            Expanded(child: ListView(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      setImageDialog(context);
                    },
                    child: Container(
                      height: 250,
                      width: 250,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: imageFile!=null?new FileImage(imageFile):new AssetImage("assets/images/placeholder.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: GestureDetector(
                    onTap: (){
                      //_pickImage(ImageSource.gallery);
                      setImageDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Add meal image", style: TextStyle(decoration: TextDecoration.underline,),),
                    ),
                  )),
                ],
              ),
              SizedBox(height: 30,),
              Container(
                //color: Colors.grey[200],
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey[500])
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
                  child: TextField(
                    maxLength: 25,
                    controller: nameController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Item Name",
                        hintStyle: TextStyle(color: Colors.grey[400])
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                //color: Colors.grey[200],
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey[500])
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
                  child: ctegory_list!=null?DropdownButton<String>(
                        items: ctegory_list.length!=0?new List.generate(ctegory_list.length, (index) => new DropdownMenuItem<String>(
                          child: Text(ctegory_list[index]['title']),
                          value: ctegory_list[index]['title']+","+ctegory_list[index].documentID,
                        ),):new DropdownMenuItem<String>(),
                        onChanged: (String value) {
                          setState(() {
                            categoryController = value;
                          });
                        },
                        hint: Text('Choose Item Category'),
                        value: categoryController,
                      ):Container()
                ),
              ),
              SizedBox(height: 10,),
              Container(
                //color: Colors.grey[200],
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey[500])
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
                  child: TextFormField(
                    controller: normalPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter normal price",
                        hintStyle: TextStyle(color: Colors.grey[400])
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                //color: Colors.grey[200],
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey[500])
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
                  child: TextFormField(
                    controller: discountPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Discounted price",
                        hintStyle: TextStyle(color: Colors.grey[400])
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                //color: Colors.grey[200],
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey[500])
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
                  child: TextFormField(
                    maxLength: 50,
                    controller: briefDescriptionController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write a brief description...",
                        hintStyle: TextStyle(color: Colors.grey[400])
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100,),
            ],)),

            Row(
              children: <Widget>[
                Expanded(child: RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text("Save", style: TextStyle(fontSize: 19),),
                  ),
                  onPressed: (){
                    print("#####################################");
                    print("#####################################");
                    print("#####################################");
                    print("#####################################");
                    String error_msg = "";
                    bool is_error = false;
                    print(nameController.text);
                    print(categoryController);
                    print(normalPriceController.text);
                    print(discountPriceController.text);
                    print(briefDescriptionController.text);
                    if(imageFile==null){
                      is_error=true;
                      error_msg+="Image must be selected\n\n";
                    }
                    if(nameController.text.isEmpty){
                      is_error=true;
                      error_msg+="Menu title cannot be empty\n\n";
                    }
                    if(categoryController==null){
                      is_error=true;
                      error_msg+="Cateory must be selected\n\n";
                    }
                    if(discountPriceController.text.isEmpty){
                      is_error=true;
                      error_msg+="Discount cannot be emptyd\n\n";
                    }
                    if(briefDescriptionController.text.isEmpty){
                      is_error=true;
                      error_msg+="Discription cannot be empty\n\n";
                    }
                    if(!is_error){
                      setState(() {
                        _validate = false;
                      });
                      Provider.of<CartBloc>(context).isLoading = true;

                      Provider.of<CartBloc>(context).uploadImage(imageFile ).then(
                          (url){
                            Firestore.instance.collection('meal').document()
                                .setData({
                              'title': nameController.text,
                              'img_url':url,
                              'category': categoryController.split(",")[0],
                              'category_id': categoryController.split(",")[1],
                              'normal_price': normalPriceController.text,
                              'discount_price': discountPriceController.text,
                              'discount': false,
                              'brief_description': briefDescriptionController.text,
                              'restaurant_id': restaurant,
                            });
                            Provider.of<CartBloc>(context).isLoading = false;
                            Provider.of<CartBloc>(context).showSnackBar=true;
                            Navigator.pop(context);
                          }
                      );
                      return null;
                    }
                    showAlertDialogValidation(context, error_msg, _scaffoldKey);
                    //Navigator.push(  if request.time < timestamp.date(2020, 5, 24)
                    //context,
                    //MaterialPageRoute(builder: (context) => AddMeal()),
                    //);
                  },
                )),
              ],
            )
          ],),
        ),
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
