import 'package:flutter/material.dart';

import '../model/restaurant.dart';
import '../utils/rest_api.dart';
import 'meals_page.dart';
import 'widgets/contact.dart';
import 'widgets/restaurant_list_item.dart';


class RestaurantPage extends StatelessWidget {
  Future<List<Restaurant>> restaurant = fetchRestaurants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurants"),
      ),
      body: Center(
        child: Container(
            child: FutureBuilder<List<Restaurant>>(
              future: restaurant,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, index) => GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MealPage(snapshot.data[index])),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              //title: Text(snapshot.data[index].name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //Text(snapshot.data[index].location.toString()),
                                  //Row(
                                  //  children: <Widget>[
                                  //    Icon(Icons.phone, size: 15,),
                                  //    Text(snapshot.data[index].phone_number.toString()),

                                  //  ],
                                  //),
                                  Text(snapshot.data[index].name,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(snapshot.data[index].location.toString(), style: TextStyle(
                                    color: Colors.black,
                                  )),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Contact(snapshot.data[index])
                                ],
                              ),
                              leading: Image.asset(
                                "assets/images/restaurant_logo.png",
                                width: 50,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Failed to load, please check your internet connect");//Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),);
              },
            ),),
      ),
    );
  }
}
