import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/model/meal.dart';
import 'package:provider/provider.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class Button extends StatefulWidget {
  Button(this.mealDocument);
  final DocumentSnapshot mealDocument;


  @override
  _ButtonState createState() => _ButtonState(mealDocument);
}

class _ButtonState extends State<Button> with TickerProviderStateMixin {
  _ButtonState(this.mealDocument);
  final DocumentSnapshot mealDocument;

  int counter = 0;

  AnimationController _animationController;

  double _containerPaddingLeft = 20.0;
  double _animationValue;
  double _translateX = 0;
  double _translateY = 0;
  double _rotate = 0;
  double _scale = 1;

  bool show;
  bool sent = false;
  Color _color = Colors.black38;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));
    show = true;
    _animationController.addListener(() {
      setState(() {
        show = false;
        _animationValue = _animationController.value;
        if (_animationValue >= 0.2 && _animationValue < 0.4) {
          _containerPaddingLeft = 100.0;
          _color = Colors.black38;
        } else if (_animationValue >= 0.4 && _animationValue <= 0.5) {
          _translateX = 80.0;
          _rotate = -20.0;
          _scale = 0.1;
        } else if (_animationValue >= 0.5 && _animationValue <= 0.8) {
          _translateY = -20.0;
        } else if (_animationValue >= 0.81) {
          _containerPaddingLeft = 20.0;
          sent = true;
        }
      });
    });
  }
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    Meal meal = Meal(id: mealDocument.documentID, name: mealDocument['title'], img_url: mealDocument['img_url'], price: mealDocument['price']);
    try{
      counter=bloc.cart[meal.id].quantity;
    }catch(e){
      counter=0;
      _animationController.reset();
      //_animationController.animateBack(100);
      setState(() {
        show=true;
        sent=true;
      });
    }
    return GestureDetector(

        onTap: () {
          if(mealDocument['discount']){
            bloc.addToCart(Meal(id: mealDocument.documentID, name: mealDocument['title'], img_url: mealDocument['img_url'], price: int.parse(mealDocument['discount_price'])));
          }else{
            bloc.addToCart(Meal(id: mealDocument.documentID, name: mealDocument['title'], img_url: mealDocument['img_url'], price: int.parse(mealDocument['normal_price'])));
          }
          _animationController.forward();
        },
        child: AnimatedContainer(
            decoration: BoxDecoration(
              //color: _color,
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.black, Color.fromRGBO(128, 0, 128, 1)]),
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: [
                BoxShadow(
                  color: _color,
                  blurRadius: 21,
                  spreadRadius: -15,
                  offset: Offset(
                    0.0,
                    20.0,
                  ),
                )
              ],
            ),
            padding: EdgeInsets.only(
                left: _containerPaddingLeft,
                right: 20.0,
                top: 10.0,
                bottom: 10.0),
            duration: Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (!sent)
                    ? AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  child: Icon(Icons.add_shopping_cart, color: Colors.white,size: 18.0),
                  curve: Curves.fastOutSlowIn,
                  transform: Matrix4.translationValues(
                      _translateX, _translateY, 0)
                    ..rotateZ(_rotate)
                    ..scale(_scale),
                )
                    : Container(),
                AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 600),
                  child: show ? SizedBox(width: 10.0) : Container(),
                ),
                AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 200),
                  child: show ? Text("Add to Cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)) : Container(),
                ),
                !show?
                AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 200),
                  child: sent ? Text(counter.toString(), style: TextStyle(color: Colors.white))/**Icon(Icons.done)**/ : Container(),
                ):Container(),
                AnimatedSize(
                  vsync: this,
                  alignment: Alignment.topLeft,
                  duration: Duration(milliseconds: 600),
                  child: sent ? SizedBox(width: 10.0) : Container(),
                ),
                !show?AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 200),
                  child: sent ? Text(counter>1?"items":"item", style: TextStyle(color: Colors.white),) : Container(),
                ):Container(),
              ],
            )));
  }
}