import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';

import 'STRINGVALUE.dart';
import 'add_category.dart';
import 'add_meal.dart';
import 'SnackBars.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'edit_category.dart';
import 'edit_meal.dart';

class Category extends StatelessWidget {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  showAlertDialog(BuildContext context, DocumentSnapshot document) {

    var title = document['title'];

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(CANCEL_LABEL_TEXT),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(CONTINUE_LABEL_TEXT),
      onPressed:  () {
        String doc_id=document.documentID;
        Firestore.instance.collection('meal').where('category_id', isEqualTo:document.documentID).getDocuments().then((value){
          if(value.documents.length>0){
            String meals = "";
            for(var i=0; i<value.documents.length; i++){
              String meal = value.documents[i]['title'];
              meals += "$meal,";
            }
            categoryISAssigned(_scaffoldKey, value.documents.length, meals);
            Navigator.of(context).pop();
          }else{
            Firestore.instance.document('category/$doc_id').delete().then((value){
              categoryDeleted(_scaffoldKey);
              Navigator.of(context).pop();
            });
          }
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(DELETE_LABEL_TEXT),
      content: Text("${ARE_YOU_SURE_YOU_WANT_TO_DELETE_LABEL_TEXT} $title?"),
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(CATEGORY_TITLE_LABEL_TEXT),
        centerTitle: true,
      ),
      //drawer: drawer(context, "meal"),
      body: Column(
        children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('category').where('restaurant_id', isEqualTo:Provider.of<CartBloc>(context).restaurant).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return new Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
                          SizedBox(height: 20,),
                          Text(LOADING_PLEASE_WAIT_LABEL_TEXT, style: TextStyle(fontSize: 20, color: Colors.white),),
                        ],
                      ),
                    );
                    default:
                      return new ListView(
                        children: snapshot.data.documents.map((DocumentSnapshot document) {
                          return Column(
                            children: <Widget>[
                              new Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: ListTile(title: Text(document['title']), trailing: Icon(Icons.border_outer),),
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Edit',
                                    color: Colors.blue,
                                    icon: Icons.edit,
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => EditCategory(document)),
                                      ).then((value){
                                        if(Provider.of<CartBloc>(context).showSnackBar){
                                          Provider.of<CartBloc>(context).showSnackBar=false;
                                          mealEdited(_scaffoldKey);
                                        }
                                      });
                                    },
                                  ),
                                  IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: (){
                                      showAlertDialog(context, document);
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 1, child: Container(color: Colors.grey[350],),)
                            ],
                          );
                        }).toList(),
                      );
                  }
                },
          ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: RaisedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(ADD_CATEGORY_LABEL_TEXT),
              ),
              onPressed: (){
                //categoryAdded(_scaffoldKey);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCategory()),
                ).then((value){
                  if(Provider.of<CartBloc>(context).showSnackBar){
                    Provider.of<CartBloc>(context).showSnackBar=false;
                    categoryAdded(_scaffoldKey);
                  }
                });
              },
            ),
          ),
          SizedBox(height: 25,),
        ],
      ),
    );
  }
}
