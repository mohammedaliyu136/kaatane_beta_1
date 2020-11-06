import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/model/meal.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kaatane/admin/STRINGVALUE.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class Meal_Item extends StatefulWidget {
  Meal_Item(this.mealDocument, this.isOpened);
  final DocumentSnapshot mealDocument;
  bool isOpened;


  @override
  _Meal_ItemState createState() => _Meal_ItemState(mealDocument, isOpened);
}

class _Meal_ItemState extends State<Meal_Item>{
  _Meal_ItemState(this.mealDocument, this.isOpened);
  final DocumentSnapshot mealDocument;
  bool isOpened;

  int counter = 0;

  bool show;
  bool sent = false;
  Color _color = Colors.black38;

  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    Meal meal = Meal(id: mealDocument.documentID, name: mealDocument['title'], img_url: mealDocument['img_url'], price: mealDocument['price']);

    try{
      counter=bloc.cart[meal.id].quantity;
    }catch(e){
      counter=0;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 16.0, bottom: 3),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:32.0,top: 9.4, ),
            child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color:Color.fromRGBO(0, 0, 0, 0.25),spreadRadius:0.1, blurRadius: 2,),
                    ],
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(100)),
                    //borderRadius: BorderRadius.vertical(top: Radius.circular(80), bottom: Radius.circular(80)),
                    color:Colors.white
                ),
              child: Padding(
                  padding: const EdgeInsets.only(left:33.0, top: 0, bottom: 0),
                  child: ListTile(
                      visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                      contentPadding: EdgeInsets.only(right: 0.0),
                      title: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left:5.0, right: 12.0, top: 10, ),
                                  child: Text(mealDocument['title'],
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: TextStyle(
                                        color: Color.fromRGBO(90,90,90,1),
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:5.0, top: 5, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Text("${PRICE_LABEL_TEXT}: ₦", style: TextStyle(fontSize: 13.0, color: Color.fromRGBO(90,90,90,1)),),
                                Text(NumberFormat.currency(symbol: "", decimalDigits: 0).format(int.parse(mealDocument['normal_price'])), style: mealDocument['discount']?TextStyle(decoration: TextDecoration.lineThrough, fontSize: 13.0,color: Color.fromRGBO(90,90,90,1)):TextStyle(fontSize: 13.0,color: Color.fromRGBO(90,90,90,1))),
                                mealDocument['discount']?Text(" ₦${NumberFormat.currency(symbol: "", decimalDigits: 0).format(int.parse(mealDocument['discount_price']))}", style: TextStyle(color: Colors.green, fontSize: 13.0,)):Container(),
                                counter>0?Row(
                                  children: [
                                    Text(" x ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13.0,color: Color.fromRGBO(90,90,90,1))),
                                    Text(counter.toString(), style: TextStyle(fontSize: 13.0,color: Color.fromRGBO(90,90,90,1))),
                                  ],
                                ):Text("", style: TextStyle(fontSize: 13.0,color: Color.fromRGBO(90,90,90,1))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      trailing: GestureDetector(
                          onTap: (){
                            if(isOpened){
                              if(mealDocument['discount']){
                                bloc.addToCart(Meal(id: mealDocument.documentID, name: mealDocument['title'], img_url: mealDocument['img_url'], price: int.parse(mealDocument['discount_price'])));
                              }else{
                                bloc.addToCart(Meal(id: mealDocument.documentID, name: mealDocument['title'], img_url: mealDocument['img_url'], price: int.parse(mealDocument['normal_price'])));
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: isOpened?Icon(Icons.add, size: 30, color: Color.fromRGBO(128, 0, 128, 1)):Text(""),
                          ))
                  )
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top:9.0),
              child: Container(
                height: 63,
                width: 63,
                child: Center(child: Text('')),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color:Color.fromRGBO(0, 0, 0, 0.25),spreadRadius:0.1, blurRadius: 2,),
                    ],
                    borderRadius: BorderRadius.circular(100),
                    //borderRadius: BorderRadius.vertical(top: Radius.circular(80), bottom: Radius.circular(80)),
                    image: DecorationImage(
                        image: NetworkImage(mealDocument['img_url']),
                        fit: BoxFit.cover
                    )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}