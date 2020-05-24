import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'order_ui_utils.dart';

class OrderDetailPage extends StatelessWidget {
  int page;
  DocumentSnapshot document;
  OrderDetailPage(this.page, this.document);
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text(page==1?"New Order":page==2?"Ongoing Order":"Past Order"), centerTitle: true,),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
        Container(
          color: Colors.purple[50],
            child: ListTile(
              leading: Icon(Icons.directions_bike, size: 40,),
              title: Text(document['name']),
              subtitle: Text(timeago.format(document['time_stamp'].toDate().add(new Duration(hours: 1)))),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("Order id: "+document['order_id'].split('-')[0],),
                  Text("Total: "+document['total'].toString()),
                ],
              ),
            ),
          ),
        SizedBox(height: 10,),
        Row(children: <Widget>[
          SizedBox(width: 18,),
          Icon(Icons.phone, size: 20, color: Colors.purple,),
          SizedBox(width: 18,),
          Text(document['phone_number'], style: TextStyle(fontSize: 16),),
        ],),
        SizedBox(height: 10,),
        SizedBox(height: 2, child: Container(color: Colors.grey[300],),),
        SizedBox(height: 10,),
        Row(children: <Widget>[
          SizedBox(width: 18,),
          Icon(Icons.mail, size: 20, color: Colors.purple,),
          SizedBox(width: 18,),
          Text(document['email'], style: TextStyle(fontSize: 16),),
        ],),
        SizedBox(height: 10,),
        SizedBox(height: 2, child: Container(color: Colors.grey[300],),),
        SizedBox(height: 10,),
        Row(children: <Widget>[
          SizedBox(width: 18,),
          Icon(Icons.location_on, size: 20, color: Colors.purple,),
          SizedBox(width: 18,),
          Text(document['address'], style: TextStyle(fontSize: 16),),
        ],),
        SizedBox(height: 10),
        SizedBox(height: 2, child: Container(color: Colors.grey[300],),),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Text("Message", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: Row(
            children: <Widget>[
              Text(document['message'], textAlign: TextAlign.start,),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: order_list(document),
        ),
        SizedBox(height: 10,),
        Container(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                document['delivery']?
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                Text("Subtotal  :  ₦"+(document['total']- int.parse(bloc.restaurantDocument['delivery_fee'])).toString(), style: TextStyle(fontSize: 18),)
              ],):
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                Text("Subtotal  :  ₦"+document['total'].toString(), style: TextStyle(fontSize: 18),)
              ],),
              bloc.restaurantDocument['delivery']?
              SizedBox(height: 10,):Container(),
                document['delivery']?
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("Delivery Fee  :  ₦"+bloc.restaurantDocument['delivery_fee'], style: TextStyle(fontSize: 18),)
              ],):Container(),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Total  :  ₦"+document['total'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),)
                ],),

            ],),
          ),
        ),
        Spacer(),

        /**
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: page==1?<Widget>[
            RaisedButton(
              onPressed: (){},
              child: Text("Cancel Order"), color: Colors.red,),
            SizedBox(width: 10,),
            RaisedButton(onPressed: (){}, child: Text("Accept Order"),color: Colors.green,)
          ]
            : page==2?<Widget>[
              Text("Order Status: ", style: TextStyle(fontWeight: FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: DropdownButton<String>(
                  items: [
                    DropdownMenuItem<String>(
                      child: Text('Finished'),
                      value: 'two',
                    ),
                    DropdownMenuItem<String>(
                      child: Text('Cancel'),
                      value: 'three',
                    ),
                  ],
                  onChanged: (String value) {
                  },
                  hint: Text('In progress'),
                  //value: _value,
                ),
              ),
              Spacer(),
              RaisedButton(onPressed: (){
              },
                child: Text("Cancel Order"), color: Colors.red,),
            ]:<Widget>[
              Text("Order Status: Order Delivered", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),),
            ],),
        ),**/
      ],),
    );
  }
}
