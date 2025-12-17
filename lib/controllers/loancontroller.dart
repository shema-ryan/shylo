import 'package:flutter_riverpod/legacy.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../controllers/databasecontroller.dart';
import '../models/loan.dart';

class Loancontroller extends StateNotifier<List<Loan>> {
  Loancontroller() : super([]);

  // fetch ALL lOANS
  Future<void> fetchAllLoans() async {
    try {
      final results = await DbController.database.db!
          .collection('loanCollection')
          .find()
          .toList();
      state = [];
      for (var result in results) {
        state = [...state, Loan.fromJson(result)];
      }
    } catch (e) {
      rethrow;
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
          .findOne({'loanId': loan.loanId});
      state = [...state, Loan.fromJson(newLoan!)];
    } catch (e) {
      rethrow;
    }
  }

  // update loan date
  Future<void> updateLoanDate({
    required ObjectId id,
    required DateTime dueDate,
  }) async {
    try {
      await DbController.database.db!
          .collection('loanCollection')
          .update(
            where.eq('_id', id),
            modify.set('dueDate', dueDate.toIso8601String()),
          );
      final index = state.indexWhere((element) => element.id == id);
      final loan = state[index];
      state.removeAt(index);
      state.insert(
        index,
        Loan(
          remarks: loan.remarks,
          loanId: loan.loanId,
          reason: loan.reason,
          client: loan.client,
          id: id,
          dueDate: dueDate,
          interestRate: loan.interestRate,
          loanStatus: loan.loanStatus,
          obtainDate: loan.obtainDate,
          principleAmount: loan.principleAmount,
          paymentTrack: loan.paymentTrack,
          collateral: loan.collateral,
        ),
      );

      state = [...state];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePayment(Loan loan) async {
    final newStatus = calculateBalance(loan: loan) == 0
        ? LoanStatus.complete
        : LoanStatus.partial;
    try {
      await DbController.database.db!
          .collection('loanCollection')
          .update(
            where.eq('_id', loan.id),
            modify
                .set('paymentTrack', loan.paymentTrack)
                .set('loanStatus', newStatus.name),
          );
      final index = state.indexWhere((index) => index.id == loan.id);
      // remove the old loan data
      state.removeAt(index);
      state.insert(
        index,
        Loan(
          remarks: loan.remarks,
          collateral: loan.collateral,
          loanId: loan.loanId,
          reason: loan.reason,
          client: loan.client,
          id: loan.id,
          dueDate: loan.dueDate,
          interestRate: loan.interestRate,
          loanStatus: newStatus,
          obtainDate: loan.obtainDate,
          principleAmount: loan.principleAmount,
          paymentTrack: loan.paymentTrack,
        ),
      );
      // Update the state.
      state = [...state];
    } catch (e) {
      rethrow;
    }
  }

  double calculateBalance({required Loan loan}) {
    var clientPaymentAmount = loan.paymentTrack.values.toList();
    double amountPaid() {
      double amount = 0;
      for (var i in clientPaymentAmount) {
        amount += i;
      }
      return amount;
    }

    return amountTopay(loan) - amountPaid();
  }

  double amountTopay(Loan loan) {
    final days = loan.dueDate.difference(loan.obtainDate).inDays;
    return (loan.principleAmount +
        (loan.principleAmount * loan.interestRate / 3000) * (days + 1)).roundToDouble();
  }

  double outStandingbalance() {
    double amount = 0;
    final activeLoans = state.where(
      (loan) =>
          loan.loanStatus == LoanStatus.disbursed ||
          loan.loanStatus == LoanStatus.partial,
    );
    for (var loan in activeLoans) {
      amount += calculateBalance(loan: loan);
    }
    return amount;
  }
}

final loanProvider = StateNotifierProvider<Loancontroller, List<Loan>>(
  (ref) => Loancontroller(),
);
