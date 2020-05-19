import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'order_ui_utils.dart';

class OrderDetailPage extends StatelessWidget {
  int page;
  OrderDetailPage(this.page);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(page==1?"New Order":page==2?"Ongoing Order":"Past Order"), centerTitle: true,),
      body: Column(children: <Widget>[
        Container(
          color: Colors.purple[50],
            child: ListTile(
              leading: Icon(Icons.directions_bike, size: 40,),
              title: Text("Angel James"),
              subtitle: Text("Today at 12:33 AM"),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("Order id: 384"),
                  Text("Total: \$384"),
                ],
              ),
            ),
          ),
        SizedBox(height: 10,),
        Row(children: <Widget>[
          SizedBox(width: 18,),
          Icon(Icons.phone, size: 20, color: Colors.purple,),
          SizedBox(width: 18,),
          Text("+1 2345 6789", style: TextStyle(fontSize: 16),),
        ],),
        SizedBox(height: 10,),
        SizedBox(height: 2, child: Container(color: Colors.grey[300],),),
        SizedBox(height: 10,),
        Row(children: <Widget>[
          SizedBox(width: 18,),
          Icon(Icons.mail, size: 20, color: Colors.purple,),
          SizedBox(width: 18,),
          Text("john.doe@gmail.com", style: TextStyle(fontSize: 16),),
        ],),
        SizedBox(height: 10,),
        SizedBox(height: 2, child: Container(color: Colors.grey[300],),),
        SizedBox(height: 10,),
        Row(children: <Widget>[
          SizedBox(width: 18,),
          Icon(Icons.location_on, size: 20, color: Colors.purple,),
          SizedBox(width: 18,),
          Text("3 South Ave.Sidney, OH 45365", style: TextStyle(fontSize: 16),),
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
          child: Text("kcml dc l v lvf vflvf  vkvklfd vfkcml dc l v lvf vflvf  vkvklfd vf kcml dc l v lvf vflvf  vkvklfd vf"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Text("Items", style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    Expanded(
                        child: Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    Expanded(
                        child: Text("Price", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                  ],),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: Text("Dal Makhani")
                  ),
                  Expanded(
                      child: Text("Qty: 2")
                  ),
                  Expanded(
                      child: Text("\$24.00", textAlign: TextAlign.end,)
                  ),
                ],),
              ),
              Row(children: <Widget>[
                Expanded(
                    flex: 3,
                    child: Text("Dal Makhani")
                ),
                Expanded(
                    child: Text("Qty: 2")
                ),
                Expanded(
                    child: Text("\$24.00", textAlign: TextAlign.end,)
                ),
              ],),
          ],),
        ),
        SizedBox(height: 10,),
        Container(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                Text("Subtotal  :  \$106.00", style: TextStyle(fontSize: 18),)
              ],),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("Delivery Fee  :  \$106.00", style: TextStyle(fontSize: 18),)
              ],),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Total  :  \$106.00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),)
                ],),

            ],),
          ),
        ),
        Spacer(),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: page==1?<Widget>[
            RaisedButton(onPressed: (){}, child: Text("Cancel Order"), color: Colors.red,),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderDetailPage(2)),
                );
              },
                child: Text("Cancel Order"), color: Colors.red,),
            ]:<Widget>[
              Text("Order Status: Order Delivered", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),),
            ],),
        ),

      ],),
    );
  }
}
