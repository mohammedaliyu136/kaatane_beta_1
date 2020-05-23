import 'package:flutter/material.dart';

snackBarBase(_scaffoldKey, message){
  return _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),));
}
mealAdded(_scaffoldKey){
 String message = "Meal successfully added";
 snackBarBase(_scaffoldKey, message);
}
mealEdited(_scaffoldKey){
  String message = "Meal successfully edited";
  snackBarBase(_scaffoldKey, message);
}
mealDeleted(_scaffoldKey){
  String message = "Meal successfully deleted";
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
  String message = "Please add item to cart before checkout";
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

profileImageUpdated(_scaffoldKey){
  String message = "Profile image updated successfully";
  snackBarBase(_scaffoldKey, message);
}
mealEditDeleteHint(_scaffoldKey){
  String message = "Swipe right to left to edit or delete a meal.";
  snackBarBase(_scaffoldKey, message);
}
delisted(_scaffoldKey){
  String message = "Meal listing has been updated successfully.";
  snackBarBase(_scaffoldKey, message);
}