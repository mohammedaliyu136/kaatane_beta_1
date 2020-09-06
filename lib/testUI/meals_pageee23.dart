import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MealsPageee23 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Restaurant"),),
      body: ListView(children: <Widget>[
        Center(child: Text("All Restaurants", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),)),

        SizedBox(height: 10,),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:0.0),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(left:30.0),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left:40.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 8.0, ),
                                        child: Text('name nkkn njs l sjjs ddjld d dld jld d  dlk',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0, right: 0.0, top: 2.0, ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('location',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w300,
                                          )),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 2.0, ),
                                  child: Text('Delivery Available',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      )),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                              ],),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top:12.0),
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Center(child: Text('')),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(80), bottom: Radius.circular(80)),
                        image: DecorationImage(
                            image: NetworkImage(''),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(left:30.0),
                  child: Card(
                    elevation: 3,
                    child: Container(
                      height: 90,
                      child: Padding(
                        padding: const EdgeInsets.only(left:40.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 8.0, ),
                                  child: Text('Salti Delight',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 2.0, ),
                                  child: Text('Near lelewal, opp. SPY',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 2.0, ),
                                  child: Text('Delivery Available',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      )),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                              ],),
                            ),
                          ],
                        ),
                      ),
                      decoration: const BoxDecoration(
                        //color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top:12.0),
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Center(child: Text('')),
                    decoration: const BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(left:30.0),
                  child: Card(
                    elevation: 3,
                    child: Container(
                      height: 90,
                      child: Padding(
                        padding: const EdgeInsets.only(left:40.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 8.0, ),
                                  child: Text('Salti Delight',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 2.0, ),
                                  child: Text('Near lelewal, opp. SPY',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 2.0, ),
                                  child: Text('Delivery Available',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      )),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                              ],),
                            ),
                          ],
                        ),
                      ),
                      decoration: const BoxDecoration(
                        //color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top:12.0),
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Center(child: Text('')),
                    decoration: const BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(left:30.0),
                  child: Card(
                    elevation: 3,
                    child: Container(
                      height: 90,
                      child: Padding(
                        padding: const EdgeInsets.only(left:40.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 8.0, ),
                                  child: Text('Salti Delight',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 2.0, ),
                                  child: Text('Near lelewal, opp. SPY',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 2.0, ),
                                  child: Text('Delivery Available',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      )),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                              ],),
                            ),
                          ],
                        ),
                      ),
                      decoration: const BoxDecoration(
                        //color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top:12.0),
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Center(child: Text('')),
                    decoration: const BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(left:30.0),
                  child: Card(
                    elevation: 3,
                    child: Container(
                      height: 90,
                      child: Padding(
                        padding: const EdgeInsets.only(left:40.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 8.0, ),
                                    child: Text('Salti Delight',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 2.0, ),
                                    child: Text('Near lelewal, opp. SPY',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w300,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 2.0, ),
                                    child: Text('Delivery Available',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w300,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                ],),
                            ),
                          ],
                        ),
                      ),
                      decoration: const BoxDecoration(
                        //color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top:12.0),
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Center(child: Text('')),
                    decoration: const BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3,),

      ],),
    );
  }
}
