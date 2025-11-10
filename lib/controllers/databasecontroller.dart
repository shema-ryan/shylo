import 'package:mongo_dart/mongo_dart.dart';
// Database initialization and control.
class DbController {
  static DbController database = DbController._();
  Db? db;
  factory DbController() {
    if(database.db == null){
      database.db = Db("mongodb://localhost:27017/shyloDb");
      return database;
    }
    else {
      return database ;
    }
  }
  // named constructor 
  DbController._();
}
