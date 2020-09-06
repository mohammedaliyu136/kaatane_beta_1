import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = "my_order";
final String Column_id = "id";
final String Column_restaurant_name = "restaurant_name";
final String Column_restaurant_id = "restaurant_id";
final String Column_order_id = "order_id";
final String Column_order_time = "order_time";
final String Column_order_total = "order_total";
final String Column_order_meals = "order_meals";
final String Column_order_rated = "order_rated";

class OrderModel{
  //final String name;
  final String restaurant_name;
  final String restaurant_id;
  final String order_id;
  final String order_time;
  final String order_total;
  final String order_meals;
  final String order_rated;
  int id;

  OrderModel({this.id, this.restaurant_name, this.restaurant_id, this.order_id, this.order_time, this.order_total, this.order_meals, this.order_rated});

  Map<String, dynamic> toMap(){
    return {
      //Column_name : this.name
      Column_order_id: this.order_id,
      Column_restaurant_name: this.restaurant_name,
      Column_restaurant_id: this.restaurant_id,
      Column_order_time: this.order_time,
      Column_order_total: this.order_total,
      Column_order_meals: this.order_meals,
      Column_order_rated: this.order_rated

    };
  }
}

class OrderHelper{
  Database db;

  OrderHelper(){
    initDatabase();
  }

  Future<void> initDatabase() async{
    db = await openDatabase(
        join(await getDatabasesPath(), "databse.db"),
        onCreate: (db, version){
          return db.execute("CREATE TABLE $tableName($Column_id INTEGER PRIMARY KEY AUTOINCREMENT, $Column_order_id TEXT, $Column_restaurant_name TEXT, $Column_restaurant_id TEXT, $Column_order_time TEXT, $Column_order_total TEXT, $Column_order_meals TEXT, $Column_order_rated TEXT)");
        },
        version: 1
    );
  }

  Future<void> insertOrder(OrderModel task) async{
    try{
      db.insert(tableName, task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }catch(_){
      print(_);
    }
  }

  Future<List<OrderModel>> getAllOrder () async{
    final List<Map<String, dynamic>> tasks = await db.rawQuery("SELECT * FROM $tableName ORDER BY $Column_id DESC");//.query(tableName);

    return List.generate(tasks.length, (i){
      return OrderModel(
          restaurant_name: tasks[i][Column_restaurant_name],
          id: tasks[i][Column_id],
          restaurant_id: tasks[i][Column_restaurant_id],
          order_id: tasks[i][Column_order_id],
          order_time: tasks[i][Column_order_time],
          order_total: tasks[i][Column_order_total],
          order_meals: tasks[i][Column_order_meals],
          order_rated: tasks[i][Column_order_rated]
      );
    });
  }
  Future<List<OrderModel>> getAllOrderNotRated () async{
    final List<Map<String, dynamic>> tasks = await db.rawQuery("SELECT * FROM $tableName WHERE $Column_order_rated = 'no'");//.query(tableName);

    return List.generate(tasks.length, (i){
      return OrderModel(
          restaurant_name: tasks[i][Column_restaurant_name],
          id: tasks[i][Column_id],
          restaurant_id: tasks[i][Column_restaurant_id],
          order_id: tasks[i][Column_order_id],
          order_time: tasks[i][Column_order_time],
          order_total: tasks[i][Column_order_total],
          order_meals: tasks[i][Column_order_meals],
          order_rated: tasks[i][Column_order_rated]
      );
    });
  }


}