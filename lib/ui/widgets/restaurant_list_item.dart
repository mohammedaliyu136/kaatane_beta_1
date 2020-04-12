import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../meals_page.dart';
import 'contact.dart';

class Restaurant_list_item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.asset("assets/images/restaurant_logo.png", width: 50, height: 100,),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Babz Lounge",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                height: 8.0,
              ),
              Text("Police Roundabout, Jimeta"),
              SizedBox(
                height: 8.0,
              ),
              //Contact()
            ],
          ),
          onTap: () {
            //Navigator.push(
              //context,
              //MaterialPageRoute(builder: (context) => MealPage()),
            //);
          },
        ),
      ),
    );
  }
}
