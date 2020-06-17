import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';

import 'STRINGVALUE.dart';

class EditMeal extends StatefulWidget {
  DocumentSnapshot _Document;
  EditMeal(this._Document);
  @override
  _EditMealState createState() => _EditMealState(_Document);
}

class _EditMealState extends State<EditMeal> {
  DocumentSnapshot _Document;
  _EditMealState(this._Document);

  var nameController = TextEditingController();
  String categoryController;
  var  normalPriceController = TextEditingController();
  var  discountPriceController = TextEditingController();
  var  briefDescriptionController = TextEditingController();
  List<DocumentSnapshot> ctegory_list;
  bool _validate = false;
  bool cat_changed = false;

  @override
  initState(){
    nameController = new TextEditingController(text: _Document['title']);
    //categoryController=_Document['category'];
    normalPriceController= new TextEditingController(text: _Document['normal_price']);
    discountPriceController= new TextEditingController(text: _Document['discount_price']);
    briefDescriptionController= new TextEditingController(text: _Document['brief_description']);
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String restaurant =Provider.of<CartBloc>(context).restaurant;
    Firestore.instance.collection('category').where('restaurant_id', isEqualTo: restaurant).getDocuments().then(
            (sn){setState(() {
          ctegory_list = sn.documents;
        });}
    );
    return Scaffold(
      appBar: AppBar(title: Text(EDIT_MENU_TITLE_LABEL_TEXT), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          Expanded(child: ListView(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 250,
                  width: 250,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: _Document['img_url']!=null?new NetworkImage(_Document['img_url']):new AssetImage("assets/images/placeholder.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Center(child: Text("Upload Image", style: TextStyle(decoration: TextDecoration.underline,color: Colors.white),)),
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
                      hintText: ENTER_ITEM_NAME_HINT_TEXT,
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
                ),):[],
                onChanged: (String value) {
                  setState(() {
                    categoryController = value;
                    cat_changed = true;
                  });
                },
                hint: Text(_Document['category']),
                value: categoryController
                ):Center(child: Text("Loading..."),),
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
                child: TextField(
                  controller: normalPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: ENTER_NORMAL_PRICE_HINT_TEXT,
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
                child: TextField(
                  controller: discountPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: ENTER_DISCOUNT_PRICE_HINT_TEXT,
                      hintStyle: TextStyle(color: Colors.grey[400])
                  ),
                ),
              ),
            ),
            /**
            SizedBox(height: 10,),
            Container(
              //color: Colors.grey[200],
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey[500])
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
                child: TextField(
                  maxLength: 50,
                  controller: briefDescriptionController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write a brief description... (optional)",
                      hintStyle: TextStyle(color: Colors.grey[400])
                  ),
                ),
              ),
            ),**/
            SizedBox(height: 100,),
          ],)),

          Row(
            children: <Widget>[
              Expanded(child: RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(UPDATE_LABEL_TEXT, style: TextStyle(fontSize: 19),),
                ),
                onPressed: (){
                  print("#####################################");
                  print("#####################################");
                  print("#####################################");
                  print("#####################################");
                  print(nameController.text);
                  print(categoryController);
                  print(normalPriceController.text);
                  print(discountPriceController.text);
                  print(briefDescriptionController.text);
                  if(nameController.text.isEmpty){
                    setState(() {
                      _validate = true;
                    });
                    return false;
                  }else if(discountPriceController.text.isEmpty){
                    setState(() {
                      _validate = true;
                    });
                    return false;
                  }else if(briefDescriptionController.text.isEmpty){
                    setState(() {
                      _validate = true;
                    });
                    return false;
                  }else{
                    setState(() {
                      _validate = false;
                    });
                    print("))))))))))))))");
                    print(cat_changed?categoryController.split(",")[0]:_Document['category']);
                    var doc_id=_Document.documentID;
                    Firestore.instance.document('meal/$doc_id')
                        .updateData({
                      'title': nameController.text,
                      'category': cat_changed?categoryController.split(",")[0]:_Document['category'],
                      'category_id': cat_changed?categoryController.split(",")[1]:_Document['category_id'],
                      'normal_price': normalPriceController.text,
                      'discount_price': discountPriceController.text,
                      'brief_description': briefDescriptionController.text,
                    });

                    Provider.of<CartBloc>(context).showSnackBar=true;
                    Navigator.pop(context);
                  }
                  //Navigator.push(
                  //context,
                  //MaterialPageRoute(builder: (context) => AddMeal()),
                  //);
                },
              )),
            ],
          )
        ],),
      ),
    );
  }
}
