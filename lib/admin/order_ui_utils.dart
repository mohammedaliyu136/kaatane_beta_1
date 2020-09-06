import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as timeago;


import 'STRINGVALUE.dart';
import 'order_detail_page.dart';
import 'SnackBars.dart';

new_order(){
  return Column(children: <Widget>[
    Row(children: <Widget>[
      Icon(Icons.directions_bike),
      Expanded(
        child: Column(children: <Widget>[
          Text("Angel James"),
          Text("Today at 12:33 AM"),
        ],),
      ),
      Column(children: <Widget>[
        Text("Order id: 384"),
        Text("Total: \$106.00"),
      ],),
    ],)
  ],);
}
new_order2(context, DocumentSnapshot document, _scaffoldKey){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    order_header(document),
    order_list(document),
    space(),
    order_message(document),
    buttons(context, document, _scaffoldKey)
  ],);
}

ongoing_order(context,  DocumentSnapshot document, _scaffoldKey){
  var uuid = Uuid();
  print("&&&&&&&&&&&&&&&&&&&&&");
  print("&&&&&&&&&&&&&&&&&&&&&");
  print("&&&&&&&&&&&&&&&&&&&&&");
  print("&&&&&&&&&&&&&&&&&&&&&");
  print("443c40b0-9abc-11ea-c2c6-9d414111eb86");
  print(uuid.v1());
  print(uuid.v1());
  print(uuid.v1().split('-')[0]);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    order_header(document),
    order_list(document),
    space(),
    order_message(document),
    buttons_ongoing(context, document, _scaffoldKey)
  ],);
}
//
past_order(context, DocumentSnapshot document){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    order_header(document),
    order_list(document),
    space(),
    order_message(document),
    SizedBox(height: 10,),
    buttons_past(context, document),
    SizedBox(height: 10,),
  ],);
}

order_header(DocumentSnapshot document){
  bool isPaid = false;
  try{
    isPaid = document['isPaid'];
    print(isPaid);
    print(isPaid==null);
    print("000");
  }catch(e){
    isPaid = false;
    print("111");
  }

  return Container(
    color: Colors.purple[50],
    child: ListTile(
      //leading: Icon(Icons.attach_money, size: 40, color: document['isPaid']!=null&&document['isPaid']!=false?Colors.green:Colors.red,),
      leading: Text("₦", style: TextStyle(fontSize: 35, fontWeight:FontWeight.w400, color: document['isPaid']!=null&&document['isPaid']!=false?Colors.green:Colors.red),),
      title: Text(document['name']),
      subtitle: Text(timeago.format(document['time_stamp'].toDate().add(new Duration(hours: 1)))),//
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text("${ORDER_ID_LABEL_TEXT}: "+document['order_id'].split('-')[0],),//document['order_id']
          Text("${TOTAL_LABEL_TEXT}: ₦${NumberFormat.currency(symbol: "",decimalDigits: 0).format(document['total'])}"),
        ],
      ),
    ),
  );
}
order_list(DocumentSnapshot document){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Column(children:
    new List.generate(document['meals'].length, (index) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: index==0?Column(
        children: <Widget>[
          new Row(children: <Widget>[///document['meals']
            Expanded(
                flex: 3,
                child: Text(MEALS_LABEL_TEXT, style: TextStyle(fontWeight: FontWeight.bold),)
            ),
            Expanded(
                child: Text(QTY_LABEL_TEXT, style: TextStyle(fontWeight: FontWeight.bold))
            ),
            Expanded(
                child: Text(PRICE_LABEL_TEXT, textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))
            ),
          ],),
          SizedBox(height: 10,),
          new Row(children: <Widget>[///document['meals']
            Expanded(
                flex: 3,
                child: Text(document['meals'][index]['food_title'])
            ),
            Expanded(
                child: Text(document['meals'][index]['qty'])
            ),
            Expanded(
                child: Text("₦${NumberFormat.currency(symbol: "", decimalDigits: 0).format(int.parse(document['meals'][index]['price']))}", textAlign: TextAlign.end,)
            ),
          ],),
        ],
      ):new Row(children: <Widget>[///document['meals']
        Expanded(
            flex: 3,
            child: Text(document['meals'][index]['food_title'])
        ),
        Expanded(
            child: Text(document['meals'][index]['qty'])
        ),
        Expanded(
            child: Text("₦${NumberFormat.currency(symbol: "", decimalDigits: 0).format(int.parse(document['meals'][index]['price']))}", textAlign: TextAlign.end,)
        ),
      ],),
    ),),),
  );
}

order_message(DocumentSnapshot document){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal:8.0),
    child: Text("${MESSAGE_LABEL_TEXT}: ${document['message']}", textAlign: TextAlign.start,),
  );
}

