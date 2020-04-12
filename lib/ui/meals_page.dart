import 'package:flutter/material.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/model/meal.dart';
import 'package:kaatane/model/restaurant.dart';
import 'package:kaatane/utils/rest_api.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart';
import 'widgets/add_to_cart_btn.dart';
import 'widgets/meal_list_item.dart';

class MealPage extends StatelessWidget {
  MealPage(this.restaurant);
  final Restaurant restaurant;
  @override
  Widget build(BuildContext context) {
    final title = restaurant.name;
    Future<List<Meal>> meal = fetchMeals(restaurant.id);
    var bloc = Provider.of<CartBloc>(context);
    bloc.restaurant = restaurant.id;
    int totalCount = 0;
    if (bloc.cart.length > 0) {
      //totalCount = bloc.cart.values.reduce((a, b) => a + b);
      totalCount = bloc.cart.length;
    }
    return MaterialApp(
      title: title,
      theme: ThemeData(
        //primarySwatch: Colors.red,
        primaryColor: Color.fromRGBO(128, 0, 128, 1),
      ),
      home: Scaffold(
        appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            leading: IconButton(
                icon: BackButtonIcon(),
                onPressed: () {
                  Navigator.pop(context);
                }),
          actions: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Container(
                  height: 150.0,
                  width: 30.0,
                  child: new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
                        ),
                      );
                    },
                    child: new Stack(
                      children: <Widget>[
                        new IconButton(
                          icon: new Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          onPressed: null,
                        ),
                        new Positioned(
                            child: new Stack(
                              children: <Widget>[
                                new Icon(Icons.brightness_1,
                                    size: 20.0, color: Colors.white),
                                new Positioned(
                                    top: 3.0,
                                    right: 7,
                                    child: new Center(
                                      child: new Text(
                                        '$totalCount',
                                        style: new TextStyle(
                                            color:  Color.fromRGBO(128, 0, 128, 1),
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            )),
                      ],
                    ),
                  )),
            )
          ],
            ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: FutureBuilder<List<Meal>>(
              future: meal,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, index) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.network(
                            snapshot.data[index].img_url,
                            width: 100,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(snapshot.data[index].name,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                  "Price: N${snapshot.data[index].price.toString()}"),
                              SizedBox(
                                height: 4.0,
                              ),
                              Add_To_Cart_btn(snapshot.data[index])
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),);
              },
            ),
          ),
        ),
      ),
    );
  }
}
