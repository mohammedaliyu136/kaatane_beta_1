import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'STRINGVALUE.dart';


class EditCategory extends StatefulWidget {
  DocumentSnapshot _Document;
  EditCategory(this._Document);

  @override
  _EditCategoryState createState() => _EditCategoryState(_Document);
}

class _EditCategoryState extends State<EditCategory> {
  _EditCategoryState(this._Document);
  DocumentSnapshot _Document;


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
    nameController.text=_Document['title'];
    return Scaffold(
      appBar: AppBar(title: Text(UPDATE_CATEGORY_LABEL_TEXT), centerTitle: true,),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 50,),
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
                      child: Text(UPDATE_LABEL_TEXT, style: TextStyle(fontSize: 19),),
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
                        String doc_id = _Document.documentID;
                        Firestore.instance.document('category/$doc_id')
                            .updateData({ 'title': nameController.text});
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
      ),
    );
  }
}
