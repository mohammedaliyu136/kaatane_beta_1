import 'package:flutter/material.dart';

snackBarBase(_scaffoldKey, message){
  return _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),));
}
mealAdded(_scaffoldKey){
 String message = "Menu successfully added";
 snackBarBase(_scaffoldKey, message);
}
mealEdited(_scaffoldKey){
  String message = "Menu successfully edited";
  snackBarBase(_scaffoldKey, message);
}
mealDeleted(_scaffoldKey){
  String message = "Menu successfully deleted";
  snackBarBase(_scaffoldKey, message);
}
categoryAdded(_scaffoldKey){
  String message = "New caegory successfully added";
  snackBarBase(_scaffoldKey, message);
}
discountChange(_scaffoldKey){
  String message = "Discount changed successfully";
  snackBarBase(_scaffoldKey, message);
}
orderAccepted(_scaffoldKey){
  String message = "Order accepted successfully";
  snackBarBase(_scaffoldKey, message);
}
orderCanceled(_scaffoldKey){
  String message = "Order Canceled successfully";
  snackBarBase(_scaffoldKey, message);
}
orderFinished(_scaffoldKey){
  String message = "Order completed successfully";
  snackBarBase(_scaffoldKey, message);
}
cartISEmpty(_scaffoldKey){
  String message = "Cart is empty. You have add things to the cart";
  snackBarBase(_scaffoldKey, message);
}
categoryISAssigned(_scaffoldKey, num, meals){
  String message = "Category is assign to $meals meals($num). Cannot be deleted";
  snackBarBase(_scaffoldKey, message);
}
categoryDeleted(_scaffoldKey){
  String message = "Category deleted successfully";
  snackBarBase(_scaffoldKey, message);
}
