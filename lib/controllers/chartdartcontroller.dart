import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:shylo/controllers/loancontroller.dart';

import 'package:shylo/models/chatdata.dart';
import 'package:shylo/models/loan.dart';
import 'package:collection/collection.dart';

class ChartDartController extends StateNotifier<List<ChartData>> {
  final List<Loan> allLoans;
  ChartDartController({required this.allLoans}) : super([]);

  //getData for 6 Months first.
  List<ChartData> generateChartData({int months = 6}) {
    final sortedList = groupBy(
      allLoans,
      (loan) => DateFormat('MMM-yy').format(loan.dueDate),
    );
    List<ChartData> chartData = [];
    for (int i = 0; i < months; i++) {
      DateTime monthDate = DateTime(
        DateTime.now().year,
        DateTime.now().month - i,
        1,
      );
      final String monthName = DateFormat('MMM').format(monthDate);
      final String lookUpKey = DateFormat('MMM-yy').format(monthDate);
      final totalAmount = (sortedList[lookUpKey] ?? []).fold(
        0.0,
        (pr, next) => pr + next.calculateInterest(),
      );
      chartData.add(ChartData(amount: totalAmount, month: monthName));
    } 
    return chartData;
  }
}

final chartDataProvider = StateNotifierProvider(
  (ref) => ChartDartController(allLoans: ref.watch(loanProvider)),
);
