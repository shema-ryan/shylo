import 'package:mongo_dart/mongo_dart.dart';
enum  ExpenseType{
  salary, normal ,
}
class Expense {
  final ObjectId ? id ; 
   final String name ;
   final double amount ; 
   final DateTime dateTime ;
   Expense({required this.id , required this.name , required this.amount , required this.dateTime});

   
}