import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';

import '../model/restaurant.dart';
import '../utils/rest_api.dart';
import 'drawer2.dart';
import 'meals_page.dart';
import 'widgets/contact.dart';
import 'widgets/restaurant_list_item.dart';


class RestaurantPage extends StatelessWidget {
  //Future<List<Restaurant>> restaurant = fetchRestaurants();

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    bool isLoading =Provider.of<CartBloc>(context).isLoading;
    //bloc.clearAll();
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurants"),
      ),
      drawer: drawer2(context),
      body: !isLoading?Center(
        child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('Restaurant').orderBy('name').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return new Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
                        SizedBox(height: 20,),
                        Text("Loading please wait...", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ],
                    ),
                  );
                  default:
                    return new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10),
                          child: new GestureDetector(
                            onTap: (){
                              isLoading=true;
                              Firestore.instance.collection('category').where('restaurant_id', isEqualTo: document.documentID).getDocuments().then(
                                      (val){
                                    List<DocumentSnapshot> ctegory_list = val.documents;
                                    List<Widget> tabBarList = [];
                                    ctegory_list.forEach((element) {
                                      tabBarList.add(Tab(text: element['title']));

                                    });
                                    isLoading=false;
                                    bloc.clearAll();
                                    bloc.not();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MealPage(document, ctegory_list, tabBarList)),
                                    );
                                  }
                              );
                            },
                            child: Card(
                              elevation: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //Text(snapshot.data[index].location.toString()),
                                  //Row(
                                  //  children: <Widget>[
                                  //    Icon(Icons.phone, size: 15,),
                                  //    Text(snapshot.data[index].phone_number.toString()),

                                  //  ],
                                  //),
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(document['image']),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 12.0, ),
                                    child: Text(document['name'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 4.0, ),
                                    child: Text(document['location'], style: TextStyle(
                                      color: Colors.grey[500],
                                    )),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 4.0, bottom: 12 ),
                                    child: Contact(document),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),),
      ):Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
            SizedBox(height: 20,),
            Text(Provider.of<CartBloc>(context).message, style: TextStyle(fontSize: 20,),),
          ],
        ),
      ),
    );
  }
}
