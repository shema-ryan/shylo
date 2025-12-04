import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shylo/controllers/clientcontroller.dart';
import 'package:shylo/controllers/investorcontroller.dart';
import 'package:shylo/controllers/loancontroller.dart';
import 'package:shylo/controllers/navigatorcontroller.dart';
import 'package:shylo/models/usermodel.dart';
import 'package:shylo/screens/customerscreen.dart';
import 'package:shylo/screens/investorscreen.dart';
import 'package:shylo/screens/loanscreen.dart';
import 'package:shylo/widgets/success.dart';
import '../widgets/navigationview.dart';
import 'dashboardscreen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final int? previous;
  final UserModel userModel;
  const HomeScreen({
    super.key,
    required this.userModel,
    required this.previous,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    super.initState();
      Future.delayed(Duration.zero, ()async{
        try {
          await ref.read(clientProvider.notifier).fetchAllClient();
          await ref.read(loanProvider.notifier).fetchAllLoans();
          await ref.read(investorProvider.notifier).fetchAllInvestor();
        } catch (e) {
          showErrorMessage(message: e.toString());
        }
      });
    
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = widget.previous ?? ref.watch(navigatorProvider);
    return Scaffold(
      backgroundColor: Color(0xffFCFCFD),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Color.fromARGB(255, 243, 251, 246),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          NavigationController(height: height, width: width),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(flex: 8, child: screenList[selectedIndex]),
            ],
          );
        },
      ),
    );
  }
}

const screenList = [
  DashBoardScreen(),
  CustomerScreen(),
  LoanScreen(),
  InvestorScreen(),
  CustomerScreen(),
];



