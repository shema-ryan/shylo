import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shylo/controllers/chartdartcontroller.dart';
import 'package:shylo/controllers/expensecontroller.dart';
import 'package:shylo/controllers/loancontroller.dart';
import 'package:shylo/models/moneyformat.dart';
import 'package:shylo/widgets/tableheaderrow.dart';
import 'dart:math' show max, min;
import '../widgets/tablerow.dart';

class ProfitScreen extends ConsumerStatefulWidget {
  const ProfitScreen({super.key});

  @override
  ConsumerState<ProfitScreen> createState() => _ProfitScreenState();
}

class _ProfitScreenState extends ConsumerState<ProfitScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loansFor6Months = ref.watch(loanProvider.notifier).getLoansForMonth();
    final expenseFor6Months = ref
        .watch(expenseProvider.notifier)
        .getExpenseForMonth();
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profit Screen.',
          style: TextTheme.of(
            context,
          ).titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'Manage all bussiness profit...',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: TextField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  constraints: BoxConstraints(maxHeight: 40),
                  filled: true,
                  fillColor: Theme.of(context).primaryColor.withAlpha(10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  prefixIcon: const Icon(IconsaxPlusLinear.calendar, size: 15),
                  labelStyle: TextStyle(fontSize: 15),
                  labelText: 'Start Date',
                ),
              ),
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: size.width * 0.2,
              child: TextField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  constraints: BoxConstraints(maxHeight: 40),
                  filled: true,
                  fillColor: Theme.of(context).primaryColor.withAlpha(10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  prefixIcon: const Icon(
                    IconsaxPlusLinear.calendar_tick,
                    size: 15,
                  ),
                  labelStyle: TextStyle(fontSize: 15),
                  labelText: 'LastDate',
                ),
              ),
            ),
            const SizedBox(width: 5),
            IconButton.filled(
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              icon: const Icon(IconsaxPlusLinear.search_status_1),
              onPressed: () {},
            ),
            SizedBox(width: size.width * 0.005),

            // Row(
            //   children: [
            //     Container(color: Colors.black),
            //     Container(color: Colors.grey),
            //   ],
            // ),
          ],
        ),

        SizedBox(
          height: size.height * 0.44,
          child: Row(
            children: [
              ChartWidget(),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.005,
                    horizontal: size.width * 0.005,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary For 6Months',
                        style: TextTheme.of(
                          context,
                        ).titleMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.trending_up_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          '${loansFor6Months.fold(0.0, (sum, pr) => sum += pr.$2)} Ugx'
                              .toMoney(),
                        ),
                        subtitle: Text('Total for 6months'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.price_check_rounded,
                          color: Colors.redAccent,
                        ),
                        title: Text(
                          '${expenseFor6Months.fold(0.0, (sum, pr) => sum += pr.$2)} Ugx'
                              .toMoney(),
                        ),
                        subtitle: Text('Total for 6months'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.done_all_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          '${loansFor6Months.fold(0.0, (sum, pr) => sum += pr.$2) - expenseFor6Months.fold(0.0, (sum, pr) => sum += pr.$2)} Ugx'
                              .toMoney(),
                        ),
                        subtitle: Text('Total estimate Made by the company'),
                      ),

                      Text(
                        'statistics will change every after month.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [const Spacer(), const Text('BreakDown'), const Spacer()],
        ),
        SizedBox(
          height: size.height * 0.41,
          child: Row(
            children: [
              Flexible(
                child: Container(
                  color: Colors.purple.withAlpha(5),
                  child: Table(
                    border: TableBorder(top: BorderSide(color: Colors.black26) , bottom: BorderSide(color: Colors.black26)),
                    children: [
                      TableRow(children: [
                        TableHeaderRow(value: ' Month'),
                        TableHeaderRow(value: 'Amount (Ugx)')
                      ]),
                      for(var loan in loansFor6Months) TableRow(children: [
                        TablesRow(value: ' ${loan.$1}'),TablesRow(value: '${loan.$2}'.toMoney())
                      ])
                    ],
                  )
                ),
              ),
              VerticalDivider(
                indent: 40,
                endIndent: 20,
                thickness: 3,
                color: Colors.black26,
              ),
              Flexible(child: Container(color: Colors.indigo.withAlpha(5) , child: Table(
                    border: TableBorder(top: BorderSide(color: Colors.black26) , bottom: BorderSide(color: Colors.black26)),
                    children: [
                      TableRow(children: [
                        TableHeaderRow(value: ' Month'),
                        TableHeaderRow(value: 'Amount (Ugx)')
                      ]),
                      for(var expense in expenseFor6Months) TableRow(children: [
                        TablesRow(value: ' ${expense.$1}'),TablesRow(value: '${expense.$2}'.toMoney())
                      ])
                    ],
                  ),)),
            ],
          ),
        ),
      ],
    );
  }
}

class ChartWidget extends ConsumerWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final chartData = ref
        .watch(chartDataProvider.notifier)
        .generateChartData()
        .reversed
        .toList();
    return Flexible(
      child: LineChart(
        curve: Curves.bounceIn,
        duration: const Duration(milliseconds: 300),
        LineChartData(
          maxX: 5,
          minX: 0,
          maxY: List.generate(
            chartData.length,
            (index) => chartData[index].amount,
          ).fold(0, (sum, next) => max(sum!, next)),
          minY: List.generate(
            chartData.length,
            (index) => chartData[index].amount,
          ).fold(0, (sum, next) => min(sum!, next)),
          gridData: FlGridData(show: false),

          lineBarsData: [
            LineChartBarData(
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withAlpha(20),
              ),
              color: Colors.redAccent,
              dotData: FlDotData(show: false),
              spots: List.generate(
                chartData.length,
                (index) => FlSpot(index.toDouble(), chartData[index].amount),
              ),
            ),
            // LineChartBarData(
            //   belowBarData: BarAreaData(
            //     show: true,
            //     color: Colors.blueAccent.withAlpha(20),
            //   ),
            //   color: Colors.blueAccent,
            //   dotData: FlDotData(show: false),
            //   spots: [
            //     FlSpot(0, 2),
            //     FlSpot(1, 5),
            //     FlSpot(2, 4),
            //     FlSpot(3, 10),
            //     FlSpot(4, 2),
            //     FlSpot(5, 5),
            //     FlSpot(6, 5),
            //   ],
            // ),
            // LineChartBarData(
            //   belowBarData: BarAreaData(
            //     show: true,
            //     color: Colors.green.withAlpha(20),
            //   ),
            //   color: Colors.green,
            //   dotData: FlDotData(show: false),
            //   spots: [
            //     FlSpot(0, 2),
            //     FlSpot(1, 8),
            //     FlSpot(2, 4),
            //     FlSpot(3, 15),
            //     FlSpot(4, 2),
            //     FlSpot(5, 20),
            //     FlSpot(6, 0),
            //   ],
            // ),
          ],
          borderData: FlBorderData(
            show: true,

            border: Border(
              top: BorderSide.none,
              right: BorderSide.none,
              left: BorderSide(color: Colors.black45),
              bottom: BorderSide(color: Colors.black45),
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 30,
                getTitlesWidget: (index, data) {
                  return SideTitleWidget(
                    meta: data,
                    angle: 45,
                    child: Text(
                      chartData[index.toInt()].month,
                      style: TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              drawBelowEverything: true,
              axisNameWidget: Text(''),
            ),

            topTitles: AxisTitles(
              drawBelowEverything: true,
              axisNameSize: 20,
              axisNameWidget: const Text('Profit graph trends'),
            ),
          ),
        ),
      ),
    );
  }
}
