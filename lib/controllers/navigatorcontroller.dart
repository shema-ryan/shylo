import 'package:flutter_riverpod/legacy.dart';

class Navigatorcontroller extends StateNotifier<int> {
  Navigatorcontroller() : super(0);

  // navigate
  void navigateTo(int index) {
    state = index ;
  }
}

final navigatorProvider = StateNotifierProvider<Navigatorcontroller, int>(
  (ref) => Navigatorcontroller(),
);
