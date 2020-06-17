import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';
import 'STRINGVALUE.dart';
import 'SnackBars.dart';

import 'login2/account_bloc.dart';


class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  final nameController = TextEditingController();
  bool _validate = false;

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
    return Scaffold(
      appBar: AppBar(title: Text(ADD_NEW_CATEGORY_LABEL_TEXT), centerTitle: true,),
      body: !isLoading?ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 0,
                  color: Colors.grey[350],
                ),
                SizedBox(height: 10,),
                //Text("Upload Image", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white),),
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
                      maxLength: 20,
                      controller: nameController,
                      decoration: InputDecoration(
                        errorText: _validate ? ERROR_LABEL_TEXT : null,
                          border: InputBorder.none,
                          hintText: ENTER_CATEGORY_NAME_LABEL_TEXT,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                Row(children: <Widget>[
                  Expanded(child: RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(SAVE_LABEL_TEXT, style: TextStyle(fontSize: 19),),
                    ),
                    onPressed: (){
                      if(nameController.text.isEmpty){
                        setState(() {
                          _validate = true;
                        });
                        return false;
                      }else{
                        setState(() {
                          _validate = false;
                        });
                        Firestore.instance.collection('category').document()
                            .setData({ 'title': nameController.text, 'restaurant_id': restaurant });
                        Provider.of<CartBloc>(context).showSnackBar=true;
                        Navigator.pop(context);

                      }
                      //Navigator.push(
                        //context,
                        //MaterialPageRoute(builder: (context) => AddMeal()),
                      //);
                    },
                  )),
                ],),
              ],
            ),
          ),
        ],
      ):Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
        SizedBox(height: 20,),
        Text(Provider.of<AccountManager>(context).message, style: TextStyle(fontSize: 20,),),
      ],
    ),
    ),
    );
  }
}
