class Meal {
  final int id;
  final String name;
  final String img_url;
  final double price;
  int quantity = 1;

  Meal({this.id, this.name, this.img_url, this.price});

  addQuantity(){
    this.quantity+=1;
  }
  subQuantity(){
    this.quantity-=1;
  }


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