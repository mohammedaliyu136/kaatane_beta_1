import 'package:flutter/material.dart';

snackBarBase(_scaffoldKey, message, color){
  return _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),backgroundColor: color,));
}
mealAdded(_scaffoldKey){
  String message = "Meal successfully added";
  snackBarBase(_scaffoldKey, message, Colors.green);
}
mealEdited(_scaffoldKey){
  String message = "Meal successfully edited";
  snackBarBase(_scaffoldKey, message, Colors.green);
}
mealDeleted(_scaffoldKey){
  String message = "Meal successfully deleted";
  snackBarBase(_scaffoldKey, message, Colors.red);
}
categoryAdded(_scaffoldKey){
  String message = "New category successfully added";
  snackBarBase(_scaffoldKey, message, Colors.green);
}
discountChange(_scaffoldKey){
  String message = "Discount changed successfully";
  snackBarBase(_scaffoldKey, message, Colors.green);
}
orderAccepted(_scaffoldKey){
  String message = "Order accepted successfully";
  snackBarBase(_scaffoldKey, message, Colors.green);
}
orderCanceled(_scaffoldKey){
  String message = "Order Cancelled successfully";
  snackBarBase(_scaffoldKey, message, Colors.green);
}
orderFinished(_scaffoldKey){
  String message = "Order completed successfully";
  snackBarBase(_scaffoldKey, message, Colors.green);
}
cartISEmpty(_scaffoldKey){
  String message = "Please add item to cart before checkout";
  snackBarBase(_scaffoldKey, message, Colors.green);
}
cartISLoggedin(_scaffoldKey){
  String message = "Sorry, you can't place order to your restaurant while you are still logged in";
  snackBarBase(_scaffoldKey, message, Colors.blue);
}
categoryISAssigned(_scaffoldKey, num, meals){
  String message = "Category is assign to $meals meals($num). Cannot be deleted";
  snackBarBase(_scaffoldKey, message, Colors.blue);
}
categoryDeleted(_scaffoldKey){
  String message = "Category deleted successfully";
  snackBarBase(_scaffoldKey, message, Colors.red);
}

profileImageUpdated(_scaffoldKey){
  String message = "Profile image updated successfully";
  snackBarBase(_scaffoldKey, message, Colors.green);
}
mealEditDeleteHint(_scaffoldKey){
  String message = "Swipe right to left to edit or delete a meal.";
  snackBarBase(_scaffoldKey, message, Colors.green);
}
delisted(_scaffoldKey){
  String message = "Meal listing has been updated successfully.";
  snackBarBase(_scaffoldKey, message, Colors.green);
}
