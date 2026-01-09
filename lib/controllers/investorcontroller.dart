import 'package:flutter_riverpod/legacy.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shylo/controllers/databasecontroller.dart';
import 'package:shylo/models/exception.dart';
import 'package:shylo/models/investor.dart';

class Investorcontroller extends StateNotifier<List<Investor>> {
  Investorcontroller() : super([]);

  //get all investor
  Future<void> fetchAllInvestor() async {
    final results = await DbController.database.db!
        .collection('investorCollection')
        .find()
        .toList();
    // empty the state
    state = [];
    for (var result in results) {
      state.add(Investor.fromJson(result));
    }
    state = [...state];
  }

  // remove an investor
  Future<void> deleteInvestor({required ObjectId id}) async {
    try {
      await DbController.database.db!.collection('investorCollection').remove({
        '_id': id,
      });
      state.removeWhere((investor) => investor.id == id);
      state = [...state];
    } catch (e) {
      rethrow;
    }
  }

  // adding an investor
  Future<void> addInvestor({required Investor investor}) async {
    try {
      final results = await DbController.database.db!
          .collection('investorCollection')
          .findOne({'name': investor.name});
      if (results == null) {
        await DbController.database.db!
            .collection('investorCollection')
            .insert(investor.investorToJson());
        final recordedInvestor = await DbController.database.db!
            .collection('investorCollection')
            .findOne({'name': investor.name});
        state = [...state, Investor.fromJson(recordedInvestor!)];
      } else {
        throw MyException(message: '${investor.name} already exists');
      }
    } catch (e) {
      rethrow;
    }
  }

  double calculateInvestement() {
    double amount = 0;
    for (var investor in state) {
      amount += investor.amount;
    }
    return amount;
  }

  Future<void> updateInvestor({required Investor investor}) async {
    try {
      await DbController.database.db!
          .collection('investorCollection')
          .update(
            where.eq('_id', investor.id),
            modify.set('paymentTracker', investor.paymentTracker),
          );
      final index = state.indexWhere((element) => element.id == investor.id);
      print('we have got  this index.');
      state.removeWhere((element) => element.id == investor.id);
      state.insert(index, investor);
      state = [...state];
    } catch (e) {
      rethrow;
    }
  }
} //

final investorProvider =
    StateNotifierProvider<Investorcontroller, List<Investor>>(
      (ref) => Investorcontroller(),
    );
// Investor Provider ---> 
final investorSearchProvider = StateProvider<String>((ref) => '');
// Filtered Provider --->
final filteredInvestorProvider = StateProvider<List<Investor>>((ref) {
  final searchProvider = ref.watch(investorSearchProvider);
  final allInvestor = ref.watch(investorProvider);
  return searchProvider.isNotEmpty
      ? allInvestor
            .where((element) => element.name.contains(searchProvider))
            .toList()
      : allInvestor;
});
