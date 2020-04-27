import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/meal.dart';
import '../model/restaurant.dart';

Future<List<Meal>> fetchMeals(int id) async {
  final response = await http.get('https://kaatane.herokuapp.com/api/meals/?q=$id');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    //print(json.decode(response.body) as List);
    var res = (json.decode(response.body) as List);
    List<Meal> meals = [];
    for(var i=0; i<res.length; i++){
      var meal = Meal(id: res[i]['id'], name: res[i]['name'], img_url: res[i]['img_url'], price: res[i]['price']);
      meals.add(meal);
    }
    return meals;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load meals');
  }
}

Future<List<Restaurant>> fetchRestaurants() async {
  final response = await http.get('https://kaatane.herokuapp.com/api/restaurant/');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    //print(json.decode(response.body) as List);
    var res = (json.decode(response.body) as List);
    List<Restaurant> restaurants = [];
    for(var i=0; i<res.length; i++){
      var restaurant = Restaurant(id: res[i]['id'], name: res[i]['name'], img_url: res[i]['img_url'], phone_number: res[i]['phone_number'], location: res[i]['location']);
      restaurants.add(restaurant);
    }
    return restaurants;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load restaurants');
  }
}