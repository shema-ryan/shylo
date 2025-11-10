import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shylo/controllers/navigatorcontroller.dart';
import 'package:shylo/models/usermodel.dart';
import 'package:shylo/screens/customerscreen.dart';

import '../widgets/navigationview.dart';


class HomeScreen extends ConsumerWidget {
  final UserModel userModel;
  const HomeScreen({super.key ,required this.userModel});
  @override
  Widget build(BuildContext context , WidgetRef ref) {
    int selectedIndex = ref.watch(navigatorProvider);
    final decodedImage = base64Decode(userModel.imagePath);
    return Scaffold(
      backgroundColor: Colors.white,
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
  CustomerScreen(),
  DashBoardScreen(),
  CustomerScreen(),
  DashBoardScreen(),
  CustomerScreen(),

];



class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('DashBoard screen'),);
  }
}
