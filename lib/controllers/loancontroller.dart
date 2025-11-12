import 'package:flutter_riverpod/legacy.dart';
import '../controllers/databasecontroller.dart';
import '../models/loan.dart';

class Loancontroller extends StateNotifier<List<Loan>> {
  Loancontroller() : super([]);

  // fetch ALL lOANS
   Future<void> fetchAllLoans()async{
      try {
        final results = await DbController.database.db!.collection('loanCollection').find().toList();
        state = [];
        for(var result in results){
          state =[...state  , Loan.fromJson(result)];       
        }
      } catch (e) {
        rethrow ;
      }
   }
  // ADD LOAN
  Future<void> registerLoan(Loan loan) async {
    try {
      await DbController.database.db!
          .collection('loanCollection')
          .insert(loan.loanToJson());
      final newLoan = await DbController.database.db!
          .collection('loanCollection')
          .findOne({'clientId': loan.client});
      state = [...state , Loan.fromJson(newLoan!)]    ;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}

final loanProvider = StateNotifierProvider<Loancontroller , List<Loan>>((ref)=>Loancontroller());
