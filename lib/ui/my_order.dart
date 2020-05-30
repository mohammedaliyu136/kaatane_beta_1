import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/model/my_order_model.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyOrder extends StatefulWidget {
  MyOrder(this.orders);
  List<OrderModel> orders;
  @override
  _MyOrderState createState() => _MyOrderState(orders);
}

class _MyOrderState extends State<MyOrder> {
  _MyOrderState(this.orders);
//class MyOrder extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool q_db = false;
  List<OrderModel> orders = [];
  bool isLoading = false;

  OrderModel currentOrder;
  OrderHelper _orderHelper = OrderHelper();
  DocumentSnapshot order;

  getdata(context)async{
    List<OrderModel> list = await Provider.of<CartBloc>(context).getMyOrders();
    setState(() {
      orders = list;
      q_db=true;
    });
  }

  showAlertDialog(BuildContext context, OrderModel meal, _scaffoldKey) {
    //isLoading = false;

    Firestore.instance.collection('order_${meal.restaurant_id}').where('order_id', isEqualTo: meal.order_id).getDocuments().then((value){
      order = value.documents[0];
      print("===========");
      print("===========");
      print("===========");
      print("333 ${order.documentID}");
      print("333 ${order["status"]}");
      print("333 ${order["status_text"]}");
      Navigator.of(context).pop();
      showAlertDialogDone(context, meal, order["status_text"], order["status"], _scaffoldKey);
    });
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.of(context).pop();
        //orderAccepted(_scaffoldKey);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Checking Order Status", style: TextStyle(fontWeight: FontWeight.bold),),
      content: isLoading?LinearProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),):Text("Order status....${order["status_text"]}", style: TextStyle(color: Colors.red)),
      actions: [
        //cancelButton,
        //continueButton,
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
  showAlertDialogDone(BuildContext context, OrderModel meal, String status_text, int status, _scaffoldKey) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
        //orderAccepted(_scaffoldKey);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: status==1?Text("The restaurant has not done anything about order yet.", style: TextStyle(fontWeight: FontWeight.bold),):Text(status_text, style: TextStyle(fontWeight: FontWeight.bold),),
      content: ListTile(
        title: Text('Restaurant: ${meal.restaurant_name}'),
        subtitle: Text('Time: ${timeago.format(DateTime.parse(meal.order_time))}'),
      ),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getdata();
    //getdata(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("My Orders"),),
      body: orders.length>0?ListView(
        children: orders.map((document) {
          print(document.order_meals.split("*")[0].split("#"));
          print(document.order_meals.split("*").length);
          var meals = document.order_meals.split("*");
          //meals.removeAt(2);
          return Column(
            children: <Widget>[
              Container(
                color:  Colors.purple[50],
                child: new ListTile(
                  title: Text('${document.restaurant_name}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('Order ID: ${document.order_id.split('-')[0]}'),
                      Text('Total: ₦${NumberFormat.currency(symbol: "", decimalDigits: 0).format(int.parse(document.order_total))}'),
                    ],
                  ),
                  subtitle: Text(timeago.format(DateTime.parse(document.order_time))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(children: meals.map((e){
                  if(e.trim()!=""){
                    return meals.indexOf(e)!=0?Row(children: <Widget>[///document['meals']
                      Expanded(
                          flex: 3,
                          child: Text(e.split("#")[0])
                      ),
                      Expanded(
                          child: Text("${e.split("#")[1]}")
                      )
                    ],):Column(
                      children: <Widget>[
                        Row(children: <Widget>[///document['meals']
                          Expanded(
                              flex: 3,
                              child: Text("Meals", style: TextStyle(fontWeight: FontWeight.bold),)
                          ),
                          Expanded(
                              child: Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold),)
                          )
                        ],),
                        SizedBox(height: 5,),
                        Row(children: <Widget>[///document['meals']
                          Expanded(
                              flex: 3,
                              child: Text(e.split("#")[0])
                          ),
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left:18.0),
                                child: Text("${e.split("#")[1]}"),
                              )
                          )
                        ],),
                        SizedBox(height: 4,),
                      ],
                    );
                  }else{
                    return Container();
                  }
                }).toList(),),
              ),
              SizedBox(height: 10,),
              RaisedButton(
                onPressed: (){
                  setState(() {
                    isLoading=true;
                  });
                  showAlertDialog(context, document, _scaffoldKey);
                  print(document.restaurant_name);
                },
                child: Text("Check Status"),),
              SizedBox(height: 10,),
              SizedBox(height: 1, child: Container(color: Colors.grey[350],),)
            ],
          );
        }).toList(),
      ):Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Sorry, you have no past orders...", style: TextStyle(fontSize: 20,),),
          ],
        ),
      ),
    );
  }
}
