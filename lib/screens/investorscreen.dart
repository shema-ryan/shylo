import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shylo/controllers/investorcontroller.dart';
import 'package:shylo/routes.dart';
import '../widgets/investorcard.dart';
import '../widgets/investorform.dart';

class InvestorScreen extends ConsumerStatefulWidget {
  const InvestorScreen({super.key});

  @override
  ConsumerState<InvestorScreen> createState() => _InvestorScreenState();
}

class _InvestorScreenState extends ConsumerState<InvestorScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(investorProvider.notifier).fetchAllInvestor();
  }

  @override
  Widget build(BuildContext context) {
    final investorList = ref.watch(investorProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Column(
          spacing: 5,
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 5),
                SizedBox(
                  width: width * 0.4,
                  child: TextField(
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).primaryColor.withAlpha(10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(
                        IconsaxPlusLinear.search_favorite,
                        size: 15,
                      ),
                      labelText: 'search using name. . . . .',
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => InvestorForm(),
                    );
                  },
                  label: const AutoSizeText('Add Investor'),
                ),
                const SizedBox(width: 5),
              ],
            ),
            SizedBox(
              height: height * 0.9,
              width: width,
              child: GridView.builder(
                itemCount: investorList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.25,
                ),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    goRouter.go(
                      '/investordetailscreen',
                      extra: investorList[index],
                    );
                  },
                  child: InvestorCard(
                    investor: investorList[index],
                    height: height,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
