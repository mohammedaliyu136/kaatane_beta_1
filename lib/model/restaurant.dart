class Restaurant {
  final int id;
  final String name;
  final String img_url;
  final String phone_number;
  final String location;

  Restaurant({this.id, this.name, this.img_url, this.phone_number, this.location});

//factory Meal.fromJson(Map<String, dynamic> json) {
//  print(json);
//  return Meal(
//    id: json['id'],
//    name: json['name'],
//    img_url: json['img_url'],
//    price: json['price'],
//  );
//}
}