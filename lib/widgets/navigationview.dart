
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shylo/controllers/navigatorcontroller.dart';
import 'package:shylo/widgets/navigationitem.dart';

class NavigationController extends ConsumerWidget {
  final double height;
  final double width;
  const NavigationController({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigatorProvider);

    return Column(
      children: [
        for (NavigationItem item in _list)
          Material(
            color: Colors.transparent,
            child: InkWell(
             hoverDuration: const Duration(milliseconds: 30),
              hoverColor:  Colors.greenAccent.withAlpha(10),
              onTap: () {
                ref.read(navigatorProvider.notifier).navigateTo(item.id);
              },
              child: NavigatorItem(
                height: height,
                width: width,
                navigationItem: item,
                selectedIndex: selectedIndex,
              ),
            ),
          ),
      ],
    );
  }
}

// used for navigation
class NavigationItem {
  final int id;
  final String name;
  final IconData data;
  const NavigationItem({
    required this.id,
    required this.data,
    required this.name,
  });
}

List<NavigationItem> _list = [
  NavigationItem(id: 0, data: IconsaxPlusLinear.graph, name: 'Dashboard'),
  NavigationItem(id: 1, data: IconsaxPlusBroken.user, name: 'Cutomers'),
  NavigationItem(id: 2, data: IconsaxPlusLinear.bank, name: 'Loan'),
  NavigationItem(id: 3, data: IconsaxPlusLinear.people, name: 'Investors'),
  NavigationItem(id: 4, data: IconsaxPlusLinear.folder, name: 'Reports'),
];

