import 'package:collection/collection.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shylo/controllers/databasecontroller.dart';
import 'package:shylo/models/expense.dart';

class ExpenseController extends StateNotifier<List<Expense>> {
  ExpenseController() : super([]);

  Future<void> addExpense(Expense expense) async {
    try {
     await DbController.database.db!
          .collection('expenseCollection')
          .insert(expense.toJson());
      final insertedDocument = await DbController.database.db!
          .collection('expenseCollection')
          .findOne({
            'name': expense.name,
            'date': expense.dateTime.toIso8601String(),
          });
      if (insertedDocument != null)state = [...state, Expense.fromJson(insertedDocument)];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAllExpenses() async {
    final List<Expense> allExpenses = [];
    try {
      final results = await DbController.database.db!
          .collection('expenseCollection')
          .find()
          .toList();
      for (var element in results) {
        allExpenses.add(Expense.fromJson(element));
      }
      state = [...allExpenses];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpense(ObjectId id) async {
    try {
      final results = await DbController.database.db!
          .collection('expenseCollection')
          .deleteOne({"_id": id});
      if (results.isSuccess && results.nRemoved == 1)
        state.removeWhere((expense) => expense.id == id);
      state = [...state];
    } catch (e) {
      rethrow;
    }
  }
   List<(String , double)> getExpenseForMonth(){
    List<(String , double)> months=[];
    final groupedExpenses = groupBy(state, (expense)=> DateFormat('YYYY-MM').format(expense.dateTime));
    for(int i = 0 ; i < 6 ; i++){
      final dateToformat = DateTime(DateTime.now().year , DateTime.now().month - i, 1);
      final lookUpKey = DateFormat('YYYY-MM').format(dateToformat);
      months.add((DateFormat('MMM').format(dateToformat),(groupedExpenses[lookUpKey]?? []) .fold(0.0, (sum , next)=> sum += next.amount)));
    }
    return months;
  }
}

// provider for all expenses.
final expenseProvider = StateNotifierProvider<ExpenseController, List<Expense>>(
  (ref) => ExpenseController(),
);


final searchExpenseController = StateProvider<String>((ref)=>'');
final filteredExpenses = StateProvider<List<Expense>>((ref){
  final searchText =ref.watch(searchExpenseController);
  final allExpenses = ref.watch(expenseProvider);
  if(searchText.isNotEmpty) return [...allExpenses.where((expense)=> expense.name.contains(searchText))];
   return allExpenses;
}); 