space(){
  return Column(children: <Widget>[
    SizedBox(height: 5),
    SizedBox(height: 1, child: Container(color: Colors.grey[300],),),
    SizedBox(height: 5),
  ],);
}

buttons(context, DocumentSnapshot document, _scaffoldKey){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal:8.0),
    child: Row(children: <Widget>[
      RaisedButton(
        onPressed: (){
          Navigator.push(
            context,
          MaterialPageRoute(builder: (context) => OrderDetailPage(1, document)),
          );
        },
       child: Text(VIEW_DETAIL_LABEL_TEXT),
      ),
      Spacer(),
      SizedBox(width: 5,),
      RaisedButton(
        onPressed: (){
          showAlertDialog(context, document, true, 'false', _scaffoldKey);
        },
        child: Text(CANCEL_LABEL_TEXT), color: Colors.redAccent,),
      SizedBox(width: 5,),
      RaisedButton(
        onPressed: (){
          showAlertDialog(context, document, true, 'true', _scaffoldKey);
        },
        child: Text(ACCEPT_LABEL_TEXT), color: Colors.green,),
    ],),
  );
}

buttons_ongoing(context, DocumentSnapshot document, _scaffoldKey){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal:8.0),
    child: Row(children: <Widget>[
      Text("${ORDER_STATUS_LABEL_TEXT}: ", style: TextStyle(fontWeight: FontWeight.bold),),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: DropdownButton<String>(
          items: [
            DropdownMenuItem<String>(
              child: Text(FINISHED_LABEL_TEXT),
              value: 'true',
            ),
            DropdownMenuItem<String>(
              child: Text(CANCEL_LABEL_TEXT),
              value: 'false',
            ),
          ],
          onChanged: (String value) {
            showAlertDialog(context, document, false, value, _scaffoldKey);
          },
          hint: Text(IN_PROGRESS_LABEL_TEXT),
          //value: _value,
        ),
      ),
      Spacer(),
      RaisedButton(onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderDetailPage(2, document)),
        );
      }, child: Text(VIEW_DETAIL_LABEL_TEXT),),
    ],),
  );
}

buttons_past(context, DocumentSnapshot document){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal:8.0),
    child: Row(children: <Widget>[
      Text(document['delivered']?"${ORDER_STATUS_LABEL_TEXT}: ${ORDER_DELIVERED_LABEL_TEXT}":"${ORDER_STATUS_LABEL_TEXT}: ${ORDER_CANCELED_LABEL_TEXT}", style: TextStyle(fontWeight: FontWeight.bold, color: document['delivered']?Colors.green:Colors.red),),
      Spacer(),
      RaisedButton(onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderDetailPage(3, document)),
        );
        },
        child: Text(VIEW_DETAIL_LABEL_TEXT),),
    ],),
  );
}

showAlertDialog(BuildContext context, DocumentSnapshot document,bool new_order, String value, _scaffoldKey) {

  final  messageController = TextEditingController();
  var acceptOrderMessage = document['delivery']?ORDER_DELIVERY_INSTRUCTION_LABEL_TEXT:ORDER_DELIVERY_OR_PICKUP_LABEL_TEXT;
  var acceptHintMessage = document['status']==1?WHEN_ORDER_WILL_BE_READY_LABEL_TEXT:acceptOrderMessage;

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
      var status = 0;
      if(new_order){
        status = value=='false'?3:2;
      }else{
        status = 3;
      }
      var message = value=='true'?ORDER_ACCEPTED_BY_RESTAURANT_LABEL_TEXT:ORDER_CANCELED_BY_RESTAURANT_LABEL_TEXT;
      var doc = document.documentID;
      var restaurant = Provider.of<CartBloc>(context).restaurant;
      Firestore.instance.document('order_$restaurant/$doc')
          .updateData({
        'status': status,
        'delivered': value=='true'?true:false,
        'time_stamp': Timestamp.now(),
        'status_text': messageController.text.isEmpty?message:messageController.text,
      });
      if(new_order){
        value=="true"?orderAccepted(_scaffoldKey):orderCanceled(_scaffoldKey);
      }else{
        value=="true"?orderFinished(_scaffoldKey):orderCanceled(_scaffoldKey);
      }
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(MESSAGE_TO_CUSTOMER_LABEL_TEXT),
    content: TextFormField(
      controller: messageController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: value=='true'?acceptHintMessage:REASON_FOR_CANCELATION_LABEL_TEXT,
          hintStyle: TextStyle(color: Colors.grey[400])
      ),
    ),
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

showAlertDialogValidation(BuildContext context, String message, _scaffoldKey) {

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
      Navigator.of(context).pop();
      //orderAccepted(_scaffoldKey);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(LIST_OF_ERROR_LABEL_TEXT, style: TextStyle(fontWeight: FontWeight.bold),),
    content: Text(message, style: TextStyle(color: Colors.red)),
    actions: [
      //cancelButton,
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